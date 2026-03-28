import '../../core/db/app_database.dart' show Walk;
import '../../core/db/tables.dart';

/// Immutable UI state for the active walk screen.
/// WalkController emits new copies of this as things change.
class WalkState {
  final Walk? activeWalk;
  final GpsMode gpsMode;
  final int gpsPointCount;
  final bool isLoading;
  final String? error;

  const WalkState({
    this.activeWalk,
    this.gpsMode = GpsMode.idle,
    this.gpsPointCount = 0,
    this.isLoading = false,
    this.error,
  });

  bool get isWalking => activeWalk?.status == WalkStatus.active;
  bool get isPaused => activeWalk?.status == WalkStatus.paused;
  bool get isIdle => activeWalk == null;

  WalkState copyWith({
    Walk? activeWalk,
    GpsMode? gpsMode,
    int? gpsPointCount,
    bool? isLoading,
    String? error,
  }) {
    return WalkState(
      activeWalk: activeWalk ?? this.activeWalk,
      gpsMode: gpsMode ?? this.gpsMode,
      gpsPointCount: gpsPointCount ?? this.gpsPointCount,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
