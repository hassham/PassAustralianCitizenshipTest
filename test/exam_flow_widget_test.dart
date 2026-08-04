import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/app.dart';
import 'package:pass_citizenship_test/data/database/app_database.dart';
import 'package:pass_citizenship_test/features/exams/application/exam_controller.dart';
import 'package:pass_citizenship_test/features/practice/application/practice_controller.dart';

/// Drives a complete mock-exam journey through the real app (real router,
/// real screens, an in-memory database seeded from the bundled question
/// bank) to cover the exam presentation screens end to end: starting an
/// exam, answering a mix of correct, incorrect, and unanswered questions,
/// using the question navigator, submitting, reviewing results, reviewing
/// individual answers, and inspecting exam history.
///
/// The bundled content import and every DB-backed exam operation run on a
/// real (in-memory) database, so they need genuine async time to complete —
/// `pumpAndSettle` never sees zero scheduled frames (matching the existing
/// `app_test.dart` precedent) and plain `pump()` never lets the underlying
/// isolate work resolve. `tester.runAsync` is used to let that real work
/// complete before each pump.
void main() {
  testWidgets(
    'completes a full mock exam through the real app and reviews the result',
    (tester) async {
      // The default test surface is too small for the exam screen's option
      // list at default text scale and overflows, which makes tap offsets
      // land on the wrong widget. Use a larger, phone-sized surface.
      await tester.binding.setSurfaceSize(const Size(430, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final database = AppDatabase.forTesting(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [databaseProvider.overrideWithValue(database)],
      );
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const CitizenshipStudyApp(),
        ),
      );
      await _settle(tester);

      await tester.tap(find.text('Exams'));
      await _settle(tester);
      expect(find.text('Mock exam'), findsWidgets);

      await tester.tap(find.text('Start mock exam'));
      await _settle(tester);
      expect(find.text('Start mock exam?'), findsOneWidget);

      await tester.tap(find.text('Start exam'));
      await _settle(tester);

      final examState = container.read(examControllerProvider);
      expect(examState.active, isTrue);
      expect(examState.questions, isNotEmpty);
      final questionCount = examState.questions.length;
      final notifier = container.read(examControllerProvider.notifier);

      // Answer the first question through a real UI tap, to cover the
      // option button's own tap-handling code path.
      final firstQuestion = examState.questions.first;
      await tester.tap(find.text(firstQuestion.correctOption.text));
      await tester.pump();
      expect(
        container.read(examControllerProvider).answers[0],
        firstQuestion.correctIndex,
      );

      // Exercise the question navigator bottom sheet.
      await tester.tap(
        find.text('Review questions (1/$questionCount answered)'),
      );
      await _settle(tester);
      expect(find.text('Review questions'), findsWidgets);
      await tester.tap(find.text('1'), warnIfMissed: false);
      await _settle(tester);
      expect(find.text(firstQuestion.text), findsOneWidget);

      // Drive the remaining questions directly through the controller: this
      // exercises the same repository/state logic as real taps (the button
      // handlers are one-line pass-throughs) without depending on brittle,
      // slow, sequential find-by-text taps for every one of the exam's
      // questions. Every Australian-values question is answered correctly
      // (so the values gate passes); other questions alternate
      // correct/incorrect (so the exam fails the overall pass mark and both
      // review states are exercised); the final question is left
      // unanswered.
      var nonValuesSeen = 0;
      for (var index = 1; index < questionCount; index++) {
        final isLast = index == questionCount - 1;
        final question = container
            .read(examControllerProvider)
            .questions[index];

        await tester.runAsync(() => notifier.goTo(index));
        await tester.pump();

        if (!isLast) {
          final answerCorrectly =
              question.isAustralianValuesQuestion || nonValuesSeen.isEven;
          if (!question.isAustralianValuesQuestion) nonValuesSeen++;
          final optionIndex = answerCorrectly
              ? question.correctIndex
              : question.options.indexWhere((o) => !o.isCorrect);
          await tester.runAsync(() => notifier.selectAnswer(optionIndex));
          await tester.pump();
        }
      }

      expect(
        container.read(examControllerProvider).currentIndex,
        questionCount - 1,
      );
      expect(find.text('Review & submit'), findsOneWidget);

      await tester.tap(find.text('Review & submit'));
      await _settle(tester);
      expect(find.textContaining('question'), findsWidgets);

      await tester.tap(find.text('Submit exam'));
      await _settle(tester);

      expect(find.text('Exam results'), findsOneWidget);
      expect(find.text('Keep practising'), findsOneWidget);
      final result = container.read(examControllerProvider).result;
      expect(result, isNotNull);
      expect(result!.passed, isFalse);
      expect(result.unanswered, 1);

      await tester.scrollUntilVisible(
        find.text('Review answers'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Review answers'));
      await _settle(tester);
      expect(find.text('Answer review'), findsOneWidget);
      expect(find.textContaining('Your answer'), findsWidgets);

      // Drag through the whole (lazily built) review list so its correct,
      // incorrect, and unanswered question cards all get built and rendered
      // at least once, without depending on exactly which scroll offset a
      // particular question's card lands at (fragile across test-suite
      // ordering, since item heights vary with the answer/notes present).
      final reviewList = find.byType(Scrollable).first;
      for (var i = 0; i < 8; i++) {
        await tester.drag(
          reviewList,
          const Offset(0, -600),
          warnIfMissed: false,
        );
        await tester.pump();
      }
      expect(tester.takeException(), isNull);
      expect(find.text('Answer review'), findsOneWidget);

      await tester.pageBack();
      await _settle(tester);
      expect(find.text('Exam results'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.text('Back to exams'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('Back to exams'));
      await _settle(tester);
      expect(find.text('Mock exam'), findsWidgets);

      await tester.scrollUntilVisible(
        find.text('View completed exams'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.tap(find.text('View completed exams'));
      await _settle(tester);
      expect(find.text('Exam history'), findsOneWidget);

      await tester.tap(find.textContaining('correct').first);
      await _settle(tester);
      expect(find.text('Exam result'), findsOneWidget);
      expect(find.text('Answer review'), findsOneWidget);
    },
  );
}

Future<void> _settle(WidgetTester tester, {int steps = 15}) async {
  for (var i = 0; i < steps; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pump(const Duration(milliseconds: 20));
  }
}
