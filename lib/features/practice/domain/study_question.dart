class StudyQuestionModel {
  const StudyQuestionModel({
    required this.id,
    required this.categoryId,
    required this.text,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String id;
  final String categoryId;
  final String text;
  final List<String> options;
  final int correctIndex;
  final String explanation;
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
