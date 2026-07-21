import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/database/app_database.dart';
import '../data/practice_repository.dart';
import '../domain/study_question.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();
  ref.onDispose(database.close);
  return database;
});

final practiceRepositoryProvider = Provider<PracticeRepository>(
  (ref) => PracticeRepository(ref.watch(databaseProvider)),
);

final categoriesProvider = FutureProvider<List<CategoryModel>>(
  (ref) => ref.watch(practiceRepositoryProvider).categories(),
);

final progressProvider = FutureProvider<ProgressSummary>(
  (ref) => ref.watch(practiceRepositoryProvider).progress(),
);

final starredQuestionsProvider = FutureProvider<List<StudyQuestionModel>>(
  (ref) => ref.watch(practiceRepositoryProvider).starredQuestions(),
);

class PracticeState {
  const PracticeState({
    this.loading = false,
    this.sessionId,
    this.questions = const [],
    this.index = 0,
    this.correctCount = 0,
    this.selectedIndex,
    this.complete = false,
    this.starredIds = const {},
    this.error,
  });

  final bool loading;
  final int? sessionId;
  final List<StudyQuestionModel> questions;
  final int index;
  final int correctCount;
  final int? selectedIndex;
  final bool complete;
  final Set<String> starredIds;
  final String? error;
  StudyQuestionModel? get current =>
      questions.isEmpty || index >= questions.length ? null : questions[index];

  PracticeState copyWith({
    bool? loading,
    int? sessionId,
    List<StudyQuestionModel>? questions,
    int? index,
    int? correctCount,
    int? selectedIndex,
    bool clearSelection = false,
    bool? complete,
    Set<String>? starredIds,
    String? error,
  }) => PracticeState(
    loading: loading ?? this.loading,
    sessionId: sessionId ?? this.sessionId,
    questions: questions ?? this.questions,
    index: index ?? this.index,
    correctCount: correctCount ?? this.correctCount,
    selectedIndex: clearSelection ? null : selectedIndex ?? this.selectedIndex,
    complete: complete ?? this.complete,
    starredIds: starredIds ?? this.starredIds,
    error: error,
  );
}

class PracticeController extends StateNotifier<PracticeState> {
  PracticeController(this.repository) : super(const PracticeState());
  final PracticeRepository repository;

  Future<bool> restore() async {
    state = state.copyWith(loading: true);
    final restored = await repository.restoreSession();
    if (restored == null) {
      state = const PracticeState();
      return false;
    }
    state = PracticeState(
      sessionId: restored.id,
      questions: restored.questions,
      index: restored.currentIndex,
      correctCount: restored.correctCount,
      starredIds: await repository.starredIds(),
    );
    return true;
  }

  Future<void> start(String? categoryId) async {
    state = state.copyWith(loading: true, clearSelection: true);
    try {
      await repository.abandonActiveSession();
      final questions = await repository.questions(categoryId);
      final id = await repository.createSession(categoryId, questions);
      state = PracticeState(
        sessionId: id,
        questions: questions,
        starredIds: await repository.starredIds(),
      );
    } catch (error) {
      state = PracticeState(error: error.toString());
    }
  }

  Future<bool> startStarred() async {
    state = state.copyWith(loading: true, clearSelection: true);
    try {
      await repository.abandonActiveSession();
      final questions = await repository.starredQuestions();
      if (questions.isEmpty) {
        state = const PracticeState();
        return false;
      }
      final id = await repository.createSession(null, questions);
      state = PracticeState(
        sessionId: id,
        questions: questions,
        starredIds: questions.map((question) => question.id).toSet(),
      );
      return true;
    } catch (error) {
      state = PracticeState(error: error.toString());
      return false;
    }
  }

  Future<void> toggleCurrentStar() async {
    final question = state.current;
    if (question == null) return;
    final starred = await repository.toggleStarred(question.id);
    final ids = {...state.starredIds};
    if (starred) {
      ids.add(question.id);
    } else {
      ids.remove(question.id);
    }
    state = state.copyWith(starredIds: ids);
  }

  void selectAnswer(int index) {
    if (state.selectedIndex != null) return;
    final correct = index == state.current!.correctIndex;
    state = state.copyWith(
      selectedIndex: index,
      correctCount: state.correctCount + (correct ? 1 : 0),
    );
  }

  Future<void> next() async {
    final question = state.current;
    final selection = state.selectedIndex;
    final sessionId = state.sessionId;
    if (question == null || selection == null || sessionId == null) return;
    final nextIndex = state.index + 1;
    final complete = nextIndex >= state.questions.length;
    await repository.recordAnswer(
      sessionId: sessionId,
      question: question,
      selectedIndex: selection,
      nextIndex: nextIndex,
      correctCount: state.correctCount,
      complete: complete,
    );
    state = state.copyWith(
      index: nextIndex,
      complete: complete,
      clearSelection: true,
    );
  }
}

final practiceControllerProvider =
    StateNotifierProvider<PracticeController, PracticeState>(
      (ref) => PracticeController(ref.watch(practiceRepositoryProvider)),
    );
