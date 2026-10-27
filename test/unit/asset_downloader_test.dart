import 'dart:async';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/data/local/tables.dart';
import 'package:masti_gurukul/data/repositories/asset_downloader.dart';
import 'package:masti_gurukul/data/repositories/download_repository.dart';

List<int> validPdfBytes({int pad = 0}) => <int>[
  ...List<int>.filled(pad, 0x20),
  0x25, 0x50, 0x44, 0x46, // %PDF
  ...'-1.4 body bytes'.codeUnits,
];

ByteSource sourceReturning(List<int> bytes) =>
    (url) async => ByteResponse(
      contentLength: bytes.length,
      bytes: Stream<List<int>>.value(bytes),
    );

void main() {
  late AppDatabase db;
  late DownloadRepository downloads;
  late Directory tempDir;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    downloads = DownloadRepository(db);
    tempDir = await Directory.systemTemp.createTemp('masti_dl_test');
    await db
        .into(db.students)
        .insert(StudentsCompanion.insert(id: 'stu-1', displayName: 'Asha'));
    await db
        .into(db.subjects)
        .insert(
          SubjectsCompanion.insert(
            id: 'sub-1',
            classId: 'class-10',
            nameHindi: 'g',
            nameEnglish: 'Math',
          ),
        );
  });

  tearDown(() async {
    await db.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  Future<String> addResource({
    required String id,
    String? remoteUrl,
    int fileSizeBytes = 0,
  }) async {
    await db
        .into(db.resources)
        .insert(
          ResourcesCompanion.insert(
            id: id,
            subjectId: 'sub-1',
            title: 'Chapter notes',
            kind: ResourceKinds.pdf,
            remoteUrl: Value(remoteUrl),
            fileSizeBytes: Value(fileSizeBytes),
            isPublished: const Value(true),
          ),
        );
    return id;
  }

  Future<Download> queue(String resourceId) =>
      downloads.enqueue(studentId: 'stu-1', resourceId: resourceId);

  group('path containment rules', () {
    test('a normal file name stays inside the base directory', () {
      final resolved = AssetDownloader.resolvedSafePath(
        tempDir.path,
        'notes.pdf',
      );
      expect(resolved, isNotNull);
      expect(File(resolved!).parent.path, tempDir.path);
    });

    test('parent traversal, separators, absolute paths and empty names are '
        'refused', () {
      expect(
        AssetDownloader.resolvedSafePath(tempDir.path, '../evil.pdf'),
        isNull,
      );
      expect(
        AssetDownloader.resolvedSafePath(tempDir.path, '../../x.pdf'),
        isNull,
      );
      expect(
        AssetDownloader.resolvedSafePath(tempDir.path, 'a/evil.pdf'),
        isNull,
      );
      expect(
        AssetDownloader.resolvedSafePath(tempDir.path, '/etc/passwd'),
        isNull,
      );
      expect(AssetDownloader.resolvedSafePath(tempDir.path, ''), isNull);
      expect(AssetDownloader.resolvedSafePath(tempDir.path, '.'), isNull);
    });

    test('safeFileName only ever produces a flat .pdf name', () {
      final name = AssetDownloader.safeFileName(
        Resource(
          id: 'res/../weird id',
          subjectId: 'sub-1',
          title: 't',
          description: '',
          kind: ResourceKinds.pdf,
          fileSizeBytes: 0,
          isPublished: true,
          createdAt: DateTime(2024),
        ),
      );
      expect(name, isNot(contains('/')));
      expect(name, endsWith('.pdf'));
    });
  });

  group('remote url allow-list', () {
    test('accepts an https file link, rejects everything else', () {
      expect(
        AssetDownloader.allowedRemoteUri(
          'https://files.example.com/notes/ab.pdf',
        ),
        isNotNull,
      );
      expect(
        AssetDownloader.allowedRemoteUri('http://files.example.com/a.pdf'),
        isNull,
      );
      expect(AssetDownloader.allowedRemoteUri('file:///etc/passwd'), isNull);
      expect(
        AssetDownloader.allowedRemoteUri('https://example.com/page'),
        isNull,
      );
      expect(AssetDownloader.allowedRemoteUri(null), isNull);
    });
  });

  test('an empty file is not marked COMPLETE', () async {
    final id = await addResource(
      id: 'res-empty',
      remoteUrl: 'https://files.example.com/notes/empty.pdf',
    );
    final download = await queue(id);
    final downloader = AssetDownloader(
      downloads: downloads,
      database: db,
      documentsDirOverride: tempDir.path,
      source: sourceReturning(const <int>[]),
    );

    await downloader.download(download);

    final stored = await downloads.byId(download.id);
    expect(stored!.status, DownloadStatuses.failed);
    expect(stored.lastError, isNotNull);
    expect(stored.status, isNot(DownloadStatuses.complete));
    // Nothing was left behind in the app folder.
    expect(tempDir.listSync(), isEmpty);
  });

  test('a corrupt (non-PDF) file is not marked COMPLETE', () async {
    final id = await addResource(
      id: 'res-corrupt',
      remoteUrl: 'https://files.example.com/notes/bad.pdf',
    );
    final download = await queue(id);
    final downloader = AssetDownloader(
      downloads: downloads,
      database: db,
      documentsDirOverride: tempDir.path,
      source: sourceReturning('<html>not a pdf</html>'.codeUnits),
    );

    await downloader.download(download);

    final stored = await downloads.byId(download.id);
    expect(stored!.status, DownloadStatuses.failed);
    expect(stored.lastError, contains('corrupt'));
    expect(tempDir.listSync(), isEmpty);
  });

  test('a refused url fails the row without calling the byte source', () async {
    var sourceCalled = false;
    final id = await addResource(
      id: 'res-badurl',
      remoteUrl: 'http://evil/a.pdf',
    );
    final download = await queue(id);
    final downloader = AssetDownloader(
      downloads: downloads,
      database: db,
      documentsDirOverride: tempDir.path,
      source: (url) async {
        sourceCalled = true;
        return ByteResponse(contentLength: 0, bytes: Stream<List<int>>.empty());
      },
    );

    await downloader.download(download);

    expect(sourceCalled, isFalse);
    final stored = await downloads.byId(download.id);
    expect(stored!.status, DownloadStatuses.failed);
    expect(stored.lastError, isNotNull);
  });

  test('a valid download runs QUEUED -> RUNNING -> COMPLETE and writes a real '
      'file', () async {
    final bytes = validPdfBytes();
    final id = await addResource(
      id: 'res-good',
      remoteUrl: 'https://files.example.com/notes/good.pdf',
      fileSizeBytes: bytes.length,
    );
    final download = await queue(id);

    final seenStatuses = <String>[];
    final sub = downloads.watchForStudent('stu-1').listen((rows) {
      for (final r in rows) {
        if (r.resourceId == id) seenStatuses.add(r.status);
      }
    });

    final downloader = AssetDownloader(
      downloads: downloads,
      database: db,
      documentsDirOverride: tempDir.path,
      source: sourceReturning(bytes),
    );

    await downloader.download(download);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    final stored = await downloads.byId(download.id);
    expect(stored!.status, DownloadStatuses.complete);
    expect(stored.lastError, isNull);
    expect(stored.downloadedBytes, bytes.length);
    expect(stored.totalBytes, bytes.length);
    expect(stored.localPath, isNotNull);

    final file = File(stored.localPath!);
    expect(await file.exists(), isTrue);
    expect(await file.length(), bytes.length);

    expect(seenStatuses, contains(DownloadStatuses.running));
    expect(seenStatuses.last, DownloadStatuses.complete);
  });
}
