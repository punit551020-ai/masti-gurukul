import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/video_grid.dart';
import '../../data/local/database.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../state/app_state.dart';
import '../common/content_refresh.dart';
import '../common/state_views.dart';
import 'lesson_screen.dart';

class ChapterScreen extends StatefulWidget {
  const ChapterScreen({super.key, required this.chapter});

  final Chapter chapter;

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

/// One chapter's lessons, split by whether they actually have a video, because
/// only a lesson with a video has a thumbnail worth showing.
class _ChapterSnapshot {
  const _ChapterSnapshot({required this.videos, required this.otherLessons});

  final List<VideoLesson> videos;
  final List<Lesson> otherLessons;

  bool get isEmpty => videos.isEmpty && otherLessons.isEmpty;
}

class _ChapterScreenState extends State<ChapterScreen> with ContentRefresh {
  late Future<_ChapterSnapshot> _lessons = _load();

  Future<_ChapterSnapshot> _load() async {
    final catalog = context.read<AppState>().catalog;
    final videos = await catalog.videoLessons(chapterId: widget.chapter.id);
    final all = await catalog.lessonsForChapter(widget.chapter.id);
    final withVideo = {for (final video in videos) video.lesson.id};
    return _ChapterSnapshot(
      videos: videos,
      otherLessons: [
        for (final lesson in all)
          if (!withVideo.contains(lesson.id)) lesson,
      ],
    );
  }

  @override
  void onContentChanged() => _lessons = observed(_load());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text('Chapter ${widget.chapter.number}')),
      body: RefreshIndicator(
        onRefresh: () async => setState(() => _lessons = observed(_load())),
        child: FutureBuilder<_ChapterSnapshot>(
          future: _lessons,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const LoadingView(message: 'Loading lessons…');
            }
            final data = snapshot.data ?? _emptySnapshot;
            if (data.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  const SizedBox(height: 80),
                  const EmptyState(
                    icon: Icons.play_lesson_rounded,
                    title: 'No lessons in this chapter',
                    message:
                        'When the admin publishes the video or notes for '
                        'this chapter, they will appear here.',
                  ),
                ],
              );
            }
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                if (data.videos.isNotEmpty) ...[
                  SectionTitle('Videos (${data.videos.length})'),
                  // Same thumbnail card and same responsive grid as Home, so a
                  // lesson never degrades into a plain text link here.
                  VideoGrid(
                    videos: data.videos,
                    onTap: (video) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => LessonScreen(lesson: video.lesson),
                      ),
                    ),
                  ),
                ],
                if (data.otherLessons.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  SectionTitle('Other lessons (${data.otherLessons.length})'),
                  for (final lesson in data.otherLessons)
                    Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const Icon(Icons.article_outlined),
                        title: Text(lesson.title),
                        subtitle: Text(
                          lesson.description.isEmpty
                              ? 'No video is attached to this lesson yet.'
                              : lesson.description,
                        ),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LessonScreen(lesson: lesson),
                          ),
                        ),
                      ),
                    ),
                ],
                const SizedBox(height: 8),
                Text(
                  'Tap a video to play it inside the app.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

const _emptySnapshot = _ChapterSnapshot(videos: [], otherLessons: []);
