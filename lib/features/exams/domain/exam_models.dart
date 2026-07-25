import '../../practice/domain/study_question.dart';

class ExamConfigModel {
  const ExamConfigModel({
    required this.id,
    required this.questionCount,
    required this.durationMinutes,
    required this.passPercentage,
  });

  final int id;
  final int questionCount;
  final int durationMinutes;
  final double passPercentage;
}

class RestoredExamModel {
  const RestoredExamModel({
    required this.attemptId,
    required this.config,
    required this.questions,
    required this.answers,
    required this.currentIndex,
    required this.isTimed,
    this.remainingSeconds,
    this.lastObservedAt,
    this.timerLocked = false,
  });

  final int attemptId;
  final ExamConfigModel config;
  final List<StudyQuestionModel> questions;
  final Map<int, int> answers;
  final int currentIndex;
  final bool isTimed;
  final int? remainingSeconds;
  final DateTime? lastObservedAt;
  final bool timerLocked;
}

class ExamResultModel {
  const ExamResultModel({
    required this.score,
    required this.passed,
    required this.correct,
    required this.incorrect,
    required this.unanswered,
    this.timedOut = false,
    this.timeTakenSeconds,
  });

  final double score;
  final bool passed;
  final int correct;
  final int incorrect;
  final int unanswered;
  final bool timedOut;
  final int? timeTakenSeconds;
}
