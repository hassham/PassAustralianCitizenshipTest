import 'package:flutter/material.dart';

import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';

class CitizenshipStudyApp extends StatefulWidget {
  const CitizenshipStudyApp({super.key});

  @override
  State<CitizenshipStudyApp> createState() => _CitizenshipStudyAppState();
}

class _CitizenshipStudyAppState extends State<CitizenshipStudyApp> {
  late final router = createAppRouter();

  @override
  void dispose() {
    router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Pass Australian Citizenship Test',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      highContrastTheme: AppTheme.highContrast,
      themeMode: ThemeMode.system,
    );
  }
}
