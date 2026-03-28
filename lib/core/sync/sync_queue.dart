import '../db/app_database.dart';
import 'cloudflare_client.dart';

const int kMaxRetries = 3;

/// The dependency-aware sync queue.
///
/// Rule: GPS points for a walkId are NEVER uploaded until ALL event logs
/// for that same walkId are confirmed synced.
///
/// This mirrors the architecture plan: event logs give the backend context
/// (walk exists, walk started/ended) before GPS data arrives.
class SyncQueue {
  final AppDatabase _db;
  final CloudflareClient _client;

  SyncQueue({required AppDatabase db, required CloudflareClient client})
    : _db = db,
      _client = client;

  /// Process all pending event logs.
  /// Returns the number successfully synced.
  Future<int> processEventLogs({
    void Function(int synced, int total)? onProgress,
  }) async {
    final pending = await _db.getPendingEventLogs();
    if (pending.isEmpty) return 0;

    int synced = 0;

    for (final log in pending) {
      // Terminal failure — mark as permanently failed so it no longer
      // blocks getPendingEventLogs() or areAllEventLogsSynced()
      if (log.retryCount >= kMaxRetries) {
        await _db.markEventLogFailed(
          log.id,
          log.errorMessage ?? 'Max retries exceeded',
          log.retryCount,
        );
        continue;
      }

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
        synced++;
        onProgress?.call(synced, pending.length);
      } on SyncUploadException catch (e) {
        final nextRetry = log.retryCount + 1;
        if (nextRetry >= kMaxRetries) {
          // This attempt pushed it over the limit — mark terminal
          await _db.markEventLogFailed(log.id, e.message, nextRetry);
        } else {
          // Non-terminal — requeue as pending so next cycle retries
          await _db.requeueEventLog(log.id, e.message, nextRetry);
        }
      }
    }
    return synced;
  }

  /// Process GPS points — but ONLY for walks where all event logs are synced.
  /// This is the dependency gate from the architecture plan.
  Future<int> processGpsPoints({
    required String walkId,
    void Function(int synced, int total)? onProgress,
  }) async {
    // ── Dependency gate ──────────────────────────────────────────────────────
    // Do not proceed if the backend doesn't have the event log context yet
    final logsReady = await _db.areAllEventLogsSynced(walkId);
    if (!logsReady) return 0;

    final pending = await _db.getPendingGpsPoints(walkId);
    if (pending.isEmpty) return 0;

    // Convert to the map format CloudflareClient expects
    final points = pending
        .map(
          (p) => {
            'id': p.id,
            'latitude': p.latitude,
            'longitude': p.longitude,
            'accuracy': p.accuracy,
            'speed': p.speed,
            'gpsMode': p.gpsMode.name,
            'isMocked': p.isMocked,
            'capturedAt': p.capturedAt.toIso8601String(),
          },
        )
        .toList();

    try {
      await _client.uploadGpsPoints(walkId: walkId, points: points);

      // Mark all in one update — batch was atomic on the backend
      await _db.markGpsPointsSynced(pending.map((p) => p.id).toList());
      onProgress?.call(pending.length, pending.length);
      return pending.length;
    } on SyncUploadException {
      // GPS batch failed — don't mark individual points, just leave as pending
      // The next sync cycle will retry the whole batch
      return 0;
    }
  }
}
