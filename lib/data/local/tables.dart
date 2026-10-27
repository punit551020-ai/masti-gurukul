import 'package:drift/drift.dart';

@DataClassName('SchoolClass')
class SchoolClasses extends Table {
  TextColumn get id => text()();
  IntColumn get level => integer()();
  TextColumn get nameHindi => text()();
  TextColumn get nameEnglish => text()();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

/// The id of the pseudo-class that holds content meant for every class at once.
///
/// The admin picks "All Classes" and files one subject under this id; every
/// read that filters by class (CatalogRepository.subjectsForClass,
/// _subjectIdsOfClass, videoLessons) also takes the rows carrying it, so one
/// upload shows up in Classes 6 to 10 instead of five. `classes()` hides it
/// from students, so nobody can ever choose it as their own class.
abstract class ClassIds {
  static const all = 'class-all';
}

class Boards extends Table {
  TextColumn get id => text()();
  TextColumn get nameHindi => text()();
  TextColumn get nameEnglish => text()();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Subjects extends Table {
  TextColumn get id => text()();
  TextColumn get classId => text().references(SchoolClasses, #id)();

  /// Null means the subject belongs to every board - that is how the original
  /// seeded list keeps working. A board id pins it to one syllabus, which is
  /// what lets a Bihar Board Class 10 Science sit beside a CBSE one without the
  /// two mixing.
  TextColumn get boardId => text().nullable().references(Boards, #id)();
  TextColumn get nameHindi => text()();
  TextColumn get nameEnglish => text()();
  TextColumn get accentColor => text().withDefault(const Constant('F1951A'))();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Chapters extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text().references(Subjects, #id)();
  IntColumn get number => integer()();
  TextColumn get title => text()();
  TextColumn get titleHindi => text().withDefault(const Constant(''))();
  TextColumn get summary => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

class Lessons extends Table {
  TextColumn get id => text()();
  TextColumn get chapterId => text().references(Chapters, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
  TextColumn get youtubeUrl => text().nullable()();
  TextColumn get localVideoPath => text().nullable()();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  BoolColumn get isPublished => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Resource kinds stored as short codes so the same values can be reused in
/// Supabase rows later.
abstract class ResourceKinds {
  static const notes = 'NOTES';
  static const pdf = 'PDF';
  static const worksheet = 'WORKSHEET';
  static const previousYearPaper = 'PREVIOUS_YEAR_PAPER';
  static const all = <String>[notes, pdf, worksheet, previousYearPaper];
}

class Resources extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text().references(Subjects, #id)();
  TextColumn get chapterId => text().nullable().references(Chapters, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get kind => text()();
  IntColumn get yearLabel => integer().nullable()();
  TextColumn get localFilePath => text().nullable()();
  TextColumn get remoteUrl => text().nullable()();
  IntColumn get fileSizeBytes => integer().withDefault(const Constant(0))();
  BoolColumn get isPublished => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class Tests extends Table {
  TextColumn get id => text()();
  TextColumn get chapterId => text().references(Chapters, #id)();
  TextColumn get title => text()();
  IntColumn get timeLimitMinutes => integer().withDefault(const Constant(20))();
  RealColumn get marksPerQuestion => real().withDefault(const Constant(1.0))();
  RealColumn get negativeMarking => real().withDefault(const Constant(0.0))();
  BoolColumn get isPublished => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class TestQuestions extends Table {
  TextColumn get id => text()();
  TextColumn get testId => text().references(Tests, #id)();
  TextColumn get prompt => text()();
  TextColumn get optionA => text()();
  TextColumn get optionB => text()();
  TextColumn get optionC => text()();
  TextColumn get optionD => text()();
  TextColumn get correctOption => text()();
  TextColumn get explanation => text().withDefault(const Constant(''))();
  RealColumn get marks => real().withDefault(const Constant(1.0))();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Students extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text()();
  TextColumn get classId => text().nullable().references(SchoolClasses, #id)();
  TextColumn get avatarEmoji => text().withDefault(const Constant('🎓'))();
  TextColumn get themeMode => text().withDefault(const Constant('system'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastSeenAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Targets that can be bookmarked or shown in "recently viewed".
abstract class TrackableKinds {
  static const lesson = 'LESSON';
  static const resource = 'RESOURCE';
  static const test = 'TEST';
  static const liveClass = 'LIVE_CLASS';
}

class Bookmarks extends Table {
  TextColumn get studentId => text().references(Students, #id)();
  TextColumn get targetKind => text()();
  TextColumn get targetId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {studentId, targetKind, targetId};
}

class RecentViews extends Table {
  TextColumn get studentId => text().references(Students, #id)();
  TextColumn get targetKind => text()();
  TextColumn get targetId => text()();
  DateTimeColumn get viewedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {studentId, targetKind, targetId};
}

@DataClassName('LessonProgressRow')
class LessonProgress extends Table {
  TextColumn get studentId => text().references(Students, #id)();
  TextColumn get lessonId => text().references(Lessons, #id)();
  RealColumn get percent => real().withDefault(const Constant(0.0))();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {studentId, lessonId};
}

abstract class DownloadStatuses {
  static const queued = 'QUEUED';
  static const running = 'RUNNING';
  static const complete = 'COMPLETE';
  static const failed = 'FAILED';
}

class Downloads extends Table {
  TextColumn get id => text()();
  TextColumn get studentId => text().references(Students, #id)();
  TextColumn get resourceId => text().references(Resources, #id)();
  TextColumn get localPath => text().nullable()();
  IntColumn get totalBytes => integer().withDefault(const Constant(0))();
  IntColumn get downloadedBytes => integer().withDefault(const Constant(0))();
  TextColumn get status => text()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

abstract class LiveClassStatuses {
  static const scheduled = 'SCHEDULED';
  static const live = 'LIVE';
  static const ended = 'ENDED';
  static const cancelled = 'CANCELLED';
}

@DataClassName('LiveClass')
class LiveClasses extends Table {
  TextColumn get id => text()();
  TextColumn get subjectId => text().references(Subjects, #id)();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get status => text()();
  DateTimeColumn get scheduledStart => dateTime()();
  DateTimeColumn get actualStart => dateTime().nullable()();
  DateTimeColumn get actualEnd => dateTime().nullable()();
  TextColumn get youtubeUrl => text().nullable()();
  BoolColumn get isPublished => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

class Announcements extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get classId => text().nullable().references(SchoolClasses, #id)();
  TextColumn get priority => text().withDefault(const Constant('NORMAL'))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get publishedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {key};
}

class TestAttempts extends Table {
  TextColumn get id => text()();
  TextColumn get testId => text().references(Tests, #id)();
  TextColumn get studentId => text().references(Students, #id)();
  RealColumn get score => real()();
  RealColumn get totalMarks => real()();
  IntColumn get correctCount => integer()();
  IntColumn get wrongCount => integer()();
  IntColumn get unansweredCount => integer().withDefault(const Constant(0))();
  IntColumn get timeSpentSeconds => integer().withDefault(const Constant(0))();
  DateTimeColumn get submittedAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class TestAttemptAnswers extends Table {
  TextColumn get attemptId => text().references(TestAttempts, #id)();
  TextColumn get questionId => text().references(TestQuestions, #id)();
  TextColumn get selectedOption => text().nullable()();
  BoolColumn get isCorrect => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {attemptId, questionId};
}
