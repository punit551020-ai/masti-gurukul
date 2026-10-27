import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    SchoolClasses,
    Boards,
    Subjects,
    Chapters,
    Lessons,
    Resources,
    Tests,
    TestQuestions,
    Students,
    Bookmarks,
    RecentViews,
    LessonProgress,
    Downloads,
    LiveClasses,
    Announcements,
    AppSettings,
    TestAttempts,
    TestAttemptAnswers,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.connection);

  AppDatabase.open()
    : super(
        driftDatabase(
          name: 'masti_gurukul',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
          ),
        ),
      );

  @override
  int get schemaVersion => 2;

  /// Version 2 gave each subject an optional board, so one class can hold a
  /// Bihar Board list and a CBSE list side by side. Existing rows are left with
  /// a null board, which the app reads as "for every board".
  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(subjects, subjects.boardId);
      }
    },
  );
}
