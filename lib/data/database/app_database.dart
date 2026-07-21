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

@DriftDatabase(
  tables: [
    Categories,
    StudyQuestions,
    QuestionAttempts,
    StarredQuestions,
    PracticeSessions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) await migrator.createTable(starredQuestions);
    },
  );

  Future<PracticeSession?> activeSession() =>
      (select(practiceSessions)
            ..where((row) => row.isComplete.equals(false))
            ..orderBy([(row) => OrderingTerm.desc(row.updatedAt)])
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
