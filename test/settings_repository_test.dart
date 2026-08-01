import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pass_citizenship_test/data/database/app_database.dart';
import 'package:pass_citizenship_test/features/practice/data/practice_repository.dart';
import 'package:pass_citizenship_test/features/settings/data/settings_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('official booklet link uses the Australian Government site', () {
    expect(SettingsRepository.commonBondUri.scheme, 'https');
    expect(SettingsRepository.commonBondUri.host, 'immi.homeaffairs.gov.au');
    expect(SettingsRepository.commonBondUri.path, contains('our-common-bond'));
  });

  test('reset progress preserves starred questions', () async {
    final database = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(database.close);
    final practice = PracticeRepository(database);
    final settings = SettingsRepository(database, practice);
    final questions = await practice.questionsFor(limit: 2);
    await practice.toggleStarred(questions.first.id);
    final session = await practice.createSession(null, questions);
    await practice.recordAnswer(
      sessionId: session,
      question: questions.first,
      selectedIndex: questions.first.correctIndex,
      nextIndex: 1,
      correctCount: 1,
      complete: false,
    );

    await settings.resetProgress();

    expect((await practice.progress()).attempted, 0);
    expect(await practice.restoreSession(), isNull);
    expect(await practice.starredIds(), contains(questions.first.id));
  });
}
