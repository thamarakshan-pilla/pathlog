import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/background/background_sync_handler.dart';
import 'ui/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initBackgroundSync();
  runApp(
    // ProviderScope is the Riverpod root — every provider lives inside this.
    // It must wrap the entire app, not just specific screens.
    const ProviderScope(child: Pathlog()),
  );
}

class Pathlog extends StatelessWidget {
  const Pathlog({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathlog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
