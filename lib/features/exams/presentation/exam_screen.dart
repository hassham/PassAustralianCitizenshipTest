import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../shared/presentation/dialog_action_buttons.dart';
import '../../progress/application/progress_providers.dart';
import '../../practice/application/practice_controller.dart';
import '../application/exam_controller.dart';

class ExamScreen extends ConsumerStatefulWidget {
  const ExamScreen({super.key});

  @override
  ConsumerState<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends ConsumerState<ExamScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    final controller = ref.read(examControllerProvider.notifier);
    if (lifecycleState == AppLifecycleState.resumed) {
      controller.handleResumed();
    } else if (lifecycleState == AppLifecycleState.paused ||
        lifecycleState == AppLifecycleState.inactive ||
        lifecycleState == AppLifecycleState.hidden) {
      controller.handleBackgrounded();
    }
  }

  Future<void> _confirmLeave(
    BuildContext context,
    WidgetRef ref,
    bool didPop,
  ) async {
    if (didPop) return;
    final leave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave exam?'),
        content: const Text(
          'Your answers and current position are saved. You can continue the '
          'exam later.',
        ),
        actions: [
          DialogActionButtons(
            secondaryLabel: 'Keep reviewing',
            onSecondaryPressed: () => Navigator.pop(context, false),
            primaryLabel: 'Leave',
            onPrimaryPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (leave == true && context.mounted) {
      context.goNamed(AppRoutes.exams);
    }
  }

  Future<void> _confirmSubmit(BuildContext context, WidgetRef ref) async {
    final state = ref.read(examControllerProvider);
    final unanswered = state.questions.length - state.answers.length;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to submit?'),
        content: Text(
          unanswered == 0
              ? 'You have answered every question.'
              : '$unanswered question${unanswered == 1 ? '' : 's'} remain unanswered.',
        ),
        actions: [
          DialogActionButtons(
            secondaryLabel: 'Keep reviewing',
            onSecondaryPressed: () => Navigator.pop(context, false),
            primaryLabel: 'Submit exam',
            onPrimaryPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(examControllerProvider.notifier).submit();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(examControllerProvider.select((state) => state.result), (
      previous,
      next,
    ) {
      if (next == null || previous == next) return;
      ref.invalidate(progressAnalyticsProvider);
      ref.invalidate(readinessInsightsProvider);
      ref.invalidate(examHistoryProvider);
      ref.invalidate(homeDashboardProvider);
    });
    final state = ref.watch(examControllerProvider);
    if (state.result != null) return const _ExamResultsView();
    final question = state.current;
    if (question == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final selected = state.answers[state.currentIndex];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) =>
          _confirmLeave(context, ref, didPop),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Question ${state.currentIndex + 1} of ${state.questions.length}',
          ),
          actions: [
            TextButton(
              onPressed: () => _confirmSubmit(context, ref),
              child: const Text('Submit'),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (state.isTimed) ...[
                  _TimerBanner(state: state),
                  const SizedBox(height: 12),
                ],
                LinearProgressIndicator(
                  value: state.answers.length / state.questions.length,
                ),
                const SizedBox(height: 24),
                Text(
                  question.text,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.separated(
                    itemCount: question.options.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final scheme = Theme.of(context).colorScheme;
                      final isSelected = selected == index;
                      return OutlinedButton(
                        onPressed: state.timerLocked
                            ? null
                            : () => ref
                                  .read(examControllerProvider.notifier)
                                  .selectAnswer(index),
                        style: OutlinedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          minimumSize: const Size.fromHeight(58),
                          padding: const EdgeInsets.all(16),
                          backgroundColor: isSelected
                              ? scheme.primaryContainer
                              : scheme.surfaceContainerLow,
                          foregroundColor: isSelected
                              ? scheme.onPrimaryContainer
                              : scheme.onSurface,
                          disabledBackgroundColor: scheme.surfaceContainer,
                          disabledForegroundColor: scheme.onSurfaceVariant,
                          side: BorderSide(
                            color: isSelected ? scheme.primary : scheme.outline,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSelected
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(question.options[index].text)),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _showQuestionNavigator(context, ref),
                  child: Text(
                    'Review questions (${state.answers.length}/${state.questions.length} answered)',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: state.currentIndex == 0
                            ? null
                            : () => ref
                                  .read(examControllerProvider.notifier)
                                  .goTo(state.currentIndex - 1),
                        child: const Text('Previous'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed:
                            state.currentIndex == state.questions.length - 1
                            ? () => _confirmSubmit(context, ref)
                            : () => ref
                                  .read(examControllerProvider.notifier)
                                  .goTo(state.currentIndex + 1),
                        child: Text(
                          state.currentIndex == state.questions.length - 1
                              ? 'Review & submit'
                              : 'Next',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showQuestionNavigator(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final state = ref.read(examControllerProvider);
    final selected = await showModalBottomSheet<int>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Review questions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              const Text('Filled circles are answered.'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  for (var index = 0; index < state.questions.length; index++)
                    ActionChip(
                      avatar: Icon(
                        state.answers.containsKey(index)
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        size: 18,
                      ),
                      label: Text('${index + 1}'),
                      onPressed: () => Navigator.pop(context, index),
                    ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
    if (selected != null) {
      await ref.read(examControllerProvider.notifier).goTo(selected);
    }
  }
}

class _TimerBanner extends StatelessWidget {
  const _TimerBanner({required this.state});
  final ExamState state;

  @override
  Widget build(BuildContext context) {
    final seconds = state.remainingSeconds ?? 0;
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    final time = '$minutes:${remainder.toString().padLeft(2, '0')}';
    return Semantics(
      liveRegion: true,
      label: state.timerLocked
          ? 'Exam timer locked because the device time changed'
          : '$time remaining',
      child: Card(
        color: state.timerLocked
            ? Theme.of(context).colorScheme.errorContainer
            : seconds <= 60
            ? Theme.of(context).colorScheme.tertiaryContainer
            : Theme.of(context).colorScheme.primaryContainer,
        child: ListTile(
          leading: Icon(state.timerLocked ? Icons.lock_clock : Icons.timer),
          title: Text(
            state.timerLocked ? 'Timer locked' : time,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            state.timerLocked
                ? 'The device clock moved backwards. Restart this exam.'
                : state.timerWarning.isEmpty
                ? 'Mock exam'
                : state.timerWarning,
          ),
        ),
      ),
    );
  }
}

class _ExamResultsView extends ConsumerWidget {
  const _ExamResultsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(examControllerProvider);
    final result = state.result!;
    final analytics = ref.watch(readinessInsightsProvider);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Exam results'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Icon(
              result.passed ? Icons.emoji_events_outlined : Icons.menu_book,
              size: 72,
              color: result.passed
                  ? const Color(0xFF238636)
                  : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            if (result.timedOut)
              Card(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                child: const ListTile(
                  leading: Icon(Icons.timer_off_outlined),
                  title: Text("Time's up!"),
                  subtitle: Text('Your exam was automatically submitted.'),
                ),
              ),
            if (result.timedOut) const SizedBox(height: 16),
            Text(
              result.passed ? 'Passed' : 'Keep practising',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Text(
              '${result.score.toStringAsFixed(0)}%',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Correct'),
                    trailing: Text('${result.correct}'),
                  ),
                  ListTile(
                    title: const Text('Incorrect'),
                    trailing: Text('${result.incorrect}'),
                  ),
                  ListTile(
                    title: const Text('Unanswered'),
                    trailing: Text('${result.unanswered}'),
                  ),
                  ListTile(
                    title: const Text('Overall requirement'),
                    subtitle: Text(
                      'At least ${state.config?.passPercentage.toStringAsFixed(0) ?? '75'}%',
                    ),
                    trailing: Icon(
                      result.overallRequirementMet
                          ? Icons.check_circle
                          : Icons.cancel,
                    ),
                  ),
                  ListTile(
                    title: const Text('Australian values'),
                    subtitle: const Text('All 5 answers must be correct'),
                    trailing: Text(
                      '${result.australianValuesCorrect}/'
                      '${result.australianValuesTotal}',
                    ),
                  ),
                ],
              ),
            ),
            if (result.failureReason != null) ...[
              const SizedBox(height: 12),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(result.failureReason!),
                ),
              ),
            ],
            const SizedBox(height: 20),
            if (state.isTimed)
              analytics.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => const SizedBox.shrink(),
                data: (value) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Readiness insights',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          value.readiness.score == null
                              ? 'Readiness: Not enough data'
                              : 'Readiness: ${value.readiness.score}/100 · '
                                    '${value.readiness.label}',
                        ),
                        if (value.readiness.score == null)
                          const Text(
                            'Complete 10 questions in every category.',
                          ),
                        if (value.readiness.capReason != null)
                          Text(value.readiness.capReason!),
                        const SizedBox(height: 8),
                        Text(
                          !value.hasEnoughWeakAreaData
                              ? 'Not enough data to identify weak areas.'
                              : value.weakAreas.isEmpty
                              ? 'No weak areas detected.'
                              : 'Focus next: ${value.weakAreas.map((area) => area.categoryName).join(', ')}',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (state.isTimed) const SizedBox(height: 20),
            FilledButton(
              onPressed: () => context.pushNamed(AppRoutes.examReview),
              child: const Text('Review answers'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => context.goNamed(AppRoutes.exams),
              child: const Text('Back to exams'),
            ),
          ],
        ),
      ),
    );
  }
}
