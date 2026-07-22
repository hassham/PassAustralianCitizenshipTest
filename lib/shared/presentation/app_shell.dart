import 'package:flutter/material.dart';

import '../../features/practice/presentation/home_screen.dart';
import '../../features/practice/presentation/practice_hub_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../features/exams/presentation/exams_home_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int index = 0;

  static const pages = [
    HomeScreen(),
    PracticeHubScreen(),
    ExamsHomeScreen(),
    ProgressScreen(),
    _ComingSoonScreen(
      title: 'Settings',
      message: 'Study preferences and app information will appear here.',
      icon: Icons.settings_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: index, children: pages),
    bottomNavigationBar: NavigationBar(
      selectedIndex: index,
      onDestinationSelected: (value) => setState(() => index = value),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.school_outlined),
          selectedIcon: Icon(Icons.school),
          label: 'Practice',
        ),
        NavigationDestination(
          icon: Icon(Icons.fact_check_outlined),
          selectedIcon: Icon(Icons.fact_check),
          label: 'Exams',
        ),
        NavigationDestination(
          icon: Icon(Icons.insights_outlined),
          selectedIcon: Icon(Icons.insights),
          label: 'Progress',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings_outlined),
          selectedIcon: Icon(Icons.settings),
          label: 'Settings',
        ),
      ],
    ),
  );
}

class _ComingSoonScreen extends StatelessWidget {
  const _ComingSoonScreen({
    required this.title,
    required this.message,
    required this.icon,
  });
  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 20),
            Text(message, textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}
