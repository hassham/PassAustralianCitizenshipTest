import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/routing/app_routes.dart';
import '../../exams/application/exam_controller.dart';
import '../../progress/application/progress_providers.dart';
import '../../progress/domain/readiness_insights_models.dart';
import '../application/practice_controller.dart';
import '../domain/study_question.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreSessions());
  }

  Future<void> _restoreSessions() async {
    await Future.wait([
      ref.read(practiceControllerProvider.notifier).restore(),
      ref.read(examControllerProvider.notifier).restore(),
    ]);
    if (!mounted) return;
    ref.invalidate(homeDashboardProvider);
    if (ref.read(examControllerProvider).result?.timedOut ?? false) {
      await context.pushNamed(AppRoutes.examSession);
    }
  }

  Future<void> _startPractice() async {
    await ref.read(practiceControllerProvider.notifier).start(null);
    if (!mounted) return;
    final failure = ref.read(practiceControllerProvider).error;
    if (failure == null) {
      await context.pushNamed(AppRoutes.practiceSession);
      ref.invalidate(homeDashboardProvider);
      ref.invalidate(progressProvider);
    }
  }

  Future<void> _continuePractice() async {
    final restored = await ref
        .read(practiceControllerProvider.notifier)
        .restore();
    if (restored && mounted) {
      await context.pushNamed(AppRoutes.practiceSession);
      ref.invalidate(homeDashboardProvider);
      ref.invalidate(progressProvider);
    }
  }

  Future<void> _continueExam() async {
    final restored = await ref.read(examControllerProvider.notifier).restore();
    if (restored && mounted) {
      await context.pushNamed(AppRoutes.examSession);
      ref.invalidate(homeDashboardProvider);
    }
  }

  Future<void> _retry() async {
    try {
      await ref.read(practiceRepositoryProvider).retryInitialise();
    } finally {
      ref.invalidate(categoriesProvider);
      ref.invalidate(progressProvider);
      ref.invalidate(starredQuestionsProvider);
      ref.invalidate(homeDashboardProvider);
      ref.invalidate(examConfigProvider);
      ref.invalidate(readinessInsightsProvider);
    }
  }

  Future<void> _refreshContent() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Refresh study content?'),
        content: const Text(
          'The bundled question bank will be imported again. Your progress, '
          'starred questions, and exam history will be kept.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref.read(practiceRepositoryProvider).refreshBundledContent();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Study content was refreshed.')),
        );
      }
    } finally {
      await _retry();
    }
  }

  Future<void> _resetLocalData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset all local data?'),
        content: const Text(
          'Use this only if saved data is corrupted. Practice progress, '
          'starred questions, and exam history will be permanently removed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset local data'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await ref.read(practiceRepositoryProvider).resetLocalDataForRecovery();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Local data was reset. Restart the app to continue.'),
          duration: Duration(seconds: 8),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboard = ref.watch(homeDashboardProvider);
    final insights = ref.watch(readinessInsightsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Citizenship Test Study')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _retry,
          child: dashboard.when(
            loading: () => const _HomeLoadingView(),
            error: (error, _) => _HomeFailureView(
              failure: AppFailure.from(error),
              onRetry: _retry,
              onRefreshContent: _refreshContent,
              onResetLocalData: _resetLocalData,
            ),
            data: (value) => _HomeDashboardView(
              value: value,
              insights: insights,
              onStartPractice: _startPractice,
              onContinuePractice: _continuePractice,
              onContinueExam: _continueExam,
            ),
          ),
        ),
      ),
    );
  }
}

class _HomeDashboardView extends StatelessWidget {
  const _HomeDashboardView({
    required this.value,
    required this.onStartPractice,
    required this.onContinuePractice,
    required this.onContinueExam,
    required this.insights,
  });

