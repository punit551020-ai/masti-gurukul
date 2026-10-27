import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/core/widgets/video_card.dart';
import 'package:masti_gurukul/core/widgets/video_embed.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/data/local/tables.dart';
import 'package:masti_gurukul/features/classes/lesson_screen.dart';
import 'package:masti_gurukul/state/app_state.dart';
import 'package:provider/provider.dart';

const _chapterId = 'ch-real-numbers';
const _goodUrl = 'https://www.youtube.com/watch?v=abc123XYZ01';

void main() {
  late AppDatabase db;
  late AppState state;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    state = AppState.forTesting(db);
    await state.catalog.seedStructureIfEmpty();
    await db
        .into(db.chapters)
        .insert(
          ChaptersCompanion.insert(
            id: _chapterId,
            subjectId: 'sub-class-10-mathematics',
            number: 1,
            title: 'Real Numbers',
          ),
        );
    await state.startStudent(name: 'Rahul', classId: 'class-10');
  });

  tearDown(() async {
    await db.close();
  });

  Future<Lesson> addLesson({
    required String id,
    required String title,
    String? youtubeUrl,
    required int order,
  }) async {
    await db
        .into(db.lessons)
        .insert(
          LessonsCompanion.insert(
            id: id,
            chapterId: _chapterId,
            title: title,
            displayOrder: Value(order),
            youtubeUrl: Value(youtubeUrl),
            isPublished: const Value(true),
          ),
        );
    return (db.select(db.lessons)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<void> open(WidgetTester tester, Lesson lesson) async {
    // Tall enough that the player and the chapter queue are both laid out;
    // a ListView never builds tiles below the fold.
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: MaterialApp(home: LessonScreen(lesson: lesson)),
      ),
    );
    for (var i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
  }

  void reportEnded(WidgetTester tester) {
    tester.widget<VideoEmbed>(find.byType(VideoEmbed)).controller.reportEnded();
  }

  testWidgets('a verified url plays in the app and the queue is listed', (
    tester,
  ) async {
    final first = await addLesson(
      id: 'l1',
      title: 'Euclids division lemma',
      youtubeUrl: _goodUrl,
      order: 1,
    );
    await addLesson(
      id: 'l2',
      title: 'The fundamental theorem of arithmetic',
      youtubeUrl: 'https://youtu.be/zzz11122233',
      order: 2,
    );
    await open(tester, first);

    expect(find.byType(VideoEmbed), findsOneWidget);
    expect(find.text('Open on YouTube'), findsOneWidget);
    expect(find.text('Euclids division lemma'), findsWidgets);
    // The chapter queue is the same thumbnail cards as Home, not a column of
    // text links: one card per video, the current one marked.
    expect(find.text('Videos in this chapter (2)'), findsOneWidget);
    expect(find.byType(VideoCard), findsNWidgets(2));
    expect(find.text('Now playing'), findsOneWidget);
    expect(
      tester
          .widget<VideoCard>(
            find.widgetWithText(
              VideoCard,
              'The fundamental theorem of arithmetic',
            ),
          )
          .item
          .lesson
          .id,
      'l2',
    );

    await tester.tap(
      find.widgetWithText(VideoCard, 'The fundamental theorem of arithmetic'),
    );
    await tester.pump(const Duration(milliseconds: 200));

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('The fundamental theorem of arithmetic'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('the player reports the end and the next lesson starts', (
    tester,
  ) async {
    final first = await addLesson(
      id: 'l1',
      title: 'Irrational numbers',
      youtubeUrl: _goodUrl,
      order: 1,
    );
    await addLesson(
      id: 'l2',
      title: 'Revisiting rational numbers',
      youtubeUrl: 'https://youtu.be/zzz11122233',
      order: 2,
    );
    await open(tester, first);

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Irrational numbers'),
      ),
      findsOneWidget,
    );

    reportEnded(tester);
    await tester.pump(const Duration(milliseconds: 200));

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Revisiting rational numbers'),
      ),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(VideoCard, 'Irrational numbers'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<VideoCard>(
            find.widgetWithText(VideoCard, 'Revisiting rational numbers'),
          )
          .nowPlaying,
      isTrue,
    );
    expect(find.text('Now playing'), findsOneWidget);
  });

  testWidgets('auto advance skips a lesson that has no video', (tester) async {
    final first = await addLesson(
      id: 'l1',
      title: 'Polynomials intro',
      youtubeUrl: _goodUrl,
      order: 1,
    );
    await addLesson(id: 'l2', title: 'Notes only lesson', order: 2);
    await addLesson(
      id: 'l3',
      title: 'Zeroes of a polynomial',
      youtubeUrl: 'https://www.youtube.com/embed/qqq11122233',
      order: 3,
    );
    await open(tester, first);

    reportEnded(tester);
    await tester.pump(const Duration(milliseconds: 200));

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Zeroes of a polynomial'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('the last video says so instead of looping back', (tester) async {
    final only = await addLesson(
      id: 'l1',
      title: 'Pair of linear equations',
      youtubeUrl: _goodUrl,
      order: 1,
    );
    await open(tester, only);

    expect(find.text('Next lesson'), findsNothing);

    reportEnded(tester);
    await tester.pump(const Duration(milliseconds: 200));

    expect(
      find.text('That was the last video in this chapter.'),
      findsOneWidget,
    );
  });

  testWidgets('an unverified url is refused instead of being embedded', (
    tester,
  ) async {
    final smuggled = await addLesson(
      id: 'l1',
      title: 'Triangles',
      youtubeUrl: 'https://evil.example.com/embed/anything',
      order: 1,
    );
    await open(tester, smuggled);

    expect(find.byType(VideoEmbed), findsNothing);
    expect(
      find.textContaining('This URL is not a verified YouTube address'),
      findsOneWidget,
    );
  });

  testWidgets('a lesson without a video says so', (tester) async {
    final quiet = await addLesson(
      id: 'l1',
      title: 'Statistics summary',
      order: 1,
    );
    await open(tester, quiet);

    expect(find.byType(VideoEmbed), findsNothing);
    expect(
      find.text('No video is attached to this lesson yet.'),
      findsOneWidget,
    );
  });

  testWidgets('a player that cannot attach offers a retry and keeps the '
      'escape hatch', (tester) async {
    final lesson = await addLesson(
      id: 'l1',
      title: 'Quadratic equations',
      youtubeUrl: _goodUrl,
      order: 1,
    );
    await open(tester, lesson);

    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('Open on YouTube'), findsOneWidget);

    await tester.tap(find.text('Try again'));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(find.text('Try again'), findsOneWidget);
    expect(find.text('YouTube lesson'), findsNothing);
  });

  testWidgets('a manual next lesson button is offered when the end cannot be '
      'detected', (tester) async {
    final first = await addLesson(
      id: 'l1',
      title: 'Introduction to trigonometry',
      youtubeUrl: _goodUrl,
      order: 1,
    );
    await addLesson(
      id: 'l2',
      title: 'Trigonometric identities',
      youtubeUrl: 'https://youtu.be/zzz11122233',
      order: 2,
    );
    await open(tester, first);

    final embed = tester.widget<VideoEmbed>(find.byType(VideoEmbed));
    expect(embed.controller.reportsEnded, isFalse);
    expect(
      find.textContaining('cannot yet tell us when the video ends'),
      findsOneWidget,
    );

    await tester.tap(find.text('Next lesson'));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Trigonometric identities'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('bookmarking the current lesson persists', (tester) async {
    final lesson = await addLesson(
      id: 'l1',
      title: 'Surface areas and volumes',
      youtubeUrl: _goodUrl,
      order: 1,
    );
    await open(tester, lesson);

    await tester.tap(find.byTooltip('Add bookmark'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.byTooltip('Remove bookmark'), findsOneWidget);

    final stored =
        await (db.select(db.bookmarks)
              ..where((t) => t.targetKind.equals(TrackableKinds.lesson))
              ..where((t) => t.targetId.equals('l1')))
            .get();
    expect(stored, hasLength(1));
    expect(
      await state.catalog.bookmarkedIds(
        state.currentStudent!.id,
        TrackableKinds.lesson,
      ),
      contains('l1'),
    );
  });

  testWidgets('watching a lesson is recorded as a recent view', (tester) async {
    final lesson = await addLesson(
      id: 'l1',
      title: 'Light reflection',
      youtubeUrl: _goodUrl,
      order: 1,
    );
    await open(tester, lesson);

    final items = await state.catalog.recentViewItems(state.currentStudent!.id);
    expect(items.map((i) => i.targetId), contains('l1'));
  });
}
