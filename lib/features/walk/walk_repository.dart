import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:drift/drift.dart';
import '../../core/db/app_database.dart';
import '../../core/db/tables.dart';
import '../../core/gps/gps_engine.dart';
import '../../core/gps/gps_point_mapper.dart';

/// Sits between WalkController and the core layer.
/// Owns the GPS engine lifecycle and writes to Drift.
/// Returns streams and futures — no UI concerns here.
class WalkRepository {
  final AppDatabase _db;
  final GpsEngine _gpsEngine;
  final _uuid = const Uuid();

  StreamSubscription<dynamic>? _positionSubscription;
  StreamSubscription<dynamic>? _modeSubscription;

  // Callbacks that WalkController registers to receive updates
  void Function(int count)? onGpsPointAdded;
  void Function(GpsMode mode)? onModeChanged;

  WalkRepository({required AppDatabase db, required GpsEngine gpsEngine})
    : _db = db,
      _gpsEngine = gpsEngine;

  // ── Walk lifecycle ─────────────────────────────────────────────────────────

  Future<Walk> startWalk() async {
    // Write event log FIRST, then start GPS engine
    // This matches the sync dependency order — event log exists before GPS points
    final walkId = _uuid.v4();
    final now = DateTime.now();

    await _db.insertWalk(
      WalksCompanion.insert(
        id: walkId,
        startedAt: now,
        status: WalkStatus.active,
      ),
    );

    await _db.insertEventLog(
      EventLogsCompanion.insert(
        id: _uuid.v4(),
        walkId: walkId,
        eventType: 'walk_started',
        payload: '{"startedAt": "${now.toIso8601String()}"}',
        createdAt: now,
        syncStatus: SyncStatus.pending,
      ),
    );

    // Now start the GPS engine and listen to its streams
    await _gpsEngine.start();
    _listenToGpsEngine(walkId);

    final walk = await _db.getActiveWalk();
    return walk!;
  }

  Future<Walk> pauseWalk(String walkId) async {
    final now = DateTime.now();

    await _db.updateWalk(
      walkId,
      WalksCompanion(status: const Value(WalkStatus.paused)),
    );

    await _db.insertEventLog(
      EventLogsCompanion.insert(
        id: _uuid.v4(),
        walkId: walkId,
        eventType: 'walk_paused',
        payload: '{"pausedAt": "${now.toIso8601String()}"}',
        createdAt: now,
        syncStatus: SyncStatus.pending,
      ),
    );

    return (await _db.getActiveWalk())!;
  }

  Future<Walk> resumeWalk(String walkId) async {
    final now = DateTime.now();

    await _db.updateWalk(
      walkId,
      WalksCompanion(status: const Value(WalkStatus.active)),
    );

    await _db.insertEventLog(
      EventLogsCompanion.insert(
        id: _uuid.v4(),
        walkId: walkId,
        eventType: 'walk_resumed',
        payload: '{"resumedAt": "${now.toIso8601String()}"}',
        createdAt: now,
        syncStatus: SyncStatus.pending,
      ),
    );

    return (await _db.getActiveWalk())!;
  }

  Future<void> completeWalk(String walkId) async {
    final now = DateTime.now();

    // Stop GPS engine first — no more points after completion
    await _stopListening();
    await _gpsEngine.stop();

    await _db.updateWalk(
      walkId,
      WalksCompanion(
        status: const Value(WalkStatus.completed),
        endedAt: Value(now),
      ),
    );

    await _db.insertEventLog(
      EventLogsCompanion.insert(
        id: _uuid.v4(),
        walkId: walkId,
        eventType: 'walk_completed',
        payload: '{"completedAt": "${now.toIso8601String()}"}',
        createdAt: now,
        syncStatus: SyncStatus.pending,
      ),
    );
  }

  // ── GPS engine wiring ──────────────────────────────────────────────────────

  void _listenToGpsEngine(String walkId) {
    // Listen to position stream — map each position to a DB row
    _positionSubscription = _gpsEngine.positionStream.listen((position) async {
      final point = GpsPointMapper.fromPosition(
        position: position,
        walkId: walkId,
        mode: _gpsEngine.currentMode,
      );
      await _db.insertGpsPoint(point);

      // Notify controller so it can update point count in UI
      final count = await _db.countGpsPointsForWalk(walkId);
      onGpsPointAdded?.call(count);
    });

    // Listen to mode stream — notify controller for UI update
    _modeSubscription = _gpsEngine.modeStream.listen((mode) {
      onModeChanged?.call(mode);
    });
  }

  Future<void> _stopListening() async {
    await _positionSubscription?.cancel();
    await _modeSubscription?.cancel();
  }

  // ── Foreground catch-up sync trigger ──────────────────────────────────────
  // Called by WalkController when app comes to foreground (iOS strategy)

  Stream<Walk> watchActiveWalk() => _db.watchAllWalks().map(
    (walks) => walks.firstWhere(
      (w) => w.status == WalkStatus.active,
      orElse: () => throw StateError('No active walk'),
    ),
  );

  Future<Walk?> getActiveWalk() => _db.getActiveWalk();

  Future<int> countGpsPointsForWalk(String walkId) =>
      _db.countGpsPointsForWalk(walkId);

  Stream<List<Walk>> watchAllWalks() => _db.watchAllWalks();

  Future<void> dispose() async {
    await _stopListening();
    await _gpsEngine.stop();
  }
}
