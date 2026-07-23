import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/app.dart';
import 'package:pass_citizenship_test/data/database/app_database.dart';
import 'package:pass_citizenship_test/features/practice/application/practice_controller.dart';
import 'package:pass_citizenship_test/features/practice/domain/study_question.dart';
import 'package:pass_citizenship_test/features/practice/presentation/practice_hub_screen.dart';
import 'package:pass_citizenship_test/features/settings/application/settings_providers.dart';
import 'package:pass_citizenship_test/features/settings/domain/settings_models.dart';
import 'package:pass_citizenship_test/features/progress/application/progress_providers.dart';
import 'package:pass_citizenship_test/features/progress/domain/progress_models.dart';
import 'package:pass_citizenship_test/features/progress/presentation/progress_screen.dart';

void main() {
  testWidgets('shows the offline practice entry point', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          homeDashboardProvider.overrideWith(
            (_) async => const HomeDashboardModel(
              progress: ProgressSummary(0, 0),
              totalQuestions: 120,
              starredQuestions: 0,
              hasActivePractice: false,
              hasActiveExam: false,
            ),
          ),
          settingsInfoProvider.overrideWith((_) async => _settingsInfo),
        ],
        child: const CitizenshipStudyApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 5));

    expect(find.text('Learn with confidence'), findsOneWidget);
    expect(find.text('Practice all categories'), findsOneWidget);
    expect(find.text('120'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Take a mock exam'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Take a mock exam'), findsOneWidget);
  });

  testWidgets('provides five-section navigation', (tester) async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(database),
          categoriesProvider.overrideWith((_) async => const []),
          homeDashboardProvider.overrideWith(
            (_) async => const HomeDashboardModel(
              progress: ProgressSummary(0, 0),
              totalQuestions: 120,
              starredQuestions: 0,
              hasActivePractice: false,
              hasActiveExam: false,
            ),
          ),
          settingsInfoProvider.overrideWith((_) async => _settingsInfo),
        ],
        child: const CitizenshipStudyApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Practice'), findsOneWidget);
    expect(find.text('Exams'), findsOneWidget);
    expect(find.text('Progress'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);

    await tester.tap(find.text('Settings'));
    await tester.pump();
    await tester.pump();
    expect(find.text('Question bank'), findsOneWidget);

    await tester.tap(find.text('Home'));
    await tester.pump();
    expect(find.text('Learn with confidence'), findsOneWidget);
  });

  testWidgets('practice hub supports category and question-count selection', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoriesProvider.overrideWith(
            (_) async => const [
              CategoryModel('values', 'Australian values', 4),
              CategoryModel('history', 'Australia and its people', 4),
            ],
          ),
          starredQuestionsProvider.overrideWith((_) async => const []),
        ],
        child: const MaterialApp(home: PracticeHubScreen()),
      ),
    );
    await tester.pump();
    await tester.pump();

    expect(find.text('Build a practice session'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('8 questions will be included.'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('8 questions will be included.'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('Australia and its people'),
      -200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Australia and its people'));
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('4 questions will be included.'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('4 questions will be included.'), findsOneWidget);

    await tester.tap(find.text('5'));
    await tester.pump();
    expect(find.text('4 questions will be included.'), findsOneWidget);
  });

  testWidgets('practice hub remains usable at 200 percent text scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          categoriesProvider.overrideWith(
            (_) async => const [
              CategoryModel('values', 'Australian values', 4),
            ],
          ),
          starredQuestionsProvider.overrideWith((_) async => const []),
        ],
        child: const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: PracticeHubScreen(),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Start practice'),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Start practice'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('activity chart does not overflow at 200 percent text scale', (
    tester,
  ) async {
    final today = DateTime(2026, 7, 23);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          progressAnalyticsProvider.overrideWith(
            (_) async => ProgressAnalyticsModel(
              attempted: 12,
              correct: 9,
              uniqueQuestions: 10,
              totalQuestions: 120,
              practiceSessions: 2,
              examAttempts: 1,
              recentAnswers: 12,
              lastActivityAt: today,
              categories: const [],
              activity: List.generate(
                7,
                (index) => DailyActivityModel(
                  today.subtract(Duration(days: index)),
                  12,
                ),
              ),
            ),
          ),
        ],
        child: const MaterialApp(
          home: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: ProgressScreen(),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('Recent activity'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Recent activity'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

const _settingsInfo = SettingsInfoModel(
  appVersion: '1.0.0',
  buildNumber: '1',
  questionBankVersion: '2026.1',
  questionBankGeneratedAt: null,
  sourceTitle: 'Our Common Bond',
  sourceEdition: '2022',
  sourcePublisher: 'Australian Government',
  copyrightNotice: 'Commonwealth of Australia',
  licenceName: 'CC BY 4.0',
  licenceUrl: 'https://creativecommons.org/licenses/by/4.0/',
  disclaimer: 'Unofficial study aid.',
  freeSpace: '10 GB',
  lowOnSpace: false,
  performanceSamples: [],
  residentMemoryBytes: 1000000,
);
