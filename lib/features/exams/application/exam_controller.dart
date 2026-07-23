import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../practice/application/practice_controller.dart';
import '../../practice/domain/study_question.dart';
import '../data/exam_repository.dart';
import '../domain/exam_models.dart';

final examRepositoryProvider = Provider<ExamRepository>(
  (ref) => ExamRepository(
    ref.watch(databaseProvider),
    ref.watch(practiceRepositoryProvider),
  ),
);

final examConfigProvider = FutureProvider<ExamConfigModel>(
  (ref) => ref.watch(examRepositoryProvider).config(),
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
  });

  final bool loading;
  final int? attemptId;
  final ExamConfigModel? config;
  final List<StudyQuestionModel> questions;
  final Map<int, int> answers;
  final int currentIndex;
  final ExamResultModel? result;
  final String? error;
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
    String? error,
  }) => ExamState(
    loading: loading ?? this.loading,
    attemptId: attemptId ?? this.attemptId,
    config: config ?? this.config,
    questions: questions ?? this.questions,
    answers: answers ?? this.answers,
    currentIndex: currentIndex ?? this.currentIndex,
    result: result ?? this.result,
    error: error,
  );
}

class ExamController extends StateNotifier<ExamState> {
  ExamController(this.repository) : super(const ExamState());

  final ExamRepository repository;

  Future<bool> restore() async {
    state = state.copyWith(loading: true);
    try {
      final restored = await repository.restoreExam();
      if (restored == null) {
        state = const ExamState();
        return false;
      }
      state = _fromRestored(restored);
      return true;
    } catch (error) {
      state = ExamState(error: error.toString());
      return false;
    }
  }

  Future<void> start() async {
    state = state.copyWith(loading: true);
    try {
      state = _fromRestored(await repository.startExam());
    } catch (error) {
      state = ExamState(error: error.toString());
    }
  }

  Future<void> selectAnswer(int optionIndex) async {
    final attemptId = state.attemptId;
    if (attemptId == null) return;
    final answers = {...state.answers, state.currentIndex: optionIndex};
    state = state.copyWith(answers: answers);
    await repository.saveAnswer(
      attemptId: attemptId,
      questionOrder: state.currentIndex,
      selectedIndex: optionIndex,
      selectedOptionId: state.current!.options[optionIndex].id,
    );
  }

  Future<void> goTo(int index) async {
    if (index < 0 || index >= state.questions.length) return;
    state = state.copyWith(currentIndex: index);
    if (state.attemptId != null) {
      await repository.savePosition(state.attemptId!, index);
    }
  }

  Future<void> submit() async {
    final attemptId = state.attemptId;
    final config = state.config;
    if (attemptId == null || config == null) return;
    final result = await repository.submit(
      attemptId: attemptId,
      questions: state.questions,
      answers: state.answers,
      passPercentage: config.passPercentage,
    );
    state = state.copyWith(result: result);
  }

  ExamState _fromRestored(RestoredExamModel restored) => ExamState(
    attemptId: restored.attemptId,
    config: restored.config,
    questions: restored.questions,
    answers: restored.answers,
    currentIndex: restored.currentIndex,
  );
}

final examControllerProvider = StateNotifierProvider<ExamController, ExamState>(
  (ref) => ExamController(ref.watch(examRepositoryProvider)),
);
