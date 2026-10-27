import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_theme.dart';
import '../../core/widgets/subject_art.dart';
import '../../core/widgets/video_grid.dart';
import '../../data/local/database.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../state/app_state.dart';
import 'lesson_screen.dart';
import '../common/content_refresh.dart';
import '../common/state_views.dart';
import '../library/resource_viewer_page.dart';
import '../tests/test_runner_screen.dart';
import 'chapter_screen.dart';

/// Everything the admin has published for one subject: videos, notes and
/// previous-year papers, tests, and the chapter list.
class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key, required this.subject});

  final Subject subject;

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectSnapshot {
  const _SubjectSnapshot({
    required this.videos,
    required this.resources,
    required this.tests,
    required this.chapters,
    required this.classVideos,
    required this.classResources,
    required this.subjectNames,
  });

  final List<VideoLesson> videos;
  final List<Resource> resources;
  final List<Test> tests;
  final List<Chapter> chapters;

  /// Published for this class but filed under another subject, so a student who
  /// opens an empty subject still sees what is actually available to them.
  final List<VideoLesson> classVideos;
  final List<Resource> classResources;

  /// Subject id → name, used to label those rows truthfully.
  final Map<String, String> subjectNames;

  bool get hasOwnContent =>
      videos.isNotEmpty ||
      resources.isNotEmpty ||
      tests.isNotEmpty ||
      chapters.isNotEmpty;

  bool get isCompletelyEmpty =>
      !hasOwnContent && classVideos.isEmpty && classResources.isEmpty;
}

class _SubjectScreenState extends State<SubjectScreen> with ContentRefresh {
  late Future<_SubjectSnapshot> _data = _load();

  /// A subject pinned to one syllabus says which, so two same-named subjects
  /// from different boards cannot look like the same page.
  late final Future<String?> _boardName = _loadBoardName();

  Future<String?> _loadBoardName() async {
    final boardId = widget.subject.boardId;
    if (boardId == null) return null;
    final board = await context.read<AppState>().catalog.boardById(boardId);
    return board?.nameEnglish;
  }

  @override
  void onContentChanged() => _data = observed(_load());

  Future<_SubjectSnapshot> _load() async {
    final catalog = context.read<AppState>().catalog;
    final id = widget.subject.id;
    final classId = widget.subject.classId;
    // The class list is everything this student is allowed to read: the class's
    // own subjects plus whatever the admin filed under "All Classes". Taking the
    // current subject out of it gives the "also published for your class" rows -
    // labelled with the subject they really belong to, never renamed to this one.
    final classSubjects = await catalog.subjectsForClass(classId);
    final classVideos = (await catalog.videoLessons(classId: classId))
        .where((video) => video.subject.id != id)
        .toList();
    final classResources = (await catalog.resources(
      ResourceFilter(classId: classId),
    )).where((resource) => resource.subjectId != id).toList();
    return _SubjectSnapshot(
      videos: await catalog.videoLessons(subjectId: id),
      resources: await catalog.resources(ResourceFilter(subjectId: id)),
      tests: await catalog.publishedTestsForSubject(id),
      chapters: await catalog.chaptersForSubject(id),
      classVideos: classVideos,
      classResources: classResources,
      subjectNames: {for (final s in classSubjects) s.id: s.nameEnglish},
    );
  }

  String _ownerLabel(_SubjectSnapshot data, String subjectId) =>
      data.subjectNames[subjectId] ?? 'another subject';

  void _reload() => setState(() => _data = observed(_load()));

  void _say(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openTest(Test test) async {
    if (!test.isPublished) return _say('That test is not open right now.');
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => TestRunnerScreen(testId: test.id)),
    );
    if (mounted) _reload();
  }

  @override
  Widget build(BuildContext context) {
    final accent = colorFromHex(widget.subject.accentColor);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            SubjectArt(
              glyph: glyphForSubject(
                english: widget.subject.nameEnglish,
                hindi: widget.subject.nameHindi,
              ),
              ink: accent,
              size: 26,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: FutureBuilder<String?>(
                future: _boardName,
                builder: (context, snapshot) {
                  final board = snapshot.data;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.subject.nameEnglish,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (board != null)
                        Text(
                          board,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: accent.withValues(alpha: 0.9),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // The refresh gesture means "the admin may have added something", so
          // it pulls from the server before re-reading this device.
          await context.read<AppState>().refreshContent();
          if (!mounted) return;
          _reload();
        },
        child: FutureBuilder<_SubjectSnapshot>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingView(message: 'Loading…');
            }
            if (snapshot.hasError) {
              return ErrorState(
                message:
                    'This subject could not be read on your device. Try again, '
                    'or pull down to refresh.',
                onRetry: _reload,
              );
            }
            final data = snapshot.data!;
            if (data.isCompletelyEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 80),
                  EmptyState(
                    icon: Icons.local_library_rounded,
                    title: 'Nothing published yet',
                    message:
                        'Videos, notes and tests for ${widget.subject.nameEnglish} '
                        'will appear here once the admin adds them.',
                  ),
                ],
              );
            }
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                if (data.videos.isNotEmpty) ...[
                  SectionTitle('Videos (${data.videos.length})'),
                  // The same thumbnail grid as Home: no fixed-height strip, no
                  // sideways drag hiding the rest of the subject.
                  VideoGrid(
                    videos: data.videos,
                    onTap: (video) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LessonScreen(lesson: video.lesson),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
                if (data.resources.isNotEmpty) ...[
                  SectionTitle('Notes & PDFs (${data.resources.length})'),
                  for (final resource in data.resources)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.description_rounded),
                        title: Text(resource.title),
                        subtitle: Text(resource.kind),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ResourceViewerPage(resource: resource),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
                if (data.tests.isNotEmpty) ...[
                  SectionTitle('Tests (${data.tests.length})'),
                  for (final test in data.tests)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.fact_check_rounded),
                        title: Text(test.title),
                        subtitle: Text('${test.timeLimitMinutes} min'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => _openTest(test),
                      ),
                    ),
                  const SizedBox(height: 16),
                ],
                SectionTitle('Chapters (${data.chapters.length})'),
                if (data.chapters.isEmpty)
                  const Text(
                    'No chapters have been published for this subject.',
                  )
                else
                  for (final chapter in data.chapters)
                    Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: accent.withValues(alpha: 0.15),
                          foregroundColor: accent,
                          child: Text('${chapter.number}'),
                        ),
                        title: Text(chapter.title),
                        subtitle: Text(chapter.summary),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ChapterScreen(chapter: chapter),
                          ),
                        ),
                      ),
                    ),
                if (data.classVideos.isNotEmpty ||
                    data.classResources.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  SectionTitle('Also published for your class'),
                  Text(
                    data.hasOwnContent
                        ? 'These belong to the subject named on each item, not to '
                              '${widget.subject.nameEnglish}.'
                        : '${widget.subject.nameEnglish} has nothing published '
                              'yet. Everything your class can open right now is '
                              'listed here, under the subject it belongs to.',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 10),
                  if (data.classVideos.isNotEmpty)
                    VideoGrid(
                      videos: data.classVideos,
                      onTap: (video) => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LessonScreen(lesson: video.lesson),
                        ),
                      ),
                    ),
                  for (final resource in data.classResources)
                    Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.description_rounded),
                        title: Text(resource.title),
                        subtitle: Text(
                          '${resource.kind} · ${_ownerLabel(data, resource.subjectId)}',
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ResourceViewerPage(resource: resource),
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
