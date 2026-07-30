import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/routing/app_routes.dart';
import '../../../shared/presentation/failure_view.dart';
import '../application/progress_providers.dart';
import '../domain/readiness_insights_models.dart';
import '../domain/progress_models.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(progressAnalyticsProvider);
    final insights = ref.watch(readinessInsightsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Progress')),
      body: SafeArea(
        child: progress.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => FailureView(
            failure: AppFailure.from(error),
            onRetry: () => ref.invalidate(progressAnalyticsProvider),
          ),
          data: (value) => value.attempted == 0
              ? _EmptyProgressView(insights: insights)
              : _ProgressView(value: value, insights: insights),
        ),
      ),
    );
  }
}

class _EmptyProgressView extends StatelessWidget {
  const _EmptyProgressView({required this.insights});
  final AsyncValue<ReadinessInsightsModel> insights;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(32),
    children: [
      Column(
        children: [
          const Icon(Icons.insights_outlined, size: 72),
          const SizedBox(height: 16),
          Text(
            'Your progress starts here',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Answer a few practice questions to see accuracy, coverage, '
            'activity, and category insights.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.goNamed(AppRoutes.practice),
            child: const Text('Start practising'),
          ),
        ],
      ),
      const SizedBox(height: 24),
      _ReadinessInsightsSection(value: insights),
    ],
  );
}

class _ProgressView extends StatelessWidget {
  const _ProgressView({required this.value, required this.insights});
  final ProgressAnalyticsModel value;
  final AsyncValue<ReadinessInsightsModel> insights;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
    onRefresh: () async {
      final container = ProviderScope.containerOf(context);
      container.invalidate(progressAnalyticsProvider);
      container.invalidate(readinessInsightsProvider);
      await container.read(progressAnalyticsProvider.future);
    },
    child: ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Learning overview',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final largeText = MediaQuery.textScalerOf(context).scale(1) >= 1.5;
            final columns = largeText
                ? 1
                : constraints.maxWidth >= 560
                ? 4
                : 2;
            final width = (constraints.maxWidth - (columns - 1) * 12) / columns;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _StatisticCard(
                  label: 'Accuracy',
                  value: '${value.accuracy}%',
                  icon: Icons.track_changes,
                ),
                _StatisticCard(
                  label: 'Coverage',
                  value: '${value.coverage}%',
                  icon: Icons.grid_view_outlined,
                ),
                _StatisticCard(
                  label: 'Correct',
                  value: '${value.correct}',
                  icon: Icons.check_circle_outline,
                ),
                _StatisticCard(
                  label: 'Incorrect',
                  value: '${value.incorrect}',
                  icon: Icons.cancel_outlined,
                ),
              ].map((card) => SizedBox(width: width, child: card)).toList(),
            );
          },
        ),
        const SizedBox(height: 24),
        Text('Recent activity', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${value.recentAnswers} answers in the last 7 days',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  value.lastActivityAt == null
                      ? 'No recent activity'
                      : 'Last activity: ${_friendlyDate(value.lastActivityAt!)}',
                ),
                const SizedBox(height: 18),
                _ActivityChart(activity: value.activity),
                const Divider(height: 28),
                Wrap(
                  spacing: 22,
                  runSpacing: 8,
                  children: [
                    Text('${value.practiceSessions} practice sessions'),
                    Text('${value.examAttempts} completed exams'),
                    Text('${value.uniqueQuestions} unique questions'),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        _StrengthSummary(value: value),
        const SizedBox(height: 24),
        Text(
          'Category performance',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        ...value.categories.map(
          (category) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _CategoryCard(category: category),
          ),
        ),
        const SizedBox(height: 14),
        _ReadinessInsightsSection(value: insights),
      ],
    ),
  );
}

class _ReadinessInsightsSection extends StatelessWidget {
  const _ReadinessInsightsSection({required this.value});
  final AsyncValue<ReadinessInsightsModel> value;

