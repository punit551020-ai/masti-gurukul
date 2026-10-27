import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/core/widgets/video_card.dart';
import 'package:masti_gurukul/core/widgets/video_embed.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/features/classes/lesson_screen.dart';
import 'package:masti_gurukul/features/classes/subject_screen.dart';
import 'package:masti_gurukul/navigation/app_shell.dart';
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

  tearDown(() async => db.close());

  /// Adds a chapter plus one published lesson carrying a real YouTube link.
  Future<void> addVideoLesson({
    String subjectId = 'sub-class-10-mathematics',
    String chapterId = 'chp-math-1',
    int chapterNumber = 1,
    String lessonId = 'les-math-1',
    String title = 'Adding and Subtracting Fractions',
    String youtubeUrl = 'https://www.youtube.com/watch?v=aqz-KE-bpKQ',
    bool published = true,
  }) async {
    await db
        .into(db.chapters)
        .insert(
          ChaptersCompanion.insert(
            id: chapterId,
            subjectId: subjectId,
            number: chapterNumber,
            title: 'Real Numbers',
          ),
        );
    await db
        .into(db.lessons)
        .insert(
          LessonsCompanion.insert(
            id: lessonId,
            chapterId: chapterId,
            title: title,
            youtubeUrl: Value(youtubeUrl),
            durationSeconds: const Value(425),
            isPublished: Value(published),
          ),
        );
  }

  Future<void> pumpShell(WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(home: AppShell()),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// Home is a lazy list, so the video row has to be scrolled into range.
  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    await tester.scrollUntilVisible(
      finder,
      220,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a published lesson video appears on Home as a card', (
    tester,
  ) async {
    await addVideoLesson();
    await pumpShell(tester);
    await scrollTo(tester, find.text('Videos for Class 10'));

    expect(find.byType(VideoCard), findsOneWidget);
    expect(find.text('Adding and Subtracting Fractions'), findsOneWidget);
    // 425 seconds is shown as 7:05, not invented.
    expect(find.text('7:05'), findsOneWidget);
    await disposeTree(tester);
  });

  testWidgets('an empty class says so instead of showing fake videos', (
    tester,
  ) async {
    await pumpShell(tester);
    await scrollTo(tester, find.text('Videos for Class 10'));

    expect(find.byType(VideoCard), findsNothing);
    expect(
      find.text('No lesson videos have been published for this class yet.'),
      findsOneWidget,
    );
    await disposeTree(tester);
  });

  testWidgets('unpublished lessons stay out of the feed', (tester) async {
    await addVideoLesson(published: false);
    await pumpShell(tester);
    await scrollTo(tester, find.text('Videos for Class 10'));

    expect(find.byType(VideoCard), findsNothing);
    await disposeTree(tester);
  });

  testWidgets('tapping a card plays the lesson inside the app', (tester) async {
    await addVideoLesson();
    await pumpShell(tester);
    await scrollTo(tester, find.byType(VideoCard));

    await tester.tap(find.byType(VideoCard));
    await tester.pumpAndSettle();

    expect(find.byType(LessonScreen), findsOneWidget);
    await disposeTree(tester);
  });

  testWidgets('a subject page keeps its own videos apart from the class\'s', (
    tester,
  ) async {
    await addVideoLesson();
    await addVideoLesson(
      subjectId: 'sub-class-10-science',
      chapterId: 'chp-sci-1',
      lessonId: 'les-sci-1',
      title: 'Motion and Speed',
    );
    await pumpShell(tester);

    await tester.tap(find.text('Mathematics').first);
    await tester.pumpAndSettle();

    expect(find.byType(SubjectScreen), findsOneWidget);
    // The subject's own section holds only its own lesson.
    expect(find.text('Videos (1)'), findsOneWidget);
    expect(find.text('Adding and Subtracting Fractions'), findsOneWidget);
    // Another subject's video is not hidden away, but it is named as Science's
    // instead of being dressed up as Mathematics.
    expect(find.text('Also published for your class'), findsOneWidget);
    expect(find.text('Science · Ch 1'), findsOneWidget);
    expect(find.text('Mathematics · Ch 1'), findsOneWidget);
    await disposeTree(tester);
  });

  testWidgets('an empty subject still shows what the class really has', (
    tester,
  ) async {
    // The owner filed everything under Mathematics and Social Science, exactly
    // as it happens in the live database.
    await addVideoLesson();
    await addVideoLesson(
      subjectId: 'sub-class-10-social-science',
      chapterId: 'chp-soc-1',
      lessonId: 'les-soc-1',
      title: 'Disaster Management',
    );
    await pumpShell(tester);

    // Opening Science, which has nothing of its own, must not look like an
    // empty app: the videos published for this class appear, each named after
    // the subject it belongs to.
    await tester.tap(find.text('Science').first);
    await tester.pumpAndSettle();

    expect(find.byType(SubjectScreen), findsOneWidget);
    expect(find.text('Nothing published yet'), findsNothing);
    expect(find.text('Also published for your class'), findsOneWidget);
    expect(find.textContaining('has nothing published yet'), findsOneWidget);
    expect(find.byType(VideoCard), findsNWidgets(2));
    await disposeTree(tester);
  });

  testWidgets(
    'a long feed has no cap: it is a grid and everything scrolls in',
    (tester) async {
      // 40 published videos, twice what the old fixed-height strip could show.
      for (var i = 1; i <= 40; i++) {
        await addVideoLesson(
          chapterId: 'chp-many-$i',
          chapterNumber: i,
          lessonId: 'les-many-$i',
          title: 'Video $i',
        );
      }
      await pumpShell(tester);
      await scrollTo(tester, find.text('Videos for Class 10'));

      expect(find.byType(SliverGrid), findsWidgets);
      // Only the cards near the viewport are built, so 40 videos never means
      // 40 widgets at once.
      expect(
        tester.widgetList<VideoCard>(find.byType(VideoCard)).length,
        lessThan(40),
        reason: 'the feed builds lazily instead of the whole list at once',
      );

      // Nothing is stuck off-screen: the last item is reached by scrolling.
      await scrollTo(tester, find.text('Video 40'));
      expect(find.text('Video 40'), findsOneWidget);
      await disposeTree(tester);
    },
  );

  testWidgets('a wide window gets several columns', (tester) async {
    // 1200 x 900 logical pixels: a laptop browser or a tablet.
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1200, 900);
    addTearDown(tester.view.reset);

    for (var i = 1; i <= 6; i++) {
      await addVideoLesson(
        chapterId: 'chp-wide-$i',
        chapterNumber: i,
        lessonId: 'les-wide-$i',
        title: 'Wide video $i',
      );
    }
    await pumpShell(tester);
    await scrollTo(tester, find.text('Videos for Class 10'));

    final tops = tester
        .widgetList<VideoCard>(find.byType(VideoCard))
        .map((card) => tester.getTopLeft(find.byWidget(card)).dy)
        .toSet();
    expect(
      tops.length,
      lessThan(6),
      reason: 'several cards share a row instead of one per line',
    );
    await disposeTree(tester);
  });

  testWidgets('tapping a late card opens that lesson with the player', (
    tester,
  ) async {
    for (var i = 1; i <= 12; i++) {
      await addVideoLesson(
        chapterId: 'chp-late-$i',
        chapterNumber: i,
        lessonId: 'les-late-$i',
        title: 'Late video $i',
      );
    }
    await pumpShell(tester);
    await scrollTo(tester, find.text('Late video 11'));

    await tester.tap(find.text('Late video 11'));
    await tester.pumpAndSettle();

    expect(find.byType(LessonScreen), findsOneWidget);
    expect(find.text('Late video 11'), findsWidgets);
    // The player itself is on screen as soon as the card is tapped.
    expect(find.byType(VideoEmbed), findsOneWidget);
    await disposeTree(tester);
  });
}
