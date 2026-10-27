import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/data/local/tables.dart';
import 'package:masti_gurukul/data/remote/content_gateway.dart';
import 'package:masti_gurukul/data/remote/remote_content.dart';
import 'package:masti_gurukul/data/repositories/admin_repository.dart';
import 'package:masti_gurukul/data/repositories/catalog_repository.dart';

/// Stands in for Supabase: records what the app tried to store and can refuse
/// on request, so the upload and rollback paths are testable without a server.
class _FakeGateway implements ContentGateway {
  _FakeGateway({
    this.uploadUrl,
    this.uploadFails = false,
    this.failWritesTo = const {},
  });

  /// Address the fake bucket hands back for a stored file, or null to imitate
  /// a backend that took the file but returned no address.
  final String? uploadUrl;
  final bool uploadFails;

  /// Table names whose writes are refused, e.g. `{RemoteTables.subjects}`.
  final Set<String> failWritesTo;

  final uploads = <_Upload>[];
  final writes = <String, ContentRow>{};

  @override
  Future<String> uploadFile({
    required String fileName,
    required List<int> bytes,
    required String contentType,
  }) async {
    uploads.add(
      _Upload(
        fileName: fileName,
        byteCount: bytes.length,
        contentType: contentType,
      ),
    );
    if (uploadFails) {
      throw RemoteFailure('The bucket policy refused the upload.');
    }
    return uploadUrl ?? 'https://bucket.example/library/$fileName';
  }

  @override
  Future<void> upsert(String table, ContentRow row) async {
    if (failWritesTo.contains(table)) {
      throw RemoteFailure('The server refused the write.');
    }
    writes[table] = row;
  }

  @override
  Future<void> delete(String table, String id) async {
    writes.remove(table);
  }

  @override
  Future<List<ContentRow>> fetchPublished(String table) async => const [];

  @override
  Future<List<ContentRow>> fetchAllForAdmin(String table) async => const [];

  @override
  Stream<String> get changedTables => const Stream.empty();

  @override
  Future<void> signInAdmin({
    required String email,
    required String password,
  }) async {}

  @override
  Future<void> signOutAdmin() async {}

  @override
  bool get isAdminSignedIn => true;

  @override
  String? get adminEmail => 'admin@example.com';

  @override
  Future<void> dispose() async {}
}

class _Upload {
  _Upload({
    required this.fileName,
    required this.byteCount,
    required this.contentType,
  });
  final String fileName;
  final int byteCount;
  final String contentType;
}

