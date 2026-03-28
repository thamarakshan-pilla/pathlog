import 'package:geolocator/geolocator.dart' show LocationAccuracy;
import '../db/tables.dart' show GpsMode;


/// Configuration for each GPS mode.
/// These are the thresholds and polling intervals the engine uses
/// to decide when to switch modes and how often to sample location.
class GpsModeConfig {
  final Duration interval;
  final double distanceFilter; // metres — minimum movement before a new point
  final LocationAccuracy accuracy;

  const GpsModeConfig({
    required this.interval,
    required this.distanceFilter,
    required this.accuracy,
  });
}

/// The three operating modes of the Pathlog GPS engine.
///
/// IDLE     — app is open but the user hasn't started a walk.
///            We still poll slowly to detect if they've started moving.
///
/// TRANSIT  — user is moving but below the active threshold.
///            Medium frequency. Catches the start of a walk early.
///
/// ACTIVE   — walk is in progress and user is moving steadily.
///            Highest frequency + accuracy. Burns more battery but
///            this is acceptable during an active session.
const Map<GpsMode, GpsModeConfig> gpsModeConfigs = {
  GpsMode.idle: GpsModeConfig(
    interval: Duration(seconds: 30),
    distanceFilter: 20,
    accuracy: LocationAccuracy.low,
  ),
  GpsMode.transit: GpsModeConfig(
    interval: Duration(seconds: 10),
    distanceFilter: 10,
    accuracy: LocationAccuracy.medium,
  ),
  GpsMode.active: GpsModeConfig(
    interval: Duration(seconds: 3),
    distanceFilter: 5,
    accuracy: LocationAccuracy.high,
  ),
};

/// Speed thresholds (m/s) that trigger mode transitions.
///
///  > 0.5 m/s (~1.8 km/h) → switch from IDLE to TRANSIT
///  > 1.2 m/s (~4.3 km/h) → switch from TRANSIT to ACTIVE (walking pace)
///  < 0.3 m/s             → switch back down toward IDLE (user has stopped)
const double kIdleToTransitSpeed = 0.5;
const double kTransitToActiveSpeed = 1.2;
const double kActiveToTransitSpeed = 0.3;