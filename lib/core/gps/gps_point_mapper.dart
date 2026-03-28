import 'package:drift/drift.dart' show Value;
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import '../db/tables.dart';
import '../db/app_database.dart';

/// Converts a raw geolocator [Position] into a [GpsPointsCompanion]
/// ready to be inserted into Drift.
///
/// This is the only place that knows both geolocator's types AND Drift's types.
/// Keeping it isolated means if we swap geolocator for another plugin,
/// only this file changes.
class GpsPointMapper {
  static final _uuid = Uuid();

  static GpsPointsCompanion fromPosition({
    required Position position,
    required String walkId,
    required GpsMode mode,
  }) {
    return GpsPointsCompanion.insert(
      id: _uuid.v4(),
      walkId: walkId,
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      speed: Value(position.speed),
      gpsMode: mode,
      // geolocator exposes isMocked on Android (LocationManager flag).
      // On iOS it's less reliable but we still capture it.
      isMocked: Value(position.isMocked),
      capturedAt: position.timestamp,
      syncStatus: SyncStatus.pending,
    );
  }
}
