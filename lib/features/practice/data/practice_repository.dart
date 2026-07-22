import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../../../data/database/app_database.dart';
import '../domain/study_question.dart';

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
  PracticeRepository(this.database);
  final AppDatabase database;
  Future<void>? _initialising;

  Future<void> initialise() => _initialising ??= _initialise();

  Future<void> _initialise() async {
    final raw = await rootBundle.loadString('assets/data/questions.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;
    final newVersion = data['version'].toString();
    
    // Get stored version
    final storedVersionRow = await (database.select(database.appSettings)
          ..where((row) => row.key.equals('questions_version')))
        .getSingleOrNull();
    final storedVersion = storedVersionRow?.value ?? '0';
    
    // If versions match and data exists, skip import
    if (storedVersion == newVersion &&
        await database.categories.count().getSingle() > 0) {
      return;
    }
    
    // Clear old data if version changed
    if (storedVersion != newVersion) {
      await database.transaction(() async {
        await database.delete(database.studyQuestions).go();
        await database.delete(database.categories).go();
      });
    }
    
    // Import new data
    await database.transaction(() async {
      for (final item in data['categories'] as List<dynamic>) {
        final map = item as Map<String, dynamic>;
        await database
            .into(database.categories)
            .insert(
              CategoriesCompanion.insert(
                id: map['id'] as String,
                name: map['name'] as String,
              ),
            );
      }
      for (final item in data['questions'] as List<dynamic>) {
        final map = item as Map<String, dynamic>;
        await database
            .into(database.studyQuestions)
            .insert(
              StudyQuestionsCompanion.insert(
                id: map['id'] as String,
                categoryId: map['categoryId'] as String,
                questionText: map['text'] as String,
                optionsJson: jsonEncode(map['options']),
                correctIndex: map['correctIndex'] as int,
                explanation: map['explanation'] as String,
              ),
            );
      }
      
      // Store the version
      await database.into(database.appSettings).insertOnConflictUpdate(
        AppSettingsCompanion(
          key: const Value('questions_version'),
          value: Value(newVersion),
        ),
      );
    });
  }

  Future<List<CategoryModel>> categories() async {
    await initialise();
    final rows = await database.select(database.categories).get();
    final questions = await database.select(database.studyQuestions).get();
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

  Future<List<StudyQuestionModel>> questions([String? categoryId]) async {
    return questionsFor(categoryIds: categoryId == null ? null : {categoryId});
  }

  Future<List<StudyQuestionModel>> questionsFor({
    Set<String>? categoryIds,
    int? limit,
  }) async {
    await initialise();
    final query = database.select(database.studyQuestions);
    if (categoryIds != null && categoryIds.isNotEmpty) {
      query.where((row) => row.categoryId.isIn(categoryIds));
    }
    final items = (await query.get()).map(_toModel).toList()..shuffle();
    if (limit == null || limit >= items.length) return items;
    return items.take(limit).toList();
  }

  Future<List<StudyQuestionModel>> questionsByIds(List<String> ids) async {
    await initialise();
    final rows = await database.select(database.studyQuestions).get();
    final byId = {for (final row in rows) row.id: _toModel(row)};
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
    final rows = await database.select(database.studyQuestions).get();
    return rows.where((row) => ids.contains(row.id)).map(_toModel).toList()
      ..shuffle();
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
  ) {
    return database
        .into(database.practiceSessions)
        .insert(
          PracticeSessionsCompanion.insert(
            categoryId: Value(categoryId),
            questionIdsJson: jsonEncode(items.map((item) => item.id).toList()),
            updatedAt: DateTime.now(),
          ),
        );
  }

  Future<RestoredSession?> restoreSession() async {
    await initialise();
    final session = await database.activeSession();
    if (session == null) return null;
    final ids = (jsonDecode(session.questionIdsJson) as List<dynamic>)
        .cast<String>();
    final all = await database.select(database.studyQuestions).get();
    final byId = {for (final row in all) row.id: _toModel(row)};
    final items = ids
        .map((id) => byId[id])
        .whereType<StudyQuestionModel>()
        .toList();
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
    final correct = selectedIndex == question.correctIndex;
    await database.transaction(() async {
      await database
          .into(database.questionAttempts)
          .insert(
            QuestionAttemptsCompanion.insert(
              questionId: question.id,
              selectedIndex: selectedIndex,
              isCorrect: correct,
              attemptedAt: DateTime.now(),
            ),
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

  StudyQuestionModel _toModel(StudyQuestion row) => StudyQuestionModel(
    id: row.id,
    categoryId: row.categoryId,
    text: row.questionText,
    options: (jsonDecode(row.optionsJson) as List<dynamic>).cast<String>(),
    correctIndex: row.correctIndex,
    explanation: row.explanation,
  );
}