void main() {
  late AppDatabase db;
  late CatalogRepository catalog;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    catalog = CatalogRepository(db);
    await catalog.seedStructureIfEmpty();
  });

  tearDown(() async {
    await db.close();
  });

  final pdfBytes = Uint8List.fromList(List.generate(1200, (i) => i % 256));

  test('a device-only build reports that it cannot upload', () async {
    final admin = AdminRepository(db);
    expect(admin.isLive, isFalse);
    expect(
      await admin.uploadFile(
        fileName: 'notes.pdf',
        bytes: pdfBytes,
        contentType: 'application/pdf',
      ),
      isNull,
    );
  });

  test('a signed-in build sends the file to the server', () async {
    final gateway = _FakeGateway(
      uploadUrl:
          'https://x.supabase.co/storage/v1/object/public/library/1-bihar.pdf',
    );
    final admin = AdminRepository(db, gateway);
    expect(admin.isLive, isTrue);

    final url = await admin.uploadFile(
      fileName: 'bihar.pdf',
      bytes: pdfBytes,
      contentType: 'application/pdf',
    );
    expect(
      gateway.uploads.map((u) => (u.fileName, u.byteCount, u.contentType)),
      [('bihar.pdf', 1200, 'application/pdf')],
    );
    expect(url, gateway.uploadUrl);
  });

  test('an uploaded PDF lands on the resource row students pull', () async {
    const url = 'https://x.supabase.co/storage/v1/object/public/library/9.pdf';
    final gateway = _FakeGateway(uploadUrl: url);
    final admin = AdminRepository(db, gateway);

    final uploaded = await admin.uploadFile(
      fileName: '9.pdf',
      bytes: pdfBytes,
      contentType: 'application/pdf',
    );
    expect(uploaded, url);

    final id = await admin.saveResource(
      subjectId: 'sub-class-10-science',
      title: 'Bihar Board Class 10 Science notes',
      kind: ResourceKinds.pdf,
      remoteUrl: uploaded,
      fileSizeBytes: pdfBytes.length,
      isPublished: true,
    );

    final row = gateway.writes[RemoteTables.resources];
    expect(row, isNotNull);
    expect(row!['id'], id);
    expect(row['remote_url'], url);
    expect(row['file_size_bytes'], pdfBytes.length);
    // Published is the only way a student device sees the row at all.
    expect(row['is_published'], true);

    final local = await (db.select(
      db.resources,
    )..where((t) => t.id.equals(id))).getSingle();
    expect(local.remoteUrl, url);
    expect(local.title, 'Bihar Board Class 10 Science notes');
  });

  test(
    'a refused upload reaches the admin instead of pretending to work',
    () async {
      final gateway = _FakeGateway(uploadFails: true);
      final admin = AdminRepository(db, gateway);
      expect(
        () => admin.uploadFile(
          fileName: 'x.pdf',
          bytes: pdfBytes,
          contentType: 'application/pdf',
        ),
        throwsA(
          isA<RemoteFailure>().having(
            (e) => e.message,
            'message',
            contains('bucket policy'),
          ),
        ),
      );
    },
  );

  group('only the title is compulsory', () {
    test('a file row is saved with nothing attached', () async {
      final gateway = _FakeGateway();
      final admin = AdminRepository(db, gateway);

      final id = await admin.saveResource(
        subjectId: 'sub-class-10-science',
        title: 'Chapter 5 notes',
        kind: ResourceKinds.notes,
        isPublished: true,
      );

      final row = gateway.writes[RemoteTables.resources];
      expect(row, isNotNull);
      expect(row!['id'], id);
      // The two boxes the owner left empty go to the server as null, and the
      // row still lands - the student screen is what explains the gap.
      expect(row['remote_url'], isNull);
      expect(row['year_label'], isNull);
      expect(row['is_published'], true);
    });

    test('an empty title is the one thing that stops a file', () async {
      final admin = AdminRepository(db);
      await expectLater(
        admin.saveResource(
          subjectId: 'sub-class-10-science',
          title: '   ',
          kind: ResourceKinds.pdf,
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'Title is required.',
          ),
        ),
      );
    });

    test('a chapter says what is missing in plain words', () async {
      final admin = AdminRepository(db);
      await expectLater(
        admin.saveChapter(
          subjectId: 'sub-class-10-science',
          number: 3,
          title: ' ',
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'Chapter title is required.',
          ),
        ),
      );
      // number >= 1 is a check the chapters table carries, so it is named here
      // instead of being left for the server to throw.
      await expectLater(
        admin.saveChapter(
          subjectId: 'sub-class-10-science',
          number: 0,
          title: 'Polynomials',
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            'Chapter numbers start at 1.',
          ),
        ),
      );
    });

    test('a test keeps the marks rules the tests table enforces', () async {
      final admin = AdminRepository(db);
      final chapterId = await admin.saveChapter(
        subjectId: 'sub-class-10-science',
        number: 1,
        title: 'Real Numbers',
      );

      await expectLater(
        admin.saveTest(
          chapterId: chapterId,
          title: 'Numbers',
          marksPerQuestion: 0,
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('more than zero'),
          ),
        ),
      );
      await expectLater(
        admin.saveTest(
          chapterId: chapterId,
          title: 'Numbers',
          timeLimitMinutes: 0,
        ),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('one minute'),
          ),
        ),
      );

      // The defaults the form falls back to are all valid rows.
      final id = await admin.saveTest(chapterId: chapterId, title: 'Numbers');
      final saved = await catalog.testById(id);
      expect(saved?.timeLimitMinutes, 20);
      expect(saved?.marksPerQuestion, 1);
    });
  });

  test('a subject the server refuses is not left half-created', () async {
    final gateway = _FakeGateway(failWritesTo: {RemoteTables.subjects});
    final admin = AdminRepository(db, gateway);
    expect(
      () => admin.saveSubject(
        classId: 'class-10',
        boardId: 'board-bihar',
        nameEnglish: 'Science',
      ),
      throwsA(isA<RemoteFailure>()),
    );
    expect(await catalog.subjectById('sub-class-10-bihar-science'), isNull);
  });

  test('an edit the server refuses puts the old subject back', () async {
    final admin = AdminRepository(db);
    final id = await admin.saveSubject(
      classId: 'class-10',
      boardId: 'board-bihar',
      nameEnglish: 'Science',
      accentColor: '1B7A3D',
    );
    final gateway = _FakeGateway(failWritesTo: {RemoteTables.subjects});
    final offlineAdmin = AdminRepository(db, gateway);

    expect(
      () => offlineAdmin.saveSubject(
        id: id,
        classId: 'class-10',
        boardId: 'board-bihar',
        nameEnglish: 'Science',
        accentColor: 'B20308',
      ),
      throwsA(isA<RemoteFailure>()),
    );

    final restored = await catalog.subjectById(id);
    expect(restored?.accentColor, '1B7A3D');
  });

  test('an edited chapter the server refuses keeps its old title', () async {
    final id = await AdminRepository(db).saveChapter(
      subjectId: 'sub-class-10-science',
      number: 1,
      title: 'Real Numbers',
    );
    final gateway = _FakeGateway(failWritesTo: {RemoteTables.chapters});

    expect(
      () => AdminRepository(db, gateway).saveChapter(
        id: id,
        subjectId: 'sub-class-10-science',
        number: 1,
        title: 'Changer',
      ),
      throwsA(isA<RemoteFailure>()),
    );

    final chapter = await catalog.chapterById(id);
    expect(chapter?.title, 'Real Numbers');
  });
}
