import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/data/remote/remote_content.dart';
import 'package:masti_gurukul/data/repositories/admin_repository.dart';
import 'package:masti_gurukul/data/repositories/catalog_repository.dart';

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

  Future<Subject> subjectOf(String id) async {
    final found = await catalog.subjectById(id);
    expect(found, isNotNull, reason: 'subject $id was not saved');
    return found!;
  }

  group('subject ids', () {
    test('a board-pinned subject names the board in its id', () {
      expect(
        AdminRepository.newSubjectId(
          classId: 'class-10',
          boardId: 'board-bihar',
          nameEnglish: 'Science',
        ),
        'sub-class-10-bihar-science',
      );
    });

    test('a shared subject leaves the board out of its id', () {
      expect(
        AdminRepository.newSubjectId(
          classId: 'class-9',
          boardId: null,
          nameEnglish: 'Social Science',
        ),
        'sub-class-9-social-science',
      );
    });
  });

  group('saveSubject', () {
    test('stores the board, colour and Hindi name', () async {
      final id = await admin.saveSubject(
        classId: 'class-10',
        boardId: 'board-bihar',
        nameEnglish: 'Science',
        nameHindi: 'विज्ञान',
        accentColor: '1B7A3D',
        displayOrder: 2,
      );
      expect(id, 'sub-class-10-bihar-science');
      final saved = await subjectOf(id);
      expect(saved.boardId, 'board-bihar');
      expect(saved.nameHindi, 'विज्ञान');
      expect(saved.accentColor, '1B7A3D');
      expect(saved.displayOrder, 2);
    });

    test('accepts a colour typed with a hash and in lower case', () async {
      final id = await admin.saveSubject(
        classId: 'class-10',
        nameEnglish: 'Computer',
        accentColor: '#091b71',
      );
      expect((await subjectOf(id)).accentColor, '091B71');
    });

    test('refuses a blank name and a colour outside the palette', () async {
      expect(
        () => admin.saveSubject(classId: 'class-10', nameEnglish: '   '),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('required'),
          ),
        ),
      );
      expect(
        () => admin.saveSubject(
          classId: 'class-10',
          nameEnglish: 'Science',
          accentColor: 'zzz',
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('colour'),
          ),
        ),
      );
    });

    test('refuses the same subject twice for one board', () async {
      await admin.saveSubject(
        classId: 'class-10',
        boardId: 'board-bihar',
        nameEnglish: 'Science',
      );
      await admin.saveSubject(
        classId: 'class-10',
        boardId: 'board-cbse',
        nameEnglish: 'Science',
      );
      expect(
        () => admin.saveSubject(
          classId: 'class-10',
          boardId: 'board-bihar',
          nameEnglish: 'Science',
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('already has'),
          ),
        ),
      );
    });

    test(
      'editing keeps the id and moves the subject to another board',
      () async {
        final id = await admin.saveSubject(
          classId: 'class-10',
          boardId: 'board-bihar',
          nameEnglish: 'Mathematics',
        );
        // The seeded shared Mathematics is still there, so the edit is what has
        // to be checked: same row, now pinned to CBSE.
        await admin.saveSubject(
          id: id,
          classId: 'class-10',
          boardId: 'board-cbse',
          nameEnglish: 'Mathematics',
        );
        final saved = await subjectOf(id);
        expect(saved.boardId, 'board-cbse');
        expect(saved.nameEnglish, 'Mathematics');
      },
    );
  });

  group('board filtering', () {
    setUp(() async {
      await admin.saveSubject(
        classId: 'class-10',
        boardId: 'board-bihar',
        nameEnglish: 'Science',
      );
    });

    test('a board filter keeps the shared subjects of the class', () async {
      final all = await catalog.subjectsForClass('class-10');
      final bihar = await catalog.subjectsForClass(
        'class-10',
        boardId: 'board-bihar',
      );
      final cbse = await catalog.subjectsForClass(
        'class-10',
        boardId: 'board-cbse',
      );
      expect(all.length, 6);
      expect(bihar.length, 6);
      // Class 10 starts with five subjects that belong to every board.
      expect(cbse.map((s) => s.nameEnglish).toList(), [
        'Mathematics',
        'Science',
        'Hindi',
        'English',
        'Social Science',
      ]);
      expect(
        bihar.where((s) => s.id == 'sub-class-10-bihar-science'),
        hasLength(1),
      );
    });

    test('only boards that really have subjects are offered', () async {
      final used = await catalog.boardsForClass('class-10');
      expect(used.map((b) => b.id), ['board-bihar']);
      expect(await catalog.boardsForClass('class-6'), isEmpty);
    });

    test('boardById reads back a seeded board', () async {
      final board = await catalog.boardById('board-bihar');
      expect(board?.nameEnglish, 'Bihar Board');
      expect(await catalog.boardById('board-nope'), isNull);
    });
  });

  group('server rows', () {
    test('board_id survives the trip to the backend and back', () async {
      final id = await admin.saveSubject(
        classId: 'class-10',
        boardId: 'board-bihar',
        nameEnglish: 'Science',
      );
      final row = RemoteContent.subjectToRow(await subjectOf(id));
      expect(row['board_id'], 'board-bihar');
      final back = RemoteContent.subject(row);
      expect(back.boardId.value, 'board-bihar');
      expect(back.id.value, id);
    });

    test('a shared subject writes a null board, not a missing key', () async {
      final shared = await catalog.subjectById('sub-class-10-mathematics');
      final row = RemoteContent.subjectToRow(shared!);
      expect(row.containsKey('board_id'), isTrue);
      expect(row['board_id'], isNull);
      expect(RemoteContent.subject(row).boardId.value, isNull);
    });

    test('a new board is writable content, not a read-only table', () {
      expect(RemoteTables.adminWritable, contains(RemoteTables.subjects));
      expect(
        RemoteTables.contentInDependencyOrder,
        contains(RemoteTables.boards),
      );
    });
  });
}
