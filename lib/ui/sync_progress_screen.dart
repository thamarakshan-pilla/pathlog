import 'package:flutter/material.dart';
import '../core/sync/sync_state.dart';
import 'home_screen.dart';

/// POC 7 — End-of-walk blocking sync progress screen.
///
/// This screen receives the SyncState stream from WalkController
/// and shows granular progress until sync completes or fails.
/// The user cannot dismiss this screen until sync is done.
class SyncProgressScreen extends StatelessWidget {
  final Stream<SyncState> syncStream;

  const SyncProgressScreen({super.key, required this.syncStream});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent back navigation while sync is in progress
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: StreamBuilder<SyncState>(
            stream: syncStream,
            initialData: const SyncState(),
            builder: (context, snapshot) {
              final state = snapshot.data ?? const SyncState();

              // Sync done — show result and allow navigation
              if (state.isComplete || state.isFailed) {
                return _SyncResultView(
                  success: state.isComplete,
                  errorMessage: state.errorMessage,
                  onDone: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (_) => false, // Clear entire navigation stack
                  ),
                );
              }

              // Sync in progress — show progress bars
              return Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Syncing walk data…',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please wait while your walk is uploaded.',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 48),

                    // Event logs progress
                    _SyncProgressRow(
                      label: 'Event logs',
                      synced: state.syncedEventLogs,
                      total: state.totalEventLogs,
                      progress: state.eventLogProgress,
                      isActive: state.phase == SyncPhase.syncingLogs,
                    ),
                    const SizedBox(height: 24),

                    // GPS points progress
                    _SyncProgressRow(
                      label: 'GPS points',
                      synced: state.syncedGpsPoints,
                      total: state.totalGpsPoints,
                      progress: state.gpsProgress,
                      // GPS phase only unlocks after logs are done
                      isActive: state.phase == SyncPhase.syncingGps,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SyncProgressRow extends StatelessWidget {
  final String label;
  final int synced;
  final int total;
  final double progress;
  final bool isActive;

  const _SyncProgressRow({
    required this.label,
    required this.synced,
    required this.total,
    required this.progress,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (isActive)
                  const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  Icon(
                    synced == total && total > 0
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 14,
                    color: synced == total && total > 0
                        ? Colors.green
                        : Colors.grey,
                  ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            Text(
              total == 0 ? 'Waiting…' : '$synced / $total',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: total == 0 ? 0 : progress,
          backgroundColor: Colors.grey.shade200,
          color: isActive ? Colors.deepPurple : Colors.green,
          minHeight: 6,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

class _SyncResultView extends StatelessWidget {
  final bool success;
  final String? errorMessage;
  final VoidCallback onDone;

  const _SyncResultView({
    required this.success,
    this.errorMessage,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            success ? Icons.cloud_done : Icons.cloud_off,
            size: 80,
            color: success ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 24),
          Text(
            success ? 'Walk synced!' : 'Sync incomplete',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            success
                ? 'Your walk data has been uploaded successfully.'
                : errorMessage ??
                      'Some items failed to sync. They will retry automatically.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}
