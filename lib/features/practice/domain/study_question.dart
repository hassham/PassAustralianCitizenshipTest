class StudyQuestionModel {
  const StudyQuestionModel({
    required this.id,
    required this.categoryId,
    required this.text,
    required this.options,
    required this.overallExplanation,
    required this.difficulty,
    required this.isAustralianValuesQuestion,
    required this.references,
  });

  final String id;
  final String categoryId;
  final String text;
  final List<QuestionOptionModel> options;
  final String overallExplanation;
  final String difficulty;
  final bool isAustralianValuesQuestion;
  final List<QuestionReferenceModel> references;

  int get correctIndex => options.indexWhere((option) => option.isCorrect);
  QuestionOptionModel get correctOption => options[correctIndex];
}

class QuestionOptionModel {
  const QuestionOptionModel({
    required this.id,
    required this.text,
    required this.isCorrect,
    required this.explanation,
    required this.displayOrder,
  });

  final String id;
  final String text;
  final bool isCorrect;
  final String explanation;
  final int displayOrder;
}

class QuestionReferenceModel {
  const QuestionReferenceModel({
    required this.sourceTitle,
    required this.edition,
    required this.part,
    required this.section,
    required this.pageStart,
    required this.pageEnd,
  });

  final String sourceTitle;
  final String edition;
  final String part;
  final String section;
  final int pageStart;
  final int pageEnd;

  String get pageLabel =>
      pageStart == pageEnd ? 'page $pageStart' : 'pages $pageStart–$pageEnd';
}

class RemovedStarredQuestionModel {
  const RemovedStarredQuestionModel(this.questionId, this.message);
  final String questionId;
  final String message;
}

class CategoryModel {
  const CategoryModel(this.id, this.name, this.questionCount);
  final String id;
  final String name;
  final int questionCount;
}

class ProgressSummary {
  const ProgressSummary(this.attempted, this.correct);
  final int attempted;
  final int correct;
  int get accuracy => attempted == 0 ? 0 : (correct * 100 / attempted).round();
}

class HomeDashboardModel {
  const HomeDashboardModel({
    required this.progress,
    required this.totalQuestions,
    required this.starredQuestions,
    required this.hasActivePractice,
    required this.hasActiveExam,
  });

  final ProgressSummary progress;
  final int totalQuestions;
  final int starredQuestions;
  final bool hasActivePractice;
  final bool hasActiveExam;
}
