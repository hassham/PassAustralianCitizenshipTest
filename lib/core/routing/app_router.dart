import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/exams/presentation/exam_review_screen.dart';
import '../../features/exams/presentation/exam_screen.dart';
import '../../features/exams/presentation/exams_home_screen.dart';
import '../../features/exams/presentation/exam_history_screen.dart';
import '../../features/exams/presentation/exam_history_detail_screen.dart';
import '../../features/practice/presentation/home_screen.dart';
import '../../features/practice/presentation/practice_hub_screen.dart';
import '../../features/practice/presentation/practice_screen.dart';
import '../../features/practice/presentation/starred_screen.dart';
import '../../features/progress/presentation/progress_screen.dart';
import '../../shared/presentation/app_shell.dart';
import '../../features/settings/presentation/settings_screen.dart';
import 'app_routes.dart';

GoRouter createAppRouter() => GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/practice',
              name: AppRoutes.practice,
              builder: (context, state) => const PracticeHubScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/exams',
              name: AppRoutes.exams,
              builder: (context, state) => const ExamsHomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/progress',
              name: AppRoutes.progress,
              builder: (context, state) => const ProgressScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              name: AppRoutes.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/practice/session',
      name: AppRoutes.practiceSession,
      builder: (context, state) => const PracticeScreen(),
    ),
    GoRoute(
      path: '/practice/starred',
      name: AppRoutes.starred,
      builder: (context, state) => const StarredScreen(),
    ),
    GoRoute(
      path: '/exams/session',
      name: AppRoutes.examSession,
      builder: (context, state) => const ExamScreen(),
    ),
    GoRoute(
      path: '/exams/review',
      name: AppRoutes.examReview,
      builder: (context, state) => const ExamReviewScreen(),
    ),
    GoRoute(
      path: '/exams/history',
      name: AppRoutes.examHistory,
      builder: (context, state) => const ExamHistoryScreen(),
    ),
    GoRoute(
      path: '/exams/history/:attemptId',
      name: AppRoutes.examHistoryDetail,
      builder: (context, state) => ExamHistoryDetailScreen(
        attemptId: int.parse(state.pathParameters['attemptId']!),
      ),
    ),
  ],
  navigatorKey: _rootNavigatorKey,
  errorBuilder: (context, state) => Scaffold(
    appBar: AppBar(title: const Text('Page not found')),
    body: Center(
      child: FilledButton(
        onPressed: () => context.goNamed(AppRoutes.home),
        child: const Text('Back to home'),
      ),
    ),
  ),
);

final _rootNavigatorKey = GlobalKey<NavigatorState>();
