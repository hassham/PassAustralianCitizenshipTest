import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/exam_controller.dart';
import 'exam_review_screen.dart';

class ExamScreen extends ConsumerWidget {
  const ExamScreen({super.key});

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
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep reviewing'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit exam'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(examControllerProvider.notifier).submit();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(examControllerProvider);
    if (state.result != null) return const _ExamResultsView();
    final question = state.current;
    if (question == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final selected = state.answers[state.currentIndex];
    return Scaffold(
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
              LinearProgressIndicator(
                value: (state.currentIndex + 1) / state.questions.length,
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
                  itemBuilder: (context, index) => OutlinedButton(
                    onPressed: () => ref
                        .read(examControllerProvider.notifier)
                        .selectAnswer(index),
                    style: OutlinedButton.styleFrom(
                      alignment: Alignment.centerLeft,
                      minimumSize: const Size.fromHeight(58),
                      padding: const EdgeInsets.all(16),
                      backgroundColor: selected == index
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Colors.white,
                      side: BorderSide(
                        color: selected == index
                            ? Theme.of(context).colorScheme.primary
                            : const Color(0xFFB7BDC5),
                        width: selected == index ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          selected == index
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(question.options[index])),
                      ],
                    ),
                  ),
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

class _ExamResultsView extends ConsumerWidget {
  const _ExamResultsView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(examControllerProvider);
    final result = state.result!;
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const ExamReviewScreen(),
                ),
              ),
              child: const Text('Review answers'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to exams'),
            ),
          ],
        ),
      ),
    );
  }
}