  final HomeDashboardModel value;
  final VoidCallback onStartPractice;
  final VoidCallback onContinuePractice;
  final VoidCallback onContinueExam;
  final AsyncValue<ReadinessInsightsModel> insights;

  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(20),
    children: [
      Text(
        'Learn with confidence',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 8),
      const Text('Focused practice that works completely offline.'),
      if (value.hasActivePractice || value.hasActiveExam) ...[
        const SizedBox(height: 24),
        Text(
          'Continue learning',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        if (value.hasActivePractice)
          _ResumeCard(
            icon: Icons.school_outlined,
            title: 'Practice session in progress',
            buttonLabel: 'Continue practice',
            onPressed: onContinuePractice,
          ),
        if (value.hasActivePractice && value.hasActiveExam)
          const SizedBox(height: 10),
        if (value.hasActiveExam)
          _ResumeCard(
            icon: Icons.fact_check_outlined,
            title: 'Mock exam in progress',
            buttonLabel: 'Continue exam',
            onPressed: onContinueExam,
          ),
      ],
      const SizedBox(height: 24),
      _ProgressCard(value: value.progress),
      const SizedBox(height: 12),
      _ReadinessCard(value: insights),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(
            child: _MetricCard(
              icon: Icons.quiz_outlined,
              value: '${value.totalQuestions}',
              label: 'Questions',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _MetricCard(
              icon: Icons.star_outline,
              value: '${value.starredQuestions}',
              label: 'Starred',
            ),
          ),
        ],
      ),
      const SizedBox(height: 24),
      FilledButton.icon(
        onPressed: onStartPractice,
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text('Practice all categories'),
      ),
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: () => context.goNamed(AppRoutes.practice),
        icon: const Icon(Icons.tune),
        label: const Text('Build a practice session'),
      ),
      const SizedBox(height: 10),
      OutlinedButton.icon(
        onPressed: () => context.goNamed(AppRoutes.exams),
        icon: const Icon(Icons.fact_check_outlined),
        label: const Text('Take a mock exam'),
      ),
      const SizedBox(height: 10),
      TextButton.icon(
        onPressed: () => context.pushNamed(AppRoutes.starred),
        icon: const Icon(Icons.star_outline),
        label: Text('Review starred questions (${value.starredQuestions})'),
      ),
    ],
  );
}

class _ReadinessCard extends StatelessWidget {
  const _ReadinessCard({required this.value});
  final AsyncValue<ReadinessInsightsModel> value;

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.secondaryContainer,
    child: ListTile(
      leading: const Icon(Icons.insights_outlined),
      title: const Text('Readiness score'),
      subtitle: value.when(
        loading: () => const Text('Calculating readiness…'),
        error: (_, _) => const Text('Readiness unavailable'),
        data: (analytics) => Text(
          analytics.readiness.score == null
              ? analytics.recommendations.first
              : '${analytics.readiness.score}/100 · ${analytics.readiness.label}\n'
                    '${analytics.recommendations.first}',
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.goNamed(AppRoutes.progress),
    ),
  );
}

class _ResumeCard extends StatelessWidget {
  const _ResumeCard({
    required this.icon,
    required this.title,
    required this.buttonLabel,
    required this.onPressed,
  });

  final IconData icon;
  final String title;
  final String buttonLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.primaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        children: [
          Icon(icon, size: 36),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                TextButton(onPressed: onPressed, child: Text(buttonLabel)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.value});
  final ProgressSummary value;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(radius: 26, child: Icon(Icons.insights)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${value.accuracy}% accuracy',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text('${value.attempted} questions answered'),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Column(
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineSmall),
          Text(label),
        ],
      ),
    ),
  );
}

class _HomeLoadingView extends StatelessWidget {
  const _HomeLoadingView();

  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(20),
    children: const [
      LinearProgressIndicator(),
      SizedBox(height: 24),
      Card(child: SizedBox(height: 120)),
      SizedBox(height: 16),
      Card(child: SizedBox(height: 100)),
    ],
  );
}

class _HomeFailureView extends StatelessWidget {
  const _HomeFailureView({
    required this.failure,
    required this.onRetry,
    required this.onRefreshContent,
    required this.onResetLocalData,
  });

  final AppFailure failure;
  final VoidCallback onRetry;
  final VoidCallback onRefreshContent;
  final VoidCallback onResetLocalData;

  @override
  Widget build(BuildContext context) => ListView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.all(28),
    children: [
      const SizedBox(height: 60),
      Icon(
        Icons.error_outline,
        size: 64,
        color: Theme.of(context).colorScheme.error,
      ),
      const SizedBox(height: 18),
      Text(
        failure.title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 8),
      Text(failure.message, textAlign: TextAlign.center),
      const SizedBox(height: 24),
      FilledButton(onPressed: onRetry, child: const Text('Try again')),
      if (failure is ContentFailure) ...[
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: onRefreshContent,
          child: const Text('Refresh bundled content'),
        ),
      ],
      if (failure is StorageFailure) ...[
        const SizedBox(height: 10),
        OutlinedButton(
          onPressed: onResetLocalData,
          child: const Text('Reset corrupted local data'),
        ),
      ],
    ],
  );
}
