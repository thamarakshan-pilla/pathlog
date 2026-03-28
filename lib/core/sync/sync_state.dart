/// Represents the full state of one sync cycle.
/// Both the background WorkManager task and the
/// sync_progress_screen UI share this same model.
enum SyncPhase {
  idle,         // Nothing happening
  syncingLogs,  // Uploading event logs
  syncingGps,   // Uploading GPS points (only after logs confirmed)
  completed,    // All items synced successfully
  failed,       // One or more items failed after max retries
}

class SyncState {
  final SyncPhase phase;

  // Progress counters — drives the progress UI (POC 7)
  final int totalEventLogs;
  final int syncedEventLogs;
  final int totalGpsPoints;
  final int syncedGpsPoints;

  // If failed, this holds the last error message
  final String? errorMessage;

  const SyncState({
    this.phase = SyncPhase.idle,
    this.totalEventLogs = 0,
    this.syncedEventLogs = 0,
    this.totalGpsPoints = 0,
    this.syncedGpsPoints = 0,
    this.errorMessage,
  });

  SyncState copyWith({
    SyncPhase? phase,
    int? totalEventLogs,
    int? syncedEventLogs,
    int? totalGpsPoints,
    int? syncedGpsPoints,
    String? errorMessage,
  }) {
    return SyncState(
      phase: phase ?? this.phase,
      totalEventLogs: totalEventLogs ?? this.totalEventLogs,
      syncedEventLogs: syncedEventLogs ?? this.syncedEventLogs,
      totalGpsPoints: totalGpsPoints ?? this.totalGpsPoints,
      syncedGpsPoints: syncedGpsPoints ?? this.syncedGpsPoints,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  // Convenience getters for the UI
  double get eventLogProgress => totalEventLogs == 0
      ? 0
      : syncedEventLogs / totalEventLogs;

  double get gpsProgress => totalGpsPoints == 0
      ? 0
      : syncedGpsPoints / totalGpsPoints;

  bool get isComplete => phase == SyncPhase.completed;
  bool get isFailed => phase == SyncPhase.failed;
}