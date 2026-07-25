// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, Category> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<Category> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Category map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Category(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class Category extends DataClass implements Insertable<Category> {
  final String id;
  final String name;
  const Category({required this.id, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(id: Value(id), name: Value(name));
  }

  factory Category.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Category(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
    };
  }

  Category copyWith({String? id, String? name}) =>
      Category(id: id ?? this.id, name: name ?? this.name);
  Category copyWithCompanion(CategoriesCompanion data) {
    return Category(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Category(')
          ..write('id: $id, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Category && other.id == this.id && other.name == this.name);
}

class CategoriesCompanion extends UpdateCompanion<Category> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<Category> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyQuestionsTable extends StudyQuestions
    with TableInfo<$StudyQuestionsTable, StudyQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionTextMeta = const VerificationMeta(
    'questionText',
  );
  @override
  late final GeneratedColumn<String> questionText = GeneratedColumn<String>(
    'question_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _optionsJsonMeta = const VerificationMeta(
    'optionsJson',
  );
  @override
  late final GeneratedColumn<String> optionsJson = GeneratedColumn<String>(
    'options_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctIndexMeta = const VerificationMeta(
    'correctIndex',
  );
  @override
  late final GeneratedColumn<int> correctIndex = GeneratedColumn<int>(
    'correct_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationMeta = const VerificationMeta(
    'explanation',
  );
  @override
  late final GeneratedColumn<String> explanation = GeneratedColumn<String>(
    'explanation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    questionText,
    optionsJson,
    correctIndex,
    explanation,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('question_text')) {
      context.handle(
        _questionTextMeta,
        questionText.isAcceptableOrUnknown(
          data['question_text']!,
          _questionTextMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionTextMeta);
    }
    if (data.containsKey('options_json')) {
      context.handle(
        _optionsJsonMeta,
        optionsJson.isAcceptableOrUnknown(
          data['options_json']!,
          _optionsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_optionsJsonMeta);
    }
    if (data.containsKey('correct_index')) {
      context.handle(
        _correctIndexMeta,
        correctIndex.isAcceptableOrUnknown(
          data['correct_index']!,
          _correctIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_correctIndexMeta);
    }
    if (data.containsKey('explanation')) {
      context.handle(
        _explanationMeta,
        explanation.isAcceptableOrUnknown(
          data['explanation']!,
          _explanationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyQuestion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      questionText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_text'],
      )!,
      optionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}options_json'],
      )!,
      correctIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_index'],
      )!,
      explanation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation'],
      )!,
    );
  }

  @override
  $StudyQuestionsTable createAlias(String alias) {
    return $StudyQuestionsTable(attachedDatabase, alias);
  }
}

class StudyQuestion extends DataClass implements Insertable<StudyQuestion> {
  final String id;
  final String categoryId;
  final String questionText;
  final String optionsJson;
  final int correctIndex;
  final String explanation;
  const StudyQuestion({
    required this.id,
    required this.categoryId,
    required this.questionText,
    required this.optionsJson,
    required this.correctIndex,
    required this.explanation,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['question_text'] = Variable<String>(questionText);
    map['options_json'] = Variable<String>(optionsJson);
    map['correct_index'] = Variable<int>(correctIndex);
    map['explanation'] = Variable<String>(explanation);
    return map;
  }

  StudyQuestionsCompanion toCompanion(bool nullToAbsent) {
    return StudyQuestionsCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      questionText: Value(questionText),
      optionsJson: Value(optionsJson),
      correctIndex: Value(correctIndex),
      explanation: Value(explanation),
    );
  }

  factory StudyQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyQuestion(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      questionText: serializer.fromJson<String>(json['questionText']),
      optionsJson: serializer.fromJson<String>(json['optionsJson']),
      correctIndex: serializer.fromJson<int>(json['correctIndex']),
      explanation: serializer.fromJson<String>(json['explanation']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'questionText': serializer.toJson<String>(questionText),
      'optionsJson': serializer.toJson<String>(optionsJson),
      'correctIndex': serializer.toJson<int>(correctIndex),
      'explanation': serializer.toJson<String>(explanation),
    };
  }

  StudyQuestion copyWith({
    String? id,
    String? categoryId,
    String? questionText,
    String? optionsJson,
    int? correctIndex,
    String? explanation,
  }) => StudyQuestion(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    questionText: questionText ?? this.questionText,
    optionsJson: optionsJson ?? this.optionsJson,
    correctIndex: correctIndex ?? this.correctIndex,
    explanation: explanation ?? this.explanation,
  );
  StudyQuestion copyWithCompanion(StudyQuestionsCompanion data) {
    return StudyQuestion(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      questionText: data.questionText.present
          ? data.questionText.value
          : this.questionText,
      optionsJson: data.optionsJson.present
          ? data.optionsJson.value
          : this.optionsJson,
      correctIndex: data.correctIndex.present
          ? data.correctIndex.value
          : this.correctIndex,
      explanation: data.explanation.present
          ? data.explanation.value
          : this.explanation,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyQuestion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('questionText: $questionText, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('explanation: $explanation')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    questionText,
    optionsJson,
    correctIndex,
    explanation,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyQuestion &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.questionText == this.questionText &&
          other.optionsJson == this.optionsJson &&
          other.correctIndex == this.correctIndex &&
          other.explanation == this.explanation);
}

class StudyQuestionsCompanion extends UpdateCompanion<StudyQuestion> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<String> questionText;
  final Value<String> optionsJson;
  final Value<int> correctIndex;
  final Value<String> explanation;
  final Value<int> rowid;
  const StudyQuestionsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.questionText = const Value.absent(),
    this.optionsJson = const Value.absent(),
    this.correctIndex = const Value.absent(),
    this.explanation = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyQuestionsCompanion.insert({
    required String id,
    required String categoryId,
    required String questionText,
    required String optionsJson,
    required int correctIndex,
    required String explanation,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoryId = Value(categoryId),
       questionText = Value(questionText),
       optionsJson = Value(optionsJson),
       correctIndex = Value(correctIndex),
       explanation = Value(explanation);
  static Insertable<StudyQuestion> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<String>? questionText,
    Expression<String>? optionsJson,
    Expression<int>? correctIndex,
    Expression<String>? explanation,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (questionText != null) 'question_text': questionText,
      if (optionsJson != null) 'options_json': optionsJson,
      if (correctIndex != null) 'correct_index': correctIndex,
      if (explanation != null) 'explanation': explanation,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyQuestionsCompanion copyWith({
    Value<String>? id,
    Value<String>? categoryId,
    Value<String>? questionText,
    Value<String>? optionsJson,
    Value<int>? correctIndex,
    Value<String>? explanation,
    Value<int>? rowid,
  }) {
    return StudyQuestionsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      questionText: questionText ?? this.questionText,
      optionsJson: optionsJson ?? this.optionsJson,
      correctIndex: correctIndex ?? this.correctIndex,
      explanation: explanation ?? this.explanation,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (questionText.present) {
      map['question_text'] = Variable<String>(questionText.value);
    }
    if (optionsJson.present) {
      map['options_json'] = Variable<String>(optionsJson.value);
    }
    if (correctIndex.present) {
      map['correct_index'] = Variable<int>(correctIndex.value);
    }
    if (explanation.present) {
      map['explanation'] = Variable<String>(explanation.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyQuestionsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('questionText: $questionText, ')
          ..write('optionsJson: $optionsJson, ')
          ..write('correctIndex: $correctIndex, ')
          ..write('explanation: $explanation, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $QuestionAttemptsTable extends QuestionAttempts
    with TableInfo<$QuestionAttemptsTable, QuestionAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $QuestionAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedIndexMeta = const VerificationMeta(
    'selectedIndex',
  );
  @override
  late final GeneratedColumn<int> selectedIndex = GeneratedColumn<int>(
    'selected_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _attemptedAtMeta = const VerificationMeta(
    'attemptedAt',
  );
  @override
  late final GeneratedColumn<DateTime> attemptedAt = GeneratedColumn<DateTime>(
    'attempted_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    questionId,
    selectedIndex,
    isCorrect,
    attemptedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'question_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<QuestionAttempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('selected_index')) {
      context.handle(
        _selectedIndexMeta,
        selectedIndex.isAcceptableOrUnknown(
          data['selected_index']!,
          _selectedIndexMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedIndexMeta);
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    } else if (isInserting) {
      context.missing(_isCorrectMeta);
    }
    if (data.containsKey('attempted_at')) {
      context.handle(
        _attemptedAtMeta,
        attemptedAt.isAcceptableOrUnknown(
          data['attempted_at']!,
          _attemptedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_attemptedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  QuestionAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return QuestionAttempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      selectedIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selected_index'],
      )!,
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      )!,
      attemptedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}attempted_at'],
      )!,
    );
  }

  @override
  $QuestionAttemptsTable createAlias(String alias) {
    return $QuestionAttemptsTable(attachedDatabase, alias);
  }
}

class QuestionAttempt extends DataClass implements Insertable<QuestionAttempt> {
  final int id;
  final String questionId;
  final int selectedIndex;
  final bool isCorrect;
  final DateTime attemptedAt;
  const QuestionAttempt({
    required this.id,
    required this.questionId,
    required this.selectedIndex,
    required this.isCorrect,
    required this.attemptedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['question_id'] = Variable<String>(questionId);
    map['selected_index'] = Variable<int>(selectedIndex);
    map['is_correct'] = Variable<bool>(isCorrect);
    map['attempted_at'] = Variable<DateTime>(attemptedAt);
    return map;
  }

  QuestionAttemptsCompanion toCompanion(bool nullToAbsent) {
    return QuestionAttemptsCompanion(
      id: Value(id),
      questionId: Value(questionId),
      selectedIndex: Value(selectedIndex),
      isCorrect: Value(isCorrect),
      attemptedAt: Value(attemptedAt),
    );
  }

  factory QuestionAttempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return QuestionAttempt(
      id: serializer.fromJson<int>(json['id']),
      questionId: serializer.fromJson<String>(json['questionId']),
      selectedIndex: serializer.fromJson<int>(json['selectedIndex']),
      isCorrect: serializer.fromJson<bool>(json['isCorrect']),
      attemptedAt: serializer.fromJson<DateTime>(json['attemptedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'questionId': serializer.toJson<String>(questionId),
      'selectedIndex': serializer.toJson<int>(selectedIndex),
      'isCorrect': serializer.toJson<bool>(isCorrect),
      'attemptedAt': serializer.toJson<DateTime>(attemptedAt),
    };
  }

  QuestionAttempt copyWith({
    int? id,
    String? questionId,
    int? selectedIndex,
    bool? isCorrect,
    DateTime? attemptedAt,
  }) => QuestionAttempt(
    id: id ?? this.id,
    questionId: questionId ?? this.questionId,
    selectedIndex: selectedIndex ?? this.selectedIndex,
    isCorrect: isCorrect ?? this.isCorrect,
    attemptedAt: attemptedAt ?? this.attemptedAt,
  );
  QuestionAttempt copyWithCompanion(QuestionAttemptsCompanion data) {
    return QuestionAttempt(
      id: data.id.present ? data.id.value : this.id,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      selectedIndex: data.selectedIndex.present
          ? data.selectedIndex.value
          : this.selectedIndex,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      attemptedAt: data.attemptedAt.present
          ? data.attemptedAt.value
          : this.attemptedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('QuestionAttempt(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('selectedIndex: $selectedIndex, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('attemptedAt: $attemptedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, questionId, selectedIndex, isCorrect, attemptedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is QuestionAttempt &&
          other.id == this.id &&
          other.questionId == this.questionId &&
          other.selectedIndex == this.selectedIndex &&
          other.isCorrect == this.isCorrect &&
          other.attemptedAt == this.attemptedAt);
}

class QuestionAttemptsCompanion extends UpdateCompanion<QuestionAttempt> {
  final Value<int> id;
  final Value<String> questionId;
  final Value<int> selectedIndex;
  final Value<bool> isCorrect;
  final Value<DateTime> attemptedAt;
  const QuestionAttemptsCompanion({
    this.id = const Value.absent(),
    this.questionId = const Value.absent(),
    this.selectedIndex = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.attemptedAt = const Value.absent(),
  });
  QuestionAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required String questionId,
    required int selectedIndex,
    required bool isCorrect,
    required DateTime attemptedAt,
  }) : questionId = Value(questionId),
       selectedIndex = Value(selectedIndex),
       isCorrect = Value(isCorrect),
       attemptedAt = Value(attemptedAt);
  static Insertable<QuestionAttempt> custom({
    Expression<int>? id,
    Expression<String>? questionId,
    Expression<int>? selectedIndex,
    Expression<bool>? isCorrect,
    Expression<DateTime>? attemptedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (questionId != null) 'question_id': questionId,
      if (selectedIndex != null) 'selected_index': selectedIndex,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (attemptedAt != null) 'attempted_at': attemptedAt,
    });
  }

  QuestionAttemptsCompanion copyWith({
    Value<int>? id,
    Value<String>? questionId,
    Value<int>? selectedIndex,
    Value<bool>? isCorrect,
    Value<DateTime>? attemptedAt,
  }) {
    return QuestionAttemptsCompanion(
      id: id ?? this.id,
      questionId: questionId ?? this.questionId,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      attemptedAt: attemptedAt ?? this.attemptedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (selectedIndex.present) {
      map['selected_index'] = Variable<int>(selectedIndex.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (attemptedAt.present) {
      map['attempted_at'] = Variable<DateTime>(attemptedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('QuestionAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('questionId: $questionId, ')
          ..write('selectedIndex: $selectedIndex, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('attemptedAt: $attemptedAt')
          ..write(')'))
        .toString();
  }
}

class $StarredQuestionsTable extends StarredQuestions
    with TableInfo<$StarredQuestionsTable, StarredQuestion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StarredQuestionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _starredAtMeta = const VerificationMeta(
    'starredAt',
  );
  @override
  late final GeneratedColumn<DateTime> starredAt = GeneratedColumn<DateTime>(
    'starred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [questionId, starredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'starred_questions';
  @override
  VerificationContext validateIntegrity(
    Insertable<StarredQuestion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('starred_at')) {
      context.handle(
        _starredAtMeta,
        starredAt.isAcceptableOrUnknown(data['starred_at']!, _starredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_starredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questionId};
  @override
  StarredQuestion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StarredQuestion(
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      starredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}starred_at'],
      )!,
    );
  }

  @override
  $StarredQuestionsTable createAlias(String alias) {
    return $StarredQuestionsTable(attachedDatabase, alias);
  }
}

class StarredQuestion extends DataClass implements Insertable<StarredQuestion> {
  final String questionId;
  final DateTime starredAt;
  const StarredQuestion({required this.questionId, required this.starredAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['question_id'] = Variable<String>(questionId);
    map['starred_at'] = Variable<DateTime>(starredAt);
    return map;
  }

  StarredQuestionsCompanion toCompanion(bool nullToAbsent) {
    return StarredQuestionsCompanion(
      questionId: Value(questionId),
      starredAt: Value(starredAt),
    );
  }

  factory StarredQuestion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StarredQuestion(
      questionId: serializer.fromJson<String>(json['questionId']),
      starredAt: serializer.fromJson<DateTime>(json['starredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questionId': serializer.toJson<String>(questionId),
      'starredAt': serializer.toJson<DateTime>(starredAt),
    };
  }

  StarredQuestion copyWith({String? questionId, DateTime? starredAt}) =>
      StarredQuestion(
        questionId: questionId ?? this.questionId,
        starredAt: starredAt ?? this.starredAt,
      );
  StarredQuestion copyWithCompanion(StarredQuestionsCompanion data) {
    return StarredQuestion(
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      starredAt: data.starredAt.present ? data.starredAt.value : this.starredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StarredQuestion(')
          ..write('questionId: $questionId, ')
          ..write('starredAt: $starredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(questionId, starredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StarredQuestion &&
          other.questionId == this.questionId &&
          other.starredAt == this.starredAt);
}

class StarredQuestionsCompanion extends UpdateCompanion<StarredQuestion> {
  final Value<String> questionId;
  final Value<DateTime> starredAt;
  final Value<int> rowid;
  const StarredQuestionsCompanion({
    this.questionId = const Value.absent(),
    this.starredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StarredQuestionsCompanion.insert({
    required String questionId,
    required DateTime starredAt,
    this.rowid = const Value.absent(),
  }) : questionId = Value(questionId),
       starredAt = Value(starredAt);
  static Insertable<StarredQuestion> custom({
    Expression<String>? questionId,
    Expression<DateTime>? starredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (questionId != null) 'question_id': questionId,
      if (starredAt != null) 'starred_at': starredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StarredQuestionsCompanion copyWith({
    Value<String>? questionId,
    Value<DateTime>? starredAt,
    Value<int>? rowid,
  }) {
    return StarredQuestionsCompanion(
      questionId: questionId ?? this.questionId,
      starredAt: starredAt ?? this.starredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (starredAt.present) {
      map['starred_at'] = Variable<DateTime>(starredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StarredQuestionsCompanion(')
          ..write('questionId: $questionId, ')
          ..write('starredAt: $starredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PracticeSessionsTable extends PracticeSessions
    with TableInfo<$PracticeSessionsTable, PracticeSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PracticeSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _questionIdsJsonMeta = const VerificationMeta(
    'questionIdsJson',
  );
  @override
  late final GeneratedColumn<String> questionIdsJson = GeneratedColumn<String>(
    'question_ids_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentIndexMeta = const VerificationMeta(
    'currentIndex',
  );
  @override
  late final GeneratedColumn<int> currentIndex = GeneratedColumn<int>(
    'current_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCompleteMeta = const VerificationMeta(
    'isComplete',
  );
  @override
  late final GeneratedColumn<bool> isComplete = GeneratedColumn<bool>(
    'is_complete',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_complete" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    questionIdsJson,
    currentIndex,
    correctCount,
    isComplete,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'practice_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PracticeSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('question_ids_json')) {
      context.handle(
        _questionIdsJsonMeta,
        questionIdsJson.isAcceptableOrUnknown(
          data['question_ids_json']!,
          _questionIdsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionIdsJsonMeta);
    }
    if (data.containsKey('current_index')) {
      context.handle(
        _currentIndexMeta,
        currentIndex.isAcceptableOrUnknown(
          data['current_index']!,
          _currentIndexMeta,
        ),
      );
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    }
    if (data.containsKey('is_complete')) {
      context.handle(
        _isCompleteMeta,
        isComplete.isAcceptableOrUnknown(data['is_complete']!, _isCompleteMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PracticeSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PracticeSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      questionIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_ids_json'],
      )!,
      currentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_index'],
      )!,
      correctCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_count'],
      )!,
      isComplete: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_complete'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PracticeSessionsTable createAlias(String alias) {
    return $PracticeSessionsTable(attachedDatabase, alias);
  }
}

class PracticeSession extends DataClass implements Insertable<PracticeSession> {
  final int id;
  final String? categoryId;
  final String questionIdsJson;
  final int currentIndex;
  final int correctCount;
  final bool isComplete;
  final DateTime updatedAt;
  const PracticeSession({
    required this.id,
    this.categoryId,
    required this.questionIdsJson,
    required this.currentIndex,
    required this.correctCount,
    required this.isComplete,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['question_ids_json'] = Variable<String>(questionIdsJson);
    map['current_index'] = Variable<int>(currentIndex);
    map['correct_count'] = Variable<int>(correctCount);
    map['is_complete'] = Variable<bool>(isComplete);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PracticeSessionsCompanion toCompanion(bool nullToAbsent) {
    return PracticeSessionsCompanion(
      id: Value(id),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      questionIdsJson: Value(questionIdsJson),
      currentIndex: Value(currentIndex),
      correctCount: Value(correctCount),
      isComplete: Value(isComplete),
      updatedAt: Value(updatedAt),
    );
  }

  factory PracticeSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PracticeSession(
      id: serializer.fromJson<int>(json['id']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      questionIdsJson: serializer.fromJson<String>(json['questionIdsJson']),
      currentIndex: serializer.fromJson<int>(json['currentIndex']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      isComplete: serializer.fromJson<bool>(json['isComplete']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'categoryId': serializer.toJson<String?>(categoryId),
      'questionIdsJson': serializer.toJson<String>(questionIdsJson),
      'currentIndex': serializer.toJson<int>(currentIndex),
      'correctCount': serializer.toJson<int>(correctCount),
      'isComplete': serializer.toJson<bool>(isComplete),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PracticeSession copyWith({
    int? id,
    Value<String?> categoryId = const Value.absent(),
    String? questionIdsJson,
    int? currentIndex,
    int? correctCount,
    bool? isComplete,
    DateTime? updatedAt,
  }) => PracticeSession(
    id: id ?? this.id,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    questionIdsJson: questionIdsJson ?? this.questionIdsJson,
    currentIndex: currentIndex ?? this.currentIndex,
    correctCount: correctCount ?? this.correctCount,
    isComplete: isComplete ?? this.isComplete,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PracticeSession copyWithCompanion(PracticeSessionsCompanion data) {
    return PracticeSession(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      questionIdsJson: data.questionIdsJson.present
          ? data.questionIdsJson.value
          : this.questionIdsJson,
      currentIndex: data.currentIndex.present
          ? data.currentIndex.value
          : this.currentIndex,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      isComplete: data.isComplete.present
          ? data.isComplete.value
          : this.isComplete,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PracticeSession(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('questionIdsJson: $questionIdsJson, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('correctCount: $correctCount, ')
          ..write('isComplete: $isComplete, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    questionIdsJson,
    currentIndex,
    correctCount,
    isComplete,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PracticeSession &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.questionIdsJson == this.questionIdsJson &&
          other.currentIndex == this.currentIndex &&
          other.correctCount == this.correctCount &&
          other.isComplete == this.isComplete &&
          other.updatedAt == this.updatedAt);
}

class PracticeSessionsCompanion extends UpdateCompanion<PracticeSession> {
  final Value<int> id;
  final Value<String?> categoryId;
  final Value<String> questionIdsJson;
  final Value<int> currentIndex;
  final Value<int> correctCount;
  final Value<bool> isComplete;
  final Value<DateTime> updatedAt;
  const PracticeSessionsCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.questionIdsJson = const Value.absent(),
    this.currentIndex = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.isComplete = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PracticeSessionsCompanion.insert({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    required String questionIdsJson,
    this.currentIndex = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.isComplete = const Value.absent(),
    required DateTime updatedAt,
  }) : questionIdsJson = Value(questionIdsJson),
       updatedAt = Value(updatedAt);
  static Insertable<PracticeSession> custom({
    Expression<int>? id,
    Expression<String>? categoryId,
    Expression<String>? questionIdsJson,
    Expression<int>? currentIndex,
    Expression<int>? correctCount,
    Expression<bool>? isComplete,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (questionIdsJson != null) 'question_ids_json': questionIdsJson,
      if (currentIndex != null) 'current_index': currentIndex,
      if (correctCount != null) 'correct_count': correctCount,
      if (isComplete != null) 'is_complete': isComplete,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PracticeSessionsCompanion copyWith({
    Value<int>? id,
    Value<String?>? categoryId,
    Value<String>? questionIdsJson,
    Value<int>? currentIndex,
    Value<int>? correctCount,
    Value<bool>? isComplete,
    Value<DateTime>? updatedAt,
  }) {
    return PracticeSessionsCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      questionIdsJson: questionIdsJson ?? this.questionIdsJson,
      currentIndex: currentIndex ?? this.currentIndex,
      correctCount: correctCount ?? this.correctCount,
      isComplete: isComplete ?? this.isComplete,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (questionIdsJson.present) {
      map['question_ids_json'] = Variable<String>(questionIdsJson.value);
    }
    if (currentIndex.present) {
      map['current_index'] = Variable<int>(currentIndex.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (isComplete.present) {
      map['is_complete'] = Variable<bool>(isComplete.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PracticeSessionsCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('questionIdsJson: $questionIdsJson, ')
          ..write('currentIndex: $currentIndex, ')
          ..write('correctCount: $correctCount, ')
          ..write('isComplete: $isComplete, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $ExamConfigurationsTable extends ExamConfigurations
    with TableInfo<$ExamConfigurationsTable, ExamConfiguration> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamConfigurationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _examNameMeta = const VerificationMeta(
    'examName',
  );
  @override
  late final GeneratedColumn<String> examName = GeneratedColumn<String>(
    'exam_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _questionCountMeta = const VerificationMeta(
    'questionCount',
  );
  @override
  late final GeneratedColumn<int> questionCount = GeneratedColumn<int>(
    'question_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMinutesMeta = const VerificationMeta(
    'durationMinutes',
  );
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
    'duration_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _passPercentageMeta = const VerificationMeta(
    'passPercentage',
  );
  @override
  late final GeneratedColumn<double> passPercentage = GeneratedColumn<double>(
    'pass_percentage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examName,
    questionCount,
    durationMinutes,
    passPercentage,
    version,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_configurations';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamConfiguration> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exam_name')) {
      context.handle(
        _examNameMeta,
        examName.isAcceptableOrUnknown(data['exam_name']!, _examNameMeta),
      );
    } else if (isInserting) {
      context.missing(_examNameMeta);
    }
    if (data.containsKey('question_count')) {
      context.handle(
        _questionCountMeta,
        questionCount.isAcceptableOrUnknown(
          data['question_count']!,
          _questionCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionCountMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
        _durationMinutesMeta,
        durationMinutes.isAcceptableOrUnknown(
          data['duration_minutes']!,
          _durationMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('pass_percentage')) {
      context.handle(
        _passPercentageMeta,
        passPercentage.isAcceptableOrUnknown(
          data['pass_percentage']!,
          _passPercentageMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_passPercentageMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamConfiguration map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamConfiguration(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      examName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exam_name'],
      )!,
      questionCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_count'],
      )!,
      durationMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_minutes'],
      )!,
      passPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pass_percentage'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $ExamConfigurationsTable createAlias(String alias) {
    return $ExamConfigurationsTable(attachedDatabase, alias);
  }
}

class ExamConfiguration extends DataClass
    implements Insertable<ExamConfiguration> {
  final int id;
  final String examName;
  final int questionCount;
  final int durationMinutes;
  final double passPercentage;
  final int version;
  final bool isActive;
  const ExamConfiguration({
    required this.id,
    required this.examName,
    required this.questionCount,
    required this.durationMinutes,
    required this.passPercentage,
    required this.version,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exam_name'] = Variable<String>(examName);
    map['question_count'] = Variable<int>(questionCount);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['pass_percentage'] = Variable<double>(passPercentage);
    map['version'] = Variable<int>(version);
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  ExamConfigurationsCompanion toCompanion(bool nullToAbsent) {
    return ExamConfigurationsCompanion(
      id: Value(id),
      examName: Value(examName),
      questionCount: Value(questionCount),
      durationMinutes: Value(durationMinutes),
      passPercentage: Value(passPercentage),
      version: Value(version),
      isActive: Value(isActive),
    );
  }

  factory ExamConfiguration.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamConfiguration(
      id: serializer.fromJson<int>(json['id']),
      examName: serializer.fromJson<String>(json['examName']),
      questionCount: serializer.fromJson<int>(json['questionCount']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      passPercentage: serializer.fromJson<double>(json['passPercentage']),
      version: serializer.fromJson<int>(json['version']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'examName': serializer.toJson<String>(examName),
      'questionCount': serializer.toJson<int>(questionCount),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'passPercentage': serializer.toJson<double>(passPercentage),
      'version': serializer.toJson<int>(version),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  ExamConfiguration copyWith({
    int? id,
    String? examName,
    int? questionCount,
    int? durationMinutes,
    double? passPercentage,
    int? version,
    bool? isActive,
  }) => ExamConfiguration(
    id: id ?? this.id,
    examName: examName ?? this.examName,
    questionCount: questionCount ?? this.questionCount,
    durationMinutes: durationMinutes ?? this.durationMinutes,
    passPercentage: passPercentage ?? this.passPercentage,
    version: version ?? this.version,
    isActive: isActive ?? this.isActive,
  );
  ExamConfiguration copyWithCompanion(ExamConfigurationsCompanion data) {
    return ExamConfiguration(
      id: data.id.present ? data.id.value : this.id,
      examName: data.examName.present ? data.examName.value : this.examName,
      questionCount: data.questionCount.present
          ? data.questionCount.value
          : this.questionCount,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      passPercentage: data.passPercentage.present
          ? data.passPercentage.value
          : this.passPercentage,
      version: data.version.present ? data.version.value : this.version,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamConfiguration(')
          ..write('id: $id, ')
          ..write('examName: $examName, ')
          ..write('questionCount: $questionCount, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('passPercentage: $passPercentage, ')
          ..write('version: $version, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    examName,
    questionCount,
    durationMinutes,
    passPercentage,
    version,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamConfiguration &&
          other.id == this.id &&
          other.examName == this.examName &&
          other.questionCount == this.questionCount &&
          other.durationMinutes == this.durationMinutes &&
          other.passPercentage == this.passPercentage &&
          other.version == this.version &&
          other.isActive == this.isActive);
}

class ExamConfigurationsCompanion extends UpdateCompanion<ExamConfiguration> {
  final Value<int> id;
  final Value<String> examName;
  final Value<int> questionCount;
  final Value<int> durationMinutes;
  final Value<double> passPercentage;
  final Value<int> version;
  final Value<bool> isActive;
  const ExamConfigurationsCompanion({
    this.id = const Value.absent(),
    this.examName = const Value.absent(),
    this.questionCount = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.passPercentage = const Value.absent(),
    this.version = const Value.absent(),
    this.isActive = const Value.absent(),
  });
  ExamConfigurationsCompanion.insert({
    this.id = const Value.absent(),
    required String examName,
    required int questionCount,
    required int durationMinutes,
    required double passPercentage,
    required int version,
    this.isActive = const Value.absent(),
  }) : examName = Value(examName),
       questionCount = Value(questionCount),
       durationMinutes = Value(durationMinutes),
       passPercentage = Value(passPercentage),
       version = Value(version);
  static Insertable<ExamConfiguration> custom({
    Expression<int>? id,
    Expression<String>? examName,
    Expression<int>? questionCount,
    Expression<int>? durationMinutes,
    Expression<double>? passPercentage,
    Expression<int>? version,
    Expression<bool>? isActive,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examName != null) 'exam_name': examName,
      if (questionCount != null) 'question_count': questionCount,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (passPercentage != null) 'pass_percentage': passPercentage,
      if (version != null) 'version': version,
      if (isActive != null) 'is_active': isActive,
    });
  }

  ExamConfigurationsCompanion copyWith({
    Value<int>? id,
    Value<String>? examName,
    Value<int>? questionCount,
    Value<int>? durationMinutes,
    Value<double>? passPercentage,
    Value<int>? version,
    Value<bool>? isActive,
  }) {
    return ExamConfigurationsCompanion(
      id: id ?? this.id,
      examName: examName ?? this.examName,
      questionCount: questionCount ?? this.questionCount,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      passPercentage: passPercentage ?? this.passPercentage,
      version: version ?? this.version,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (examName.present) {
      map['exam_name'] = Variable<String>(examName.value);
    }
    if (questionCount.present) {
      map['question_count'] = Variable<int>(questionCount.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (passPercentage.present) {
      map['pass_percentage'] = Variable<double>(passPercentage.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamConfigurationsCompanion(')
          ..write('id: $id, ')
          ..write('examName: $examName, ')
          ..write('questionCount: $questionCount, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('passPercentage: $passPercentage, ')
          ..write('version: $version, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }
}

class $ExamAttemptsTable extends ExamAttempts
    with TableInfo<$ExamAttemptsTable, ExamAttempt> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamAttemptsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _configIdMeta = const VerificationMeta(
    'configId',
  );
  @override
  late final GeneratedColumn<int> configId = GeneratedColumn<int>(
    'config_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedQuestionsJsonMeta =
      const VerificationMeta('selectedQuestionsJson');
  @override
  late final GeneratedColumn<String> selectedQuestionsJson =
      GeneratedColumn<String>(
        'selected_questions_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _totalQuestionsMeta = const VerificationMeta(
    'totalQuestions',
  );
  @override
  late final GeneratedColumn<int> totalQuestions = GeneratedColumn<int>(
    'total_questions',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentQuestionIndexMeta =
      const VerificationMeta('currentQuestionIndex');
  @override
  late final GeneratedColumn<int> currentQuestionIndex = GeneratedColumn<int>(
    'current_question_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isPassedMeta = const VerificationMeta(
    'isPassed',
  );
  @override
  late final GeneratedColumn<bool> isPassed = GeneratedColumn<bool>(
    'is_passed',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_passed" IN (0, 1))',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _submittedAtMeta = const VerificationMeta(
    'submittedAt',
  );
  @override
  late final GeneratedColumn<DateTime> submittedAt = GeneratedColumn<DateTime>(
    'submitted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPremiumTimedMeta = const VerificationMeta(
    'isPremiumTimed',
  );
  @override
  late final GeneratedColumn<bool> isPremiumTimed = GeneratedColumn<bool>(
    'is_premium_timed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_premium_timed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _remainingTimeSecondsMeta =
      const VerificationMeta('remainingTimeSeconds');
  @override
  late final GeneratedColumn<int> remainingTimeSeconds = GeneratedColumn<int>(
    'remaining_time_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastObservedAtMeta = const VerificationMeta(
    'lastObservedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastObservedAt =
      GeneratedColumn<DateTime>(
        'last_observed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _backgroundedAtMeta = const VerificationMeta(
    'backgroundedAt',
  );
  @override
  late final GeneratedColumn<DateTime> backgroundedAt =
      GeneratedColumn<DateTime>(
        'backgrounded_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _timerLockedMeta = const VerificationMeta(
    'timerLocked',
  );
  @override
  late final GeneratedColumn<bool> timerLocked = GeneratedColumn<bool>(
    'timer_locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("timer_locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _timeTakenSecondsMeta = const VerificationMeta(
    'timeTakenSeconds',
  );
  @override
  late final GeneratedColumn<int> timeTakenSeconds = GeneratedColumn<int>(
    'time_taken_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _readinessScoreMeta = const VerificationMeta(
    'readinessScore',
  );
  @override
  late final GeneratedColumn<double> readinessScore = GeneratedColumn<double>(
    'readiness_score',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    configId,
    selectedQuestionsJson,
    totalQuestions,
    currentQuestionIndex,
    score,
    isPassed,
    startedAt,
    submittedAt,
    isCompleted,
    isPremiumTimed,
    remainingTimeSeconds,
    lastObservedAt,
    backgroundedAt,
    timerLocked,
    timeTakenSeconds,
    readinessScore,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_attempts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamAttempt> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('config_id')) {
      context.handle(
        _configIdMeta,
        configId.isAcceptableOrUnknown(data['config_id']!, _configIdMeta),
      );
    } else if (isInserting) {
      context.missing(_configIdMeta);
    }
    if (data.containsKey('selected_questions_json')) {
      context.handle(
        _selectedQuestionsJsonMeta,
        selectedQuestionsJson.isAcceptableOrUnknown(
          data['selected_questions_json']!,
          _selectedQuestionsJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_selectedQuestionsJsonMeta);
    }
    if (data.containsKey('total_questions')) {
      context.handle(
        _totalQuestionsMeta,
        totalQuestions.isAcceptableOrUnknown(
          data['total_questions']!,
          _totalQuestionsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalQuestionsMeta);
    }
    if (data.containsKey('current_question_index')) {
      context.handle(
        _currentQuestionIndexMeta,
        currentQuestionIndex.isAcceptableOrUnknown(
          data['current_question_index']!,
          _currentQuestionIndexMeta,
        ),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('is_passed')) {
      context.handle(
        _isPassedMeta,
        isPassed.isAcceptableOrUnknown(data['is_passed']!, _isPassedMeta),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('submitted_at')) {
      context.handle(
        _submittedAtMeta,
        submittedAt.isAcceptableOrUnknown(
          data['submitted_at']!,
          _submittedAtMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('is_premium_timed')) {
      context.handle(
        _isPremiumTimedMeta,
        isPremiumTimed.isAcceptableOrUnknown(
          data['is_premium_timed']!,
          _isPremiumTimedMeta,
        ),
      );
    }
    if (data.containsKey('remaining_time_seconds')) {
      context.handle(
        _remainingTimeSecondsMeta,
        remainingTimeSeconds.isAcceptableOrUnknown(
          data['remaining_time_seconds']!,
          _remainingTimeSecondsMeta,
        ),
      );
    }
    if (data.containsKey('last_observed_at')) {
      context.handle(
        _lastObservedAtMeta,
        lastObservedAt.isAcceptableOrUnknown(
          data['last_observed_at']!,
          _lastObservedAtMeta,
        ),
      );
    }
    if (data.containsKey('backgrounded_at')) {
      context.handle(
        _backgroundedAtMeta,
        backgroundedAt.isAcceptableOrUnknown(
          data['backgrounded_at']!,
          _backgroundedAtMeta,
        ),
      );
    }
    if (data.containsKey('timer_locked')) {
      context.handle(
        _timerLockedMeta,
        timerLocked.isAcceptableOrUnknown(
          data['timer_locked']!,
          _timerLockedMeta,
        ),
      );
    }
    if (data.containsKey('time_taken_seconds')) {
      context.handle(
        _timeTakenSecondsMeta,
        timeTakenSeconds.isAcceptableOrUnknown(
          data['time_taken_seconds']!,
          _timeTakenSecondsMeta,
        ),
      );
    }
    if (data.containsKey('readiness_score')) {
      context.handle(
        _readinessScoreMeta,
        readinessScore.isAcceptableOrUnknown(
          data['readiness_score']!,
          _readinessScoreMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamAttempt map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamAttempt(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      configId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}config_id'],
      )!,
      selectedQuestionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}selected_questions_json'],
      )!,
      totalQuestions: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_questions'],
      )!,
      currentQuestionIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_question_index'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      ),
      isPassed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_passed'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      submittedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}submitted_at'],
      ),
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      isPremiumTimed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_premium_timed'],
      )!,
      remainingTimeSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}remaining_time_seconds'],
      ),
      lastObservedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_observed_at'],
      ),
      backgroundedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}backgrounded_at'],
      ),
      timerLocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}timer_locked'],
      )!,
      timeTakenSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}time_taken_seconds'],
      ),
      readinessScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}readiness_score'],
      ),
    );
  }

  @override
  $ExamAttemptsTable createAlias(String alias) {
    return $ExamAttemptsTable(attachedDatabase, alias);
  }
}

class ExamAttempt extends DataClass implements Insertable<ExamAttempt> {
  final int id;
  final int configId;
  final String selectedQuestionsJson;
  final int totalQuestions;
  final int currentQuestionIndex;
  final double? score;
  final bool? isPassed;
  final DateTime startedAt;
  final DateTime? submittedAt;
  final bool isCompleted;
  final bool isPremiumTimed;
  final int? remainingTimeSeconds;
  final DateTime? lastObservedAt;
  final DateTime? backgroundedAt;
  final bool timerLocked;
  final int? timeTakenSeconds;
  final double? readinessScore;
  const ExamAttempt({
    required this.id,
    required this.configId,
    required this.selectedQuestionsJson,
    required this.totalQuestions,
    required this.currentQuestionIndex,
    this.score,
    this.isPassed,
    required this.startedAt,
    this.submittedAt,
    required this.isCompleted,
    required this.isPremiumTimed,
    this.remainingTimeSeconds,
    this.lastObservedAt,
    this.backgroundedAt,
    required this.timerLocked,
    this.timeTakenSeconds,
    this.readinessScore,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['config_id'] = Variable<int>(configId);
    map['selected_questions_json'] = Variable<String>(selectedQuestionsJson);
    map['total_questions'] = Variable<int>(totalQuestions);
    map['current_question_index'] = Variable<int>(currentQuestionIndex);
    if (!nullToAbsent || score != null) {
      map['score'] = Variable<double>(score);
    }
    if (!nullToAbsent || isPassed != null) {
      map['is_passed'] = Variable<bool>(isPassed);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || submittedAt != null) {
      map['submitted_at'] = Variable<DateTime>(submittedAt);
    }
    map['is_completed'] = Variable<bool>(isCompleted);
    map['is_premium_timed'] = Variable<bool>(isPremiumTimed);
    if (!nullToAbsent || remainingTimeSeconds != null) {
      map['remaining_time_seconds'] = Variable<int>(remainingTimeSeconds);
    }
    if (!nullToAbsent || lastObservedAt != null) {
      map['last_observed_at'] = Variable<DateTime>(lastObservedAt);
    }
    if (!nullToAbsent || backgroundedAt != null) {
      map['backgrounded_at'] = Variable<DateTime>(backgroundedAt);
    }
    map['timer_locked'] = Variable<bool>(timerLocked);
    if (!nullToAbsent || timeTakenSeconds != null) {
      map['time_taken_seconds'] = Variable<int>(timeTakenSeconds);
    }
    if (!nullToAbsent || readinessScore != null) {
      map['readiness_score'] = Variable<double>(readinessScore);
    }
    return map;
  }

  ExamAttemptsCompanion toCompanion(bool nullToAbsent) {
    return ExamAttemptsCompanion(
      id: Value(id),
      configId: Value(configId),
      selectedQuestionsJson: Value(selectedQuestionsJson),
      totalQuestions: Value(totalQuestions),
      currentQuestionIndex: Value(currentQuestionIndex),
      score: score == null && nullToAbsent
          ? const Value.absent()
          : Value(score),
      isPassed: isPassed == null && nullToAbsent
          ? const Value.absent()
          : Value(isPassed),
      startedAt: Value(startedAt),
      submittedAt: submittedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(submittedAt),
      isCompleted: Value(isCompleted),
      isPremiumTimed: Value(isPremiumTimed),
      remainingTimeSeconds: remainingTimeSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(remainingTimeSeconds),
      lastObservedAt: lastObservedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastObservedAt),
      backgroundedAt: backgroundedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(backgroundedAt),
      timerLocked: Value(timerLocked),
      timeTakenSeconds: timeTakenSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(timeTakenSeconds),
      readinessScore: readinessScore == null && nullToAbsent
          ? const Value.absent()
          : Value(readinessScore),
    );
  }

  factory ExamAttempt.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamAttempt(
      id: serializer.fromJson<int>(json['id']),
      configId: serializer.fromJson<int>(json['configId']),
      selectedQuestionsJson: serializer.fromJson<String>(
        json['selectedQuestionsJson'],
      ),
      totalQuestions: serializer.fromJson<int>(json['totalQuestions']),
      currentQuestionIndex: serializer.fromJson<int>(
        json['currentQuestionIndex'],
      ),
      score: serializer.fromJson<double?>(json['score']),
      isPassed: serializer.fromJson<bool?>(json['isPassed']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      submittedAt: serializer.fromJson<DateTime?>(json['submittedAt']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      isPremiumTimed: serializer.fromJson<bool>(json['isPremiumTimed']),
      remainingTimeSeconds: serializer.fromJson<int?>(
        json['remainingTimeSeconds'],
      ),
      lastObservedAt: serializer.fromJson<DateTime?>(json['lastObservedAt']),
      backgroundedAt: serializer.fromJson<DateTime?>(json['backgroundedAt']),
      timerLocked: serializer.fromJson<bool>(json['timerLocked']),
      timeTakenSeconds: serializer.fromJson<int?>(json['timeTakenSeconds']),
      readinessScore: serializer.fromJson<double?>(json['readinessScore']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'configId': serializer.toJson<int>(configId),
      'selectedQuestionsJson': serializer.toJson<String>(selectedQuestionsJson),
      'totalQuestions': serializer.toJson<int>(totalQuestions),
      'currentQuestionIndex': serializer.toJson<int>(currentQuestionIndex),
      'score': serializer.toJson<double?>(score),
      'isPassed': serializer.toJson<bool?>(isPassed),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'submittedAt': serializer.toJson<DateTime?>(submittedAt),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'isPremiumTimed': serializer.toJson<bool>(isPremiumTimed),
      'remainingTimeSeconds': serializer.toJson<int?>(remainingTimeSeconds),
      'lastObservedAt': serializer.toJson<DateTime?>(lastObservedAt),
      'backgroundedAt': serializer.toJson<DateTime?>(backgroundedAt),
      'timerLocked': serializer.toJson<bool>(timerLocked),
      'timeTakenSeconds': serializer.toJson<int?>(timeTakenSeconds),
      'readinessScore': serializer.toJson<double?>(readinessScore),
    };
  }

  ExamAttempt copyWith({
    int? id,
    int? configId,
    String? selectedQuestionsJson,
    int? totalQuestions,
    int? currentQuestionIndex,
    Value<double?> score = const Value.absent(),
    Value<bool?> isPassed = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> submittedAt = const Value.absent(),
    bool? isCompleted,
    bool? isPremiumTimed,
    Value<int?> remainingTimeSeconds = const Value.absent(),
    Value<DateTime?> lastObservedAt = const Value.absent(),
    Value<DateTime?> backgroundedAt = const Value.absent(),
    bool? timerLocked,
    Value<int?> timeTakenSeconds = const Value.absent(),
    Value<double?> readinessScore = const Value.absent(),
  }) => ExamAttempt(
    id: id ?? this.id,
    configId: configId ?? this.configId,
    selectedQuestionsJson: selectedQuestionsJson ?? this.selectedQuestionsJson,
    totalQuestions: totalQuestions ?? this.totalQuestions,
    currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
    score: score.present ? score.value : this.score,
    isPassed: isPassed.present ? isPassed.value : this.isPassed,
    startedAt: startedAt ?? this.startedAt,
    submittedAt: submittedAt.present ? submittedAt.value : this.submittedAt,
    isCompleted: isCompleted ?? this.isCompleted,
    isPremiumTimed: isPremiumTimed ?? this.isPremiumTimed,
    remainingTimeSeconds: remainingTimeSeconds.present
        ? remainingTimeSeconds.value
        : this.remainingTimeSeconds,
    lastObservedAt: lastObservedAt.present
        ? lastObservedAt.value
        : this.lastObservedAt,
    backgroundedAt: backgroundedAt.present
        ? backgroundedAt.value
        : this.backgroundedAt,
    timerLocked: timerLocked ?? this.timerLocked,
    timeTakenSeconds: timeTakenSeconds.present
        ? timeTakenSeconds.value
        : this.timeTakenSeconds,
    readinessScore: readinessScore.present
        ? readinessScore.value
        : this.readinessScore,
  );
  ExamAttempt copyWithCompanion(ExamAttemptsCompanion data) {
    return ExamAttempt(
      id: data.id.present ? data.id.value : this.id,
      configId: data.configId.present ? data.configId.value : this.configId,
      selectedQuestionsJson: data.selectedQuestionsJson.present
          ? data.selectedQuestionsJson.value
          : this.selectedQuestionsJson,
      totalQuestions: data.totalQuestions.present
          ? data.totalQuestions.value
          : this.totalQuestions,
      currentQuestionIndex: data.currentQuestionIndex.present
          ? data.currentQuestionIndex.value
          : this.currentQuestionIndex,
      score: data.score.present ? data.score.value : this.score,
      isPassed: data.isPassed.present ? data.isPassed.value : this.isPassed,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      submittedAt: data.submittedAt.present
          ? data.submittedAt.value
          : this.submittedAt,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      isPremiumTimed: data.isPremiumTimed.present
          ? data.isPremiumTimed.value
          : this.isPremiumTimed,
      remainingTimeSeconds: data.remainingTimeSeconds.present
          ? data.remainingTimeSeconds.value
          : this.remainingTimeSeconds,
      lastObservedAt: data.lastObservedAt.present
          ? data.lastObservedAt.value
          : this.lastObservedAt,
      backgroundedAt: data.backgroundedAt.present
          ? data.backgroundedAt.value
          : this.backgroundedAt,
      timerLocked: data.timerLocked.present
          ? data.timerLocked.value
          : this.timerLocked,
      timeTakenSeconds: data.timeTakenSeconds.present
          ? data.timeTakenSeconds.value
          : this.timeTakenSeconds,
      readinessScore: data.readinessScore.present
          ? data.readinessScore.value
          : this.readinessScore,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamAttempt(')
          ..write('id: $id, ')
          ..write('configId: $configId, ')
          ..write('selectedQuestionsJson: $selectedQuestionsJson, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('currentQuestionIndex: $currentQuestionIndex, ')
          ..write('score: $score, ')
          ..write('isPassed: $isPassed, ')
          ..write('startedAt: $startedAt, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isPremiumTimed: $isPremiumTimed, ')
          ..write('remainingTimeSeconds: $remainingTimeSeconds, ')
          ..write('lastObservedAt: $lastObservedAt, ')
          ..write('backgroundedAt: $backgroundedAt, ')
          ..write('timerLocked: $timerLocked, ')
          ..write('timeTakenSeconds: $timeTakenSeconds, ')
          ..write('readinessScore: $readinessScore')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    configId,
    selectedQuestionsJson,
    totalQuestions,
    currentQuestionIndex,
    score,
    isPassed,
    startedAt,
    submittedAt,
    isCompleted,
    isPremiumTimed,
    remainingTimeSeconds,
    lastObservedAt,
    backgroundedAt,
    timerLocked,
    timeTakenSeconds,
    readinessScore,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamAttempt &&
          other.id == this.id &&
          other.configId == this.configId &&
          other.selectedQuestionsJson == this.selectedQuestionsJson &&
          other.totalQuestions == this.totalQuestions &&
          other.currentQuestionIndex == this.currentQuestionIndex &&
          other.score == this.score &&
          other.isPassed == this.isPassed &&
          other.startedAt == this.startedAt &&
          other.submittedAt == this.submittedAt &&
          other.isCompleted == this.isCompleted &&
          other.isPremiumTimed == this.isPremiumTimed &&
          other.remainingTimeSeconds == this.remainingTimeSeconds &&
          other.lastObservedAt == this.lastObservedAt &&
          other.backgroundedAt == this.backgroundedAt &&
          other.timerLocked == this.timerLocked &&
          other.timeTakenSeconds == this.timeTakenSeconds &&
          other.readinessScore == this.readinessScore);
}

class ExamAttemptsCompanion extends UpdateCompanion<ExamAttempt> {
  final Value<int> id;
  final Value<int> configId;
  final Value<String> selectedQuestionsJson;
  final Value<int> totalQuestions;
  final Value<int> currentQuestionIndex;
  final Value<double?> score;
  final Value<bool?> isPassed;
  final Value<DateTime> startedAt;
  final Value<DateTime?> submittedAt;
  final Value<bool> isCompleted;
  final Value<bool> isPremiumTimed;
  final Value<int?> remainingTimeSeconds;
  final Value<DateTime?> lastObservedAt;
  final Value<DateTime?> backgroundedAt;
  final Value<bool> timerLocked;
  final Value<int?> timeTakenSeconds;
  final Value<double?> readinessScore;
  const ExamAttemptsCompanion({
    this.id = const Value.absent(),
    this.configId = const Value.absent(),
    this.selectedQuestionsJson = const Value.absent(),
    this.totalQuestions = const Value.absent(),
    this.currentQuestionIndex = const Value.absent(),
    this.score = const Value.absent(),
    this.isPassed = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.submittedAt = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isPremiumTimed = const Value.absent(),
    this.remainingTimeSeconds = const Value.absent(),
    this.lastObservedAt = const Value.absent(),
    this.backgroundedAt = const Value.absent(),
    this.timerLocked = const Value.absent(),
    this.timeTakenSeconds = const Value.absent(),
    this.readinessScore = const Value.absent(),
  });
  ExamAttemptsCompanion.insert({
    this.id = const Value.absent(),
    required int configId,
    required String selectedQuestionsJson,
    required int totalQuestions,
    this.currentQuestionIndex = const Value.absent(),
    this.score = const Value.absent(),
    this.isPassed = const Value.absent(),
    required DateTime startedAt,
    this.submittedAt = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.isPremiumTimed = const Value.absent(),
    this.remainingTimeSeconds = const Value.absent(),
    this.lastObservedAt = const Value.absent(),
    this.backgroundedAt = const Value.absent(),
    this.timerLocked = const Value.absent(),
    this.timeTakenSeconds = const Value.absent(),
    this.readinessScore = const Value.absent(),
  }) : configId = Value(configId),
       selectedQuestionsJson = Value(selectedQuestionsJson),
       totalQuestions = Value(totalQuestions),
       startedAt = Value(startedAt);
  static Insertable<ExamAttempt> custom({
    Expression<int>? id,
    Expression<int>? configId,
    Expression<String>? selectedQuestionsJson,
    Expression<int>? totalQuestions,
    Expression<int>? currentQuestionIndex,
    Expression<double>? score,
    Expression<bool>? isPassed,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? submittedAt,
    Expression<bool>? isCompleted,
    Expression<bool>? isPremiumTimed,
    Expression<int>? remainingTimeSeconds,
    Expression<DateTime>? lastObservedAt,
    Expression<DateTime>? backgroundedAt,
    Expression<bool>? timerLocked,
    Expression<int>? timeTakenSeconds,
    Expression<double>? readinessScore,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (configId != null) 'config_id': configId,
      if (selectedQuestionsJson != null)
        'selected_questions_json': selectedQuestionsJson,
      if (totalQuestions != null) 'total_questions': totalQuestions,
      if (currentQuestionIndex != null)
        'current_question_index': currentQuestionIndex,
      if (score != null) 'score': score,
      if (isPassed != null) 'is_passed': isPassed,
      if (startedAt != null) 'started_at': startedAt,
      if (submittedAt != null) 'submitted_at': submittedAt,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (isPremiumTimed != null) 'is_premium_timed': isPremiumTimed,
      if (remainingTimeSeconds != null)
        'remaining_time_seconds': remainingTimeSeconds,
      if (lastObservedAt != null) 'last_observed_at': lastObservedAt,
      if (backgroundedAt != null) 'backgrounded_at': backgroundedAt,
      if (timerLocked != null) 'timer_locked': timerLocked,
      if (timeTakenSeconds != null) 'time_taken_seconds': timeTakenSeconds,
      if (readinessScore != null) 'readiness_score': readinessScore,
    });
  }

  ExamAttemptsCompanion copyWith({
    Value<int>? id,
    Value<int>? configId,
    Value<String>? selectedQuestionsJson,
    Value<int>? totalQuestions,
    Value<int>? currentQuestionIndex,
    Value<double?>? score,
    Value<bool?>? isPassed,
    Value<DateTime>? startedAt,
    Value<DateTime?>? submittedAt,
    Value<bool>? isCompleted,
    Value<bool>? isPremiumTimed,
    Value<int?>? remainingTimeSeconds,
    Value<DateTime?>? lastObservedAt,
    Value<DateTime?>? backgroundedAt,
    Value<bool>? timerLocked,
    Value<int?>? timeTakenSeconds,
    Value<double?>? readinessScore,
  }) {
    return ExamAttemptsCompanion(
      id: id ?? this.id,
      configId: configId ?? this.configId,
      selectedQuestionsJson:
          selectedQuestionsJson ?? this.selectedQuestionsJson,
      totalQuestions: totalQuestions ?? this.totalQuestions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      score: score ?? this.score,
      isPassed: isPassed ?? this.isPassed,
      startedAt: startedAt ?? this.startedAt,
      submittedAt: submittedAt ?? this.submittedAt,
      isCompleted: isCompleted ?? this.isCompleted,
      isPremiumTimed: isPremiumTimed ?? this.isPremiumTimed,
      remainingTimeSeconds: remainingTimeSeconds ?? this.remainingTimeSeconds,
      lastObservedAt: lastObservedAt ?? this.lastObservedAt,
      backgroundedAt: backgroundedAt ?? this.backgroundedAt,
      timerLocked: timerLocked ?? this.timerLocked,
      timeTakenSeconds: timeTakenSeconds ?? this.timeTakenSeconds,
      readinessScore: readinessScore ?? this.readinessScore,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (configId.present) {
      map['config_id'] = Variable<int>(configId.value);
    }
    if (selectedQuestionsJson.present) {
      map['selected_questions_json'] = Variable<String>(
        selectedQuestionsJson.value,
      );
    }
    if (totalQuestions.present) {
      map['total_questions'] = Variable<int>(totalQuestions.value);
    }
    if (currentQuestionIndex.present) {
      map['current_question_index'] = Variable<int>(currentQuestionIndex.value);
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (isPassed.present) {
      map['is_passed'] = Variable<bool>(isPassed.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (submittedAt.present) {
      map['submitted_at'] = Variable<DateTime>(submittedAt.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (isPremiumTimed.present) {
      map['is_premium_timed'] = Variable<bool>(isPremiumTimed.value);
    }
    if (remainingTimeSeconds.present) {
      map['remaining_time_seconds'] = Variable<int>(remainingTimeSeconds.value);
    }
    if (lastObservedAt.present) {
      map['last_observed_at'] = Variable<DateTime>(lastObservedAt.value);
    }
    if (backgroundedAt.present) {
      map['backgrounded_at'] = Variable<DateTime>(backgroundedAt.value);
    }
    if (timerLocked.present) {
      map['timer_locked'] = Variable<bool>(timerLocked.value);
    }
    if (timeTakenSeconds.present) {
      map['time_taken_seconds'] = Variable<int>(timeTakenSeconds.value);
    }
    if (readinessScore.present) {
      map['readiness_score'] = Variable<double>(readinessScore.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamAttemptsCompanion(')
          ..write('id: $id, ')
          ..write('configId: $configId, ')
          ..write('selectedQuestionsJson: $selectedQuestionsJson, ')
          ..write('totalQuestions: $totalQuestions, ')
          ..write('currentQuestionIndex: $currentQuestionIndex, ')
          ..write('score: $score, ')
          ..write('isPassed: $isPassed, ')
          ..write('startedAt: $startedAt, ')
          ..write('submittedAt: $submittedAt, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('isPremiumTimed: $isPremiumTimed, ')
          ..write('remainingTimeSeconds: $remainingTimeSeconds, ')
          ..write('lastObservedAt: $lastObservedAt, ')
          ..write('backgroundedAt: $backgroundedAt, ')
          ..write('timerLocked: $timerLocked, ')
          ..write('timeTakenSeconds: $timeTakenSeconds, ')
          ..write('readinessScore: $readinessScore')
          ..write(')'))
        .toString();
  }
}

class $ExamAttemptAnswersTable extends ExamAttemptAnswers
    with TableInfo<$ExamAttemptAnswersTable, ExamAttemptAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExamAttemptAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _examAttemptIdMeta = const VerificationMeta(
    'examAttemptId',
  );
  @override
  late final GeneratedColumn<int> examAttemptId = GeneratedColumn<int>(
    'exam_attempt_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _questionOrderMeta = const VerificationMeta(
    'questionOrder',
  );
  @override
  late final GeneratedColumn<int> questionOrder = GeneratedColumn<int>(
    'question_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _selectedIndexMeta = const VerificationMeta(
    'selectedIndex',
  );
  @override
  late final GeneratedColumn<int> selectedIndex = GeneratedColumn<int>(
    'selected_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCorrectMeta = const VerificationMeta(
    'isCorrect',
  );
  @override
  late final GeneratedColumn<bool> isCorrect = GeneratedColumn<bool>(
    'is_correct',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _answeredAtMeta = const VerificationMeta(
    'answeredAt',
  );
  @override
  late final GeneratedColumn<DateTime> answeredAt = GeneratedColumn<DateTime>(
    'answered_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    examAttemptId,
    questionId,
    questionOrder,
    selectedIndex,
    isCorrect,
    answeredAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'exam_attempt_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExamAttemptAnswer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('exam_attempt_id')) {
      context.handle(
        _examAttemptIdMeta,
        examAttemptId.isAcceptableOrUnknown(
          data['exam_attempt_id']!,
          _examAttemptIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_examAttemptIdMeta);
    }
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('question_order')) {
      context.handle(
        _questionOrderMeta,
        questionOrder.isAcceptableOrUnknown(
          data['question_order']!,
          _questionOrderMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_questionOrderMeta);
    }
    if (data.containsKey('selected_index')) {
      context.handle(
        _selectedIndexMeta,
        selectedIndex.isAcceptableOrUnknown(
          data['selected_index']!,
          _selectedIndexMeta,
        ),
      );
    }
    if (data.containsKey('is_correct')) {
      context.handle(
        _isCorrectMeta,
        isCorrect.isAcceptableOrUnknown(data['is_correct']!, _isCorrectMeta),
      );
    }
    if (data.containsKey('answered_at')) {
      context.handle(
        _answeredAtMeta,
        answeredAt.isAcceptableOrUnknown(data['answered_at']!, _answeredAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExamAttemptAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExamAttemptAnswer(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      examAttemptId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}exam_attempt_id'],
      )!,
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      questionOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}question_order'],
      )!,
      selectedIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}selected_index'],
      ),
      isCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_correct'],
      ),
      answeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}answered_at'],
      ),
    );
  }

  @override
  $ExamAttemptAnswersTable createAlias(String alias) {
    return $ExamAttemptAnswersTable(attachedDatabase, alias);
  }
}

class ExamAttemptAnswer extends DataClass
    implements Insertable<ExamAttemptAnswer> {
  final int id;
  final int examAttemptId;
  final String questionId;
  final int questionOrder;
  final int? selectedIndex;
  final bool? isCorrect;
  final DateTime? answeredAt;
  const ExamAttemptAnswer({
    required this.id,
    required this.examAttemptId,
    required this.questionId,
    required this.questionOrder,
    this.selectedIndex,
    this.isCorrect,
    this.answeredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['exam_attempt_id'] = Variable<int>(examAttemptId);
    map['question_id'] = Variable<String>(questionId);
    map['question_order'] = Variable<int>(questionOrder);
    if (!nullToAbsent || selectedIndex != null) {
      map['selected_index'] = Variable<int>(selectedIndex);
    }
    if (!nullToAbsent || isCorrect != null) {
      map['is_correct'] = Variable<bool>(isCorrect);
    }
    if (!nullToAbsent || answeredAt != null) {
      map['answered_at'] = Variable<DateTime>(answeredAt);
    }
    return map;
  }

  ExamAttemptAnswersCompanion toCompanion(bool nullToAbsent) {
    return ExamAttemptAnswersCompanion(
      id: Value(id),
      examAttemptId: Value(examAttemptId),
      questionId: Value(questionId),
      questionOrder: Value(questionOrder),
      selectedIndex: selectedIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(selectedIndex),
      isCorrect: isCorrect == null && nullToAbsent
          ? const Value.absent()
          : Value(isCorrect),
      answeredAt: answeredAt == null && nullToAbsent
          ? const Value.absent()
          : Value(answeredAt),
    );
  }

  factory ExamAttemptAnswer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExamAttemptAnswer(
      id: serializer.fromJson<int>(json['id']),
      examAttemptId: serializer.fromJson<int>(json['examAttemptId']),
      questionId: serializer.fromJson<String>(json['questionId']),
      questionOrder: serializer.fromJson<int>(json['questionOrder']),
      selectedIndex: serializer.fromJson<int?>(json['selectedIndex']),
      isCorrect: serializer.fromJson<bool?>(json['isCorrect']),
      answeredAt: serializer.fromJson<DateTime?>(json['answeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'examAttemptId': serializer.toJson<int>(examAttemptId),
      'questionId': serializer.toJson<String>(questionId),
      'questionOrder': serializer.toJson<int>(questionOrder),
      'selectedIndex': serializer.toJson<int?>(selectedIndex),
      'isCorrect': serializer.toJson<bool?>(isCorrect),
      'answeredAt': serializer.toJson<DateTime?>(answeredAt),
    };
  }

  ExamAttemptAnswer copyWith({
    int? id,
    int? examAttemptId,
    String? questionId,
    int? questionOrder,
    Value<int?> selectedIndex = const Value.absent(),
    Value<bool?> isCorrect = const Value.absent(),
    Value<DateTime?> answeredAt = const Value.absent(),
  }) => ExamAttemptAnswer(
    id: id ?? this.id,
    examAttemptId: examAttemptId ?? this.examAttemptId,
    questionId: questionId ?? this.questionId,
    questionOrder: questionOrder ?? this.questionOrder,
    selectedIndex: selectedIndex.present
        ? selectedIndex.value
        : this.selectedIndex,
    isCorrect: isCorrect.present ? isCorrect.value : this.isCorrect,
    answeredAt: answeredAt.present ? answeredAt.value : this.answeredAt,
  );
  ExamAttemptAnswer copyWithCompanion(ExamAttemptAnswersCompanion data) {
    return ExamAttemptAnswer(
      id: data.id.present ? data.id.value : this.id,
      examAttemptId: data.examAttemptId.present
          ? data.examAttemptId.value
          : this.examAttemptId,
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      questionOrder: data.questionOrder.present
          ? data.questionOrder.value
          : this.questionOrder,
      selectedIndex: data.selectedIndex.present
          ? data.selectedIndex.value
          : this.selectedIndex,
      isCorrect: data.isCorrect.present ? data.isCorrect.value : this.isCorrect,
      answeredAt: data.answeredAt.present
          ? data.answeredAt.value
          : this.answeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExamAttemptAnswer(')
          ..write('id: $id, ')
          ..write('examAttemptId: $examAttemptId, ')
          ..write('questionId: $questionId, ')
          ..write('questionOrder: $questionOrder, ')
          ..write('selectedIndex: $selectedIndex, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    examAttemptId,
    questionId,
    questionOrder,
    selectedIndex,
    isCorrect,
    answeredAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExamAttemptAnswer &&
          other.id == this.id &&
          other.examAttemptId == this.examAttemptId &&
          other.questionId == this.questionId &&
          other.questionOrder == this.questionOrder &&
          other.selectedIndex == this.selectedIndex &&
          other.isCorrect == this.isCorrect &&
          other.answeredAt == this.answeredAt);
}

class ExamAttemptAnswersCompanion extends UpdateCompanion<ExamAttemptAnswer> {
  final Value<int> id;
  final Value<int> examAttemptId;
  final Value<String> questionId;
  final Value<int> questionOrder;
  final Value<int?> selectedIndex;
  final Value<bool?> isCorrect;
  final Value<DateTime?> answeredAt;
  const ExamAttemptAnswersCompanion({
    this.id = const Value.absent(),
    this.examAttemptId = const Value.absent(),
    this.questionId = const Value.absent(),
    this.questionOrder = const Value.absent(),
    this.selectedIndex = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.answeredAt = const Value.absent(),
  });
  ExamAttemptAnswersCompanion.insert({
    this.id = const Value.absent(),
    required int examAttemptId,
    required String questionId,
    required int questionOrder,
    this.selectedIndex = const Value.absent(),
    this.isCorrect = const Value.absent(),
    this.answeredAt = const Value.absent(),
  }) : examAttemptId = Value(examAttemptId),
       questionId = Value(questionId),
       questionOrder = Value(questionOrder);
  static Insertable<ExamAttemptAnswer> custom({
    Expression<int>? id,
    Expression<int>? examAttemptId,
    Expression<String>? questionId,
    Expression<int>? questionOrder,
    Expression<int>? selectedIndex,
    Expression<bool>? isCorrect,
    Expression<DateTime>? answeredAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (examAttemptId != null) 'exam_attempt_id': examAttemptId,
      if (questionId != null) 'question_id': questionId,
      if (questionOrder != null) 'question_order': questionOrder,
      if (selectedIndex != null) 'selected_index': selectedIndex,
      if (isCorrect != null) 'is_correct': isCorrect,
      if (answeredAt != null) 'answered_at': answeredAt,
    });
  }

  ExamAttemptAnswersCompanion copyWith({
    Value<int>? id,
    Value<int>? examAttemptId,
    Value<String>? questionId,
    Value<int>? questionOrder,
    Value<int?>? selectedIndex,
    Value<bool?>? isCorrect,
    Value<DateTime?>? answeredAt,
  }) {
    return ExamAttemptAnswersCompanion(
      id: id ?? this.id,
      examAttemptId: examAttemptId ?? this.examAttemptId,
      questionId: questionId ?? this.questionId,
      questionOrder: questionOrder ?? this.questionOrder,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isCorrect: isCorrect ?? this.isCorrect,
      answeredAt: answeredAt ?? this.answeredAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (examAttemptId.present) {
      map['exam_attempt_id'] = Variable<int>(examAttemptId.value);
    }
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (questionOrder.present) {
      map['question_order'] = Variable<int>(questionOrder.value);
    }
    if (selectedIndex.present) {
      map['selected_index'] = Variable<int>(selectedIndex.value);
    }
    if (isCorrect.present) {
      map['is_correct'] = Variable<bool>(isCorrect.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<DateTime>(answeredAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExamAttemptAnswersCompanion(')
          ..write('id: $id, ')
          ..write('examAttemptId: $examAttemptId, ')
          ..write('questionId: $questionId, ')
          ..write('questionOrder: $questionOrder, ')
          ..write('selectedIndex: $selectedIndex, ')
          ..write('isCorrect: $isCorrect, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $StudyQuestionsTable studyQuestions = $StudyQuestionsTable(this);
  late final $QuestionAttemptsTable questionAttempts = $QuestionAttemptsTable(
    this,
  );
  late final $StarredQuestionsTable starredQuestions = $StarredQuestionsTable(
    this,
  );
  late final $PracticeSessionsTable practiceSessions = $PracticeSessionsTable(
    this,
  );
  late final $ExamConfigurationsTable examConfigurations =
      $ExamConfigurationsTable(this);
  late final $ExamAttemptsTable examAttempts = $ExamAttemptsTable(this);
  late final $ExamAttemptAnswersTable examAttemptAnswers =
      $ExamAttemptAnswersTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    studyQuestions,
    questionAttempts,
    starredQuestions,
    practiceSessions,
    examConfigurations,
    examAttempts,
    examAttemptAnswers,
    appSettings,
  ];
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> rowid,
    });

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          Category,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
          Category,
          PrefetchHooks Function()
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(id: id, name: name, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) =>
                  CategoriesCompanion.insert(id: id, name: name, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      Category,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (Category, BaseReferences<_$AppDatabase, $CategoriesTable, Category>),
      Category,
      PrefetchHooks Function()
    >;
typedef $$StudyQuestionsTableCreateCompanionBuilder =
    StudyQuestionsCompanion Function({
      required String id,
      required String categoryId,
      required String questionText,
      required String optionsJson,
      required int correctIndex,
      required String explanation,
      Value<int> rowid,
    });
typedef $$StudyQuestionsTableUpdateCompanionBuilder =
    StudyQuestionsCompanion Function({
      Value<String> id,
      Value<String> categoryId,
      Value<String> questionText,
      Value<String> optionsJson,
      Value<int> correctIndex,
      Value<String> explanation,
      Value<int> rowid,
    });

class $$StudyQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyQuestionsTable> {
  $$StudyQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudyQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyQuestionsTable> {
  $$StudyQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudyQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyQuestionsTable> {
  $$StudyQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionText => $composableBuilder(
    column: $table.questionText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get optionsJson => $composableBuilder(
    column: $table.optionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctIndex => $composableBuilder(
    column: $table.correctIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get explanation => $composableBuilder(
    column: $table.explanation,
    builder: (column) => column,
  );
}

class $$StudyQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyQuestionsTable,
          StudyQuestion,
          $$StudyQuestionsTableFilterComposer,
          $$StudyQuestionsTableOrderingComposer,
          $$StudyQuestionsTableAnnotationComposer,
          $$StudyQuestionsTableCreateCompanionBuilder,
          $$StudyQuestionsTableUpdateCompanionBuilder,
          (
            StudyQuestion,
            BaseReferences<_$AppDatabase, $StudyQuestionsTable, StudyQuestion>,
          ),
          StudyQuestion,
          PrefetchHooks Function()
        > {
  $$StudyQuestionsTableTableManager(
    _$AppDatabase db,
    $StudyQuestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> questionText = const Value.absent(),
                Value<String> optionsJson = const Value.absent(),
                Value<int> correctIndex = const Value.absent(),
                Value<String> explanation = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyQuestionsCompanion(
                id: id,
                categoryId: categoryId,
                questionText: questionText,
                optionsJson: optionsJson,
                correctIndex: correctIndex,
                explanation: explanation,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String categoryId,
                required String questionText,
                required String optionsJson,
                required int correctIndex,
                required String explanation,
                Value<int> rowid = const Value.absent(),
              }) => StudyQuestionsCompanion.insert(
                id: id,
                categoryId: categoryId,
                questionText: questionText,
                optionsJson: optionsJson,
                correctIndex: correctIndex,
                explanation: explanation,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudyQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyQuestionsTable,
      StudyQuestion,
      $$StudyQuestionsTableFilterComposer,
      $$StudyQuestionsTableOrderingComposer,
      $$StudyQuestionsTableAnnotationComposer,
      $$StudyQuestionsTableCreateCompanionBuilder,
      $$StudyQuestionsTableUpdateCompanionBuilder,
      (
        StudyQuestion,
        BaseReferences<_$AppDatabase, $StudyQuestionsTable, StudyQuestion>,
      ),
      StudyQuestion,
      PrefetchHooks Function()
    >;
typedef $$QuestionAttemptsTableCreateCompanionBuilder =
    QuestionAttemptsCompanion Function({
      Value<int> id,
      required String questionId,
      required int selectedIndex,
      required bool isCorrect,
      required DateTime attemptedAt,
    });
typedef $$QuestionAttemptsTableUpdateCompanionBuilder =
    QuestionAttemptsCompanion Function({
      Value<int> id,
      Value<String> questionId,
      Value<int> selectedIndex,
      Value<bool> isCorrect,
      Value<DateTime> attemptedAt,
    });

class $$QuestionAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $QuestionAttemptsTable> {
  $$QuestionAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$QuestionAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $QuestionAttemptsTable> {
  $$QuestionAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$QuestionAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $QuestionAttemptsTable> {
  $$QuestionAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<DateTime> get attemptedAt => $composableBuilder(
    column: $table.attemptedAt,
    builder: (column) => column,
  );
}

class $$QuestionAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $QuestionAttemptsTable,
          QuestionAttempt,
          $$QuestionAttemptsTableFilterComposer,
          $$QuestionAttemptsTableOrderingComposer,
          $$QuestionAttemptsTableAnnotationComposer,
          $$QuestionAttemptsTableCreateCompanionBuilder,
          $$QuestionAttemptsTableUpdateCompanionBuilder,
          (
            QuestionAttempt,
            BaseReferences<
              _$AppDatabase,
              $QuestionAttemptsTable,
              QuestionAttempt
            >,
          ),
          QuestionAttempt,
          PrefetchHooks Function()
        > {
  $$QuestionAttemptsTableTableManager(
    _$AppDatabase db,
    $QuestionAttemptsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$QuestionAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$QuestionAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$QuestionAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<int> selectedIndex = const Value.absent(),
                Value<bool> isCorrect = const Value.absent(),
                Value<DateTime> attemptedAt = const Value.absent(),
              }) => QuestionAttemptsCompanion(
                id: id,
                questionId: questionId,
                selectedIndex: selectedIndex,
                isCorrect: isCorrect,
                attemptedAt: attemptedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String questionId,
                required int selectedIndex,
                required bool isCorrect,
                required DateTime attemptedAt,
              }) => QuestionAttemptsCompanion.insert(
                id: id,
                questionId: questionId,
                selectedIndex: selectedIndex,
                isCorrect: isCorrect,
                attemptedAt: attemptedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$QuestionAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $QuestionAttemptsTable,
      QuestionAttempt,
      $$QuestionAttemptsTableFilterComposer,
      $$QuestionAttemptsTableOrderingComposer,
      $$QuestionAttemptsTableAnnotationComposer,
      $$QuestionAttemptsTableCreateCompanionBuilder,
      $$QuestionAttemptsTableUpdateCompanionBuilder,
      (
        QuestionAttempt,
        BaseReferences<_$AppDatabase, $QuestionAttemptsTable, QuestionAttempt>,
      ),
      QuestionAttempt,
      PrefetchHooks Function()
    >;
typedef $$StarredQuestionsTableCreateCompanionBuilder =
    StarredQuestionsCompanion Function({
      required String questionId,
      required DateTime starredAt,
      Value<int> rowid,
    });
typedef $$StarredQuestionsTableUpdateCompanionBuilder =
    StarredQuestionsCompanion Function({
      Value<String> questionId,
      Value<DateTime> starredAt,
      Value<int> rowid,
    });

class $$StarredQuestionsTableFilterComposer
    extends Composer<_$AppDatabase, $StarredQuestionsTable> {
  $$StarredQuestionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get starredAt => $composableBuilder(
    column: $table.starredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StarredQuestionsTableOrderingComposer
    extends Composer<_$AppDatabase, $StarredQuestionsTable> {
  $$StarredQuestionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get starredAt => $composableBuilder(
    column: $table.starredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StarredQuestionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StarredQuestionsTable> {
  $$StarredQuestionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get starredAt =>
      $composableBuilder(column: $table.starredAt, builder: (column) => column);
}

class $$StarredQuestionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StarredQuestionsTable,
          StarredQuestion,
          $$StarredQuestionsTableFilterComposer,
          $$StarredQuestionsTableOrderingComposer,
          $$StarredQuestionsTableAnnotationComposer,
          $$StarredQuestionsTableCreateCompanionBuilder,
          $$StarredQuestionsTableUpdateCompanionBuilder,
          (
            StarredQuestion,
            BaseReferences<
              _$AppDatabase,
              $StarredQuestionsTable,
              StarredQuestion
            >,
          ),
          StarredQuestion,
          PrefetchHooks Function()
        > {
  $$StarredQuestionsTableTableManager(
    _$AppDatabase db,
    $StarredQuestionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StarredQuestionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StarredQuestionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StarredQuestionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> questionId = const Value.absent(),
                Value<DateTime> starredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StarredQuestionsCompanion(
                questionId: questionId,
                starredAt: starredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String questionId,
                required DateTime starredAt,
                Value<int> rowid = const Value.absent(),
              }) => StarredQuestionsCompanion.insert(
                questionId: questionId,
                starredAt: starredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StarredQuestionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StarredQuestionsTable,
      StarredQuestion,
      $$StarredQuestionsTableFilterComposer,
      $$StarredQuestionsTableOrderingComposer,
      $$StarredQuestionsTableAnnotationComposer,
      $$StarredQuestionsTableCreateCompanionBuilder,
      $$StarredQuestionsTableUpdateCompanionBuilder,
      (
        StarredQuestion,
        BaseReferences<_$AppDatabase, $StarredQuestionsTable, StarredQuestion>,
      ),
      StarredQuestion,
      PrefetchHooks Function()
    >;
typedef $$PracticeSessionsTableCreateCompanionBuilder =
    PracticeSessionsCompanion Function({
      Value<int> id,
      Value<String?> categoryId,
      required String questionIdsJson,
      Value<int> currentIndex,
      Value<int> correctCount,
      Value<bool> isComplete,
      required DateTime updatedAt,
    });
typedef $$PracticeSessionsTableUpdateCompanionBuilder =
    PracticeSessionsCompanion Function({
      Value<int> id,
      Value<String?> categoryId,
      Value<String> questionIdsJson,
      Value<int> currentIndex,
      Value<int> correctCount,
      Value<bool> isComplete,
      Value<DateTime> updatedAt,
    });

class $$PracticeSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTable> {
  $$PracticeSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionIdsJson => $composableBuilder(
    column: $table.questionIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PracticeSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTable> {
  $$PracticeSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionIdsJson => $composableBuilder(
    column: $table.questionIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PracticeSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PracticeSessionsTable> {
  $$PracticeSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryId => $composableBuilder(
    column: $table.categoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionIdsJson => $composableBuilder(
    column: $table.questionIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentIndex => $composableBuilder(
    column: $table.currentIndex,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isComplete => $composableBuilder(
    column: $table.isComplete,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PracticeSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PracticeSessionsTable,
          PracticeSession,
          $$PracticeSessionsTableFilterComposer,
          $$PracticeSessionsTableOrderingComposer,
          $$PracticeSessionsTableAnnotationComposer,
          $$PracticeSessionsTableCreateCompanionBuilder,
          $$PracticeSessionsTableUpdateCompanionBuilder,
          (
            PracticeSession,
            BaseReferences<
              _$AppDatabase,
              $PracticeSessionsTable,
              PracticeSession
            >,
          ),
          PracticeSession,
          PrefetchHooks Function()
        > {
  $$PracticeSessionsTableTableManager(
    _$AppDatabase db,
    $PracticeSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PracticeSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PracticeSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PracticeSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> questionIdsJson = const Value.absent(),
                Value<int> currentIndex = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<bool> isComplete = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PracticeSessionsCompanion(
                id: id,
                categoryId: categoryId,
                questionIdsJson: questionIdsJson,
                currentIndex: currentIndex,
                correctCount: correctCount,
                isComplete: isComplete,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                required String questionIdsJson,
                Value<int> currentIndex = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<bool> isComplete = const Value.absent(),
                required DateTime updatedAt,
              }) => PracticeSessionsCompanion.insert(
                id: id,
                categoryId: categoryId,
                questionIdsJson: questionIdsJson,
                currentIndex: currentIndex,
                correctCount: correctCount,
                isComplete: isComplete,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PracticeSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PracticeSessionsTable,
      PracticeSession,
      $$PracticeSessionsTableFilterComposer,
      $$PracticeSessionsTableOrderingComposer,
      $$PracticeSessionsTableAnnotationComposer,
      $$PracticeSessionsTableCreateCompanionBuilder,
      $$PracticeSessionsTableUpdateCompanionBuilder,
      (
        PracticeSession,
        BaseReferences<_$AppDatabase, $PracticeSessionsTable, PracticeSession>,
      ),
      PracticeSession,
      PrefetchHooks Function()
    >;
typedef $$ExamConfigurationsTableCreateCompanionBuilder =
    ExamConfigurationsCompanion Function({
      Value<int> id,
      required String examName,
      required int questionCount,
      required int durationMinutes,
      required double passPercentage,
      required int version,
      Value<bool> isActive,
    });
typedef $$ExamConfigurationsTableUpdateCompanionBuilder =
    ExamConfigurationsCompanion Function({
      Value<int> id,
      Value<String> examName,
      Value<int> questionCount,
      Value<int> durationMinutes,
      Value<double> passPercentage,
      Value<int> version,
      Value<bool> isActive,
    });

class $$ExamConfigurationsTableFilterComposer
    extends Composer<_$AppDatabase, $ExamConfigurationsTable> {
  $$ExamConfigurationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examName => $composableBuilder(
    column: $table.examName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get passPercentage => $composableBuilder(
    column: $table.passPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExamConfigurationsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamConfigurationsTable> {
  $$ExamConfigurationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examName => $composableBuilder(
    column: $table.examName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get passPercentage => $composableBuilder(
    column: $table.passPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExamConfigurationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamConfigurationsTable> {
  $$ExamConfigurationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get examName =>
      $composableBuilder(column: $table.examName, builder: (column) => column);

  GeneratedColumn<int> get questionCount => $composableBuilder(
    column: $table.questionCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
    column: $table.durationMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get passPercentage => $composableBuilder(
    column: $table.passPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);
}

class $$ExamConfigurationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamConfigurationsTable,
          ExamConfiguration,
          $$ExamConfigurationsTableFilterComposer,
          $$ExamConfigurationsTableOrderingComposer,
          $$ExamConfigurationsTableAnnotationComposer,
          $$ExamConfigurationsTableCreateCompanionBuilder,
          $$ExamConfigurationsTableUpdateCompanionBuilder,
          (
            ExamConfiguration,
            BaseReferences<
              _$AppDatabase,
              $ExamConfigurationsTable,
              ExamConfiguration
            >,
          ),
          ExamConfiguration,
          PrefetchHooks Function()
        > {
  $$ExamConfigurationsTableTableManager(
    _$AppDatabase db,
    $ExamConfigurationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamConfigurationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamConfigurationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamConfigurationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> examName = const Value.absent(),
                Value<int> questionCount = const Value.absent(),
                Value<int> durationMinutes = const Value.absent(),
                Value<double> passPercentage = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
              }) => ExamConfigurationsCompanion(
                id: id,
                examName: examName,
                questionCount: questionCount,
                durationMinutes: durationMinutes,
                passPercentage: passPercentage,
                version: version,
                isActive: isActive,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String examName,
                required int questionCount,
                required int durationMinutes,
                required double passPercentage,
                required int version,
                Value<bool> isActive = const Value.absent(),
              }) => ExamConfigurationsCompanion.insert(
                id: id,
                examName: examName,
                questionCount: questionCount,
                durationMinutes: durationMinutes,
                passPercentage: passPercentage,
                version: version,
                isActive: isActive,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExamConfigurationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamConfigurationsTable,
      ExamConfiguration,
      $$ExamConfigurationsTableFilterComposer,
      $$ExamConfigurationsTableOrderingComposer,
      $$ExamConfigurationsTableAnnotationComposer,
      $$ExamConfigurationsTableCreateCompanionBuilder,
      $$ExamConfigurationsTableUpdateCompanionBuilder,
      (
        ExamConfiguration,
        BaseReferences<
          _$AppDatabase,
          $ExamConfigurationsTable,
          ExamConfiguration
        >,
      ),
      ExamConfiguration,
      PrefetchHooks Function()
    >;
typedef $$ExamAttemptsTableCreateCompanionBuilder =
    ExamAttemptsCompanion Function({
      Value<int> id,
      required int configId,
      required String selectedQuestionsJson,
      required int totalQuestions,
      Value<int> currentQuestionIndex,
      Value<double?> score,
      Value<bool?> isPassed,
      required DateTime startedAt,
      Value<DateTime?> submittedAt,
      Value<bool> isCompleted,
      Value<bool> isPremiumTimed,
      Value<int?> remainingTimeSeconds,
      Value<DateTime?> lastObservedAt,
      Value<DateTime?> backgroundedAt,
      Value<bool> timerLocked,
      Value<int?> timeTakenSeconds,
      Value<double?> readinessScore,
    });
typedef $$ExamAttemptsTableUpdateCompanionBuilder =
    ExamAttemptsCompanion Function({
      Value<int> id,
      Value<int> configId,
      Value<String> selectedQuestionsJson,
      Value<int> totalQuestions,
      Value<int> currentQuestionIndex,
      Value<double?> score,
      Value<bool?> isPassed,
      Value<DateTime> startedAt,
      Value<DateTime?> submittedAt,
      Value<bool> isCompleted,
      Value<bool> isPremiumTimed,
      Value<int?> remainingTimeSeconds,
      Value<DateTime?> lastObservedAt,
      Value<DateTime?> backgroundedAt,
      Value<bool> timerLocked,
      Value<int?> timeTakenSeconds,
      Value<double?> readinessScore,
    });

class $$ExamAttemptsTableFilterComposer
    extends Composer<_$AppDatabase, $ExamAttemptsTable> {
  $$ExamAttemptsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get configId => $composableBuilder(
    column: $table.configId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get selectedQuestionsJson => $composableBuilder(
    column: $table.selectedQuestionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentQuestionIndex => $composableBuilder(
    column: $table.currentQuestionIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPassed => $composableBuilder(
    column: $table.isPassed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPremiumTimed => $composableBuilder(
    column: $table.isPremiumTimed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get remainingTimeSeconds => $composableBuilder(
    column: $table.remainingTimeSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastObservedAt => $composableBuilder(
    column: $table.lastObservedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get backgroundedAt => $composableBuilder(
    column: $table.backgroundedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get timerLocked => $composableBuilder(
    column: $table.timerLocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timeTakenSeconds => $composableBuilder(
    column: $table.timeTakenSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get readinessScore => $composableBuilder(
    column: $table.readinessScore,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExamAttemptsTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamAttemptsTable> {
  $$ExamAttemptsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get configId => $composableBuilder(
    column: $table.configId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get selectedQuestionsJson => $composableBuilder(
    column: $table.selectedQuestionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentQuestionIndex => $composableBuilder(
    column: $table.currentQuestionIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPassed => $composableBuilder(
    column: $table.isPassed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPremiumTimed => $composableBuilder(
    column: $table.isPremiumTimed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get remainingTimeSeconds => $composableBuilder(
    column: $table.remainingTimeSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastObservedAt => $composableBuilder(
    column: $table.lastObservedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get backgroundedAt => $composableBuilder(
    column: $table.backgroundedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get timerLocked => $composableBuilder(
    column: $table.timerLocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timeTakenSeconds => $composableBuilder(
    column: $table.timeTakenSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get readinessScore => $composableBuilder(
    column: $table.readinessScore,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExamAttemptsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamAttemptsTable> {
  $$ExamAttemptsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get configId =>
      $composableBuilder(column: $table.configId, builder: (column) => column);

  GeneratedColumn<String> get selectedQuestionsJson => $composableBuilder(
    column: $table.selectedQuestionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalQuestions => $composableBuilder(
    column: $table.totalQuestions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentQuestionIndex => $composableBuilder(
    column: $table.currentQuestionIndex,
    builder: (column) => column,
  );

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<bool> get isPassed =>
      $composableBuilder(column: $table.isPassed, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get submittedAt => $composableBuilder(
    column: $table.submittedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPremiumTimed => $composableBuilder(
    column: $table.isPremiumTimed,
    builder: (column) => column,
  );

  GeneratedColumn<int> get remainingTimeSeconds => $composableBuilder(
    column: $table.remainingTimeSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastObservedAt => $composableBuilder(
    column: $table.lastObservedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get backgroundedAt => $composableBuilder(
    column: $table.backgroundedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get timerLocked => $composableBuilder(
    column: $table.timerLocked,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timeTakenSeconds => $composableBuilder(
    column: $table.timeTakenSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get readinessScore => $composableBuilder(
    column: $table.readinessScore,
    builder: (column) => column,
  );
}

class $$ExamAttemptsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamAttemptsTable,
          ExamAttempt,
          $$ExamAttemptsTableFilterComposer,
          $$ExamAttemptsTableOrderingComposer,
          $$ExamAttemptsTableAnnotationComposer,
          $$ExamAttemptsTableCreateCompanionBuilder,
          $$ExamAttemptsTableUpdateCompanionBuilder,
          (
            ExamAttempt,
            BaseReferences<_$AppDatabase, $ExamAttemptsTable, ExamAttempt>,
          ),
          ExamAttempt,
          PrefetchHooks Function()
        > {
  $$ExamAttemptsTableTableManager(_$AppDatabase db, $ExamAttemptsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamAttemptsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamAttemptsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamAttemptsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> configId = const Value.absent(),
                Value<String> selectedQuestionsJson = const Value.absent(),
                Value<int> totalQuestions = const Value.absent(),
                Value<int> currentQuestionIndex = const Value.absent(),
                Value<double?> score = const Value.absent(),
                Value<bool?> isPassed = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> submittedAt = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<bool> isPremiumTimed = const Value.absent(),
                Value<int?> remainingTimeSeconds = const Value.absent(),
                Value<DateTime?> lastObservedAt = const Value.absent(),
                Value<DateTime?> backgroundedAt = const Value.absent(),
                Value<bool> timerLocked = const Value.absent(),
                Value<int?> timeTakenSeconds = const Value.absent(),
                Value<double?> readinessScore = const Value.absent(),
              }) => ExamAttemptsCompanion(
                id: id,
                configId: configId,
                selectedQuestionsJson: selectedQuestionsJson,
                totalQuestions: totalQuestions,
                currentQuestionIndex: currentQuestionIndex,
                score: score,
                isPassed: isPassed,
                startedAt: startedAt,
                submittedAt: submittedAt,
                isCompleted: isCompleted,
                isPremiumTimed: isPremiumTimed,
                remainingTimeSeconds: remainingTimeSeconds,
                lastObservedAt: lastObservedAt,
                backgroundedAt: backgroundedAt,
                timerLocked: timerLocked,
                timeTakenSeconds: timeTakenSeconds,
                readinessScore: readinessScore,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int configId,
                required String selectedQuestionsJson,
                required int totalQuestions,
                Value<int> currentQuestionIndex = const Value.absent(),
                Value<double?> score = const Value.absent(),
                Value<bool?> isPassed = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> submittedAt = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<bool> isPremiumTimed = const Value.absent(),
                Value<int?> remainingTimeSeconds = const Value.absent(),
                Value<DateTime?> lastObservedAt = const Value.absent(),
                Value<DateTime?> backgroundedAt = const Value.absent(),
                Value<bool> timerLocked = const Value.absent(),
                Value<int?> timeTakenSeconds = const Value.absent(),
                Value<double?> readinessScore = const Value.absent(),
              }) => ExamAttemptsCompanion.insert(
                id: id,
                configId: configId,
                selectedQuestionsJson: selectedQuestionsJson,
                totalQuestions: totalQuestions,
                currentQuestionIndex: currentQuestionIndex,
                score: score,
                isPassed: isPassed,
                startedAt: startedAt,
                submittedAt: submittedAt,
                isCompleted: isCompleted,
                isPremiumTimed: isPremiumTimed,
                remainingTimeSeconds: remainingTimeSeconds,
                lastObservedAt: lastObservedAt,
                backgroundedAt: backgroundedAt,
                timerLocked: timerLocked,
                timeTakenSeconds: timeTakenSeconds,
                readinessScore: readinessScore,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExamAttemptsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamAttemptsTable,
      ExamAttempt,
      $$ExamAttemptsTableFilterComposer,
      $$ExamAttemptsTableOrderingComposer,
      $$ExamAttemptsTableAnnotationComposer,
      $$ExamAttemptsTableCreateCompanionBuilder,
      $$ExamAttemptsTableUpdateCompanionBuilder,
      (
        ExamAttempt,
        BaseReferences<_$AppDatabase, $ExamAttemptsTable, ExamAttempt>,
      ),
      ExamAttempt,
      PrefetchHooks Function()
    >;
typedef $$ExamAttemptAnswersTableCreateCompanionBuilder =
    ExamAttemptAnswersCompanion Function({
      Value<int> id,
      required int examAttemptId,
      required String questionId,
      required int questionOrder,
      Value<int?> selectedIndex,
      Value<bool?> isCorrect,
      Value<DateTime?> answeredAt,
    });
typedef $$ExamAttemptAnswersTableUpdateCompanionBuilder =
    ExamAttemptAnswersCompanion Function({
      Value<int> id,
      Value<int> examAttemptId,
      Value<String> questionId,
      Value<int> questionOrder,
      Value<int?> selectedIndex,
      Value<bool?> isCorrect,
      Value<DateTime?> answeredAt,
    });

class $$ExamAttemptAnswersTableFilterComposer
    extends Composer<_$AppDatabase, $ExamAttemptAnswersTable> {
  $$ExamAttemptAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get examAttemptId => $composableBuilder(
    column: $table.examAttemptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get questionOrder => $composableBuilder(
    column: $table.questionOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ExamAttemptAnswersTableOrderingComposer
    extends Composer<_$AppDatabase, $ExamAttemptAnswersTable> {
  $$ExamAttemptAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get examAttemptId => $composableBuilder(
    column: $table.examAttemptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get questionOrder => $composableBuilder(
    column: $table.questionOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCorrect => $composableBuilder(
    column: $table.isCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ExamAttemptAnswersTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExamAttemptAnswersTable> {
  $$ExamAttemptAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get examAttemptId => $composableBuilder(
    column: $table.examAttemptId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get questionOrder => $composableBuilder(
    column: $table.questionOrder,
    builder: (column) => column,
  );

  GeneratedColumn<int> get selectedIndex => $composableBuilder(
    column: $table.selectedIndex,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCorrect =>
      $composableBuilder(column: $table.isCorrect, builder: (column) => column);

  GeneratedColumn<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => column,
  );
}

class $$ExamAttemptAnswersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExamAttemptAnswersTable,
          ExamAttemptAnswer,
          $$ExamAttemptAnswersTableFilterComposer,
          $$ExamAttemptAnswersTableOrderingComposer,
          $$ExamAttemptAnswersTableAnnotationComposer,
          $$ExamAttemptAnswersTableCreateCompanionBuilder,
          $$ExamAttemptAnswersTableUpdateCompanionBuilder,
          (
            ExamAttemptAnswer,
            BaseReferences<
              _$AppDatabase,
              $ExamAttemptAnswersTable,
              ExamAttemptAnswer
            >,
          ),
          ExamAttemptAnswer,
          PrefetchHooks Function()
        > {
  $$ExamAttemptAnswersTableTableManager(
    _$AppDatabase db,
    $ExamAttemptAnswersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExamAttemptAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExamAttemptAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExamAttemptAnswersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> examAttemptId = const Value.absent(),
                Value<String> questionId = const Value.absent(),
                Value<int> questionOrder = const Value.absent(),
                Value<int?> selectedIndex = const Value.absent(),
                Value<bool?> isCorrect = const Value.absent(),
                Value<DateTime?> answeredAt = const Value.absent(),
              }) => ExamAttemptAnswersCompanion(
                id: id,
                examAttemptId: examAttemptId,
                questionId: questionId,
                questionOrder: questionOrder,
                selectedIndex: selectedIndex,
                isCorrect: isCorrect,
                answeredAt: answeredAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int examAttemptId,
                required String questionId,
                required int questionOrder,
                Value<int?> selectedIndex = const Value.absent(),
                Value<bool?> isCorrect = const Value.absent(),
                Value<DateTime?> answeredAt = const Value.absent(),
              }) => ExamAttemptAnswersCompanion.insert(
                id: id,
                examAttemptId: examAttemptId,
                questionId: questionId,
                questionOrder: questionOrder,
                selectedIndex: selectedIndex,
                isCorrect: isCorrect,
                answeredAt: answeredAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ExamAttemptAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExamAttemptAnswersTable,
      ExamAttemptAnswer,
      $$ExamAttemptAnswersTableFilterComposer,
      $$ExamAttemptAnswersTableOrderingComposer,
      $$ExamAttemptAnswersTableAnnotationComposer,
      $$ExamAttemptAnswersTableCreateCompanionBuilder,
      $$ExamAttemptAnswersTableUpdateCompanionBuilder,
      (
        ExamAttemptAnswer,
        BaseReferences<
          _$AppDatabase,
          $ExamAttemptAnswersTable,
          ExamAttemptAnswer
        >,
      ),
      ExamAttemptAnswer,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$StudyQuestionsTableTableManager get studyQuestions =>
      $$StudyQuestionsTableTableManager(_db, _db.studyQuestions);
  $$QuestionAttemptsTableTableManager get questionAttempts =>
      $$QuestionAttemptsTableTableManager(_db, _db.questionAttempts);
  $$StarredQuestionsTableTableManager get starredQuestions =>
      $$StarredQuestionsTableTableManager(_db, _db.starredQuestions);
  $$PracticeSessionsTableTableManager get practiceSessions =>
      $$PracticeSessionsTableTableManager(_db, _db.practiceSessions);
  $$ExamConfigurationsTableTableManager get examConfigurations =>
      $$ExamConfigurationsTableTableManager(_db, _db.examConfigurations);
  $$ExamAttemptsTableTableManager get examAttempts =>
      $$ExamAttemptsTableTableManager(_db, _db.examAttempts);
  $$ExamAttemptAnswersTableTableManager get examAttemptAnswers =>
      $$ExamAttemptAnswersTableTableManager(_db, _db.examAttemptAnswers);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
}
