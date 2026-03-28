import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/app_database.dart';
import '../../core/gps/gps_engine.dart';
import '../../core/sync/cloudflare_client.dart';
import '../../core/sync/sync_runner.dart';
import '../../core/sync/sync_state.dart';
import 'walk_repository.dart';
import 'walk_state.dart';

// ── Providers ──────────────────────────────────────────────────────────────────

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final gpsEngineProvider = Provider<GpsEngine>((ref) {
  final engine = GpsEngine();
  ref.onDispose(() => engine.stop());
  return engine;
});

final cloudflareClientProvider = Provider<CloudflareClient>((ref) {
  return CloudflareClient();
});

final walkRepositoryProvider = Provider<WalkRepository>((ref) {
  final repo = WalkRepository(
    db: ref.watch(appDatabaseProvider),
    gpsEngine: ref.watch(gpsEngineProvider),
  );
  ref.onDispose(() => repo.dispose());
  return repo;
});

final syncRunnerProvider = Provider<SyncRunner>((ref) {
  return SyncRunner(
    db: ref.watch(appDatabaseProvider),
    client: ref.watch(cloudflareClientProvider),
  );
});

final walkControllerProvider = NotifierProvider<WalkController, WalkState>(
  WalkController.new,
);

// ── WalkController ─────────────────────────────────────────────────────────────

class WalkController extends Notifier<WalkState> {
  late final WalkRepository _repository;
  late final SyncRunner _syncRunner;

  @override
  WalkState build() {
    _repository = ref.watch(walkRepositoryProvider);
    _syncRunner = ref.watch(syncRunnerProvider);

    // Wire repository callbacks to state updates
    _repository.onGpsPointAdded = (count) {
      state = state.copyWith(gpsPointCount: count);
    };
    _repository.onModeChanged = (mode) {
      state = state.copyWith(gpsMode: mode);
    };

    // Restore state if app was killed mid-walk
    _restoreActiveWalk();

    return const WalkState();
  }

  Future<void> _restoreActiveWalk() async {
    final active = await _repository.getActiveWalk();
    if (active != null) {
      final count = await _repository.countGpsPointsForWalk(active.id);
      state = state.copyWith(activeWalk: active, gpsPointCount: count);
    }
  }

  Future<void> startWalk() async {
    state = state.copyWith(isLoading: true);
    try {
      final walk = await _repository.startWalk();
      state = state.copyWith(activeWalk: walk, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> pauseWalk() async {
    if (state.activeWalk == null) return;
    final walk = await _repository.pauseWalk(state.activeWalk!.id);
    state = state.copyWith(activeWalk: walk);
  }

  Future<void> resumeWalk() async {
    if (state.activeWalk == null) return;
    final walk = await _repository.resumeWalk(state.activeWalk!.id);
    state = state.copyWith(activeWalk: walk);
  }

  /// Completes the walk and returns a sync stream for the progress screen.
  Stream<SyncState> completeWalk() async* {
    if (state.activeWalk == null) return;
    final walkId = state.activeWalk!.id;

    await _repository.completeWalk(walkId);
    state = state.copyWith(activeWalk: null, gpsPointCount: 0);

    yield* _syncRunner.run(walkId: walkId);
  }

  /// iOS foreground catch-up sync
  Future<void> onAppForegrounded() async {
    await _syncRunner.run().last;
  }
}
