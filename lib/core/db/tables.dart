import 'package:drift/drift.dart';

// ─── Enums ────────────────────────────────────────────────────────────────────

enum WalkStatus { active, paused, completed }

enum SyncStatus { pending, syncing, synced, failed }

enum GpsMode { idle, transit, active }

// ─── Table 1: Walks ───────────────────────────────────────────────────────────
// One row per walking session.

class Walks extends Table {
  // Client-generated UUID — used as idempotency key on Cloudflare backend
  TextColumn get id => text()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get status => textEnum<WalkStatus>()();

  @override
  Set<Column> get primaryKey => {id};
}

// ─── Table 2: GpsPoints ──────────────────────────────────────────────────────
// One row per location sample captured during a walk.

class GpsPoints extends Table {
  TextColumn get id => text()();
  TextColumn get walkId => text().references(Walks, #id)();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get accuracy => real()();
  RealColumn get speed => real().withDefault(const Constant(0.0))();

  // Which GPS engine mode was active when this point was captured
  TextColumn get gpsMode => textEnum<GpsMode>()();

  // Android LocationManager / iOS CLLocationManager both expose this flag.
  // Stored so we have it in the audit trail if a trip is ever disputed.
  BoolColumn get isMocked => boolean().withDefault(const Constant(false))();

  DateTimeColumn get capturedAt => dateTime()();
  TextColumn get syncStatus => textEnum<SyncStatus>()();

  @override
  Set<Column> get primaryKey => {id};
}

// ─── Table 3: EventLogs ───────────────────────────────────────────────────────
// Audit trail of walk lifecycle events.
// retryCount + errorMessage live here — no separate retry table needed.
// createdAt enables resync windowing on the backend.

class EventLogs extends Table {
  // Client UUID — backend uses this for idempotent upsert
  TextColumn get id => text()();
  TextColumn get walkId => text().references(Walks, #id)();

  // walk_started | walk_paused | walk_resumed | walk_completed
  TextColumn get eventType => text()();

  // JSON string — flexible payload per event type
  TextColumn get payload => text()();

  DateTimeColumn get createdAt => dateTime()();

  // Exponential backoff state — no separate queue table needed
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();

  TextColumn get syncStatus => textEnum<SyncStatus>()();

  @override
  Set<Column> get primaryKey => {id};
}
