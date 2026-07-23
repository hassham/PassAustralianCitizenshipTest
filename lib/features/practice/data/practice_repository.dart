import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../../../data/database/app_database.dart';
import '../domain/study_question.dart';
import 'question_bank_validator.dart';

class RestoredSession {
  const RestoredSession({
    required this.id,
    required this.questions,
    required this.currentIndex,
    required this.correctCount,
  });
  final int id;
  final List<StudyQuestionModel> questions;
  final int currentIndex;
  final int correctCount;
}

class PracticeRepository {
  PracticeRepository(
    this.database, {
    this.assetPath = 'assets/data/questions.json',
    QuestionBankValidator validator = const QuestionBankValidator(),
  }) : _validator = validator;

  final AppDatabase database;
  final String assetPath;
  final QuestionBankValidator _validator;
  Future<void>? _initialising;

  Future<void> initialise() => _initialising ??= _initialise();

  Future<void> _initialise() async {
    final raw = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw QuestionBankValidationException(['bank must be a JSON object.']);
    }
    _validator.validate(decoded);
    final newVersion = decoded['questionBankVersion'] as String;
    final storedVersion = await _setting('questions_version');
    final hasNormalizedContent =
        (await database
                .customSelect('SELECT COUNT(*) AS count FROM question_options')
                .getSingle())
            .read<int>('count') >
        0;
    if (storedVersion == newVersion && hasNormalizedContent) return;
    await _importBank(decoded, newVersion);
  }

  Future<String?> _setting(String key) async => (await (database.select(
    database.appSettings,
  )..where((row) => row.key.equals(key))).getSingleOrNull())?.value;

  Future<void> _importBank(Map<String, dynamic> bank, String version) async {
    final activeQuestionIds = (bank['questions'] as List<dynamic>)
        .map((item) => (item as Map<String, dynamic>)['id'] as String)
        .toSet();
    const removalMessage =
        'This question is no longer available because the question bank was updated.';

    await database.transaction(() async {
      for (final value in bank['sourceEditions'] as List<dynamic>) {
        final item = value as Map<String, dynamic>;
        await database.customStatement(
          'INSERT OR REPLACE INTO source_editions '
          '(id, title, publisher, edition, publication_year, url, licence) '
          'VALUES (?, ?, ?, ?, ?, ?, ?)',
          [
            item['id'],
            item['title'],
            item['publisher'],
            item['edition'],
            item['publicationYear'],
            item['url'],
            item['licence'],
          ],
        );
      }

      for (final value in bank['categories'] as List<dynamic>) {
        final item = value as Map<String, dynamic>;
        await database
            .into(database.categories)
            .insertOnConflictUpdate(
              CategoriesCompanion.insert(
                id: item['id'] as String,
                name: item['name'] as String,
              ),
            );
      }

      final existing = await database.select(database.studyQuestions).get();
      final alreadyRemoved = await _removedQuestionIds();
      for (final old in existing.where(
        (row) =>
            !alreadyRemoved.contains(row.id) &&
            !activeQuestionIds.contains(row.id),
      )) {
        await _archiveQuestion(
          old.id,
          DateTime.now().toUtc(),
          'source_changed',
          removalMessage,
        );
      }

      for (final value in bank['questions'] as List<dynamic>) {
        final item = value as Map<String, dynamic>;
        final options =
            (item['options'] as List<dynamic>).cast<Map<String, dynamic>>()
              ..sort(
                (left, right) => (left['displayOrder'] as int).compareTo(
                  right['displayOrder'] as int,
                ),
              );
        final correctIndex = options.indexWhere(
          (option) => option['isCorrect'] as bool,
        );
        await database
            .into(database.studyQuestions)
            .insertOnConflictUpdate(
              StudyQuestionsCompanion.insert(
                id: item['id'] as String,
                categoryId: item['categoryId'] as String,
                questionText: item['text'] as String,
                optionsJson: jsonEncode(
                  options.map((option) => option['text']).toList(),
                ),
                correctIndex: correctIndex,
                explanation:
                    item['overallExplanation'] as String? ??
                    options[correctIndex]['explanation'] as String,
              ),
            );
        await database.customStatement(
          'INSERT OR REPLACE INTO question_metadata '
          '(question_id, revision, status, difficulty, is_australian_values) '
          'VALUES (?, ?, ?, ?, ?)',
          [
            item['id'],
            item['revision'],
            item['status'],
            item['difficulty'],
            (item['isAustralianValuesQuestion'] as bool) ? 1 : 0,
          ],
        );
        await database.customStatement(
          'DELETE FROM question_options WHERE question_id = ?',
          [item['id']],
        );
        for (final option in options) {
          await database.customStatement(
            'INSERT INTO question_options '
            '(id, question_id, option_text, is_correct, explanation, display_order) '
            'VALUES (?, ?, ?, ?, ?, ?)',
            [
              option['id'],
              item['id'],
              option['text'],
              (option['isCorrect'] as bool) ? 1 : 0,
              option['explanation'],
              option['displayOrder'],
            ],
          );
        }
        await database.customStatement(
          'DELETE FROM question_references WHERE question_id = ?',
          [item['id']],
        );
        for (final referenceValue
            in item['sourceReferences'] as List<dynamic>) {
          final reference = referenceValue as Map<String, dynamic>;
          await database.customStatement(
            'INSERT INTO question_references '
            '(question_id, source_edition_id, part, chapter, section, page_start, page_end, notes) '
            'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
            [
              item['id'],
              reference['sourceEditionId'],
              reference['part'],
              reference['chapter'],
              reference['section'],
              reference['pageStart'],
              reference['pageEnd'],
              reference['notes'],
            ],
          );
        }
        await database.customStatement(
          'DELETE FROM removed_questions WHERE question_id = ?',
          [item['id']],
        );
      }

      for (final value
          in (bank['removedQuestions'] as List<dynamic>? ?? const [])) {
        final item = value as Map<String, dynamic>;
        await _archiveQuestion(
          item['questionId'] as String,
          DateTime.parse(item['removedAt'] as String),
          item['reason'] as String,
          item['userMessage'] as String? ?? removalMessage,
          replacementQuestionId: item['replacementQuestionId'] as String?,
        );
      }

      await database
          .into(database.appSettings)
          .insertOnConflictUpdate(
            AppSettingsCompanion.insert(
              key: 'questions_version',
              value: version,
            ),
          );
      await database
          .into(database.appSettings)
          .insertOnConflictUpdate(
            AppSettingsCompanion.insert(
              key: 'questions_generated_at',
              value: bank['generatedAt'] as String,
            ),
          );
      await database
          .into(database.appSettings)
          .insertOnConflictUpdate(
            AppSettingsCompanion.insert(
              key: 'questions_attribution',
              value: jsonEncode(bank['attribution']),
            ),
          );
    });
  }

  Future<void> _archiveQuestion(
    String questionId,
    DateTime removedAt,
    String reason,
    String message, {
    String? replacementQuestionId,
  }) async {
    await database.customStatement(
      'INSERT OR REPLACE INTO removed_questions '
      '(question_id, removed_at, reason, replacement_question_id, user_message) '
      'VALUES (?, ?, ?, ?, ?)',
      [
        questionId,
        removedAt.toIso8601String(),
        reason,
        replacementQuestionId,
        message,
      ],
    );
  }

  Future<List<CategoryModel>> categories() async {
    await initialise();
    final rows = await database.select(database.categories).get();
    final removedIds = await _removedQuestionIds();
    final questions = (await database.select(database.studyQuestions).get())
        .where((question) => !removedIds.contains(question.id))
        .toList();
    return rows
        .map(
          (row) => CategoryModel(
            row.id,
            row.name,
            questions.where((question) => question.categoryId == row.id).length,
          ),
        )
        .toList();
  }

  Future<List<StudyQuestionModel>> questions([String? categoryId]) =>
      questionsFor(categoryIds: categoryId == null ? null : {categoryId});

  Future<List<StudyQuestionModel>> questionsFor({
    Set<String>? categoryIds,
    int? limit,
  }) async {
    await initialise();
    final query = database.select(database.studyQuestions);
    if (categoryIds != null && categoryIds.isNotEmpty) {
      query.where((row) => row.categoryId.isIn(categoryIds));
    }
    final removedIds = await _removedQuestionIds();
    final rows = (await query.get())
        .where((row) => !removedIds.contains(row.id))
        .toList();
    final items = await Future.wait(rows.map(_toModel))
      ..shuffle();
    if (limit == null || limit >= items.length) return items;
    return items.take(limit).toList();
  }

  Future<List<StudyQuestionModel>> questionsByIds(List<String> ids) async {
    await initialise();
    final removedIds = await _removedQuestionIds();
    final rows =
        (await (database.select(
              database.studyQuestions,
            )..where((row) => row.id.isIn(ids))).get())
            .where((row) => !removedIds.contains(row.id))
            .toList();
    final models = await Future.wait(rows.map(_toModel));
    final byId = {for (final model in models) model.id: model};
    return ids.map((id) => byId[id]).whereType<StudyQuestionModel>().toList();
  }

  Future<Set<String>> starredIds() async {
    await initialise();
    final rows = await database.select(database.starredQuestions).get();
    return rows.map((row) => row.questionId).toSet();
  }

  Future<List<StudyQuestionModel>> starredQuestions() async {
    final ids = await starredIds();
    if (ids.isEmpty) return [];
    final questions = await questionsByIds(ids.toList());
    return questions..shuffle();
  }

  Future<List<RemovedStarredQuestionModel>> removedStarredQuestions() async {
    await initialise();
    final rows = await database
        .customSelect(
          'SELECT removed.question_id, removed.user_message '
          'FROM removed_questions removed '
          'INNER JOIN starred_questions starred '
          'ON starred.question_id = removed.question_id',
        )
        .get();
    return rows
        .map(
          (row) => RemovedStarredQuestionModel(
            row.read<String>('question_id'),
            row.read<String>('user_message'),
          ),
        )
        .toList();
  }

  Future<void> acknowledgeRemovedStarred() async {
    final removed = await removedStarredQuestions();
    if (removed.isEmpty) return;
    await (database.delete(database.starredQuestions)..where(
          (row) => row.questionId.isIn(removed.map((e) => e.questionId)),
        ))
        .go();
  }

  Future<bool> toggleStarred(String questionId) async {
    final existing = await (database.select(
      database.starredQuestions,
    )..where((row) => row.questionId.equals(questionId))).getSingleOrNull();
    if (existing == null) {
      await database
          .into(database.starredQuestions)
          .insert(
            StarredQuestionsCompanion.insert(
              questionId: questionId,
              starredAt: DateTime.now(),
            ),
          );
      return true;
    }
    await (database.delete(
      database.starredQuestions,
    )..where((row) => row.questionId.equals(questionId))).go();
    return false;
  }

  Future<int> createSession(
    String? categoryId,
    List<StudyQuestionModel> items,
  ) => database
      .into(database.practiceSessions)
      .insert(
        PracticeSessionsCompanion.insert(
          categoryId: Value(categoryId),
          questionIdsJson: jsonEncode(items.map((item) => item.id).toList()),
          updatedAt: DateTime.now(),
        ),
      );

  Future<RestoredSession?> restoreSession() async {
    await initialise();
    final session = await database.activeSession();
    if (session == null) return null;
    final ids = (jsonDecode(session.questionIdsJson) as List<dynamic>)
        .cast<String>();
    final items = await questionsByIds(ids);
    if (items.isEmpty || session.currentIndex >= items.length) return null;
    return RestoredSession(
      id: session.id,
      questions: items,
      currentIndex: session.currentIndex,
      correctCount: session.correctCount,
    );
  }

  Future<void> recordAnswer({
    required int sessionId,
    required StudyQuestionModel question,
    required int selectedIndex,
    required int nextIndex,
    required int correctCount,
    required bool complete,
  }) async {
    final selected = question.options[selectedIndex];
    await database.transaction(() async {
      final attemptId = await database
          .into(database.questionAttempts)
          .insert(
            QuestionAttemptsCompanion.insert(
              questionId: question.id,
              selectedIndex: selectedIndex,
              isCorrect: selected.isCorrect,
              attemptedAt: DateTime.now(),
            ),
          );
      await database.customStatement(
        'INSERT OR REPLACE INTO answer_option_selections '
        '(owner_type, owner_id, option_id) VALUES (?, ?, ?)',
        ['practice_attempt', attemptId, selected.id],
      );
      await (database.update(
        database.practiceSessions,
      )..where((row) => row.id.equals(sessionId))).write(
        PracticeSessionsCompanion(
          currentIndex: Value(nextIndex),
          correctCount: Value(correctCount),
          isComplete: Value(complete),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  Future<void> abandonActiveSession() async {
    await (database.update(database.practiceSessions)
          ..where((row) => row.isComplete.equals(false)))
        .write(const PracticeSessionsCompanion(isComplete: Value(true)));
  }

  Future<ProgressSummary> progress() async {
    await initialise();
    final attempts = await database.select(database.questionAttempts).get();
    return ProgressSummary(
      attempts.length,
      attempts.where((attempt) => attempt.isCorrect).length,
    );
  }

  Future<StudyQuestionModel> _toModel(StudyQuestion row) async {
    final metadata = await database
        .customSelect(
          'SELECT difficulty, is_australian_values FROM question_metadata '
          'WHERE question_id = ?',
          variables: [Variable.withString(row.id)],
        )
        .getSingleOrNull();
    final optionRows = await database
        .customSelect(
          'SELECT id, option_text, is_correct, explanation, display_order '
          'FROM question_options WHERE question_id = ? ORDER BY display_order',
          variables: [Variable.withString(row.id)],
        )
        .get();
    final referenceRows = await database
        .customSelect(
          'SELECT source.title, source.edition, reference.part, reference.section, '
          'reference.page_start, reference.page_end '
          'FROM question_references reference '
          'INNER JOIN source_editions source ON source.id = reference.source_edition_id '
          'WHERE reference.question_id = ?',
          variables: [Variable.withString(row.id)],
        )
        .get();
    return StudyQuestionModel(
      id: row.id,
      categoryId: row.categoryId,
      text: row.questionText,
      options: optionRows
          .map(
            (option) => QuestionOptionModel(
              id: option.read<String>('id'),
              text: option.read<String>('option_text'),
              isCorrect: option.read<int>('is_correct') == 1,
              explanation: option.read<String>('explanation'),
              displayOrder: option.read<int>('display_order'),
            ),
          )
          .toList(),
      overallExplanation: row.explanation,
      difficulty: metadata?.read<String>('difficulty') ?? 'medium',
      isAustralianValuesQuestion:
          (metadata?.read<int>('is_australian_values') ?? 0) == 1,
      references: referenceRows.map((reference) {
        return QuestionReferenceModel(
          sourceTitle: reference.read<String>('title'),
          edition: reference.read<String>('edition'),
          part: reference.read<String>('part'),
          section: reference.read<String>('section'),
          pageStart: reference.read<int>('page_start'),
          pageEnd: reference.read<int>('page_end'),
        );
      }).toList(),
    );
  }

  Future<Set<String>> _removedQuestionIds() async =>
      (await database
              .customSelect('SELECT question_id FROM removed_questions')
              .get())
          .map((row) => row.read<String>('question_id'))
          .toSet();
}
