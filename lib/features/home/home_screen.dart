import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/subject_art.dart';
import '../../core/widgets/video_grid.dart';
import '../../data/local/database.dart';
import '../../data/local/tables.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../state/app_state.dart';
import '../classes/lesson_screen.dart';
import '../classes/subject_screen.dart';
import '../common/content_refresh.dart';
import '../common/state_views.dart';
import '../library/resource_viewer_page.dart';
import '../tests/test_runner_screen.dart';
import 'class_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with ContentRefresh {
  late Future<_HomeSnapshot> _data;

  /// The class the currently pending/loaded snapshot was built for. Used to
  /// detect class changes made anywhere in the app, not just by this screen.
  String? _loadedClassId;

  @override
  void initState() {
    super.initState();
    _data = _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // `build` registers the AppState dependency, so this runs on every class
    // change however it was made (picker, profile, another tab). The element is
    // already scheduled to rebuild, so no setState is needed here.
    if (context.read<AppState>().selectedClassId != _loadedClassId) {
      _data = _load();
    }
  }

  /// New content synced from the backend while this tab was open.
  @override
  void onContentChanged() => _data = observed(_load());

  void _reload() {
    setState(() {
      _data = observed(_load());
    });
  }

  /// Pull-to-refresh is the only "retry" gesture a student has on this tab, so
  /// it must ask the server for new content — re-reading the local database
  /// alone would show the same empty screen forever.
  Future<void> _onRefresh() async {
    await context.read<AppState>().refreshContent();
    if (!mounted) return;
    _reload();
  }

  Future<void> _chooseClass(AppState state, String id) async {
    try {
      await state.setSelectedClassId(id);
    } on Object {
      _say('Your class choice could not be saved on this device.');
    }
  }

  static String _kindLabel(String kind) => switch (kind) {
    TrackableKinds.lesson => 'Lesson',
    TrackableKinds.resource => 'PDF/Notes',
    TrackableKinds.test => 'Test',
    TrackableKinds.liveClass => 'Live class',
    _ => kind,
  };

  Future<void> _openRecent(RecentViewItem view) async {
    final catalog = context.read<AppState>().catalog;
    switch (view.targetKind) {
      case TrackableKinds.lesson:
        final lesson = await catalog.lessonById(view.targetId);
        if (lesson == null) return _say(_goneMessage);
        await _open(LessonScreen(lesson: lesson));
      case TrackableKinds.resource:
        final resource = await catalog.resourceById(view.targetId);
        if (resource == null) return _say(_goneMessage);
        await _open(ResourceViewerPage(resource: resource));
      case TrackableKinds.test:
        final test = await catalog.testById(view.targetId);
        if (test == null) return _say(_goneMessage);
        if (!test.isPublished) return _say('That test is not open right now.');
        await _open(TestRunnerScreen(testId: test.id));
      default:
        _say('Open Live Classes to join that session.');
    }
  }

  static const _goneMessage = 'This item is no longer available.';

  void _say(String message) {
    // Several callers reach here after an `await`, so the student may already
    // have left the screen; using a dead context would throw instead of
    // showing a message nobody needs.
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  /// Opens a recent item and re-reads the list afterwards, because viewing a
  /// lesson or test changes what "continue learning" shows.
  Future<void> _open(Widget screen) async {
    if (!mounted) return;
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => screen));
    if (mounted) _data = observed(_load());
  }

  Future<_HomeSnapshot> _load() async {
    final state = context.read<AppState>();
    final catalog = state.catalog;
    final classId = state.selectedClassId;
    _loadedClassId = classId;
    final student = state.currentStudent;

    final classes = await catalog.classes();
    final subjects = classId == null
        ? const <Subject>[]
        : await catalog.subjectsForClass(classId);
    // Subjects pinned to one syllabus show their board name on the tile.
    final boardNames = classId == null
        ? const <String, String>{}
        : {for (final b in await catalog.boards()) b.id: b.nameEnglish};
    final announcements = await catalog.activeAnnouncements(classId: classId);
    final recent = student == null
        ? const <RecentViewItem>[]
        : await catalog.recentViewItems(student.id);
    var publishedLessons = 0;
    for (final subject in subjects) {
      publishedLessons += await catalog.lessonCountForSubject(subject.id);
    }
    final tests = classId == null
        ? const <Test>[]
        : await catalog.publishedTestsForClass(classId);
    final videos = classId == null
        ? const <VideoLesson>[]
        : await catalog.videoLessons(classId: classId);

    final selectedClass = classes.where((c) => c.id == classId).firstOrNull;

    return _HomeSnapshot(
      classes: classes,
      selectedClass: selectedClass,
      subjects: subjects,
      boardNames: boardNames,
      announcements: announcements,
      recent: recent,
      publishedLessons: publishedLessons,
      testCount: tests.length,
      videos: videos,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final student = state.currentStudent;
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: FutureBuilder<_HomeSnapshot>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView(message: 'Loading…');
          }
          if (snapshot.hasError) {
            // The exception text is for the developer, not a Class 6 student.
            return ErrorState(
              message:
                  'The home screen could not read your content on this device. '
                  'Try again, or pull down to refresh.',
              onRetry: _reload,
            );
          }
          final data = snapshot.data!;
          return CustomScrollView(
            // A student on a short list must still be able to pull down.
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Hello, ${student?.displayName ?? 'student'} 🙏',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.selectedClass == null
                            ? 'Choose your class'
                            : '${data.selectedClass!.nameEnglish} selected',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      ClassPicker(
                        classes: data.classes,
                        selectedClassId: data.selectedClass?.id,
                        onChanged: (id) => _chooseClass(state, id),
                        onRetry: _onRefresh,
                      ),
                      const SizedBox(height: 20),
                      _StatRow(
                        subjects: data.subjects.length,
                        lessons: data.publishedLessons,
                        tests: data.testCount,
                      ),
                      const SizedBox(height: 24),
                      const SectionTitle('Your class subjects'),
                      if (data.subjects.isEmpty)
                        const _NothingYet('Choose your class first.')
                      else
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final columns = (constraints.maxWidth / 210)
                                .floor()
                                .clamp(1, 4);
                            return GridView.count(
                              crossAxisCount: columns,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 2.5,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                for (final subject in data.subjects)
                                  SubjectCard(
                                    nameEnglish: subject.nameEnglish,
                                    nameHindi: subject.nameHindi,
                                    colorHex: subject.accentColor,
                                    board: data.boardNames[subject.boardId],
                                    onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SubjectScreen(subject: subject),
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverToBoxAdapter(
                  child: SectionTitle(
                    data.selectedClass == null
                        ? 'Class videos'
                        : 'Videos for ${data.selectedClass!.nameEnglish}',
                  ),
                ),
              ),
              if (data.videos.isEmpty)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: const SliverToBoxAdapter(
                    child: _NothingYet(
                      'No lesson videos have been published for this class yet.',
                    ),
                  ),
                )
              else
                _videoFeed(data.videos),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverPadding(
                // The bottom keeps the last announcement clear of the tab bar.
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SectionTitle('Recently viewed'),
                      if (data.recent.isEmpty)
                        const _NothingYet(
                          'When you open a lesson or PDF, it will show up here.',
                        )
                      else
                        ..._recentSection(data),
                      const SizedBox(height: 24),
                      const SectionTitle('Announcements'),
                      if (data.announcements.isEmpty)
                        const _NothingYet('No announcements yet.')
                      else
                        for (final a in data.announcements)
                          Card(
                            child: ListTile(
                              leading: Icon(
                                a.priority == 'URGENT'
                                    ? Icons.priority_high_rounded
                                    : Icons.campaign_rounded,
                              ),
                              title: Text(a.title),
                              subtitle: Text(a.body),
                            ),
                          ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Every published video of this class, in the shared thumbnail grid.
  ///
  /// The sliver form is the lazy one, so a class with a few hundred lessons
  /// still scrolls smoothly: `CatalogRepository.videoLessons` hands over the
  /// whole list, only the cards near the viewport are built, and a video the
  /// admin publishes lands here on the next sync without any restart.
  Widget _videoFeed(List<VideoLesson> videos) => SliverPadding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    sliver: VideoGridSliver(
      videos: videos,
      onTap: (video) => _open(LessonScreen(lesson: video.lesson)),
    ),
  );

  /// Recently opened videos as thumbnail cards, and everything else as rows.
  ///
  /// A lesson is the same object wherever a student meets it, so the ones this
  /// class has a published video for get the same card as the feed underneath.
  /// A PDF, a test, or a lesson whose video the admin has not added (or that
  /// belongs to another class) stays an honest line of text.
  List<Widget> _recentSection(_HomeSnapshot data) {
    final byLesson = {for (final video in data.videos) video.lesson.id: video};
    final shown = <String>{};
    final recentVideos = <VideoLesson>[];
    final recentOther = <RecentViewItem>[];
    for (final view in data.recent) {
      final video = view.targetKind == TrackableKinds.lesson
          ? byLesson[view.targetId]
          : null;
      if (video == null) {
        recentOther.add(view);
      } else if (shown.add(video.lesson.id)) {
        recentVideos.add(video);
      }
    }
    return [
      if (recentVideos.isNotEmpty)
        VideoGrid(
          videos: recentVideos,
          onTap: (video) => _open(LessonScreen(lesson: video.lesson)),
        ),
      for (final view in recentOther)
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            view.targetKind == TrackableKinds.resource
                ? Icons.description_rounded
                : Icons.play_circle_outline_rounded,
          ),
          title: Text(view.title),
          subtitle: Text(
            '${_kindLabel(view.targetKind)} • '
            '${DateFormat('d MMM yyyy').format(view.viewedAt)}',
          ),
          trailing: const Icon(Icons.chevron_right_rounded),
          onTap: () => _openRecent(view),
        ),
    ];
  }
}

class _HomeSnapshot {
  const _HomeSnapshot({
    required this.classes,
    required this.selectedClass,
    required this.subjects,
    required this.boardNames,
    required this.announcements,
    required this.recent,
    required this.videos,
    required this.publishedLessons,
    required this.testCount,
  });

  final List<SchoolClass> classes;
  final SchoolClass? selectedClass;
  final List<Subject> subjects;
  final Map<String, String> boardNames;
  final List<Announcement> announcements;
  final List<RecentViewItem> recent;
  final List<VideoLesson> videos;
  final int publishedLessons;
  final int testCount;
}

class _NothingYet extends StatelessWidget {
  const _NothingYet(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(message, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.subjects,
    required this.lessons,
    required this.tests,
  });

  final int subjects;
  final int lessons;
  final int tests;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatBox(label: 'Subjects', value: '$subjects'),
        const SizedBox(width: 10),
        _StatBox(label: 'Lessons', value: '$lessons'),
        const SizedBox(width: 10),
        _StatBox(label: 'Tests', value: '$tests'),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.12),
          ),
        ),
        child: Column(
          children: [
            Text(value, style: theme.textTheme.headlineSmall),
            Text(label, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
