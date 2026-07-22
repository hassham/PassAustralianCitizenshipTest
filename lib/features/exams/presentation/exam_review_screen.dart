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
          return Card(
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
                            ? Colors.orange
                            : correct
                            ? const Color(0xFF238636)
                            : const Color(0xFFCF222E),
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
                  Text(
                    selected == null
                        ? 'Your answer: Unanswered'
                        : 'Your answer: ${question.options[selected]}',
                  ),
                  Text(
                    'Correct answer: ${question.options[question.correctIndex]}',
                  ),
                  const SizedBox(height: 8),
                  Text(question.explanation),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
