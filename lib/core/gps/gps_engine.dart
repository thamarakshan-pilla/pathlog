import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'gps_mode.dart';
import '../db/tables.dart' show GpsMode;


/// The adaptive GPS engine.
///
/// Responsibilities:
///   1. Manage a single location stream and reconfigure it when mode changes
///   2. Emit Position objects to whoever is listening (walk_repository)
///   3. Switch modes automatically based on speed
///   4. Expose current mode as a stream so the UI can display it
///
/// This class knows nothing about Drift or the UI.
/// It only speaks in terms of Position and GpsMode.
class GpsEngine {
  GpsMode _currentMode = GpsMode.idle;
  StreamController<Position>? _positionController;
  StreamController<GpsMode>? _modeController;
  StreamSubscription<Position>? _locationSubscription;

  bool _isRunning = false;

  /// Stream of GPS positions — walk_repository listens to this
  Stream<Position> get positionStream =>
      _positionController!.stream;

  /// Stream of mode changes — UI listens to this to show current mode
  Stream<GpsMode> get modeStream =>
      _modeController!.stream;

  GpsMode get currentMode => _currentMode;

  /// Call this once when a walk starts (or on app launch for IDLE monitoring).
  Future<void> start() async {
    if (_isRunning) return;

    _positionController = StreamController<Position>.broadcast();
    _modeController = StreamController<GpsMode>.broadcast();

    _isRunning = true;
    _applyMode(GpsMode.idle);
  }

  /// Call this when the walk ends or the app goes fully to background.
  Future<void> stop() async {
    await _locationSubscription?.cancel();
    await _positionController?.close();
    await _modeController?.close();
    _isRunning = false;
  }

  /// Reconfigures the underlying location stream for the given mode.
  /// Called internally on mode switch, and also on start().
  void _applyMode(GpsMode mode) {
    _locationSubscription?.cancel();

    final config = gpsModeConfigs[mode]!;

    final settings = LocationSettings(
      accuracy: config.accuracy,
      distanceFilter: config.distanceFilter.toInt(),
    );

    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: settings,
    ).listen(_onPosition);

    _currentMode = mode;
    _modeController?.add(mode);
  }

  /// Called on every incoming position from geolocator.
  /// Two jobs: forward the position, then check if mode should change.
  void _onPosition(Position position) {
    // Forward to walk_repository
    _positionController?.add(position);

    // Mode switching logic based on speed
    _evaluateModeSwitch(position.speed);
  }

  void _evaluateModeSwitch(double speedMs) {
    final next = _computeNextMode(speedMs);
    if (next != _currentMode) {
      _applyMode(next);
    }
  }

  GpsMode _computeNextMode(double speedMs) {
    switch (_currentMode) {
      case GpsMode.idle:
        if (speedMs > kIdleToTransitSpeed) return GpsMode.transit;
        return GpsMode.idle;

      case GpsMode.transit:
        if (speedMs > kTransitToActiveSpeed) return GpsMode.active;
        if (speedMs < kActiveToTransitSpeed) return GpsMode.idle;
        return GpsMode.transit;

      case GpsMode.active:
        if (speedMs < kActiveToTransitSpeed) return GpsMode.transit;
        return GpsMode.active;
    }
  }
}