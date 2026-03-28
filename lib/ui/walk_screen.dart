import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/db/tables.dart' show GpsMode;
import '../features/walk/walk_controller.dart';
import 'sync_progress_screen.dart';

class WalkScreen extends ConsumerWidget {
  const WalkScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(walkControllerProvider);
    final controller = ref.read(walkControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Walk'),
        centerTitle: true,
        automaticallyImplyLeading: !state.isWalking,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // GPS Mode indicator
            _GpsModeCard(mode: state.gpsMode),
            const SizedBox(height: 32),

            // GPS point counter
            Text(
              '${state.gpsPointCount}',
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Text(
              'GPS points captured',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 48),

            // Action buttons
            if (state.isIdle)
              _ActionButton(
                label: 'Start Walk',
                icon: Icons.play_arrow,
                color: Colors.green,
                onPressed: () => controller.startWalk(),
              ),

            if (state.isWalking) ...[
              _ActionButton(
                label: 'Pause',
                icon: Icons.pause,
                color: Colors.orange,
                onPressed: () => controller.pauseWalk(),
              ),
              const SizedBox(height: 16),
              _ActionButton(
                label: 'Complete Walk',
                icon: Icons.stop,
                color: Colors.red,
                onPressed: () => _onComplete(context, controller),
              ),
            ],

            if (state.isPaused) ...[
              _ActionButton(
                label: 'Resume',
                icon: Icons.play_arrow,
                color: Colors.green,
                onPressed: () => controller.resumeWalk(),
              ),
              const SizedBox(height: 16),
              _ActionButton(
                label: 'Complete Walk',
                icon: Icons.stop,
                color: Colors.red,
                onPressed: () => _onComplete(context, controller),
              ),
            ],

            if (state.isLoading) const CircularProgressIndicator(),

            if (state.error != null)
              Text(state.error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  void _onComplete(BuildContext context, WalkController controller) {
    // completeWalk() returns a Stream<SyncState>.
    // We pass it directly to SyncProgressScreen — it owns the stream
    // and shows progress until sync is done.
    final syncStream = controller.completeWalk();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SyncProgressScreen(syncStream: syncStream),
      ),
    );
  }
}

class _GpsModeCard extends StatelessWidget {
  final GpsMode mode;
  const _GpsModeCard({required this.mode});

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (mode) {
      GpsMode.idle => ('IDLE', Colors.grey, Icons.gps_off),
      GpsMode.transit => ('TRANSIT', Colors.orange, Icons.gps_not_fixed),
      GpsMode.active => ('ACTIVE', Colors.green, Icons.gps_fixed),
    };

    return Card(
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(
              'GPS: $label',
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(label, style: const TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
