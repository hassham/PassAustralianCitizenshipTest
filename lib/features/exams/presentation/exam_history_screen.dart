import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/errors/app_failure.dart';
import '../../../core/routing/app_routes.dart';
import '../../../shared/presentation/failure_view.dart';
import '../application/exam_controller.dart';

class ExamHistoryScreen extends ConsumerWidget {
  const ExamHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(examHistoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Exam history')),
      body: SafeArea(
        child: history.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => FailureView(
            failure: AppFailure.from(error),
            onRetry: () => ref.invalidate(examHistoryProvider),
          ),
          data: (attempts) {
            if (attempts.isEmpty) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.history_edu_outlined, size: 72),
                      SizedBox(height: 16),
                      Text(
                        'No completed exams yet',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Submit a mock exam and its result will appear here.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => ref.refresh(examHistoryProvider.future),
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: attempts.length + (attempts.length >= 2 ? 1 : 0),
                separatorBuilder: (_, _) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  if (attempts.length >= 2 && index == 0) {
                    return Card(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      child: ListTile(
                        leading: const Icon(Icons.trending_up),
                        title: const Text('Exam trend'),
                        subtitle: Text(
                          '${attempts.last.score.toStringAsFixed(0)}% → '
                          '${attempts.first.score.toStringAsFixed(0)}%',
                        ),
                      ),
                    );
                  }
                  final attempt =
                      attempts[index - (attempts.length >= 2 ? 1 : 0)];
                  final scheme = Theme.of(context).colorScheme;
                  return Card(
                    color: attempt.passed
                        ? scheme.secondaryContainer
                        : scheme.errorContainer,
                    child: ListTile(
                      textColor: attempt.passed
                          ? scheme.onSecondaryContainer
                          : scheme.onErrorContainer,
                      iconColor: attempt.passed
                          ? scheme.onSecondaryContainer
                          : scheme.onErrorContainer,
                      leading: CircleAvatar(
                        backgroundColor: attempt.passed
                            ? scheme.secondary
                            : scheme.error,
                        foregroundColor: attempt.passed
                            ? scheme.onSecondary
                            : scheme.onError,
                        child: Icon(
                          attempt.passed ? Icons.check : Icons.close,
                          semanticLabel: attempt.passed
                              ? 'Passed'
                              : 'Not passed',
                        ),
                      ),
                      title: Text(
                        '${attempt.score.toStringAsFixed(0)}% · '
                        '${attempt.passed ? 'Passed' : 'Not passed'}',
                      ),
                      subtitle: Text(
                        '${attempt.correctAnswers}/${attempt.totalQuestions} correct · '
                        '${MaterialLocalizations.of(context).formatMediumDate(attempt.completedAt)}'
                        '${attempt.timeTakenSeconds == null ? '' : ' · ${_duration(attempt.timeTakenSeconds!)}'}',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.pushNamed(
                        AppRoutes.examHistoryDetail,
                        pathParameters: {'attemptId': '${attempt.attemptId}'},
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

String _duration(int seconds) {
  final minutes = seconds ~/ 60;
  final remainder = seconds % 60;
  return '$minutes:${remainder.toString().padLeft(2, '0')}';
}
