import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/exam_controller.dart';

class ExamReviewScreen extends ConsumerWidget {
  const ExamReviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(examControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Answer review')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: state.questions.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final question = state.questions[index];
          final selected = state.answers[index];
          final correct = selected == question.correctIndex;
          final scheme = Theme.of(context).colorScheme;
          return Card(
            color: selected == null
                ? scheme.tertiaryContainer
                : correct
                ? scheme.secondaryContainer
                : scheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        selected == null
                            ? Icons.help_outline
                            : correct
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: selected == null
                            ? scheme.onTertiaryContainer
                            : correct
                            ? scheme.onSecondaryContainer
                            : scheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Text('Question ${index + 1}'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    question.text,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  if (selected == null)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.help_outline,
                        color: scheme.onTertiaryContainer,
                      ),
                      title: const Text('Unanswered'),
                    )
                  else
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        correct ? Icons.check_circle : Icons.cancel,
                        color: correct
                            ? scheme.onSecondaryContainer
                            : scheme.onErrorContainer,
                      ),
                      title: Text('Your answer'),
                      subtitle: Text(question.options[selected].text),
                    ),
                  if (!correct)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.check_circle,
                        color: scheme.onErrorContainer,
                      ),
                      title: const Text('Correct answer'),
                      subtitle: Text(question.correctOption.text),
                    ),
                  const SizedBox(height: 8),
                  if (selected != null) ...[
                    const SizedBox(height: 8),
                    Text(question.options[selected].explanation),
                  ],
                  if (!correct && selected != null) ...[
                    const SizedBox(height: 8),
                    Text(question.correctOption.explanation),
                  ],
                  if (question.overallExplanation.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(question.overallExplanation),
                  ],
                  if (question.references.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(
                      '${question.references.first.sourceTitle}, '
                      '${question.references.first.section}, '
                      '${question.references.first.pageLabel}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
