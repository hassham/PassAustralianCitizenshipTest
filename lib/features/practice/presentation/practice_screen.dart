import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../application/practice_controller.dart';

class PracticeScreen extends ConsumerWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(practiceControllerProvider);
    if (state.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (state.error != null || state.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(state.error ?? 'No questions are available.')),
      );
    }
    if (state.complete) return _ResultsView(state: state);
    final question = state.current!;
    final answered = state.selectedIndex != null;
    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${state.index + 1} of ${state.questions.length}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                label: '${state.index + 1} of ${state.questions.length}',
                child: LinearProgressIndicator(
                  value: (state.index + 1) / state.questions.length,
                ),
              ),
              const SizedBox(height: 28),
              Text(
                question.text,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: question.options.length + (answered ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    if (index == question.options.length) {
                      final correct =
                          state.selectedIndex == question.correctIndex;
                      return Semantics(
                        liveRegion: true,
                        child: Card(
                          color: correct
                              ? const Color(0xFFE7F5EA)
                              : const Color(0xFFFFECEB),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  correct ? 'Correct' : 'Not quite',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 6),
                                Text(question.explanation),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    final isCorrect =
                        answered && index == question.correctIndex;
                    final isWrongSelection =
                        answered &&
                        index == state.selectedIndex &&
                        index != question.correctIndex;
                    return Semantics(
                      button: true,
                      selected: index == state.selectedIndex,
                      label: 'Answer ${index + 1}: ${question.options[index]}',
                      child: OutlinedButton(
                        onPressed: answered
                            ? null
                            : () => ref
                                  .read(practiceControllerProvider.notifier)
                                  .selectAnswer(index),
                        style: OutlinedButton.styleFrom(
                          alignment: Alignment.centerLeft,
                          minimumSize: const Size.fromHeight(58),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 14,
                          ),
                          backgroundColor: isCorrect
                              ? const Color(0xFFE7F5EA)
                              : isWrongSelection
                              ? const Color(0xFFFFECEB)
                              : Colors.white,
                          side: BorderSide(
                            color: isCorrect
                                ? const Color(0xFF238636)
                                : isWrongSelection
                                ? const Color(0xFFCF222E)
                                : const Color(0xFFB7BDC5),
                            width: answered && (isCorrect || isWrongSelection)
                                ? 2
                                : 1,
                          ),
                        ),
                        child: Text(question.options[index]),
                      ),
                    );
                  },
                ),
              ),
              if (answered)
                FilledButton(
                  onPressed: () =>
                      ref.read(practiceControllerProvider.notifier).next(),
                  child: Text(
                    state.index + 1 == state.questions.length
                        ? 'See results'
                        : 'Next question',
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ResultsView extends StatelessWidget {
  const _ResultsView({required this.state});
  final PracticeState state;

  @override
  Widget build(BuildContext context) {
    final percentage = (state.correctCount * 100 / state.questions.length)
        .round();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Practice complete'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.emoji_events_outlined,
                size: 72,
                color: Color(0xFF005A9C),
              ),
              const SizedBox(height: 20),
              Text(
                '$percentage%',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '${state.correctCount} of ${state.questions.length} correct',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 36),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
