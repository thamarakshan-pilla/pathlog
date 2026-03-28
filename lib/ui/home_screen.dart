import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/db/app_database.dart';
import '../core/db/tables.dart';
import '../features/walk/walk_controller.dart';
import 'walk_screen.dart';

// A provider that watches all walks from the DB as a stream.
// Every time a walk is inserted or updated, this rebuilds automatically.
final allWalksProvider = StreamProvider<List<Walk>>((ref) {
  return ref.watch(appDatabaseProvider).watchAllWalks();
});

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walksAsync = ref.watch(allWalksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pathlog'), centerTitle: true),
      body: walksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (walks) {
          if (walks.isEmpty) {
            return const Center(
              child: Text(
                'No walks yet.\nTap + to start your first walk.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            itemCount: walks.length,
            itemBuilder: (context, index) {
              final walk = walks[index];
              return _WalkTile(walk: walk);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const WalkScreen()),
        ),
        child: const Icon(Icons.directions_walk),
      ),
    );
  }
}

class _WalkTile extends StatelessWidget {
  final Walk walk;
  const _WalkTile({required this.walk});

  @override
  Widget build(BuildContext context) {
    final duration = walk.endedAt != null
        ? walk.endedAt!.difference(walk.startedAt)
        : DateTime.now().difference(walk.startedAt);

    return ListTile(
      leading: Icon(
        _iconForStatus(walk.status),
        color: _colorForStatus(walk.status),
      ),
      title: Text(_formatDate(walk.startedAt)),
      subtitle: Text(_formatDuration(duration)),
      trailing: _StatusChip(status: walk.status),
    );
  }

  IconData _iconForStatus(WalkStatus status) => switch (status) {
    WalkStatus.active => Icons.play_arrow,
    WalkStatus.paused => Icons.pause,
    WalkStatus.completed => Icons.check_circle,
  };

  Color _colorForStatus(WalkStatus status) => switch (status) {
    WalkStatus.active => Colors.green,
    WalkStatus.paused => Colors.orange,
    WalkStatus.completed => Colors.blue,
  };

  String _formatDate(DateTime dt) =>
      '${dt.day}/${dt.month}/${dt.year}  ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return h > 0 ? '${h}h ${m}m ${s}s' : '${m}m ${s}s';
  }
}

class _StatusChip extends StatelessWidget {
  final WalkStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final label = status.name[0].toUpperCase() + status.name.substring(1);
    final color = switch (status) {
      WalkStatus.active => Colors.green,
      WalkStatus.paused => Colors.orange,
      WalkStatus.completed => Colors.blue,
    };
    return Chip(
      label: Text(label, style: TextStyle(color: color, fontSize: 12)),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
    );
  }
}
