import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/core/widgets/pdf_view.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/data/local/tables.dart';
import 'package:masti_gurukul/features/library/library_screen.dart';
import 'package:masti_gurukul/features/library/resource_viewer_page.dart';
import 'package:masti_gurukul/state/app_state.dart';
import 'package:provider/provider.dart';

import 'tree_disposal.dart';

void main() {
  late AppDatabase db;
  late AppState state;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    state = AppState.forTesting(db);
    await state.catalog.seedStructureIfEmpty();
    await state.startStudent(name: 'Asha', classId: 'class-10');
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> addPublishedPdf({
    String id = 'res-pdf-1',
    String? remoteUrl = 'https://files.example.com/notes/ch1.pdf',
    int fileSizeBytes = 20480,
    bool published = true,
  }) async {
    await db
        .into(db.resources)
        .insert(
          ResourcesCompanion.insert(
            id: id,
            // A real class-10 subject created by seedStructureIfEmpty.
            subjectId: 'sub-class-10-mathematics',
            title: 'Fractions notes',
            kind: ResourceKinds.pdf,
            remoteUrl: Value(remoteUrl),
            fileSizeBytes: Value(fileSizeBytes),
            isPublished: Value(published),
          ),
        );
  }

  Future<void> pumpLibrary(WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(home: Scaffold(body: LibraryScreen())),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('library lists a published PDF resource', (tester) async {
    await addPublishedPdf();
    await pumpLibrary(tester);

    expect(find.text('Fractions notes'), findsOneWidget);
    // Kind and size are shown on the row.
    expect(find.textContaining('PDF'), findsWidgets);
    expect(find.textContaining('20.0 KB'), findsOneWidget);
    await disposeTree(tester);
  });

  testWidgets('an unpublished resource is not listed', (tester) async {
    await addPublishedPdf(id: 'res-draft', published: false);
    await pumpLibrary(tester);

    expect(find.text('Fractions notes'), findsNothing);
    await disposeTree(tester);
  });

  testWidgets('tapping the PDF opens the viewer widget', (tester) async {
    await addPublishedPdf();
    await pumpLibrary(tester);

    await tester.tap(find.text('Fractions notes'));
    await tester.pumpAndSettle();

    expect(find.byType(ResourceViewerPage), findsOneWidget);
    expect(find.byType(PdfViewer), findsOneWidget);
    // The viewer re-states the document title in its app bar.
    expect(find.text('Fractions notes'), findsWidgets);
    await disposeTree(tester);
  });

  testWidgets('a resource with nothing attached says so plainly', (
    tester,
  ) async {
    // The admin can now save a row with only a title, so this is a real state a
    // student can land in. The screen has to say it, on every platform, instead
    // of showing a blank page and a download button that cannot work.
    await addPublishedPdf(remoteUrl: null);
    await pumpLibrary(tester);

    await tester.tap(find.text('Fractions notes'));
    await tester.pumpAndSettle();

    expect(find.byType(ResourceViewerPage), findsOneWidget);
    expect(find.text('The file is not here yet'), findsOneWidget);
    expect(
      find.textContaining('The owner can add the file later'),
      findsOneWidget,
    );
    expect(find.byType(PdfViewer), findsNothing);
    await disposeTree(tester);
  });

  testWidgets('a file that already has a local copy is not called missing', (
    tester,
  ) async {
    await db
        .into(db.resources)
        .insert(
          ResourcesCompanion.insert(
            id: 'res-local-1',
            subjectId: 'sub-class-10-mathematics',
            title: 'On this device',
            kind: ResourceKinds.pdf,
            localFilePath: const Value('/library/notes.pdf'),
            isPublished: const Value(true),
          ),
        );
    await pumpLibrary(tester);

    await tester.tap(find.text('On this device'));
    await tester.pumpAndSettle();

    // The new "nothing attached yet" screen must not swallow a row that does
    // have a file: the viewer is still what opens.
    expect(find.byType(PdfViewer), findsOneWidget);
    expect(find.text('The file is not here yet'), findsNothing);
    await disposeTree(tester);
  });
}
