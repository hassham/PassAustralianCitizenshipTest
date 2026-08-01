import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_failure.dart';
import '../../../shared/presentation/failure_view.dart';
import '../application/exam_controller.dart';
import '../domain/exam_history_models.dart';

class ExamHistoryDetailScreen extends ConsumerWidget {
  const ExamHistoryDetailScreen({required this.attemptId, super.key});
  final int attemptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(examHistoryDetailProvider(attemptId));
    return Scaffold(
      appBar: AppBar(title: const Text('Exam result')),
      body: SafeArea(
        child: detail.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => FailureView(
            failure: AppFailure.from(error),
            onRetry: () => ref.invalidate(examHistoryDetailProvider(attemptId)),
          ),
          data: (value) => ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Semantics(
                header: true,
                child: Card(
                  color: value.summary.passed
                      ? Theme.of(context).colorScheme.primaryContainer
                      : Theme.of(context).colorScheme.errorContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Text(
                          '${value.summary.score.toStringAsFixed(0)}%',
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        Text(value.summary.passed ? 'Passed' : 'Not passed'),
                        Text(
                          '${value.summary.correctAnswers} of '
                          '${value.summary.totalQuestions} correct',
                        ),
                        Text(
                          'Australian values: '
                          '${value.summary.australianValuesCorrect}/'
                          '${value.summary.australianValuesTotal}',
                        ),
                        if (value.summary.failureReason != null) ...[
                          const SizedBox(height: 8),
                          Text(value.summary.failureReason!),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Answer review',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              ...value.answers.map((answer) => _AnswerCard(answer: answer)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({required this.answer});
  final HistoricalAnswer answer;

  @override
  Widget build(BuildContext context) {
    final question = answer.question;
    final scheme = Theme.of(context).colorScheme;
    final backgroundColor = answer.selectedIndex == null
        ? scheme.tertiaryContainer
        : answer.wasCorrect == true
        ? scheme.secondaryContainer
        : scheme.errorContainer;
    final foregroundColor = answer.selectedIndex == null
        ? scheme.onTertiaryContainer
        : answer.wasCorrect == true
        ? scheme.onSecondaryContainer
        : scheme.onErrorContainer;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        color: backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question ${answer.order + 1}',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 6),
              if (answer.removed)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(width: 10),
                    Expanded(child: Text(answer.removalMessage!)),
                  ],
                )
              else if (question == null)
                const Text('This question is not available.')
              else ...[
                Text(
                  question.text,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                for (var index = 0; index < question.options.length; index++)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      question.options[index].isCorrect
                          ? Icons.check_circle
                          : index == answer.selectedIndex
                          ? Icons.cancel
                          : Icons.radio_button_unchecked,
                      color: question.options[index].isCorrect
                          ? foregroundColor
                          : index == answer.selectedIndex
                          ? foregroundColor
                          : null,
                    ),
                    title: Text(question.options[index].text),
                    subtitle: index == answer.selectedIndex
                        ? const Text('Your answer')
                        : null,
                  ),
                Text(
                  answer.selectedIndex == null
                      ? 'Not answered'
                      : answer.wasCorrect == true
                      ? 'Correct'
                      : 'Incorrect',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(question.overallExplanation),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
