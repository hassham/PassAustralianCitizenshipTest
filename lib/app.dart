import 'package:flutter/material.dart';

import 'core/routing/app_router.dart';

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF005A9C),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7F8FA),
        cardTheme: const CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            side: BorderSide(color: Color(0xFFE2E5E9)),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(52),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
        focusColor: const Color(0xFF005A9C).withValues(alpha: 0.22),
      ),
      highContrastTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF003E6B),
          contrastLevel: 1,
        ),
        useMaterial3: true,
      ),
    );
  }
}
