import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_failure.dart';
import '../../practice/application/practice_controller.dart';
import '../../practice/domain/study_question.dart';
import '../data/exam_repository.dart';
import '../domain/exam_models.dart';
import '../domain/exam_history_models.dart';
import '../domain/exam_timer_engine.dart';

final examRepositoryProvider = Provider<ExamRepository>(
  (ref) => ExamRepository(
    ref.watch(databaseProvider),
    ref.watch(practiceRepositoryProvider),
  ),
);

final examConfigProvider = FutureProvider<ExamConfigModel>(
  (ref) => ref.watch(examRepositoryProvider).config(),
);

final examHistoryProvider = FutureProvider<List<ExamHistorySummary>>(
  (ref) => ref.watch(examRepositoryProvider).history(),
);

final examHistoryDetailProvider = FutureProvider.family<ExamHistoryDetail, int>(
  (ref, attemptId) =>
      ref.watch(examRepositoryProvider).historyDetail(attemptId),
);

class ExamState {
  const ExamState({
    this.loading = false,
    this.attemptId,
    this.config,
    this.questions = const [],
    this.answers = const {},
    this.currentIndex = 0,
    this.result,
    this.error,
    this.isTimed = false,
    this.remainingSeconds,
    this.lastObservedAt,
    this.timerLocked = false,
    this.timerWarning = '',
  });

  final bool loading;
  final int? attemptId;
  final ExamConfigModel? config;
  final List<StudyQuestionModel> questions;
  final Map<int, int> answers;
  final int currentIndex;
  final ExamResultModel? result;
  final AppFailure? error;
  final bool isTimed;
  final int? remainingSeconds;
  final DateTime? lastObservedAt;
  final bool timerLocked;
  final String timerWarning;
  bool get active =>
      attemptId != null && questions.isNotEmpty && result == null;
  StudyQuestionModel? get current =>
      questions.isEmpty ? null : questions[currentIndex];

  ExamState copyWith({
    bool? loading,
    int? attemptId,
    ExamConfigModel? config,
    List<StudyQuestionModel>? questions,
    Map<int, int>? answers,
    int? currentIndex,
    ExamResultModel? result,
    AppFailure? error,
    bool? isTimed,
    int? remainingSeconds,
    DateTime? lastObservedAt,
    bool? timerLocked,
    String? timerWarning,
  }) => ExamState(
    loading: loading ?? this.loading,
    attemptId: attemptId ?? this.attemptId,
    config: config ?? this.config,
    questions: questions ?? this.questions,
    answers: answers ?? this.answers,
    currentIndex: currentIndex ?? this.currentIndex,
    result: result ?? this.result,
    error: error,
    isTimed: isTimed ?? this.isTimed,
    remainingSeconds: remainingSeconds ?? this.remainingSeconds,
    lastObservedAt: lastObservedAt ?? this.lastObservedAt,
    timerLocked: timerLocked ?? this.timerLocked,
    timerWarning: timerWarning ?? this.timerWarning,
  );
}

