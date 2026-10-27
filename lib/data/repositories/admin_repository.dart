import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../local/tables.dart';
import '../remote/content_gateway.dart';
import '../remote/remote_content.dart';

/// Write side of the content catalogue.
///
/// Every mutation follows the same order: validate, write locally, push the
/// finished row to the backend, and put the device back the way it was if the
/// server refuses. A rejected edit therefore never lingers on the admin's own
/// screen looking saved.
///
/// [gateway] is null in an offline-only build and in widget tests, and then this
/// class behaves exactly as the local-only version did. When it is set, the
/// server's Row Level Security — not any check in this file — decides whether a
/// write is allowed. That is why removing the admin screen from the app would
/// not protect the content, and why it is not the security boundary.
class AdminRepository {
  AdminRepository(this._db, [this._gateway]);

  final AppDatabase _db;
  final ContentGateway? _gateway;
  static const _uuid = Uuid();

  /// Whether content saved here also reaches the shared backend.
  bool get isLive => _gateway != null;

  Future<void> _push(String table, ContentRow row) async {
    await _gateway?.upsert(table, row);
  }

  Future<void> _drop(String table, String id) async {
    await _gateway?.delete(table, id);
  }

  // ---------------------------------------------------------------- subjects

  /// Subjects are the top of the content tree, so a board-scoped one is what
  /// makes "Class 10 Bihar Board Science" a real place to put videos and notes
  /// instead of a phrase in someone's head.
  Future<List<Subject>> subjects(String classId) =>
      (_db.select(_db.subjects)
            ..where((t) => t.classId.equals(classId))
            ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
          .get();

  Future<Subject?> _subject(String id) => (_db.select(
    _db.subjects,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  /// `sub-class-10-bihar-science`, or `sub-class-10-science` when the subject
  /// belongs to every board. Readable ids keep a hand-written SQL fix possible.
  static String newSubjectId({
    required String classId,
    required String? boardId,
    required String nameEnglish,
  }) {
    String slug(String value) => value
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    final board = boardId == null
        ? ''
        : '-${slug(boardId.replaceFirst('board-', ''))}';
    return 'sub-$classId$board-${slug(nameEnglish)}';
  }

  Future<String> saveSubject({
    String? id,
    required String classId,
    String? boardId,
    required String nameEnglish,
    String nameHindi = '',
    String accentColor = 'F1951A',
    int displayOrder = 0,
  }) async {
    final english = nameEnglish.trim();
    if (english.isEmpty) throw StateError('Subject name is required.');
    final color = accentColor.trim().replaceFirst('#', '').toUpperCase();
    if (!RegExp(r'^[0-9A-F]{6}$').hasMatch(color)) {
      throw StateError('Pick one of the listed colours.');
    }

    final clashQuery = _db.select(_db.subjects)
      ..where((t) => t.classId.equals(classId) & t.nameEnglish.equals(english))
      ..where(
        (t) => boardId == null ? t.boardId.isNull() : t.boardId.equals(boardId),
      );
    if (id != null) clashQuery.where((t) => t.id.equals(id).not());
    final clash = await clashQuery.getSingleOrNull();
    if (clash != null) {
      throw StateError(
        'This class already has a $english subject for that board.',
      );
    }

    final subjectId =
        id ??
        newSubjectId(classId: classId, boardId: boardId, nameEnglish: english);
    final previous = id == null ? null : await _subject(subjectId);
    await _db
        .into(_db.subjects)
        .insertOnConflictUpdate(
          SubjectsCompanion.insert(
            id: subjectId,
            classId: classId,
            boardId: Value(boardId),
            nameHindi: nameHindi.trim(),
            nameEnglish: english,
            accentColor: Value(color),
            displayOrder: Value(displayOrder),
          ),
        );
    try {
      await _push(
        RemoteTables.subjects,
        RemoteContent.subjectToRow((await _subject(subjectId))!),
      );
    } on RemoteFailure {
      if (previous == null) {
        await (_db.delete(
          _db.subjects,
        )..where((t) => t.id.equals(subjectId))).go();
      } else {
        await _db.into(_db.subjects).insertOnConflictUpdate(previous);
      }
      rethrow;
    }
    return subjectId;
  }

  // ---------------------------------------------------------------- chapters

  Future<List<Chapter>> chapters(String subjectId) =>
      (_db.select(_db.chapters)
            ..where((t) => t.subjectId.equals(subjectId))
            ..orderBy([(t) => OrderingTerm.asc(t.number)]))
          .get();

  Future<Chapter?> _chapter(String id) => (_db.select(
    _db.chapters,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<String> saveChapter({
    String? id,
    required String subjectId,
    required int number,
    required String title,
    String titleHindi = '',
    String summary = '',
  }) async {
    // Both of these mirror a Postgres check (title <> '' and number >= 1), so
    // saying it here is what turns a raw server error into a sentence.
    if (title.trim().isEmpty) throw StateError('Chapter title is required.');
    if (number < 1) throw StateError('Chapter numbers start at 1.');

    final clash =
        await (_db.select(_db.chapters)..where(
              (t) =>
                  t.subjectId.equals(subjectId) &
                  t.number.equals(number) &
                  (id == null ? const Constant(true) : t.id.equals(id).not()),
            ))
            .getSingleOrNull();
    if (clash != null) {
      throw StateError('Chapter $number already exists in this subject.');
    }

    final chapterId = id ?? _uuid.v4();
    final previous = id == null ? null : await _chapter(chapterId);
    await _db
        .into(_db.chapters)
        .insertOnConflictUpdate(
          ChaptersCompanion.insert(
            id: chapterId,
            subjectId: subjectId,
            number: number,
            title: title.trim(),
            titleHindi: Value(titleHindi.trim()),
            summary: Value(summary.trim()),
          ),
        );
    try {
      await _push(
        RemoteTables.chapters,
        RemoteContent.chapterToRow((await _chapter(chapterId))!),
      );
    } on RemoteFailure {
      await _restoreChapter(chapterId, previous);
      rethrow;
    }
    return chapterId;
  }

  /// The backend cascades to lessons and tests; this device has no cascades, so
  /// it removes its own children here.
  Future<void> deleteChapter(String id) async {
    await _drop(RemoteTables.chapters, id);
    await _db.transaction(() async {
      final lessons = await (_db.select(
        _db.lessons,
      )..where((t) => t.chapterId.equals(id))).get();
      for (final lesson in lessons) {
        await (_db.delete(
          _db.lessonProgress,
        )..where((t) => t.lessonId.equals(lesson.id))).go();
      }
      await (_db.delete(
        _db.lessons,
      )..where((t) => t.chapterId.equals(id))).go();

      final tests = await (_db.select(
        _db.tests,
      )..where((t) => t.chapterId.equals(id))).get();
      for (final test in tests) {
        await _drop(RemoteTables.tests, test.id);
        await _deleteTestLocally(test.id);
      }

      await (_db.update(_db.resources)..where((t) => t.chapterId.equals(id)))
          .write(const ResourcesCompanion(chapterId: Value<String?>(null)));
      await (_db.delete(_db.chapters)..where((t) => t.id.equals(id))).go();
    });
  }

  // ----------------------------------------------------------------- lessons

  Future<List<Lesson>> lessons(String chapterId) =>
      (_db.select(_db.lessons)
            ..where((t) => t.chapterId.equals(chapterId))
            ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
          .get();

  Future<Lesson?> _lesson(String id) => (_db.select(
    _db.lessons,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<String> saveLesson({
    String? id,
    required String chapterId,
    required String title,
    String description = '',
    String? youtubeUrl,
    int durationSeconds = 0,
    int displayOrder = 0,
    bool isPublished = false,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) throw StateError('Title is required.');
    if (youtubeUrl != null && youtubeUrl.trim().isEmpty) youtubeUrl = null;

    final clash =
        await (_db.select(_db.lessons)..where(
              (t) =>
                  t.chapterId.equals(chapterId) &
                  t.title.equals(trimmed) &
                  (id == null ? const Constant(true) : t.id.equals(id).not()),
            ))
            .getSingleOrNull();
    if (clash != null) {
      throw StateError(
        'A lesson with this title already exists in the chapter.',
      );
    }

    final lessonId = id ?? _uuid.v4();
    final previous = id == null ? null : await _lesson(lessonId);
    await _db
        .into(_db.lessons)
        .insertOnConflictUpdate(
          LessonsCompanion.insert(
            id: lessonId,
            chapterId: chapterId,
            title: trimmed,
            description: Value(description.trim()),
            youtubeUrl: Value(youtubeUrl?.trim()),
            durationSeconds: Value(durationSeconds),
            displayOrder: Value(displayOrder),
            isPublished: Value(isPublished),
          ),
        );
    try {
      await _push(
        RemoteTables.lessons,
        RemoteContent.lessonToRow((await _lesson(lessonId))!),
      );
    } on RemoteFailure {
      await _restoreLesson(lessonId, previous);
      rethrow;
    }
    return lessonId;
  }

  Future<void> setLessonPublished(String id, bool published) async {
    final before = await _lesson(id);
    if (before == null) throw StateError('That lesson no longer exists.');
    await (_db.update(_db.lessons)..where((t) => t.id.equals(id))).write(
      LessonsCompanion(isPublished: Value(published)),
    );
    try {
      await _push(
        RemoteTables.lessons,
        RemoteContent.lessonToRow((await _lesson(id))!),
      );
    } on RemoteFailure {
      await _db.into(_db.lessons).insertOnConflictUpdate(before);
      rethrow;
    }
  }

  Future<void> deleteLesson(String id) async {
    await _drop(RemoteTables.lessons, id);
    await _db.transaction(() async {
      await (_db.delete(
        _db.lessonProgress,
      )..where((t) => t.lessonId.equals(id))).go();
      await (_db.delete(_db.lessons)..where((t) => t.id.equals(id))).go();
    });
  }

  // --------------------------------------------------------------- resources

  Future<List<Resource>> resources({String? subjectId}) =>
      (_db.select(_db.resources)
            ..where(
              (t) => subjectId == null
                  ? const Constant(true)
                  : t.subjectId.equals(subjectId),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();

  Future<Resource?> _resource(String id) => (_db.select(
    _db.resources,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Uploads a file the admin attached so every student device can fetch it, and
  /// returns the URL to store on the row. Null means no backend is configured,
  /// in which case the file can only ever exist on this device.
  Future<String?> uploadFile({
    required String fileName,
    required List<int> bytes,
    required String contentType,
  }) async {
    final gateway = _gateway;
    if (gateway == null) return null;
    return gateway.uploadFile(
      fileName: fileName,
      bytes: bytes,
      contentType: contentType,
    );
  }

  /// Title is the only mandatory field. A file, a link, a chapter and a year
  /// can all be left out: the owner can register a handout first and attach
  /// the PDF afterwards, and an empty row then simply says "not saved on this
  /// device yet" on the student's screen instead of blocking the save.
  Future<String> saveResource({
    String? id,
    required String subjectId,
    String? chapterId,
    required String title,
    String description = '',
    required String kind,
    int? yearLabel,
    String? localFilePath,
    String? remoteUrl,
    int fileSizeBytes = 0,
    bool isPublished = false,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) throw StateError('Title is required.');

    final clash =
        await (_db.select(_db.resources)..where(
              (t) =>
                  t.subjectId.equals(subjectId) &
                  t.title.equals(trimmed) &
                  t.kind.equals(kind) &
                  (id == null ? const Constant(true) : t.id.equals(id).not()),
            ))
            .getSingleOrNull();
    if (clash != null) {
      throw StateError('A similar file already exists in this subject.');
    }

    final resourceId = id ?? _uuid.v4();
    final previous = id == null ? null : await _resource(resourceId);
    await _db
        .into(_db.resources)
        .insertOnConflictUpdate(
          ResourcesCompanion.insert(
            id: resourceId,
            subjectId: subjectId,
            chapterId: Value(chapterId),
            title: trimmed,
            description: Value(description.trim()),
            kind: kind,
            yearLabel: Value(yearLabel),
            localFilePath: Value(localFilePath),
            remoteUrl: Value(remoteUrl),
            fileSizeBytes: Value(fileSizeBytes),
            isPublished: Value(isPublished),
          ),
        );
    try {
      await _push(
        RemoteTables.resources,
        RemoteContent.resourceToRow((await _resource(resourceId))!),
      );
    } on RemoteFailure {
      await _restoreResource(resourceId, previous);
      rethrow;
    }
    return resourceId;
  }

  Future<void> setResourcePublished(String id, bool published) async {
    final before = await _resource(id);
    if (before == null) throw StateError('That file no longer exists.');
    await (_db.update(_db.resources)..where((t) => t.id.equals(id))).write(
      ResourcesCompanion(isPublished: Value(published)),
    );
    try {
      await _push(
        RemoteTables.resources,
        RemoteContent.resourceToRow((await _resource(id))!),
      );
    } on RemoteFailure {
      await _db.into(_db.resources).insertOnConflictUpdate(before);
      rethrow;
    }
  }

  Future<void> deleteResource(String id) async {
    await _drop(RemoteTables.resources, id);
    await (_db.delete(_db.resources)..where((t) => t.id.equals(id))).go();
  }

  // ------------------------------------------------------------ live classes

  Future<List<LiveClass>> liveClasses() => (_db.select(
    _db.liveClasses,
  )..orderBy([(t) => OrderingTerm.desc(t.scheduledStart)])).get();

  Future<LiveClass?> _liveClass(String id) => (_db.select(
    _db.liveClasses,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<String> saveLiveClass({
    String? id,
    required String subjectId,
    required String title,
    String description = '',
    required DateTime scheduledStart,
    String status = LiveClassStatuses.scheduled,
    String? youtubeUrl,
    bool isPublished = false,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) throw StateError('Title is required.');
    if (youtubeUrl != null && youtubeUrl.trim().isEmpty) youtubeUrl = null;

    final clash =
        await (_db.select(_db.liveClasses)..where(
              (t) =>
                  t.title.equals(trimmed) &
                  t.scheduledStart.equals(scheduledStart) &
                  (id == null ? const Constant(true) : t.id.equals(id).not()),
            ))
            .getSingleOrNull();
    if (clash != null) {
      throw StateError('This live class is already scheduled.');
    }

    final liveId = id ?? _uuid.v4();
    final previous = id == null ? null : await _liveClass(liveId);
    await _db
        .into(_db.liveClasses)
        .insertOnConflictUpdate(
          LiveClassesCompanion.insert(
            id: liveId,
            subjectId: subjectId,
            title: trimmed,
            description: Value(description.trim()),
            status: status,
            scheduledStart: scheduledStart,
            youtubeUrl: Value(youtubeUrl?.trim()),
            isPublished: Value(isPublished),
          ),
        );
    try {
      await _push(
        RemoteTables.liveClasses,
        RemoteContent.liveClassToRow((await _liveClass(liveId))!),
      );
    } on RemoteFailure {
      await _restoreLiveClass(liveId, previous);
      rethrow;
    }
    return liveId;
  }

  Future<void> setLiveClassPublished(String id, bool published) async {
    final before = await _liveClass(id);
    if (before == null) throw StateError('That live class no longer exists.');
    await (_db.update(_db.liveClasses)..where((t) => t.id.equals(id))).write(
      LiveClassesCompanion(isPublished: Value(published)),
    );
    try {
      await _push(
        RemoteTables.liveClasses,
        RemoteContent.liveClassToRow((await _liveClass(id))!),
      );
    } on RemoteFailure {
      await _db.into(_db.liveClasses).insertOnConflictUpdate(before);
      rethrow;
    }
  }

  Future<void> deleteLiveClass(String id) async {
    await _drop(RemoteTables.liveClasses, id);
    await (_db.delete(_db.liveClasses)..where((t) => t.id.equals(id))).go();
  }

  // ----------------------------------------------------------- announcements

  Future<List<Announcement>> announcements() => (_db.select(
    _db.announcements,
  )..orderBy([(t) => OrderingTerm.desc(t.publishedAt)])).get();

  Future<Announcement?> _announcement(String id) => (_db.select(
    _db.announcements,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<String> saveAnnouncement({
    String? id,
    required String title,
    required String body,
    String? classId,
    String priority = 'NORMAL',
    bool isActive = true,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty || body.trim().isEmpty) {
      throw StateError('Title and message are both required.');
    }

    final clash =
        await (_db.select(_db.announcements)..where(
              (t) =>
                  t.title.equals(trimmed) &
                  (id == null ? const Constant(true) : t.id.equals(id).not()),
            ))
            .getSingleOrNull();
    if (clash != null) {
      throw StateError('An announcement with this title already exists.');
    }

    final announcementId = id ?? _uuid.v4();
    final previous = id == null ? null : await _announcement(announcementId);
    await _db
        .into(_db.announcements)
        .insertOnConflictUpdate(
          AnnouncementsCompanion.insert(
            id: announcementId,
            title: trimmed,
            body: body.trim(),
            classId: Value(classId),
            priority: Value(priority),
            isActive: Value(isActive),
            publishedAt: Value(DateTime.now()),
          ),
        );
    try {
      await _push(
        RemoteTables.announcements,
        RemoteContent.announcementToRow((await _announcement(announcementId))!),
      );
    } on RemoteFailure {
      await _restoreAnnouncement(announcementId, previous);
      rethrow;
    }
    return announcementId;
  }

  Future<void> setAnnouncementActive(String id, bool active) async {
    final before = await _announcement(id);
    if (before == null) throw StateError('That announcement no longer exists.');
    await (_db.update(_db.announcements)..where((t) => t.id.equals(id))).write(
      AnnouncementsCompanion(isActive: Value(active)),
    );
    try {
      await _push(
        RemoteTables.announcements,
        RemoteContent.announcementToRow((await _announcement(id))!),
      );
    } on RemoteFailure {
      await _db.into(_db.announcements).insertOnConflictUpdate(before);
      rethrow;
    }
  }

  Future<void> deleteAnnouncement(String id) async {
    await _drop(RemoteTables.announcements, id);
    await (_db.delete(_db.announcements)..where((t) => t.id.equals(id))).go();
  }

  // ------------------------------------------------------------------- tests

  Future<List<Test>> tests({String? chapterId}) =>
      (_db.select(_db.tests)
            ..where(
              (t) => chapterId == null
                  ? const Constant(true)
                  : t.chapterId.equals(chapterId),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.title)]))
          .get();

  Future<Test?> _test(String id) =>
      (_db.select(_db.tests)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<String> saveTest({
    String? id,
    required String chapterId,
    required String title,
    int timeLimitMinutes = 20,
    double marksPerQuestion = 1,
    double negativeMarking = 0,
    bool isPublished = false,
  }) async {
    final trimmed = title.trim();
    if (trimmed.isEmpty) throw StateError('Title is required.');
    // These are the checks the tests table carries in Postgres. Naming them
    // here is what turns a raw constraint error into a sentence.
    if (timeLimitMinutes < 1) {
      throw StateError('The time limit has to be at least one minute.');
    }
    if (marksPerQuestion <= 0) {
      throw StateError('Marks per question has to be more than zero.');
    }
    if (negativeMarking < 0) {
      throw StateError('Negative marking cannot be a negative number.');
    }

    final testId = id ?? _uuid.v4();
    final previous = id == null ? null : await _test(testId);
    await _db
        .into(_db.tests)
        .insertOnConflictUpdate(
          TestsCompanion.insert(
            id: testId,
            chapterId: chapterId,
            title: trimmed,
            timeLimitMinutes: Value(timeLimitMinutes),
            marksPerQuestion: Value(marksPerQuestion),
            negativeMarking: Value(negativeMarking),
            isPublished: Value(isPublished),
          ),
        );
    try {
      await _push(
        RemoteTables.tests,
        RemoteContent.testToRow((await _test(testId))!),
      );
    } on RemoteFailure {
      await _restoreTest(testId, previous);
      rethrow;
    }
    return testId;
  }

  Future<void> setTestPublished(String id, bool published) async {
    final before = await _test(id);
    if (before == null) throw StateError('That test no longer exists.');
    await (_db.update(_db.tests)..where((t) => t.id.equals(id))).write(
      TestsCompanion(isPublished: Value(published)),
    );
    try {
      await _push(
        RemoteTables.tests,
        RemoteContent.testToRow((await _test(id))!),
      );
    } on RemoteFailure {
      await _db.into(_db.tests).insertOnConflictUpdate(before);
      rethrow;
    }
  }

  Future<List<TestQuestion>> questions(String testId) =>
      (_db.select(_db.testQuestions)
            ..where((t) => t.testId.equals(testId))
            ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
          .get();

  Future<TestQuestion?> _question(String id) => (_db.select(
    _db.testQuestions,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<String> saveQuestion({
    String? id,
    required String testId,
    required String prompt,
    required String optionA,
    required String optionB,
    required String optionC,
    required String optionD,
    required String correctOption,
    String explanation = '',
    double marks = 1,
    int displayOrder = 0,
  }) async {
    if (!const ['A', 'B', 'C', 'D'].contains(correctOption)) {
      throw StateError('Mark one option as correct (A, B, C or D).');
    }
    // Mirrors the questions table checks: a question needs text and marks above
    // zero, and all four options have to be filled in.
    if (prompt.trim().isEmpty) throw StateError('Question text is required.');
    if (marks <= 0) throw StateError('Marks have to be more than zero.');

    final questionId = id ?? _uuid.v4();
    final previous = id == null ? null : await _question(questionId);
    await _db
        .into(_db.testQuestions)
        .insertOnConflictUpdate(
          TestQuestionsCompanion.insert(
            id: questionId,
            testId: testId,
            prompt: prompt.trim(),
            optionA: optionA.trim(),
            optionB: optionB.trim(),
            optionC: optionC.trim(),
            optionD: optionD.trim(),
            correctOption: correctOption,
            explanation: Value(explanation.trim()),
            marks: Value(marks),
            displayOrder: Value(displayOrder),
          ),
        );
    try {
      await _push(
        RemoteTables.testQuestions,
        RemoteContent.questionToRow((await _question(questionId))!),
      );
    } on RemoteFailure {
      await _restoreQuestion(questionId, previous);
      rethrow;
    }
    return questionId;
  }

  Future<void> deleteQuestion(String id) async {
    await _drop(RemoteTables.testQuestions, id);
    await (_db.delete(_db.testQuestions)..where((t) => t.id.equals(id))).go();
  }

  Future<void> deleteTest(String id) async {
    await _drop(RemoteTables.tests, id);
    await _deleteTestLocally(id);
  }

  /// The server cascades to questions; this device has no cascade, so it clears
  /// its own answer rows before dropping the attempts that reference them.
  Future<void> _deleteTestLocally(String id) => _db.transaction(() async {
    final questions = await (_db.select(
      _db.testQuestions,
    )..where((t) => t.testId.equals(id))).get();
    final attempts = await (_db.select(
      _db.testAttempts,
    )..where((t) => t.testId.equals(id))).get();
    for (final attempt in attempts) {
      await (_db.delete(
        _db.testAttemptAnswers,
      )..where((t) => t.attemptId.equals(attempt.id))).go();
    }
    await (_db.delete(
      _db.testAttempts,
    )..where((t) => t.testId.equals(id))).go();
    for (final question in questions) {
      await (_db.delete(
        _db.testAttemptAnswers,
      )..where((t) => t.questionId.equals(question.id))).go();
    }
    await (_db.delete(
      _db.testQuestions,
    )..where((t) => t.testId.equals(id))).go();
    await (_db.delete(_db.tests)..where((t) => t.id.equals(id))).go();
  });

  // ------------------------------------------------------------- rollbacks
  //
  // A save the server refused has already overwritten the local row, so the
  // old copy goes back with an upsert, not a plain insert - inserting would
  // fail on the very id it is trying to restore.

  Future<void> _restoreChapter(String id, Chapter? previous) async {
    if (previous == null) {
      await (_db.delete(_db.chapters)..where((t) => t.id.equals(id))).go();
    } else {
      await _db.into(_db.chapters).insertOnConflictUpdate(previous);
    }
  }

  Future<void> _restoreLesson(String id, Lesson? previous) async {
    if (previous == null) {
      await (_db.delete(_db.lessons)..where((t) => t.id.equals(id))).go();
    } else {
      await _db.into(_db.lessons).insertOnConflictUpdate(previous);
    }
  }

  Future<void> _restoreResource(String id, Resource? previous) async {
    if (previous == null) {
      await (_db.delete(_db.resources)..where((t) => t.id.equals(id))).go();
    } else {
      await _db.into(_db.resources).insertOnConflictUpdate(previous);
    }
  }

  Future<void> _restoreLiveClass(String id, LiveClass? previous) async {
    if (previous == null) {
      await (_db.delete(_db.liveClasses)..where((t) => t.id.equals(id))).go();
    } else {
      await _db.into(_db.liveClasses).insertOnConflictUpdate(previous);
    }
  }

  Future<void> _restoreAnnouncement(String id, Announcement? previous) async {
    if (previous == null) {
      await (_db.delete(_db.announcements)..where((t) => t.id.equals(id))).go();
    } else {
      await _db.into(_db.announcements).insertOnConflictUpdate(previous);
    }
  }

  Future<void> _restoreTest(String id, Test? previous) async {
    if (previous == null) {
      await (_db.delete(_db.tests)..where((t) => t.id.equals(id))).go();
    } else {
      await _db.into(_db.tests).insertOnConflictUpdate(previous);
    }
  }

  Future<void> _restoreQuestion(String id, TestQuestion? previous) async {
    if (previous == null) {
      await (_db.delete(_db.testQuestions)..where((t) => t.id.equals(id))).go();
    } else {
      await _db.into(_db.testQuestions).insertOnConflictUpdate(previous);
    }
  }
}
