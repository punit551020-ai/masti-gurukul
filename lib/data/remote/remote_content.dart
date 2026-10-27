import 'package:drift/drift.dart';

import '../local/database.dart';

/// Remote table names, matching `supabase/schema.sql`.
abstract class RemoteTables {
  static const schoolClasses = 'school_classes';
  static const boards = 'boards';
  static const subjects = 'subjects';
  static const chapters = 'chapters';
  static const lessons = 'lessons';
  static const resources = 'resources';
  static const tests = 'tests';
  static const testQuestions = 'test_questions';
  static const liveClasses = 'live_classes';
  static const announcements = 'announcements';

  /// Content the student app mirrors locally. Order matters when clearing the
  /// cache: children before parents, so foreign keys stay satisfied.
  static const contentInDependencyOrder = <String>[
    testQuestions,
    tests,
    lessons,
    chapters,
    resources,
    liveClasses,
    announcements,
    subjects,
    boards,
    schoolClasses,
  ];

  /// Tables an authenticated admin may write to. Progress and downloads are
  /// deliberately absent: they stay on the device until students have accounts.
  static const adminWritable = <String>[
    schoolClasses,
    boards,
    subjects,
    chapters,
    lessons,
    resources,
    tests,
    testQuestions,
    liveClasses,
    announcements,
  ];
}

typedef ContentRow = Map<String, dynamic>;

String? _text(ContentRow row, String key) {
  final value = row[key];
  if (value == null) return null;
  return value.toString();
}

String _textOr(ContentRow row, String key, String fallback) =>
    _text(row, key) ?? fallback;

int _int(ContentRow row, String key, int fallback) {
  final value = row[key];
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

double _double(ContentRow row, String key, double fallback) {
  final value = row[key];
  if (value is double) return value;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? fallback;
  return fallback;
}

bool _bool(ContentRow row, String key, {bool fallback = false}) {
  final value = row[key];
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    if (value == 'true') return true;
    if (value == 'false') return false;
  }
  return fallback;
}

DateTime? _moment(ContentRow row, String key) {
  final value = row[key];
  if (value is String) return DateTime.tryParse(value)?.toLocal();
  if (value is DateTime) return value.toLocal();
  return null;
}

DateTime _momentOrNow(ContentRow row, String key) =>
    _moment(row, key) ?? DateTime.now();

/// Converts one remote row into a drift insertable. A row whose `id` is missing
/// or whose shape cannot be read is rejected rather than half-written, so one
/// malformed admin edit cannot corrupt the local cache.
abstract class RemoteContent {
  const RemoteContent._();

  static SchoolClassesCompanion schoolClass(ContentRow row) =>
      SchoolClassesCompanion(
        id: Value(_require(row, 'id')),
        level: Value(_int(row, 'level', 6)),
        nameHindi: Value(_textOr(row, 'name_hindi', '')),
        nameEnglish: Value(_textOr(row, 'name_english', '')),
        displayOrder: Value(_int(row, 'display_order', 0)),
      );

  static BoardsCompanion board(ContentRow row) => BoardsCompanion(
    id: Value(_require(row, 'id')),
    nameHindi: Value(_textOr(row, 'name_hindi', '')),
    nameEnglish: Value(_textOr(row, 'name_english', '')),
    displayOrder: Value(_int(row, 'display_order', 0)),
  );

  static SubjectsCompanion subject(ContentRow row) => SubjectsCompanion(
    id: Value(_require(row, 'id')),
    classId: Value(_require(row, 'class_id')),
    boardId: Value(_text(row, 'board_id')),
    nameHindi: Value(_textOr(row, 'name_hindi', '')),
    nameEnglish: Value(_textOr(row, 'name_english', '')),
    accentColor: Value(_textOr(row, 'accent_color', 'F1951A')),
    displayOrder: Value(_int(row, 'display_order', 0)),
  );

  static ChaptersCompanion chapter(ContentRow row) => ChaptersCompanion(
    id: Value(_require(row, 'id')),
    subjectId: Value(_require(row, 'subject_id')),
    number: Value(_int(row, 'number', 1)),
    title: Value(_textOr(row, 'title', '')),
    titleHindi: Value(_textOr(row, 'title_hindi', '')),
    summary: Value(_textOr(row, 'summary', '')),
  );

