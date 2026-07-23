import '../../practice/domain/study_question.dart';

class ExamHistorySummary {
  const ExamHistorySummary({
    required this.attemptId,
    required this.completedAt,
    required this.score,
    required this.passed,
    required this.totalQuestions,
    required this.correctAnswers,
  });

  final int attemptId;
  final DateTime completedAt;
  final double score;
  final bool passed;
  final int totalQuestions;
  final int correctAnswers;
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
