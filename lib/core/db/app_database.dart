import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Walks, GpsPoints, EventLogs])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'pathlog');
  }

  // ─── Walk queries ──────────────────────────────────────────────────────────

  Future<Walk?> getActiveWalk() => (select(
    walks,
  )..where((w) => w.status.equalsValue(WalkStatus.active))).getSingleOrNull();

  Future<void> insertWalk(WalksCompanion walk) => into(walks).insert(walk);

  Future<void> updateWalk(String id, WalksCompanion companion) =>
      (update(walks)..where((w) => w.id.equals(id))).write(companion);

  Stream<List<Walk>> watchAllWalks() =>
      (select(walks)..orderBy([(w) => OrderingTerm.desc(w.startedAt)])).watch();

  // ─── GpsPoint queries ──────────────────────────────────────────────────────

  Future<void> insertGpsPoint(GpsPointsCompanion point) =>
      into(gpsPoints).insert(point);

  Future<List<GpsPoint>> getPendingGpsPoints(String walkId) =>
      (select(gpsPoints)
            ..where(
              (g) =>
                  g.walkId.equals(walkId) &
                  g.syncStatus.equalsValue(SyncStatus.pending),
            )
            ..orderBy([(g) => OrderingTerm.asc(g.capturedAt)]))
          .get();

  Future<void> markGpsPointsSynced(List<String> ids) =>
      (update(gpsPoints)..where((g) => g.id.isIn(ids))).write(
        const GpsPointsCompanion(syncStatus: Value(SyncStatus.synced)),
      );

  // ─── EventLog queries ──────────────────────────────────────────────────────

  Future<void> insertEventLog(EventLogsCompanion log) =>
      into(eventLogs).insert(log);

  Future<List<EventLog>> getPendingEventLogs() =>
      (select(eventLogs)
            ..where((e) => e.syncStatus.equalsValue(SyncStatus.pending))
            ..orderBy([(e) => OrderingTerm.asc(e.createdAt)]))
          .get();

  Future<void> markEventLogSyncing(String id) =>
      (update(eventLogs)..where((e) => e.id.equals(id))).write(
        const EventLogsCompanion(syncStatus: Value(SyncStatus.syncing)),
      );

  Future<void> markEventLogSynced(String id) =>
      (update(eventLogs)..where((e) => e.id.equals(id))).write(
        const EventLogsCompanion(syncStatus: Value(SyncStatus.synced)),
      );

  Future<void> markEventLogFailed(String id, String error, int retryCount) =>
      (update(eventLogs)..where((e) => e.id.equals(id))).write(
        EventLogsCompanion(
          syncStatus: const Value(SyncStatus.failed),
          errorMessage: Value(error),
          retryCount: Value(retryCount),
        ),
      );

  // ─── Sync gate query ───────────────────────────────────────────────────────
  // Used by sync queue: GPS upload only starts after ALL event logs
  // for that walkId are confirmed synced. This is the dependency gate.

  Future<bool> areAllEventLogsSynced(String walkId) async {
    final logs = await (select(
      eventLogs,
    )..where((e) => e.walkId.equals(walkId))).get();
    if (logs.isEmpty) return false;
    return logs.every((e) => e.syncStatus == SyncStatus.synced);
  }

  // ─── UI badge count ────────────────────────────────────────────────────────

  Stream<int> watchPendingCount() {
    final query = select(eventLogs)
      ..where((e) => e.syncStatus.equalsValue(SyncStatus.pending));
    return query.watch().map((rows) => rows.length);
  }
}
