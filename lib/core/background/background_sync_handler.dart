import 'package:workmanager/workmanager.dart';
import '../db/app_database.dart';
import '../sync/cloudflare_client.dart';
import '../sync/sync_runner.dart';

const kBackgroundSyncTask = 'pathlog.background_sync';

/// Called by WorkManager (Android) and BGAppRefreshTask (iOS)
/// when the OS decides to run our background task.
///
/// This runs in a SEPARATE ISOLATE — it has no access to the
/// main isolate's memory, providers, or streams.
/// It must create its own DB and client instances from scratch.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName != kBackgroundSyncTask) return Future.value(true);

    // Fresh instances — we are in a new isolate
    final db = AppDatabase();
    final client = CloudflareClient();
    final runner = SyncRunner(db: db, client: client);

    try {
      // Run the sync cycle, drain the stream to completion
      // No walkId here — background sync flushes event logs only
      await runner.run().last;
      return Future.value(true); // Tell WorkManager: success
    } catch (_) {
      return Future.value(false); // Tell WorkManager: retry me
    } finally {
      await db.close();
    }
  });
}

/// Registers and configures WorkManager.
/// Call this once from main.dart before runApp().
Future<void> initBackgroundSync() async {
  await Workmanager().initialize(callbackDispatcher);

  await Workmanager().registerPeriodicTask(
    kBackgroundSyncTask,
    kBackgroundSyncTask,
    // 15 min is the minimum WorkManager allows on Android.
    // iOS ignores this — BGAppRefreshTask timing is OS-controlled.
    frequency: const Duration(minutes: 15),
    constraints: Constraints(
      // Only sync when network is available — no point trying offline
      networkType: NetworkType.connected,
    ),
    // If a previous task is still running, replace it
    existingWorkPolicy: ExistingPeriodicWorkPolicy.replace,
  );
}
