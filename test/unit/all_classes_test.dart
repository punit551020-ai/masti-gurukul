import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/data/local/tables.dart';
import 'package:masti_gurukul/data/repositories/admin_repository.dart';
import 'package:masti_gurukul/data/repositories/catalog_repository.dart';

/// One upload, every class. The admin files content under ClassIds.all and a
/// Class 6 as well as a Class 10 student must see it without a second copy.
void main() {
  late AppDatabase db;
  late AdminRepository admin;
  late CatalogRepository catalog;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    admin = AdminRepository(db);
    catalog = CatalogRepository(db);
    await catalog.seedStructureIfEmpty();
  });

  tearDown(() async {
    await db.close();
  });

  /// The shared subject the owner would create: All Classes -> General Science.
  Future<String> sharedSubject() => admin.saveSubject(
    classId: ClassIds.all,
    nameEnglish: 'General Science',
    nameHindi: 'सामान्य विज्ञान',
  );

  group('the class list', () {
    test('students are never offered "All Classes"', () async {
      final names = (await catalog.classes())
          .map((c) => c.nameEnglish)
          .toList();
      expect(names, ['Class 6', 'Class 7', 'Class 8', 'Class 9', 'Class 10']);
      expect(names, isNot(contains('All Classes')));
    });

    test(
      'the admin panel opens with "All Classes" above the real classes',
      () async {
        final forAdmin = await catalog.classesForAdmin();
        expect(forAdmin.first.id, ClassIds.all);
        expect(forAdmin.first.nameEnglish, 'All Classes');
        expect(forAdmin.length, 6);
        expect(forAdmin.skip(1).map((c) => c.id), [
          'class-6',
          'class-7',
          'class-8',
          'class-9',
          'class-10',
        ]);
      },
    );

    test(
      'the shared class is not stored as a row, so sync cannot drop it',
      () async {
        // classesForAdmin() builds it, so a device whose backend has not been
        // given the matching row yet still has the option.
        expect(await catalog.classById(ClassIds.all), isNull);
        expect((await catalog.classesForAdmin()).first.id, ClassIds.all);
      },
    );
  });

  group('content filed under "All Classes"', () {
    test('is a subject of every class', () async {
      final id = await sharedSubject();
      for (final level in [6, 7, 8, 9, 10]) {
        final subjects = await catalog.subjectsForClass('class-$level');
        expect(
          subjects.map((s) => s.id),
          contains(id),
          reason: 'Class $level must see the shared subject',
        );
      }
      // A board filter still keeps it: a shared subject with no board belongs
      // to every syllabus, exactly like the seeded list does.
      final cbse = await catalog.subjectsForClass(
        'class-9',
        boardId: 'board-cbse',
      );
      expect(cbse.map((s) => s.id), contains(id));
    });

    test('its files reach every class library', () async {
      final subjectId = await sharedSubject();
      await admin.saveResource(
        subjectId: subjectId,
        title: 'Revision notes',
        kind: ResourceKinds.pdf,
        remoteUrl: 'https://bucket.example/library/revision.pdf',
        isPublished: true,
      );

      for (final level in [6, 10]) {
        final found = await catalog.resources(
          ResourceFilter(classId: 'class-$level'),
        );
        expect(
          found.map((r) => r.title),
          contains('Revision notes'),
          reason: 'Class $level must list the shared file',
        );
      }
      // Drafts stay invisible even when the class matches.
      await admin.saveResource(
        subjectId: subjectId,
        title: 'Staff room copy',
        kind: ResourceKinds.notes,
      );
      final withDraft = await catalog.resources(
        ResourceFilter(classId: 'class-8'),
      );
      expect(withDraft.map((r) => r.title), isNot(contains('Staff room copy')));
    });

    test('its videos reach every class feed', () async {
      final subjectId = await sharedSubject();
      final chapterId = await admin.saveChapter(
        subjectId: subjectId,
        number: 1,
        title: 'Measurements',
      );
      await admin.saveLesson(
        chapterId: chapterId,
        title: 'Length and mass',
        youtubeUrl: 'https://youtu.be/dQw4w9WgXcQ',
        isPublished: true,
      );

      final feed = await catalog.videoLessons(classId: 'class-7');
      expect(feed.map((v) => v.lesson.title), contains('Length and mass'));
      expect(feed.first.subject.id, subjectId);
    });

    test('its tests reach every class test list', () async {
      final subjectId = await sharedSubject();
      final chapterId = await admin.saveChapter(
        subjectId: subjectId,
        number: 1,
        title: 'Algebra basics',
      );
      await admin.saveTest(
        chapterId: chapterId,
        title: 'Like terms practice',
        isPublished: true,
      );

      expect(
        (await catalog.publishedTestsForClass('class-6')).map((t) => t.title),
        contains('Like terms practice'),
      );
      expect(
        (await catalog.publishedTestsForClass('class-10')).map((t) => t.title),
        contains('Like terms practice'),
      );
    });

    test('an announcement for "All Classes" is for every class', () async {
      await admin.saveAnnouncement(
        title: 'Holiday',
        body: 'The school stays closed on Monday.',
        classId: ClassIds.all,
      );
      for (final level in [6, 10]) {
        final items = await catalog.activeAnnouncements(
          classId: 'class-$level',
        );
        expect(items.map((a) => a.title), contains('Holiday'));
      }
    });

    test('a class of its own still keeps shared content beside it', () async {
      final classId = await admin.saveSubject(
        classId: 'class-6',
        nameEnglish: 'Farming',
      );
      final sharedId = await sharedSubject();
      final subjects = await catalog.subjectsForClass('class-6');
      expect(subjects.map((s) => s.id), containsAll([classId, sharedId]));
      // And Class 7 sees the shared one only.
      expect(
        (await catalog.subjectsForClass('class-7')).map((s) => s.id),
        isNot(contains(classId)),
      );
    });
  });
}
