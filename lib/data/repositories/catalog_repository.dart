import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';
import '../local/tables.dart';

class ResourceFilter {
  const ResourceFilter({
    this.classId,
    this.subjectId,
    this.chapterId,
    this.kind,
    this.yearLabel,
    this.search,
  });

  final String? classId;
  final String? subjectId;
  final String? chapterId;
  final String? kind;
  final int? yearLabel;
  final String? search;
}

class RecentViewItem {
  const RecentViewItem({
    required this.targetKind,
    required this.targetId,
    required this.title,
    required this.viewedAt,
  });

  final String targetKind;
  final String targetId;
  final String title;
  final DateTime viewedAt;
}

/// A lesson that has a video, carrying the chapter and subject it belongs to so
/// a card can name its context without extra queries.
class VideoLesson {
  const VideoLesson({
    required this.lesson,
    required this.chapter,
    required this.subject,
  });

  final Lesson lesson;
  final Chapter chapter;
  final Subject subject;
}

class CatalogRepository {
  CatalogRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();
  static const _seededKey = 'catalog_seeded_v1';

  /// Structural curriculum data only (classes, boards, subject names).
  /// Chapters, lessons and resources stay empty until an admin uploads them.
  Future<void> seedStructureIfEmpty() async {
    final marker =
        await (_db.select(_db.appSettings)
              ..where((t) => t.key.equals(_seededKey))
              ..limit(1))
            .getSingleOrNull();
    if (marker != null) return;

    final classIds = <String, String>{};
    for (final level in [6, 7, 8, 9, 10]) {
      final id = 'class-$level';
      classIds['$level'] = id;
      await _db
          .into(_db.schoolClasses)
          .insertOnConflictUpdate(
            SchoolClassesCompanion.insert(
              id: id,
              level: level,
              nameHindi: 'कक्षा $level',
              nameEnglish: 'Class $level',
              displayOrder: Value(level),
            ),
          );
    }

    for (final (id, hindi, english, order) in [
      ('board-cbse', 'सीबीएसई', 'CBSE', 1),
      ('board-icse', 'आईसीएसई', 'ICSE', 2),
      ('board-up', 'उत्तर प्रदेश बोर्ड', 'UP Board', 3),
      ('board-bihar', 'बिहार बोर्ड', 'Bihar Board', 4),
    ]) {
      await _db
          .into(_db.boards)
          .insertOnConflictUpdate(
            BoardsCompanion.insert(
              id: id,
              nameHindi: hindi,
              nameEnglish: english,
              displayOrder: Value(order),
            ),
          );
    }

    const subjects = [
      ('गणित', 'Mathematics', 'F1951A'),
      ('विज्ञान', 'Science', '1B7A3D'),
      ('हिन्दी', 'Hindi', 'B20308'),
      ('अंग्रेज़ी', 'English', '091B71'),
      ('सामाजिक विज्ञान', 'Social Science', '7A4A9E'),
    ];
    for (final entry in classIds.entries) {
      var order = 0;
      for (final (hindi, english, color) in subjects) {
        order++;
        await _db
            .into(_db.subjects)
            .insertOnConflictUpdate(
              SubjectsCompanion.insert(
                id: 'sub-${entry.value}-${english.toLowerCase().replaceAll(' ', '-')}',
                classId: entry.value,
                nameHindi: hindi,
                nameEnglish: english,
                accentColor: Value(color),
                displayOrder: Value(order),
              ),
            );
      }
    }

    await _db
        .into(_db.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: _seededKey, value: '1'),
        );
  }

  /// The classes a student can belong to. The "All Classes" row the admin uses
  /// for shared content is left out: a student must never be able to pick it.
  Future<List<SchoolClass>> classes() =>
      (_db.select(_db.schoolClasses)
            ..where((t) => t.id.equals(ClassIds.all).not())
            ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
          .get();

  /// The class list the admin panel offers: "All Classes" first, then the real
  /// ones. The first entry is built here rather than read from the table, so the
  /// panel keeps the option even on a device whose backend has not been given the
  /// matching row yet.
  Future<List<SchoolClass>> classesForAdmin() async => [
    const SchoolClass(
      id: ClassIds.all,
      // Never shown: level is only carried so the row fits the server's check.
      level: 1,
      nameHindi: 'सभी कक्षाएं',
      nameEnglish: 'All Classes',
      displayOrder: 0,
    ),
    ...await classes(),
  ];

  Future<List<Board>> boards() => (_db.select(
    _db.boards,
  )..orderBy([(t) => OrderingTerm.asc(t.displayOrder)])).get();

  /// Subjects for a class.
  ///
  /// [boardId] narrows the list to that board plus the subjects carrying no
  /// board at all - those are shared by every syllabus, which is how the
  /// original seeded list still shows up. Null asks for every subject of the
  /// class, which is what these screens did before boards were wired up.
  ///
  /// Subjects filed under ClassIds.all (the admin's "All Classes") are always
  /// included, which is what makes one upload visible to every class.
  Future<List<Subject>> subjectsForClass(
    String classId, {
    String? boardId,
  }) async {
    final query = _db.select(
      _db.subjects,
    )..where((t) => t.classId.equals(classId) | t.classId.equals(ClassIds.all));
    if (boardId != null) {
      query.where((t) => t.boardId.equals(boardId) | t.boardId.isNull());
    }
    query.orderBy([(t) => OrderingTerm.asc(t.displayOrder)]);
    return query.get();
  }

  /// Boards that really have subjects in this class, so a board filter only
  /// offers choices that can actually change the list.
  Future<List<Board>> boardsForClass(String classId) async {
    final subjects = await subjectsForClass(classId);
    final used = {for (final s in subjects) s.boardId}
        .whereType<String>()
        .toSet();
    if (used.isEmpty) return const [];
    final all = await boards();
    return [
      for (final board in all)
        if (used.contains(board.id)) board,
    ];
  }

  Future<Board?> boardById(String id) =>
      (_db.select(_db.boards)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Subject?> subjectById(String id) => (_db.select(
    _db.subjects,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<SchoolClass?> classById(String id) => (_db.select(
    _db.schoolClasses,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Chapter>> chaptersForSubject(String subjectId) =>
      (_db.select(_db.chapters)
            ..where((t) => t.subjectId.equals(subjectId))
            ..orderBy([(t) => OrderingTerm.asc(t.number)]))
          .get();

  Future<List<Lesson>> lessonsForChapter(String chapterId) =>
      (_db.select(_db.lessons)
            ..where(
              (t) => t.chapterId.equals(chapterId) & t.isPublished.equals(true),
            )
            ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
          .get();

  Future<Chapter?> chapterById(String id) => (_db.select(
    _db.chapters,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Every published lesson that actually has a video, in class → chapter →
  /// lesson order.
  ///
  /// Used by every thumbnail grid in the app: the Home feed, the subject page, a
  /// chapter's own lessons and the lesson screen's "Up next" queue. There is no
  /// limit on purpose - a lesson the admin published must always reach the
  /// student's screen.
  Future<List<VideoLesson>> videoLessons({
    String? classId,
    String? subjectId,
    String? chapterId,
  }) async {
    final List<Subject> subjects;
    Chapter? onlyChapter;
    if (chapterId != null) {
      onlyChapter = await chapterById(chapterId);
      if (onlyChapter == null) return const [];
      final subject = await subjectById(onlyChapter.subjectId);
      subjects = subject == null ? const [] : [subject];
    } else if (subjectId != null) {
      final one = await subjectById(subjectId);
      subjects = one == null ? const [] : [one];
    } else if (classId != null) {
      subjects = await subjectsForClass(classId);
    } else {
      subjects = await (_db.select(
        _db.subjects,
      )..orderBy([(t) => OrderingTerm.asc(t.displayOrder)])).get();
    }

    final out = <VideoLesson>[];
    for (final subject in subjects) {
      final chapters = onlyChapter == null
          ? await chaptersForSubject(subject.id)
          : [onlyChapter];
      for (final chapter in chapters) {
        final lessons =
            await (_db.select(_db.lessons)
                  ..where(
                    (t) =>
                        t.chapterId.equals(chapter.id) &
                        t.isPublished.equals(true) &
                        (t.youtubeUrl.isNotNull() |
                            t.localVideoPath.isNotNull()),
                  )
                  ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
                .get();
        for (final lesson in lessons) {
          out.add(
            VideoLesson(lesson: lesson, chapter: chapter, subject: subject),
          );
        }
      }
    }
    return out;
  }

  Future<Lesson?> lessonById(String id) => (_db.select(
    _db.lessons,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Resource?> resourceById(String id) => (_db.select(
    _db.resources,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Test?> testById(String id) =>
      (_db.select(_db.tests)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<LiveClass?> liveClassById(String id) => (_db.select(
    _db.liveClasses,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<int> lessonCountForSubject(String subjectId) async {
    final chapters = await chaptersForSubject(subjectId);
    if (chapters.isEmpty) return 0;
    final count = _db.lessons.id.count();
    final row =
        await (_db.selectOnly(_db.lessons)
              ..addColumns([count])
              ..where(
                _db.lessons.chapterId.isIn(chapters.map((c) => c.id).toList()) &
                    _db.lessons.isPublished.equals(true),
              ))
            .getSingle();
    return row.read(count)?.toInt() ?? 0;
  }

  Future<List<Resource>> resources(ResourceFilter filter) async {
    final subjectIdFilter = filter.subjectId;
    final query = _db.select(_db.resources)
      ..where((t) => t.isPublished.equals(true));

    if (subjectIdFilter != null) {
      query.where((t) => t.subjectId.equals(subjectIdFilter));
    }
    if (filter.chapterId != null) {
      query.where((t) => t.chapterId.equals(filter.chapterId!));
    }
    if (filter.kind != null) {
      query.where((t) => t.kind.equals(filter.kind!));
    }
    if (filter.yearLabel != null) {
      query.where((t) => t.yearLabel.equals(filter.yearLabel!));
    }
    final search = filter.search?.trim().toLowerCase();
    if (search != null && search.isNotEmpty) {
      query.where(
        (t) =>
            t.title.lower().contains(search) |
            t.description.lower().contains(search),
      );
    }
    if (filter.classId != null) {
      final ids = await _subjectIdsOfClass(filter.classId!);
      query.where((t) => t.subjectId.isIn(ids));
    }
    query
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
      ..limit(200);
    return query.get();
  }

  /// Every subject whose content this class can see: its own plus the ones the
  /// admin filed under "All Classes". This is the one place the Library, live
  /// class and test lists decide what a class is allowed to read, so shared
  /// content appears for Classes 6 to 10 from here.
  Future<List<String>> _subjectIdsOfClass(String classId) async {
    final rows =
        await (_db.select(_db.subjects)..where(
              (t) => t.classId.equals(classId) | t.classId.equals(ClassIds.all),
            ))
            .get();
    return rows.map((r) => r.id).toList();
  }

  /// Distinct years that actually have published content, newest first.
  Future<List<int>> resourceYears({String? classId, String? subjectId}) async {
    final year = _db.resources.yearLabel;
    final query = _db.selectOnly(_db.resources, distinct: true)
      ..addColumns([year])
      ..where(_db.resources.isPublished.equals(true) & year.isNotNull())
      ..orderBy([OrderingTerm.desc(year)]);
    if (subjectId != null) {
      query.where(_db.resources.subjectId.equals(subjectId));
    }
    if (classId != null) {
      query.where(
        _db.resources.subjectId.isIn(await _subjectIdsOfClass(classId)),
      );
    }
    final rows = await query.get();
    return rows.map((r) => r.read(year)).whereType<int>().toList();
  }

  Future<List<Announcement>> activeAnnouncements({String? classId}) {
    // An announcement aimed at "All Classes" reads the same as one with no
    // class at all, so the two audience choices in the panel cannot disagree.
    final matchesClass = classId == null
        ? const Constant<bool>(true)
        : _db.announcements.classId.isNull() |
              _db.announcements.classId.equals(classId) |
              _db.announcements.classId.equals(ClassIds.all);
    return (_db.select(_db.announcements)
          ..where((t) => t.isActive.equals(true) & matchesClass)
          ..orderBy([(t) => OrderingTerm.desc(t.publishedAt)]))
        .get();
  }

  Future<List<LiveClass>> liveClasses({String? classId}) async {
    final subjects = classId == null ? null : await _subjectIdsOfClass(classId);
    final query = _db.select(_db.liveClasses)
      ..where((t) => t.isPublished.equals(true))
      ..orderBy([(t) => OrderingTerm.asc(t.scheduledStart)]);
    if (subjects != null) {
      query.where((t) => t.subjectId.isIn(subjects));
    }
    return query.get();
  }

  Future<List<Test>> publishedTestsForChapter(String chapterId) =>
      (_db.select(_db.tests)..where(
            (t) => t.chapterId.equals(chapterId) & t.isPublished.equals(true),
          ))
          .get();

  Future<List<Test>> publishedTestsForSubject(String subjectId) async {
    final chapters = await chaptersForSubject(subjectId);
    if (chapters.isEmpty) return const [];
    return (_db.select(_db.tests)..where(
          (t) =>
              t.chapterId.isIn(chapters.map((c) => c.id).toList()) &
              t.isPublished.equals(true),
        ))
        .get();
  }

  Future<List<Test>> publishedTestsForClass(String classId) async {
    final subjects = await _subjectIdsOfClass(classId);
    if (subjects.isEmpty) return const [];
    final chapters = await (_db.select(
      _db.chapters,
    )..where((t) => t.subjectId.isIn(subjects))).get();
    if (chapters.isEmpty) return const [];
    return (_db.select(_db.tests)
          ..where(
            (t) =>
                t.chapterId.isIn(chapters.map((c) => c.id).toList()) &
                t.isPublished.equals(true),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.title)]))
        .get();
  }

  Future<List<TestQuestion>> questionsForTest(String testId) =>
      (_db.select(_db.testQuestions)
            ..where((t) => t.testId.equals(testId))
            ..orderBy([(t) => OrderingTerm.asc(t.displayOrder)]))
          .get();

  Future<void> toggleBookmark({
    required String studentId,
    required String targetKind,
    required String targetId,
  }) async {
    final existing =
        await (_db.select(_db.bookmarks)..where(
              (t) =>
                  t.studentId.equals(studentId) &
                  t.targetKind.equals(targetKind) &
                  t.targetId.equals(targetId),
            ))
            .getSingleOrNull();
    if (existing == null) {
      await _db
          .into(_db.bookmarks)
          .insert(
            BookmarksCompanion.insert(
              studentId: studentId,
              targetKind: targetKind,
              targetId: targetId,
            ),
          );
    } else {
      await _db.delete(_db.bookmarks).delete(existing);
    }
  }

  Future<Set<String>> bookmarkedIds(String studentId, String targetKind) async {
    final rows =
        await (_db.select(_db.bookmarks)..where(
              (t) =>
                  t.studentId.equals(studentId) &
                  t.targetKind.equals(targetKind),
            ))
            .get();
    return rows.map((r) => r.targetId).toSet();
  }

  Future<void> markViewed({
    required String studentId,
    required String targetKind,
    required String targetId,
  }) => _db
      .into(_db.recentViews)
      .insertOnConflictUpdate(
        RecentViewsCompanion.insert(
          studentId: studentId,
          targetKind: targetKind,
          targetId: targetId,
          viewedAt: Value(DateTime.now()),
        ),
      );

  Future<List<RecentView>> recentlyViewed(String studentId, {int limit = 10}) =>
      (_db.select(_db.recentViews)
            ..where((t) => t.studentId.equals(studentId))
            ..orderBy([(t) => OrderingTerm.desc(t.viewedAt)])
            ..limit(limit))
          .get();

  /// Recent views with the lesson/resource title resolved, so the UI never
  /// shows a bare id. Items whose content was deleted are skipped.
  Future<List<RecentViewItem>> recentViewItems(
    String studentId, {
    int limit = 10,
  }) async {
    final rows = await recentlyViewed(studentId, limit: limit);
    if (rows.isEmpty) return const [];

    final lessonIds = rows
        .where((r) => r.targetKind == TrackableKinds.lesson)
        .map((r) => r.targetId)
        .toSet()
        .toList();
    final resourceIds = rows
        .where((r) => r.targetKind == TrackableKinds.resource)
        .map((r) => r.targetId)
        .toSet()
        .toList();
    final testIds = rows
        .where((r) => r.targetKind == TrackableKinds.test)
        .map((r) => r.targetId)
        .toSet()
        .toList();

    final titles = <String, String>{};
    if (lessonIds.isNotEmpty) {
      final lessons = await (_db.select(
        _db.lessons,
      )..where((t) => t.id.isIn(lessonIds))).get();
      for (final l in lessons) {
        titles[l.id] = l.title;
      }
    }
    if (resourceIds.isNotEmpty) {
      final resources = await (_db.select(
        _db.resources,
      )..where((t) => t.id.isIn(resourceIds))).get();
      for (final r in resources) {
        titles[r.id] = r.title;
      }
    }
    if (testIds.isNotEmpty) {
      final tests = await (_db.select(
        _db.tests,
      )..where((t) => t.id.isIn(testIds))).get();
      for (final t in tests) {
        titles[t.id] = t.title;
      }
    }

    return [
      for (final row in rows)
        if (titles[row.targetId] != null)
          RecentViewItem(
            targetKind: row.targetKind,
            targetId: row.targetId,
            title: titles[row.targetId]!,
            viewedAt: row.viewedAt,
          ),
    ];
  }

  Future<void> saveLessonProgressRow({
    required String studentId,
    required String lessonId,
    required double percent,
  }) async {
    final completed = percent >= 99.5;
    await _db
        .into(_db.lessonProgress)
        .insertOnConflictUpdate(
          LessonProgressCompanion.insert(
            studentId: studentId,
            lessonId: lessonId,
            percent: Value(percent),
            completed: Value(completed),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<LessonProgressRow?> progressFor(String studentId, String lessonId) =>
      (_db.select(_db.lessonProgress)..where(
            (t) => t.studentId.equals(studentId) & t.lessonId.equals(lessonId),
          ))
          .getSingleOrNull();

  Future<List<LessonProgressRow>> allProgress(String studentId) => (_db.select(
    _db.lessonProgress,
  )..where((t) => t.studentId.equals(studentId))).get();

  String newId(String prefix) => '$prefix-${_uuid.v4()}';
}
