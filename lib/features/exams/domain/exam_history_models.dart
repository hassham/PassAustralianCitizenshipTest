import '../../practice/domain/study_question.dart';

class ExamHistorySummary {
  const ExamHistorySummary({
    required this.attemptId,
    required this.completedAt,
    required this.score,
    required this.passed,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.isTimed,
    required this.overallRequirementMet,
    required this.australianValuesRequirementMet,
    required this.australianValuesCorrect,
    required this.australianValuesTotal,
    this.timeTakenSeconds,
  });

  final int attemptId;
  final DateTime completedAt;
  final double score;
  final bool passed;
  final int totalQuestions;
  final int correctAnswers;
  final bool isTimed;
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
    return 'All 5 Australian values questions were required to be correct.';
  }

  final int? timeTakenSeconds;
}

class HistoricalAnswer {
  const HistoricalAnswer({
    required this.order,
    required this.questionId,
    required this.question,
    required this.selectedIndex,
    required this.wasCorrect,
    this.removalMessage,
  });

  final int order;
  final String questionId;
  final StudyQuestionModel? question;
  final int? selectedIndex;
  final bool? wasCorrect;
  final String? removalMessage;
  bool get removed => removalMessage != null;
}

class ExamHistoryDetail {
  const ExamHistoryDetail({required this.summary, required this.answers});

  final ExamHistorySummary summary;
  final List<HistoricalAnswer> answers;
}