  static LessonsCompanion lesson(ContentRow row) => LessonsCompanion(
    id: Value(_require(row, 'id')),
    chapterId: Value(_require(row, 'chapter_id')),
    title: Value(_textOr(row, 'title', '')),
    description: Value(_textOr(row, 'description', '')),
    displayOrder: Value(_int(row, 'display_order', 0)),
    youtubeUrl: Value(_text(row, 'youtube_url')),
    localVideoPath: Value(_text(row, 'local_video_path')),
    durationSeconds: Value(_int(row, 'duration_seconds', 0)),
    isPublished: Value(_bool(row, 'is_published')),
  );

  static ResourcesCompanion resource(ContentRow row) => ResourcesCompanion(
    id: Value(_require(row, 'id')),
    subjectId: Value(_require(row, 'subject_id')),
    chapterId: Value(_text(row, 'chapter_id')),
    title: Value(_textOr(row, 'title', '')),
    description: Value(_textOr(row, 'description', '')),
    kind: Value(_textOr(row, 'kind', 'NOTES')),
    yearLabel: Value(_intOrNull(row, 'year_label')),
    localFilePath: Value(_text(row, 'local_file_path')),
    remoteUrl: Value(_text(row, 'remote_url')),
    fileSizeBytes: Value(_int(row, 'file_size_bytes', 0)),
    isPublished: Value(_bool(row, 'is_published')),
    createdAt: Value(_momentOrNow(row, 'created_at')),
  );

  static TestsCompanion test(ContentRow row) => TestsCompanion(
    id: Value(_require(row, 'id')),
    chapterId: Value(_require(row, 'chapter_id')),
    title: Value(_textOr(row, 'title', '')),
    timeLimitMinutes: Value(_int(row, 'time_limit_minutes', 20)),
    marksPerQuestion: Value(_double(row, 'marks_per_question', 1.0)),
    negativeMarking: Value(_double(row, 'negative_marking', 0.0)),
    isPublished: Value(_bool(row, 'is_published')),
  );

  static TestQuestionsCompanion question(ContentRow row) =>
      TestQuestionsCompanion(
        id: Value(_require(row, 'id')),
        testId: Value(_require(row, 'test_id')),
        prompt: Value(_textOr(row, 'prompt', '')),
        optionA: Value(_textOr(row, 'option_a', '')),
        optionB: Value(_textOr(row, 'option_b', '')),
        optionC: Value(_textOr(row, 'option_c', '')),
        optionD: Value(_textOr(row, 'option_d', '')),
        correctOption: Value(_textOr(row, 'correct_option', 'A')),
        explanation: Value(_textOr(row, 'explanation', '')),
        marks: Value(_double(row, 'marks', 1.0)),
        displayOrder: Value(_int(row, 'display_order', 0)),
      );

  static LiveClassesCompanion liveClass(ContentRow row) => LiveClassesCompanion(
    id: Value(_require(row, 'id')),
    subjectId: Value(_require(row, 'subject_id')),
    title: Value(_textOr(row, 'title', '')),
    description: Value(_textOr(row, 'description', '')),
    status: Value(_textOr(row, 'status', 'SCHEDULED')),
    scheduledStart: Value(_momentOrNow(row, 'scheduled_start')),
    actualStart: Value(_moment(row, 'actual_start')),
    actualEnd: Value(_moment(row, 'actual_end')),
    youtubeUrl: Value(_text(row, 'youtube_url')),
    isPublished: Value(_bool(row, 'is_published')),
  );

  static AnnouncementsCompanion announcement(ContentRow row) =>
      AnnouncementsCompanion(
        id: Value(_require(row, 'id')),
        title: Value(_textOr(row, 'title', '')),
        body: Value(_textOr(row, 'body', '')),
        classId: Value(_text(row, 'class_id')),
        priority: Value(_textOr(row, 'priority', 'NORMAL')),
        isActive: Value(_bool(row, 'is_active', fallback: true)),
        publishedAt: Value(_momentOrNow(row, 'published_at')),
      );

  /// Turns a local lesson row into the map Supabase expects, so an admin edit
  /// made offline can be pushed unchanged. Column names are the remote ones.
  static ContentRow lessonToRow(Lesson lesson) => {
    'id': lesson.id,
    'chapter_id': lesson.chapterId,
    'title': lesson.title,
    'description': lesson.description,
    'display_order': lesson.displayOrder,
    'youtube_url': lesson.youtubeUrl,
    'local_video_path': lesson.localVideoPath,
    'duration_seconds': lesson.durationSeconds,
    'is_published': lesson.isPublished,
  };

