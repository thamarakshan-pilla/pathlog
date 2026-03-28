/// iOS Background App Refresh handler.
///
/// On iOS, WorkManager uses BGAppRefreshTask under the hood,
/// but the task identifier must be registered in AppDelegate.swift
/// AND in Info.plist before iOS will allow background execution.
///
/// This file documents what needs to happen on the native side.
/// The actual Dart execution is handled by callbackDispatcher in
/// background_sync_handler.dart — WorkManager bridges both platforms.
///
/// iOS-specific constraints to be aware of:
///   - BGAppRefreshTask timing is decided by the OS, not you.
///     iOS learns from usage patterns — if the user opens Pathlog
///     every morning, iOS will schedule refresh before that time.
///   - Background time is limited to ~30 seconds per task.
///     SyncRunner must complete within this window.
///   - If the app has never been foregrounded, iOS won't run
///     background tasks at all.
///
/// The most important iOS sync strategy is FOREGROUND CATCH-UP:
/// Every time the app comes to the foreground, trigger a sync cycle.
/// Don't rely on background refresh as your primary sync mechanism on iOS.
/// This is handled in walk_controller.dart (Step 6).
class IosRefreshHandler {
  /// No Dart code needed here — WorkManager handles the iOS bridge.
  /// This class exists as documentation for the native setup required.
  /// See AppDelegate.swift and Info.plist changes below.
}