class ExamController extends StateNotifier<ExamState> {
  ExamController(this.repository, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now,
      super(const ExamState());

  final ExamRepository repository;
  final DateTime Function() _clock;
  Timer? _timer;
  int _ticksSincePersistence = 0;

  void reset() {
    _timer?.cancel();
    state = const ExamState();
  }

  Future<bool> restore() async {
    state = state.copyWith(loading: true);
    try {
      final restored = await repository.restoreExam(now: _clock());
      if (restored == null) {
        state = const ExamState();
        return false;
      }
      state = _fromRestored(restored);
      if (state.isTimed) {
        if ((state.remainingSeconds ?? 0) <= 0) {
          await submit(timedOut: true);
        } else if (!state.timerLocked) {
          _startTimer();
        }
      }
      return true;
    } catch (error) {
      state = ExamState(error: AppFailure.from(error));
      return false;
    }
  }

  Future<void> start() async {
    _timer?.cancel();
    state = state.copyWith(loading: true);
    try {
      state = _fromRestored(
        await repository.startExam(timed: true, now: _clock()),
      );
      _startTimer();
    } catch (error) {
      state = ExamState(error: AppFailure.from(error));
    }
  }

  Future<void> selectAnswer(int optionIndex) async {
    final attemptId = state.attemptId;
    if (attemptId == null || state.timerLocked) return;
    final answers = {...state.answers, state.currentIndex: optionIndex};
    state = state.copyWith(answers: answers);
    try {
      await repository.saveAnswer(
        attemptId: attemptId,
        questionOrder: state.currentIndex,
        selectedIndex: optionIndex,
        selectedOptionId: state.current!.options[optionIndex].id,
      );
    } catch (error) {
      state = state.copyWith(error: AppFailure.from(error));
    }
  }

  Future<void> goTo(int index) async {
    if (index < 0 || index >= state.questions.length) return;
    state = state.copyWith(currentIndex: index);
    if (state.attemptId != null) {
      await repository.savePosition(state.attemptId!, index);
    }
  }

  Future<void> submit({bool timedOut = false}) async {
    final attemptId = state.attemptId;
    final config = state.config;
    if (attemptId == null || config == null) return;
    try {
      final result = await repository.submit(
        attemptId: attemptId,
        questions: state.questions,
        answers: state.answers,
        passPercentage: config.passPercentage,
        requiredAustralianValuesQuestions:
            config.australianValuesQuestionCount,
        timedOut: timedOut,
        remainingSeconds: state.remainingSeconds,
      );
      _timer?.cancel();
      state = state.copyWith(result: result);
    } catch (error) {
      state = state.copyWith(error: AppFailure.from(error));
    }
  }

  Future<void> handleBackgrounded() async {
    if (!state.isTimed || !state.active || state.timerLocked) return;
    final snapshot = _advance(_clock());
    final attemptId = state.attemptId;
    if (attemptId != null) {
      await repository.markBackgrounded(attemptId, snapshot);
    }
    _timer?.cancel();
  }

  Future<void> handleResumed() async {
    if (!state.isTimed || !state.active) return;
    final snapshot = _advance(_clock());
    final attemptId = state.attemptId;
    if (attemptId != null) await repository.saveTimer(attemptId, snapshot);
    if (snapshot.expired) {
      await submit(timedOut: true);
    } else if (!snapshot.locked) {
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      final snapshot = _advance(_clock());
      _ticksSincePersistence++;
      if (_ticksSincePersistence >= 5 && state.attemptId != null) {
        _ticksSincePersistence = 0;
        await repository.saveTimer(state.attemptId!, snapshot);
      }
      if (snapshot.expired) await submit(timedOut: true);
    });
  }

  ExamTimerSnapshot _advance(DateTime now) {
    final snapshot = ExamTimerEngine.advance(
      remainingSeconds: state.remainingSeconds ?? 0,
      lastObservedAt: state.lastObservedAt ?? now,
      now: now,
      locked: state.timerLocked,
    );
    state = state.copyWith(
      remainingSeconds: snapshot.remainingSeconds,
      lastObservedAt: snapshot.observedAt,
      timerLocked: snapshot.locked,
      timerWarning: ExamTimerEngine.warningFor(snapshot.remainingSeconds),
    );
    if (snapshot.locked) _timer?.cancel();
    return snapshot;
  }

  ExamState _fromRestored(RestoredExamModel restored) => ExamState(
    attemptId: restored.attemptId,
    config: restored.config,
    questions: restored.questions,
    answers: restored.answers,
    currentIndex: restored.currentIndex,
    isTimed: restored.isTimed,
    remainingSeconds: restored.remainingSeconds,
    lastObservedAt: restored.lastObservedAt,
    timerLocked: restored.timerLocked,
  );

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final examControllerProvider = StateNotifierProvider<ExamController, ExamState>(
  (ref) => ExamController(ref.watch(examRepositoryProvider)),
);