  @override
  Widget build(BuildContext context) => Card(
    color: Theme.of(context).colorScheme.secondaryContainer,
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: value.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => const Text(
          'Readiness insights could not be calculated. Pull to refresh.',
        ),
        data: (analytics) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.insights_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Readiness insights',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (analytics.readiness.score == null) ...[
              Text(
                'Readiness: Not enough data',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Text('Complete at least 10 questions in every category.'),
              const SizedBox(height: 8),
              ...analytics.readiness.incompleteCategories.entries.map(
                (entry) => Text('${entry.key}: ${entry.value} more needed'),
              ),
            ] else
              Semantics(
                label:
                    'Readiness score ${analytics.readiness.score} out of 100, '
                    '${analytics.readiness.label}',
                child: Row(
                  children: [
                    SizedBox(
                      width: 72,
                      height: 72,
                      child: CircularProgressIndicator(
                        value: analytics.readiness.score! / 100,
                        strokeWidth: 8,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${analytics.readiness.score}/100',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          Text(analytics.readiness.label),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            if (analytics.readiness.score != null &&
                analytics.readiness.capReason != null) ...[
              const SizedBox(height: 12),
              Text(analytics.readiness.capReason!),
              if (analytics.readiness.nextAction != null)
                Text(analytics.readiness.nextAction!),
            ],
            const SizedBox(height: 20),
            Text('Weak areas', style: Theme.of(context).textTheme.titleMedium),
            if (!analytics.hasEnoughWeakAreaData)
              const Text(
                'Not enough data to identify weak areas. Complete at least '
                '10 questions in every category.',
              )
            else if (analytics.weakAreas.isEmpty)
              const Text('No weak areas detected yet.')
            else
              ...analytics.weakAreas.map(
                (area) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.trending_down),
                  title: Text(area.categoryName),
                  subtitle: Text(
                    '${area.accuracy}% accuracy · target ${area.targetAccuracy}%',
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text(
              'Recommendations',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ...analytics.recommendations.map(
              (recommendation) => ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.arrow_right),
                title: Text(recommendation),
              ),
            ),
            if (analytics.examScores.length >= 2) ...[
              const Divider(),
              Text(
                'Exam trend',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                '${analytics.examScores.first.toStringAsFixed(0)}% → '
                '${analytics.examScores.last.toStringAsFixed(0)}%',
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Semantics(
    label: '$label: $value',
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            Text(label, textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}

class _ActivityChart extends StatelessWidget {
  const _ActivityChart({required this.activity});
  final List<DailyActivityModel> activity;

  @override
  Widget build(BuildContext context) {
    final maximum = activity.fold<int>(
      1,
      (current, item) => item.answers > current ? item.answers : current,
    );
    final textScale = MediaQuery.textScalerOf(context).scale(14) / 14;
    final chartHeight = 132.0 + ((textScale.clamp(1, 2) - 1) * 64);
    return SizedBox(
      height: chartHeight,
      child: Row(
        children: activity.map((item) {
          final heightFactor = 0.15 + (item.answers / maximum * 0.85);
          final weekday = const ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
          return Expanded(
            child: Semantics(
              label:
                  '${_friendlyDate(item.date)}: ${item.answers} answers completed',
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final scaledLineHeight =
                      MediaQuery.textScalerOf(context).scale(14) * 1.45;
                  final barTop = scaledLineHeight + 4;
                  final barBottom = scaledLineHeight + 4;
                  final availableBarHeight =
                      (constraints.maxHeight - barTop - barBottom).clamp(
                        0.0,
                        constraints.maxHeight,
                      );
                  return Stack(
                    clipBehavior: Clip.hardEdge,
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Text(
                          '${item.answers}',
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ),
                      Positioned(
                        bottom: barBottom,
                        child: Container(
                          height: availableBarHeight * heightFactor,
                          width: 18,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Text(
                          weekday[item.date.weekday - 1],
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _StrengthSummary extends StatelessWidget {
  const _StrengthSummary({required this.value});
  final ProgressAnalyticsModel value;

  @override
  Widget build(BuildContext context) {
    final strong = value.strongCategories;
    final weak = value.weakCategories;
    return LayoutBuilder(
      builder: (context, constraints) {
        final cards = [
          _InsightCard(
            icon: Icons.verified_outlined,
            title: 'Strong areas',
            message: strong.isEmpty
                ? value.categories.any((item) => item.attempted < 10)
                      ? 'More practice data is needed before identifying strong areas.'
                      : 'Keep practising to establish a strong area.'
                : strong.map((item) => item.categoryName).join(', '),
            color: const Color(0xFFE7F5EA),
          ),
          _InsightCard(
            icon: Icons.trending_up,
            title: 'Needs attention',
            message: weak.isEmpty
                ? value.categories.any((item) => item.attempted < 10)
                      ? 'Not enough data to identify weak areas.'
                      : 'No weak areas detected yet.'
                : weak.map((item) => item.categoryName).join(', '),
            color: const Color(0xFFFFF3CD),
          ),
        ];
        if (constraints.maxWidth < 600) {
          return Column(
            children: [cards.first, const SizedBox(height: 10), cards.last],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: cards.first),
            const SizedBox(width: 12),
            Expanded(child: cards.last),
          ],
        );
      },
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.icon,
    required this.title,
    required this.message,
    required this.color,
  });
  final IconData icon;
  final String title;
  final String message;
  final Color color;

  @override
  Widget build(BuildContext context) => Card(
    color: color,
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(message),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});
  final CategoryPerformanceModel category;

  @override
  Widget build(BuildContext context) {
    final label = category.attempted > 0 && category.attempted < 10
        ? 'Building data'
        : switch (category.band) {
            PerformanceBand.strong => 'Strong',
            PerformanceBand.weak => 'Needs attention',
            PerformanceBand.developing => 'Developing',
            PerformanceBand.notStarted => 'Not started',
          };
    return Semantics(
      label:
          '${category.categoryName}. $label. '
          '${category.accuracy}% accuracy and ${category.coverage}% coverage.',
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      category.categoryName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Chip(label: Text(label)),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                category.attempted == 0
                    ? 'No questions answered'
                    : '${category.correct}/${category.attempted} correct • '
                          '${category.accuracy}% accuracy',
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: category.coverage / 100,
                semanticsLabel: '${category.categoryName} coverage',
                semanticsValue: '${category.coverage}%',
              ),
              const SizedBox(height: 6),
              Text(
                '${category.uniqueQuestions}/${category.totalQuestions} '
                'questions covered (${category.coverage}%)',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _friendlyDate(DateTime value) {
  final now = DateTime.now();
  final date = DateTime(value.year, value.month, value.day);
  final today = DateTime(now.year, now.month, now.day);
  final difference = today.difference(date).inDays;
  if (difference == 0) return 'Today';
  if (difference == 1) return 'Yesterday';
  return '${value.day}/${value.month}/${value.year}';
}
