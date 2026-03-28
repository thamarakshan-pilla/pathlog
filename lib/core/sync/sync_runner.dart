import '../db/app_database.dart';
import '../sync/cloudflare_client.dart';
import '../sync/sync_queue.dart';
import '../sync/sync_state.dart';

class SyncRunner {
  final AppDatabase _db;
  final CloudflareClient _client; // stored directly now
  late final SyncQueue _queue;

  SyncRunner({required AppDatabase db, required CloudflareClient client})
      : _db = db,
        _client = client {
    _queue = SyncQueue(db: db, client: client);
  }

  Stream<SyncState> run({String? walkId}) async* {
    SyncState state = const SyncState();

    // ── Phase 1: Event Logs ──────────────────────────────────────────────────
    // Process one by one so we can yield after each item.
    // This is what drives the per-item progress bar in sync_progress_screen.
    final pendingLogs = await _db.getPendingEventLogs();

    yield state = state.copyWith(
      phase: SyncPhase.syncingLogs,
      totalEventLogs: pendingLogs.length,
    );

    for (final log in pendingLogs) {
      if (log.retryCount >= kMaxRetries) continue;

      await _db.markEventLogSyncing(log.id);

      try {
        await _client.uploadEventLog(
          id: log.id,
          walkId: log.walkId,
          eventType: log.eventType,
          payload: log.payload,
          createdAt: log.createdAt,
        );
        await _db.markEventLogSynced(log.id);

        // Yield after every confirmed upload — drives the progress bar
        yield state = state.copyWith(
          syncedEventLogs: state.syncedEventLogs + 1,
        );
      } on SyncUploadException catch (e) {
        await _db.markEventLogFailed(log.id, e.message, log.retryCount + 1);
      }
    }

    // ── Phase 2: GPS Points (dependency-gated) ───────────────────────────────
    // GPS is a single batch call — no per-item progress needed here.
    // The dependency gate lives inside sync_queue.processGpsPoints().
    if (walkId != null) {
      final pendingGps = await _db.getPendingGpsPoints(walkId);

      yield state = state.copyWith(
        phase: SyncPhase.syncingGps,
        totalGpsPoints: pendingGps.length,
      );

      final syncedGps = await _queue.processGpsPoints(walkId: walkId);

      yield state = state.copyWith(
        syncedGpsPoints: syncedGps,
      );
    }

    // ── Phase 3: Result ──────────────────────────────────────────────────────
    final hasFailures = (await _db.getPendingEventLogs())
        .any((e) => e.retryCount >= kMaxRetries);

    yield state.copyWith(
      phase: hasFailures ? SyncPhase.failed : SyncPhase.completed,
    );
  }
}