  static ContentRow resourceToRow(Resource resource) => {
    'id': resource.id,
    'subject_id': resource.subjectId,
    'chapter_id': resource.chapterId,
    'title': resource.title,
    'description': resource.description,
    'kind': resource.kind,
    'year_label': resource.yearLabel,
    'local_file_path': resource.localFilePath,
    'remote_url': resource.remoteUrl,
    'file_size_bytes': resource.fileSizeBytes,
    'is_published': resource.isPublished,
    'created_at': resource.createdAt.toUtc().toIso8601String(),
  };

  static ContentRow liveClassToRow(LiveClass liveClass) => {
    'id': liveClass.id,
    'subject_id': liveClass.subjectId,
    'title': liveClass.title,
    'description': liveClass.description,
    'status': liveClass.status,
    'scheduled_start': liveClass.scheduledStart.toUtc().toIso8601String(),
    'actual_start': liveClass.actualStart?.toUtc().toIso8601String(),
    'actual_end': liveClass.actualEnd?.toUtc().toIso8601String(),
    'youtube_url': liveClass.youtubeUrl,
    'is_published': liveClass.isPublished,
  };

  static ContentRow announcementToRow(Announcement announcement) => {
    'id': announcement.id,
    'title': announcement.title,
    'body': announcement.body,
    'class_id': announcement.classId,
    'priority': announcement.priority,
    'is_active': announcement.isActive,
    'published_at': announcement.publishedAt.toUtc().toIso8601String(),
  };

  static ContentRow chapterToRow(Chapter chapter) => {
    'id': chapter.id,
    'subject_id': chapter.subjectId,
    'number': chapter.number,
    'title': chapter.title,
    'title_hindi': chapter.titleHindi,
    'summary': chapter.summary,
  };

  static ContentRow testToRow(Test test) => {
    'id': test.id,
    'chapter_id': test.chapterId,
    'title': test.title,
    'time_limit_minutes': test.timeLimitMinutes,
    'marks_per_question': test.marksPerQuestion,
    'negative_marking': test.negativeMarking,
    'is_published': test.isPublished,
  };

  static ContentRow questionToRow(TestQuestion question) => {
    'id': question.id,
    'test_id': question.testId,
    'prompt': question.prompt,
    'option_a': question.optionA,
    'option_b': question.optionB,
    'option_c': question.optionC,
    'option_d': question.optionD,
    'correct_option': question.correctOption,
    'explanation': question.explanation,
    'marks': question.marks,
    'display_order': question.displayOrder,
  };

  static ContentRow subjectToRow(Subject subject) => {
    'id': subject.id,
    'class_id': subject.classId,
    'board_id': subject.boardId,
    'name_hindi': subject.nameHindi,
    'name_english': subject.nameEnglish,
    'accent_color': subject.accentColor,
    'display_order': subject.displayOrder,
  };

  static ContentRow schoolClassToRow(SchoolClass schoolClass) => {
    'id': schoolClass.id,
    'level': schoolClass.level,
    'name_hindi': schoolClass.nameHindi,
    'name_english': schoolClass.nameEnglish,
    'display_order': schoolClass.displayOrder,
  };

  static ContentRow boardToRow(Board board) => {
    'id': board.id,
    'name_hindi': board.nameHindi,
    'name_english': board.nameEnglish,
    'display_order': board.displayOrder,
  };

  static ContentRow rowFor(String table, Object local) => switch (table) {
    RemoteTables.schoolClasses => schoolClassToRow(local as SchoolClass),
    RemoteTables.boards => boardToRow(local as Board),
    RemoteTables.subjects => subjectToRow(local as Subject),
    RemoteTables.chapters => chapterToRow(local as Chapter),
    RemoteTables.lessons => lessonToRow(local as Lesson),
    RemoteTables.resources => resourceToRow(local as Resource),
    RemoteTables.tests => testToRow(local as Test),
    RemoteTables.testQuestions => questionToRow(local as TestQuestion),
    RemoteTables.liveClasses => liveClassToRow(local as LiveClass),
    RemoteTables.announcements => announcementToRow(local as Announcement),
    _ => throw ArgumentError('Table $table is not mirrored'),
  };

  static String _require(ContentRow row, String key) {
    final value = _text(row, key);
    if (value == null || value.isEmpty) {
      throw RemoteRowException('A saved row is missing its "$key" value.');
    }
    return value;
  }

  static int? _intOrNull(ContentRow row, String key) {
    if (!row.containsKey(key) || row[key] == null) return null;
    return _int(row, key, 0);
  }
}

/// Raised when a remote row cannot be mirrored. Surfaced to the admin as a
/// readable message instead of being silently skipped.
class RemoteRowException implements Exception {
  RemoteRowException(this.message);
  final String message;

  @override
  String toString() => message;
}
