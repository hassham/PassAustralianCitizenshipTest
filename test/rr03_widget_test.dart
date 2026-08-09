import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/data/database/app_database.dart';
import 'package:pass_citizenship_test/features/exams/application/exam_controller.dart';
import 'package:pass_citizenship_test/features/exams/domain/exam_history_models.dart';
import 'package:pass_citizenship_test/features/exams/presentation/exam_history_screen.dart';
import 'package:pass_citizenship_test/features/practice/application/practice_controller.dart';
import 'package:pass_citizenship_test/features/practice/data/practice_repository.dart';
import 'package:pass_citizenship_test/features/practice/domain/study_question.dart';
import 'package:pass_citizenship_test/features/practice/presentation/practice_screen.dart';
import 'package:pass_citizenship_test/features/practice/presentation/starred_screen.dart';
import 'package:pass_citizenship_test/features/settings/application/settings_providers.dart';
import 'package:pass_citizenship_test/features/settings/domain/settings_models.dart';
import 'package:pass_citizenship_test/features/settings/presentation/settings_screen.dart';

void main() {
  testWidgets('practice interaction shows feedback and completes the session', (
    tester,
  ) async {
    // The question bank has real-world variance in stem/option length; a
    // small surface can push the correct option below the lazy ListView's
    // built extent, making it unfindable regardless of which question the
    // (randomised) selection happens to pick. A generous surface avoids
    // that regardless of content length.
    await tester.binding.setSurfaceSize(const Size(430, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final controller = PracticeController(PracticeRepository(database));
    await tester.runAsync(() => controller.startSelection(questionCount: 1));
    final question = controller.state.current!;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [practiceControllerProvider.overrideWith((_) => controller)],
        child: const MaterialApp(home: PracticeScreen()),
      ),
    );

    await tester.tap(find.text(question.correctOption.text));
    await tester.pump();

    expect(find.text('Correct'), findsOneWidget);
    expect(
      find.textContaining(question.references.first.sourceTitle),
      findsOneWidget,
    );
    expect(find.textContaining(RegExp(r'pages? \d')), findsNothing);

    await tester.runAsync(controller.next);
    await tester.pump();

    expect(find.text('Practice complete'), findsOneWidget);
    expect(find.text('1 of 1 correct'), findsOneWidget);
  });

  testWidgets('practice recovery failure presents a retry-safe state', (
    tester,
  ) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final controller = PracticeController(_FailingPracticeRepository(database));
    expect(await tester.runAsync(controller.restore), isFalse);
    expect(controller.state.error, isNotNull);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [practiceControllerProvider.overrideWith((_) => controller)],
        child: const MaterialApp(home: PracticeScreen()),
      ),
    );

    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Something went wrong'), findsOneWidget);
  });

  testWidgets('settings renders content, data, and source sections', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsInfoProvider.overrideWith((_) async => _settings)],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Question bank'), findsOneWidget);
    expect(find.text('Reset progress'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Open the official course content'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Open the official course content'), findsOneWidget);
  });

  testWidgets('settings failure presents the documented safe state', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        key: const ValueKey('starred-empty'),
        overrides: [
          settingsInfoProvider.overrideWith(
            (_) => Future<SettingsInfoModel>.error(
              StateError('settings unavailable'),
            ),
          ),
        ],
        child: const MaterialApp(home: SettingsScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Something went wrong'), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });

  testWidgets('starred screen covers empty and populated states', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        key: const ValueKey('starred-populated'),
        overrides: [
          starredQuestionsProvider.overrideWith((_) async => const []),
          removedStarredQuestionsProvider.overrideWith((_) async => const []),
        ],
        child: const MaterialApp(home: StarredScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No starred questions yet'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          starredQuestionsProvider.overrideWith((_) async => [_question]),
          removedStarredQuestionsProvider.overrideWith((_) async => const []),
        ],
        child: const MaterialApp(home: StarredScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('1 saved'), findsOneWidget);
    expect(find.text(_question.text), findsOneWidget);
    expect(find.text('Practise starred questions'), findsOneWidget);
  });

  testWidgets('history screen covers empty, result, and trend states', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        key: const ValueKey('history-empty'),
        overrides: [examHistoryProvider.overrideWith((_) async => const [])],
        child: const MaterialApp(home: ExamHistoryScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('No completed exams yet'), findsOneWidget);

    await tester.pumpWidget(
      ProviderScope(
        key: const ValueKey('history-populated'),
        overrides: [examHistoryProvider.overrideWith((_) async => _history)],
        child: const MaterialApp(home: ExamHistoryScreen()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Exam trend'), findsOneWidget);
    expect(find.textContaining('Passed'), findsOneWidget);
    expect(find.textContaining('Not passed'), findsOneWidget);
  });
}

const _question = StudyQuestionModel(
  id: 'question-1',
  categoryId: 'values',
  text: 'What does the Rule of Law require?',
  options: [
    QuestionOptionModel(
      id: 'option-1',
      text: 'Everyone obeys the law',
      isCorrect: true,
      explanation: 'The law applies to everyone.',
      displayOrder: 0,
    ),
    QuestionOptionModel(
      id: 'option-2',
      text: 'Only leaders obey the law',
      isCorrect: false,
      explanation: 'Leaders are not above the law.',
      displayOrder: 1,
    ),
    QuestionOptionModel(
      id: 'option-3',
      text: 'The law is optional',
      isCorrect: false,
      explanation: 'Australian laws must be obeyed.',
      displayOrder: 2,
    ),
    QuestionOptionModel(
      id: 'option-4',
      text: 'Religious rules replace the law',
      isCorrect: false,
      explanation: 'Australian law prevails.',
      displayOrder: 3,
    ),
  ],
  overallExplanation: 'No person or group is above Australian law.',
  difficulty: 'easy',
  isAustralianValuesQuestion: true,
  references: [
    QuestionReferenceModel(
      sourceTitle: 'Our Common Bond',
      edition: '2020',
      part: 'Part 4',
      section: 'Commitment to the Rule of Law',
      pageStart: 36,
      pageEnd: 36,
    ),
  ],
);

const _settings = SettingsInfoModel(
  appVersion: '1.0.0',
  buildNumber: '1',
  questionBankVersion: '1.0.0',
  questionBankGeneratedAt: null,
  sourceTitle: 'Our Common Bond',
  sourceEdition: '2020 edition',
  sourcePublisher: 'Australian Government',
  copyrightNotice: 'Commonwealth of Australia',
  licenceName: 'CC BY 4.0',
  licenceUrl: 'https://creativecommons.org/licenses/by/4.0/',
  disclaimer: 'Unofficial study aid.',
  freeSpace: '10 GB',
  lowOnSpace: false,
  performanceSamples: [],
  residentMemoryBytes: 1024,
);

final _history = [
  ExamHistorySummary(
    attemptId: 2,
    completedAt: DateTime(2026, 8, 1),
    score: 80,
    passed: true,
    totalQuestions: 20,
    correctAnswers: 16,
    isTimed: true,
    overallRequirementMet: true,
    australianValuesRequirementMet: true,
    australianValuesCorrect: 5,
    australianValuesTotal: 5,
    timeTakenSeconds: 1200,
  ),
  ExamHistorySummary(
    attemptId: 1,
    completedAt: DateTime(2026, 7, 31),
    score: 65,
    passed: false,
    totalQuestions: 20,
    correctAnswers: 13,
    isTimed: false,
    overallRequirementMet: false,
    australianValuesRequirementMet: true,
    australianValuesCorrect: 5,
    australianValuesTotal: 5,
  ),
];

class _FailingPracticeRepository extends PracticeRepository {
  _FailingPracticeRepository(super.database);

  @override
  Future<RestoredSession?> restoreSession() =>
      Future<RestoredSession?>.error(StateError('restore failed'));
}
