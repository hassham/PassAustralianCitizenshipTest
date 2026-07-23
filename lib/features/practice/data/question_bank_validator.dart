class QuestionBankValidationException implements Exception {
  QuestionBankValidationException(this.errors);

  final List<String> errors;

  @override
  String toString() => 'Question bank validation failed:\n${errors.join('\n')}';
}

class QuestionBankValidator {
  const QuestionBankValidator();

  void validate(Map<String, dynamic> bank) {
    final errors = <String>[];
    _requiredString(bank, 'schemaVersion', r'bank', errors);
    _requiredString(bank, 'questionBankVersion', r'bank', errors);
    final categories = _list(bank, 'categories', r'bank', errors);
    final sources = _list(bank, 'sourceEditions', r'bank', errors);
    final questions = _list(bank, 'questions', r'bank', errors);
    final removed = bank['removedQuestions'] == null
        ? const <dynamic>[]
        : _list(bank, 'removedQuestions', r'bank', errors);

    final categoryIds = _uniqueIds(categories, 'categories', errors);
    final sourceIds = _uniqueIds(sources, 'sourceEditions', errors);
    final questionIds = _uniqueIds(questions, 'questions', errors);
    final removedIds = _uniqueIds(removed, 'removedQuestions', errors);
    final globalOptionIds = <String>{};

    for (var i = 0; i < questions.length; i++) {
      final value = questions[i];
      if (value is! Map<String, dynamic>) continue;
      final path = 'questions[$i]';
      final id = _requiredString(value, 'id', path, errors);
      final categoryId = _requiredString(value, 'categoryId', path, errors);
      _requiredString(value, 'text', path, errors);
      final status = _requiredString(value, 'status', path, errors);
      final difficulty = _requiredString(value, 'difficulty', path, errors);
      if (status != null &&
          !{
            'draft',
            'ready_for_review',
            'approved',
            'needs_changes',
            'archived',
          }.contains(status)) {
        errors.add('$path.status has unsupported value "$status".');
      }
      if (difficulty != null &&
          !{'easy', 'medium', 'hard'}.contains(difficulty)) {
        errors.add('$path.difficulty has unsupported value "$difficulty".');
      }
      if (value['revision'] is! int || (value['revision'] as int) < 1) {
        errors.add('$path.revision must be a positive integer.');
      }
      if (value['isAustralianValuesQuestion'] is! bool) {
        errors.add('$path.isAustralianValuesQuestion must be a boolean.');
      }
      if (categoryId != null && !categoryIds.contains(categoryId)) {
        errors.add(
          '$path.categoryId references unknown category "$categoryId".',
        );
      }

      final options = _list(value, 'options', path, errors);
      if (options.length != 4) {
        errors.add('$path.options must contain exactly 4 options.');
      }
      final optionIds = <String>{};
      final orders = <int>{};
      var correctCount = 0;
      for (var optionIndex = 0; optionIndex < options.length; optionIndex++) {
        final option = options[optionIndex];
        if (option is! Map<String, dynamic>) {
          errors.add('$path.options[$optionIndex] must be an object.');
          continue;
        }
        final optionPath = '$path.options[$optionIndex]';
        final optionId = _requiredString(option, 'id', optionPath, errors);
        _requiredString(option, 'text', optionPath, errors);
        _requiredString(option, 'explanation', optionPath, errors);
        if (optionId != null && !optionIds.add(optionId)) {
          errors.add('$optionPath.id is duplicated within question "$id".');
        }
        if (optionId != null && !globalOptionIds.add(optionId)) {
          errors.add('$optionPath.id duplicates option ID "$optionId".');
        }
        if (option['isCorrect'] is! bool) {
          errors.add('$optionPath.isCorrect must be a boolean.');
        } else if (option['isCorrect'] == true) {
          correctCount++;
        }
        final order = option['displayOrder'];
        if (order is! int || order < 0 || order > 3) {
          errors.add(
            '$optionPath.displayOrder must be an integer from 0 to 3.',
          );
        } else if (!orders.add(order)) {
          errors.add('$optionPath.displayOrder duplicates $order.');
        }
      }
      if (correctCount != 1) {
        errors.add('$path must have exactly one correct option.');
      }

      final references = _list(value, 'sourceReferences', path, errors);
      if (references.isEmpty) {
        errors.add('$path.sourceReferences cannot be empty.');
      }
      for (
        var referenceIndex = 0;
        referenceIndex < references.length;
        referenceIndex++
      ) {
        final reference = references[referenceIndex];
        if (reference is! Map<String, dynamic>) {
          continue;
        }
        final referencePath = '$path.sourceReferences[$referenceIndex]';
        final sourceId = _requiredString(
          reference,
          'sourceEditionId',
          referencePath,
          errors,
        );
        if (sourceId != null && !sourceIds.contains(sourceId)) {
          errors.add(
            '$referencePath.sourceEditionId references unknown source "$sourceId".',
          );
        }
        final start = reference['pageStart'];
        final end = reference['pageEnd'];
        if (start is! int || start < 1) {
          errors.add('$referencePath.pageStart must be positive.');
        }
        if (end is! int || end < 1) {
          errors.add('$referencePath.pageEnd must be positive.');
        }
        if (start is int && end is int && end < start) {
          errors.add('$referencePath.pageEnd cannot be less than pageStart.');
        }
      }
    }

    for (var i = 0; i < removed.length; i++) {
      final item = removed[i];
      if (item is! Map<String, dynamic>) continue;
      final replacement = item['replacementQuestionId'];
      if (replacement is String && !questionIds.contains(replacement)) {
        errors.add(
          'removedQuestions[$i].replacementQuestionId references unknown question "$replacement".',
        );
      }
    }
    final conflicts = questionIds.intersection(removedIds);
    if (conflicts.isNotEmpty) {
      errors.add(
        'Question IDs cannot be both active and removed: ${conflicts.join(', ')}.',
      );
    }
    if (errors.isNotEmpty) {
      throw QuestionBankValidationException(errors);
    }
  }

  List<dynamic> _list(
    Map<String, dynamic> object,
    String key,
    String path,
    List<String> errors,
  ) {
    final value = object[key];
    if (value is List<dynamic>) return value;
    errors.add('$path.$key must be an array.');
    return const [];
  }

  String? _requiredString(
    Map<String, dynamic> object,
    String key,
    String path,
    List<String> errors,
  ) {
    final value = object[key];
    if (value is String && value.trim().isNotEmpty) return value;
    errors.add('$path.$key must be a non-empty string.');
    return null;
  }

  Set<String> _uniqueIds(
    List<dynamic> items,
    String path,
    List<String> errors,
  ) {
    final ids = <String>{};
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      if (item is! Map<String, dynamic>) {
        errors.add('$path[$i] must be an object.');
        continue;
      }
      final key = item.containsKey('id') ? 'id' : 'questionId';
      final id = _requiredString(item, key, '$path[$i]', errors);
      if (id != null && !ids.add(id)) {
        errors.add('$path[$i].id duplicates "$id".');
      }
    }
    return ids;
  }
}
