import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../../../data/database/app_database.dart';
import '../../../core/errors/app_failure.dart';
import '../../practice/data/practice_repository.dart';
import 'package:pass_citizenship_test/features/practice/domain/study_question.dart';
import '../domain/exam_models.dart';
import '../domain/exam_history_models.dart';
import '../domain/exam_timer_engine.dart';

class ExamRepository {
  ExamRepository(this.database, this.practiceRepository);

  final AppDatabase database;
  final PracticeRepository practiceRepository;
  Future<ExamConfigModel>? _configFuture;

  Future<ExamConfigModel> config() async {
    try {
      return await (_configFuture ??= _loadConfig());
    } catch (error, stackTrace) {
      _configFuture = null;
      Error.throwWithStackTrace(AppFailure.from(error), stackTrace);
    }
  }

  Future<ExamConfigModel> _loadConfig() async {
    final existing =
        await (database.select(database.examConfigurations)
              ..where((row) => row.isActive.equals(true))
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) return _configModel(existing);

    final raw = await rootBundle.loadString('assets/data/exam_config.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final id = await database
        .into(database.examConfigurations)
        .insert(
          ExamConfigurationsCompanion.insert(
            examName: 'Australian Citizenship Test',
            questionCount: json['questionCount'] as int,
            durationMinutes: json['durationMinutes'] as int,
            passPercentage: (json['passPercentage'] as num).toDouble(),
            version: json['version'] as int,
          ),
        );
    return ExamConfigModel(
      id: id,
      questionCount: json['questionCount'] as int,
      durationMinutes: json['durationMinutes'] as int,
      passPercentage: (json['passPercentage'] as num).toDouble(),
    );
  }

  Future<RestoredExamModel> startExam({
    bool timed = false,
    DateTime? now,
  }) async {
    await abandonActiveExam();
    final examConfig = await config();
    final startedAt = now ?? DateTime.now();
    final durationSeconds = examConfig.durationMinutes * 60;
    final questions = await practiceRepository.questionsFor(
      limit: examConfig.questionCount,
    );
    final attemptId = await database
        .into(database.examAttempts)
        .insert(
          ExamAttemptsCompanion.insert(
            configId: examConfig.id,
            selectedQuestionsJson: jsonEncode(
              questions.map((question) => question.id).toList(),
            ),
            totalQuestions: questions.length,
            startedAt: startedAt,
            isTimed: Value(timed),
            remainingTimeSeconds: Value(timed ? durationSeconds : null),
            lastObservedAt: Value(timed ? startedAt : null),
          ),
        );
    await database.batch((batch) {
      batch.insertAll(database.examAttemptAnswers, [
        for (var index = 0; index < questions.length; index++)
          ExamAttemptAnswersCompanion.insert(
            examAttemptId: attemptId,
            questionId: questions[index].id,
            questionOrder: index,
            selectedIndex: const Value.absent(),
            isCorrect: const Value.absent(),
            answeredAt: const Value.absent(),
          ),
      ]);
    });
    return RestoredExamModel(
      attemptId: attemptId,
      config: examConfig,
      questions: questions,
      answers: const {},
      currentIndex: 0,
      isTimed: timed,
      remainingSeconds: timed ? durationSeconds : null,
      lastObservedAt: timed ? startedAt : null,
    );
  }

  Future<RestoredExamModel?> restoreExam({DateTime? now}) async {
    final attempt = await database.activeExamAttempt();
    if (attempt == null) return null;
    final examConfig = await (database.select(
      database.examConfigurations,
    )..where((row) => row.id.equals(attempt.configId))).getSingle();
    final ids = (jsonDecode(attempt.selectedQuestionsJson) as List<dynamic>)
        .cast<String>();
    final questions = await practiceRepository.questionsByIds(ids);
    if (questions.length != ids.length) {
      await abandonActiveExam();
      throw const ContentFailure(
        message:
            'An active exam contained a question removed by a question-bank '
            'update. Start a new exam to use the current bank.',
      );
    }
    final answerRows = await (database.select(
      database.examAttemptAnswers,
    )..where((row) => row.examAttemptId.equals(attempt.id))).get();
    final savedOptions = await database
        .customSelect(
          'SELECT owner_id, option_id FROM answer_option_selections '
          'WHERE owner_type = ?',
          variables: [Variable.withString('exam_answer')],
        )
        .get();
    final optionIdByAnswerId = {
      for (final row in savedOptions)
        row.read<int>('owner_id'): row.read<String>('option_id'),
    };
    int? remainingSeconds = attempt.remainingTimeSeconds;
    DateTime? lastObservedAt = attempt.lastObservedAt;
    var timerLocked = attempt.timerLocked;
    if (attempt.isTimed && remainingSeconds != null && lastObservedAt != null) {
      final snapshot = ExamTimerEngine.advance(
        remainingSeconds: remainingSeconds,
        lastObservedAt: lastObservedAt,
        now: now ?? DateTime.now(),
        locked: timerLocked,
      );
      remainingSeconds = snapshot.remainingSeconds;
      lastObservedAt = snapshot.observedAt;
      timerLocked = snapshot.locked;
      await saveTimer(attempt.id, snapshot, clearBackgroundedAt: true);
    }
    return RestoredExamModel(
      attemptId: attempt.id,
      config: _configModel(examConfig),
      questions: questions,
      answers: {
        for (final answer in answerRows)
          if (answer.selectedIndex != null)
            answer.questionOrder: _restoredOptionIndex(
              answer.questionOrder,
              answer.selectedIndex!,
              optionIdByAnswerId[answer.id],
              questions,
            ),
      },
      currentIndex: attempt.currentQuestionIndex.clamp(0, questions.length - 1),
      isTimed: attempt.isTimed,
      remainingSeconds: remainingSeconds,
      lastObservedAt: lastObservedAt,
      timerLocked: timerLocked,
    );
  }

  Future<void> saveTimer(
    int attemptId,
    ExamTimerSnapshot snapshot, {
    bool clearBackgroundedAt = false,
  }) async {
    await (database.update(
      database.examAttempts,
    )..where((row) => row.id.equals(attemptId))).write(
      ExamAttemptsCompanion(
        remainingTimeSeconds: Value(snapshot.remainingSeconds),
        lastObservedAt: Value(snapshot.observedAt),
        timerLocked: Value(snapshot.locked),
        backgroundedAt: clearBackgroundedAt
            ? const Value(null)
            : const Value.absent(),
      ),
    );
  }

  Future<void> markBackgrounded(
    int attemptId,
    ExamTimerSnapshot snapshot,
  ) async {
    await (database.update(
      database.examAttempts,
    )..where((row) => row.id.equals(attemptId))).write(
      ExamAttemptsCompanion(
        remainingTimeSeconds: Value(snapshot.remainingSeconds),
        lastObservedAt: Value(snapshot.observedAt),
        backgroundedAt: Value(snapshot.observedAt),
        timerLocked: Value(snapshot.locked),
      ),
    );
  }

  Future<void> saveAnswer({
    required int attemptId,
    required int questionOrder,
    required int selectedIndex,
    required String selectedOptionId,
  }) async {
    await (database.update(database.examAttemptAnswers)..where(
          (row) =>
              row.examAttemptId.equals(attemptId) &
              row.questionOrder.equals(questionOrder),
        ))
        .write(
          ExamAttemptAnswersCompanion(
            selectedIndex: Value(selectedIndex),
            answeredAt: Value(DateTime.now()),
          ),
        );
    final answer =
        await (database.select(database.examAttemptAnswers)..where(
              (row) =>
                  row.examAttemptId.equals(attemptId) &
                  row.questionOrder.equals(questionOrder),
            ))
            .getSingle();
    await database.customStatement(
      'INSERT OR REPLACE INTO answer_option_selections '
      '(owner_type, owner_id, option_id) VALUES (?, ?, ?)',
      ['exam_answer', answer.id, selectedOptionId],
    );
  }

  Future<void> savePosition(int attemptId, int index) async {
    await (database.update(database.examAttempts)
          ..where((row) => row.id.equals(attemptId)))
        .write(ExamAttemptsCompanion(currentQuestionIndex: Value(index)));
  }

  Future<ExamResultModel> submit({
    required int attemptId,
    required List<StudyQuestionModel> questions,
    required Map<int, int> answers,
    required double passPercentage,
    bool timedOut = false,
    int? remainingSeconds,
  }) async {
    var correct = 0;
    for (var index = 0; index < questions.length; index++) {
      final selected = answers[index];
      if (selected == questions[index].correctIndex) correct++;
      if (selected != null) {
        await (database.update(database.examAttemptAnswers)..where(
              (row) =>
                  row.examAttemptId.equals(attemptId) &
                  row.questionOrder.equals(index),
            ))
            .write(
              ExamAttemptAnswersCompanion(
                isCorrect: Value(selected == questions[index].correctIndex),
              ),
            );
      }
    }
    final unanswered = questions.length - answers.length;
    final incorrect = answers.length - correct;
    final score = questions.isEmpty ? 0.0 : correct * 100 / questions.length;
    final passed = score >= passPercentage;
    final attempt = await (database.select(
      database.examAttempts,
    )..where((row) => row.id.equals(attemptId))).getSingle();
    final configuredSeconds =
        (await (database.select(
              database.examConfigurations,
            )..where((row) => row.id.equals(attempt.configId))).getSingle())
            .durationMinutes *
        60;
    final timeTaken = attempt.isTimed
        ? configuredSeconds - (remainingSeconds ?? 0)
        : null;
    await (database.update(
      database.examAttempts,
    )..where((row) => row.id.equals(attemptId))).write(
      ExamAttemptsCompanion(
        score: Value(score),
        isPassed: Value(passed),
        submittedAt: Value(DateTime.now()),
        isCompleted: const Value(true),
        remainingTimeSeconds: attempt.isTimed
            ? Value(remainingSeconds ?? 0)
            : const Value.absent(),
        timeTakenSeconds: Value(timeTaken),
      ),
    );
    return ExamResultModel(
      score: score,
      passed: passed,
      correct: correct,
      incorrect: incorrect,
      unanswered: unanswered,
      timedOut: timedOut,
      timeTakenSeconds: timeTaken,
    );
  }

  Future<void> abandonActiveExam() async {
    await (database.update(database.examAttempts)
          ..where((row) => row.isCompleted.equals(false)))
        .write(const ExamAttemptsCompanion(isCompleted: Value(true)));
  }

  Future<List<ExamHistorySummary>> history() async {
    final attempts =
        await (database.select(database.examAttempts)
              ..where((row) => row.submittedAt.isNotNull())
              ..orderBy([(row) => OrderingTerm.desc(row.submittedAt)]))
            .get();
    final result = <ExamHistorySummary>[];
    for (final attempt in attempts) {
      final correct =
          await (database.selectOnly(database.examAttemptAnswers)
                ..addColumns([database.examAttemptAnswers.id.count()])
                ..where(
                  database.examAttemptAnswers.examAttemptId.equals(attempt.id) &
                      database.examAttemptAnswers.isCorrect.equals(true),
                ))
              .map(
                (row) => row.read(database.examAttemptAnswers.id.count()) ?? 0,
              )
              .getSingle();
      result.add(
        ExamHistorySummary(
          attemptId: attempt.id,
          completedAt: attempt.submittedAt!,
          score: attempt.score ?? 0,
          passed: attempt.isPassed ?? false,
          totalQuestions: attempt.totalQuestions,
          correctAnswers: correct,
          isTimed: attempt.isTimed,
          timeTakenSeconds: attempt.timeTakenSeconds,
        ),
      );
    }
    return result;
  }

  Future<ExamHistoryDetail> historyDetail(int attemptId) async {
    final summaries = await history();
    final summary = summaries.firstWhere(
      (item) => item.attemptId == attemptId,
      orElse: () =>
          throw StateError('Completed exam $attemptId was not found.'),
    );
    final answerRows =
        await (database.select(database.examAttemptAnswers)
              ..where((row) => row.examAttemptId.equals(attemptId))
              ..orderBy([(row) => OrderingTerm.asc(row.questionOrder)]))
            .get();
    final questions = await practiceRepository.questionsByIdsIncludingRemoved(
      answerRows.map((answer) => answer.questionId).toList(),
    );
    final questionsById = {
      for (final question in questions) question.id: question,
    };
    final removalRows = await database
        .customSelect(
          'SELECT question_id, user_message FROM removed_questions '
          'WHERE question_id IN (${List.filled(answerRows.length, '?').join(',')})',
          variables: answerRows
              .map((answer) => Variable.withString(answer.questionId))
              .toList(),
        )
        .get();
    final removalMessages = {
      for (final row in removalRows)
        row.read<String>('question_id'): row.read<String>('user_message'),
    };
    final selections = await database
        .customSelect(
          'SELECT owner_id, option_id FROM answer_option_selections '
          'WHERE owner_type = ?',
          variables: [Variable.withString('exam_answer')],
        )
        .get();
    final selectedOptionIds = {
      for (final row in selections)
        row.read<int>('owner_id'): row.read<String>('option_id'),
    };
    return ExamHistoryDetail(
      summary: summary,
      answers: [
        for (final answer in answerRows)
          HistoricalAnswer(
            order: answer.questionOrder,
            questionId: answer.questionId,
            question: questionsById[answer.questionId],
            selectedIndex: _historicalSelectedIndex(
              answer.selectedIndex,
              selectedOptionIds[answer.id],
              questionsById[answer.questionId],
            ),
            wasCorrect: answer.isCorrect,
            removalMessage: removalMessages[answer.questionId],
          ),
      ],
    );
  }

  int? _historicalSelectedIndex(
    int? legacyIndex,
    String? optionId,
    StudyQuestionModel? question,
  ) {
    if (legacyIndex == null || question == null || optionId == null) {
      return legacyIndex;
    }
    final stableIndex = question.options.indexWhere(
      (option) => option.id == optionId,
    );
    return stableIndex < 0 ? legacyIndex : stableIndex;
  }

  ExamConfigModel _configModel(ExamConfiguration row) => ExamConfigModel(
    id: row.id,
    questionCount: row.questionCount,
    durationMinutes: row.durationMinutes,
    passPercentage: row.passPercentage,
  );

  int _restoredOptionIndex(
    int questionOrder,
    int legacyIndex,
    String? optionId,
    List<StudyQuestionModel> questions,
  ) {
    if (optionId == null || questionOrder >= questions.length) {
      return legacyIndex;
    }
    final index = questions[questionOrder].options.indexWhere(
      (option) => option.id == optionId,
    );
    return index < 0 ? legacyIndex : index;
  }
}
