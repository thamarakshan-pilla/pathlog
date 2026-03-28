import 'dart:async';
import '../db/app_database.dart';
import 'cloudflare_client.dart';
import 'sync_queue.dart';
import 'sync_state.dart';

/// Orchestrates one complete sync cycle.
///
/// Called from two places:
///   1. background_sync_handler.dart (WorkManager / BGAppRefreshTask)
///   2. sync_progress_screen.dart (end-of-walk blocking sync)
///
/// Emits a stream of SyncState so both callers can react to progress.
class SyncRunner {
  final AppDatabase _db;
  final SyncQueue _queue;

  SyncRunner({required AppDatabase db, required CloudflareClient client})
    : _db = db,
      _queue = SyncQueue(db: db, client: client);

  /// Runs a full sync cycle and emits state updates throughout.
  ///
  /// The stream closes when the cycle is complete or has failed.
  /// Listeners (UI or background handler) react to each emission.
  Stream<SyncState> run({String? walkId}) async* {
    SyncState state = const SyncState();

    // ── Phase 1: Event Logs ──────────────────────────────────────────────────
    final pendingLogs = await _db.getPendingEventLogs();

    yield state = state.copyWith(
      phase: SyncPhase.syncingLogs,
      totalEventLogs: pendingLogs.length,
    );

    await _queue.processEventLogs(
      onProgress: (synced, total) {
        // Granular per-item progress not wired here yet.
        // Will be connected in sync_progress_screen (Step 7).
      },
    );

    final syncedLogs =
        pendingLogs.length - (await _db.getPendingEventLogs()).length;

    yield state = state.copyWith(syncedEventLogs: syncedLogs);

    // ── Phase 2: GPS Points (dependency-gated) ───────────────────────────────
    if (walkId != null) {
      final pendingGps = await _db.getPendingGpsPoints(walkId);

      yield state = state.copyWith(
        phase: SyncPhase.syncingGps,
        totalGpsPoints: pendingGps.length,
      );

      final syncedGps = await _queue.processGpsPoints(walkId: walkId);

      yield state = state.copyWith(syncedGpsPoints: syncedGps);
    }

    // ── Phase 3: Result ──────────────────────────────────────────────────────
    final hasFailures = (await _db.getPendingEventLogs()).any(
      (e) => e.retryCount >= kMaxRetries,
    );

    yield state.copyWith(
      phase: hasFailures ? SyncPhase.failed : SyncPhase.completed,
    );
  }
}
