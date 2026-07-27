import '../../practice/domain/study_question.dart';

class ExamConfigModel {
  const ExamConfigModel({
    required this.id,
    required this.questionCount,
    required this.durationMinutes,
    required this.passPercentage,
    this.australianValuesQuestionCount = 5,
    this.requireAllAustralianValuesCorrect = true,
  });

  final int id;
  final int questionCount;
  final int durationMinutes;
  final double passPercentage;
  final int australianValuesQuestionCount;
  final bool requireAllAustralianValuesCorrect;
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
    required this.overallRequirementMet,
    required this.australianValuesRequirementMet,
    required this.australianValuesCorrect,
    required this.australianValuesTotal,
    this.timedOut = false,
    this.timeTakenSeconds,
  });

  final double score;
  final bool passed;
  final int correct;
  final int incorrect;
  final int unanswered;
  final bool overallRequirementMet;
  final bool australianValuesRequirementMet;
  final int australianValuesCorrect;
  final int australianValuesTotal;
  String? get failureReason {
    if (passed) return null;
    if (!overallRequirementMet && !australianValuesRequirementMet) {
      return 'The overall pass mark and the Australian values requirement '
          'were not met.';
    }
    if (!overallRequirementMet) {
      return 'The overall score was below the required pass mark.';
    }
    return 'All 5 Australian values questions must be answered correctly.';
  }
  final bool timedOut;
  final int? timeTakenSeconds;
}
