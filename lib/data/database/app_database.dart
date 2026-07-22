import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class StudyQuestions extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text()();
  TextColumn get questionText => text()();
  TextColumn get optionsJson => text()();
  IntColumn get correctIndex => integer()();
  TextColumn get explanation => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class QuestionAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get questionId => text()();
  IntColumn get selectedIndex => integer()();
  BoolColumn get isCorrect => boolean()();
  DateTimeColumn get attemptedAt => dateTime()();
}

class StarredQuestions extends Table {
  TextColumn get questionId => text()();
  DateTimeColumn get starredAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {questionId};
}

class PracticeSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get categoryId => text().nullable()();
  TextColumn get questionIdsJson => text()();
  IntColumn get currentIndex => integer().withDefault(const Constant(0))();
  IntColumn get correctCount => integer().withDefault(const Constant(0))();
  BoolColumn get isComplete => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();
}

class ExamConfigurations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get examName => text().unique()();
  IntColumn get questionCount => integer()();
  IntColumn get durationMinutes => integer()();
  RealColumn get passPercentage => real()();
  IntColumn get version => integer()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

class ExamAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get configId => integer()();
  TextColumn get selectedQuestionsJson => text()();
  IntColumn get totalQuestions => integer()();
  IntColumn get currentQuestionIndex =>
      integer().withDefault(const Constant(0))();
  RealColumn get score => real().nullable()();
  BoolColumn get isPassed => boolean().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get submittedAt => dateTime().nullable()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  BoolColumn get isPremiumTimed =>
      boolean().withDefault(const Constant(false))();
}

class ExamAttemptAnswers extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get examAttemptId => integer()();
  TextColumn get questionId => text()();
  IntColumn get questionOrder => integer()();
  IntColumn get selectedIndex => integer().nullable()();
  BoolColumn get isCorrect => boolean().nullable()();
  DateTimeColumn get answeredAt => dateTime().nullable()();
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

@DriftDatabase(
  tables: [
    Categories,
    StudyQuestions,
    QuestionAttempts,
    StarredQuestions,
    PracticeSessions,
    ExamConfigurations,
    ExamAttempts,
    ExamAttemptAnswers,
    AppSettings,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) await migrator.createTable(starredQuestions);
      if (from < 3) {
        await migrator.createTable(examConfigurations);
        await migrator.createTable(examAttempts);
        await migrator.createTable(examAttemptAnswers);
      }
      if (from < 4) {
        await migrator.createTable(appSettings);
      }
    },
  );

  Future<PracticeSession?> activeSession() =>
      (select(practiceSessions)
            ..where((row) => row.isComplete.equals(false))
            ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<ExamAttempt?> activeExamAttempt() =>
      (select(examAttempts)
            ..where((row) => row.isCompleted.equals(false))
            ..orderBy([(row) => OrderingTerm.desc(row.startedAt)])
            ..limit(1))
          .getSingleOrNull();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();
    return NativeDatabase.createInBackground(
      File(p.join(directory.path, 'citizenship_study.sqlite')),
    );
  });
}
