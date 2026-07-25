import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/services/performance_monitor.dart';

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
  IntColumn get remainingTimeSeconds => integer().nullable()();
  DateTimeColumn get lastObservedAt => dateTime().nullable()();
  DateTimeColumn get backgroundedAt => dateTime().nullable()();
  BoolColumn get timerLocked => boolean().withDefault(const Constant(false))();
  IntColumn get timeTakenSeconds => integer().nullable()();
  RealColumn get readinessScore => real().nullable()();
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
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await PerformanceMonitor.measure('database_create', () async {
        await migrator.createAll();
        await _createNormalizedContentTables();
      }, warningThreshold: const Duration(seconds: 2));
    },
    onUpgrade: (migrator, from, to) async {
      await PerformanceMonitor.measure(
        'database_migration_${from}_to_$to',
        () async {
          if (from < 2) await migrator.createTable(starredQuestions);
          if (from < 3) {
            await migrator.createTable(examConfigurations);
            await migrator.createTable(examAttempts);
            await migrator.createTable(examAttemptAnswers);
          }
          if (from < 4) await migrator.createTable(appSettings);
          if (from < 5) await _createNormalizedContentTables();
          if (from < 6) {
            await migrator.addColumn(
              examAttempts,
              examAttempts.remainingTimeSeconds,
            );
            await migrator.addColumn(examAttempts, examAttempts.lastObservedAt);
            await migrator.addColumn(examAttempts, examAttempts.backgroundedAt);
            await migrator.addColumn(examAttempts, examAttempts.timerLocked);
            await migrator.addColumn(
              examAttempts,
              examAttempts.timeTakenSeconds,
            );
            await migrator.addColumn(examAttempts, examAttempts.readinessScore);
          }
        },
        warningThreshold: const Duration(seconds: 2),
      );
    },
  );

  Future<void> _createNormalizedContentTables() async {
    await customStatement('''
      CREATE TABLE IF NOT EXISTS question_options (
        id TEXT PRIMARY KEY NOT NULL,
        question_id TEXT NOT NULL,
        option_text TEXT NOT NULL,
        is_correct INTEGER NOT NULL CHECK (is_correct IN (0, 1)),
        explanation TEXT NOT NULL,
        display_order INTEGER NOT NULL
      )
    ''');
    await customStatement('''
      CREATE TABLE IF NOT EXISTS question_metadata (
        question_id TEXT PRIMARY KEY NOT NULL,
        revision INTEGER NOT NULL,
        status TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        is_australian_values INTEGER NOT NULL CHECK (is_australian_values IN (0, 1))
      )
    ''');
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_question_options_question '
      'ON question_options(question_id, display_order)',
    );
    await customStatement('''
      CREATE TABLE IF NOT EXISTS source_editions (
        id TEXT PRIMARY KEY NOT NULL,
        title TEXT NOT NULL,
        publisher TEXT NOT NULL,
        edition TEXT NOT NULL,
        publication_year INTEGER NOT NULL,
        url TEXT NOT NULL,
        licence TEXT NOT NULL
      )
    ''');
    await customStatement('''
      CREATE TABLE IF NOT EXISTS question_references (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        question_id TEXT NOT NULL,
        source_edition_id TEXT NOT NULL,
        part TEXT NOT NULL,
        chapter TEXT,
        section TEXT NOT NULL,
        page_start INTEGER NOT NULL,
        page_end INTEGER NOT NULL,
        notes TEXT
      )
    ''');
    await customStatement('''
      CREATE TABLE IF NOT EXISTS removed_questions (
        question_id TEXT PRIMARY KEY NOT NULL,
        removed_at TEXT NOT NULL,
        reason TEXT NOT NULL,
        replacement_question_id TEXT,
        user_message TEXT NOT NULL
      )
    ''');
    await customStatement('''
      CREATE TABLE IF NOT EXISTS answer_option_selections (
        owner_type TEXT NOT NULL,
        owner_id INTEGER NOT NULL,
        option_id TEXT NOT NULL,
        PRIMARY KEY (owner_type, owner_id)
      )
    ''');
  }

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

  Future<void> deleteForRecovery() async {
    await close();
    final databaseFile = await _databaseFile();
    if (await databaseFile.exists()) await databaseFile.delete();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    return NativeDatabase.createInBackground(await _databaseFile());
  });
}

Future<File> _databaseFile() async {
  final directory = await getApplicationDocumentsDirectory();
  return File(p.join(directory.path, 'citizenship_study.sqlite'));
}
