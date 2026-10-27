import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/utils/youtube_url.dart';
import '../../core/widgets/video_embed.dart';
import '../../core/widgets/video_grid.dart';
import '../../data/local/database.dart';
import '../../data/local/tables.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../state/app_state.dart';
import '../common/content_refresh.dart';
import '../common/state_views.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key, required this.lesson});

  final Lesson lesson;

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> with ContentRefresh {
  final VideoEmbedController _player = VideoEmbedController();

  List<Lesson> _queue = const [];
  List<VideoLesson> _videos = const [];
  String? _queueError;
  String _playingId = '';
  bool _bookmarked = false;
  bool _endOfQueueReached = false;
  StreamSubscription<void>? _endedSubscription;

  @override
  void initState() {
    super.initState();
    _playingId = widget.lesson.id;
    _endedSubscription = _player.onEnded.listen((_) => _advanceAutomatically());
    _loadQueue();
    _trackCurrent();
  }

  @override
  void dispose() {
    _endedSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  /// A new lesson or a corrected YouTube link appears in the playlist while
  /// the current video keeps playing.
  @override
  void onContentChanged() => _loadQueue();

  Future<void> _loadQueue() async {
    try {
      final catalog = context.read<AppState>().catalog;
      final lessons = await catalog.lessonsForChapter(widget.lesson.chapterId);
      // The same join Home uses, so the queue can be drawn as thumbnail cards
      // instead of a column of text links.
      final videos = await catalog.videoLessons(
        chapterId: widget.lesson.chapterId,
      );
      if (!mounted) return;
      setState(() {
        _queue = lessons;
        _videos = videos;
        _queueError = null;
      });
    } on Object catch (_) {
      if (!mounted) return;
      setState(
        () => _queueError =
            'The list of lessons in this chapter could not be loaded.',
      );
    }
  }

  Lesson get _current {
    for (final lesson in _queue) {
      if (lesson.id == _playingId) return lesson;
    }
    return widget.lesson;
  }

  String? _videoIdOf(Lesson lesson) =>
      lesson.youtubeUrl == null ? null : YouTubeUrl.parseId(lesson.youtubeUrl!);

  String? _nextPlayableId() {
    final index = _queue.indexWhere((l) => l.id == _playingId);
    if (index < 0) return null;
    for (var i = index + 1; i < _queue.length; i++) {
      if (_videoIdOf(_queue[i]) != null) return _queue[i].id;
    }
    return null;
  }

  Future<void> _advanceAutomatically() async {
    final next = _nextPlayableId();
    if (next == null) {
      if (mounted) setState(() => _endOfQueueReached = true);
      return;
    }
    await _play(next);
  }

  Future<void> _play(String lessonId) async {
    if (!mounted) return;
    if (_playingId == lessonId) return;
    setState(() {
      _playingId = lessonId;
      _endOfQueueReached = false;
    });
    await _trackCurrent();
  }

  Future<void> _trackCurrent() async {
    final state = context.read<AppState>();
    final student = state.currentStudent;
    if (student == null) return;
    final watchedId = _playingId;
    await state.catalog.markViewed(
      studentId: student.id,
      targetKind: TrackableKinds.lesson,
      targetId: watchedId,
    );
    final ids = await state.catalog.bookmarkedIds(
      student.id,
      TrackableKinds.lesson,
    );
    if (!mounted || _playingId != watchedId) return;
    setState(() => _bookmarked = ids.contains(watchedId));
  }

  Future<void> _toggleBookmark() async {
    final state = context.read<AppState>();
    final student = state.currentStudent;
    if (student == null) return;
    final targetId = _playingId;
    await state.catalog.toggleBookmark(
      studentId: student.id,
      targetKind: TrackableKinds.lesson,
      targetId: targetId,
    );
    final ids = await state.catalog.bookmarkedIds(
      student.id,
      TrackableKinds.lesson,
    );
    if (!mounted || _playingId != targetId) return;
    setState(() => _bookmarked = ids.contains(targetId));
  }

  Future<void> _openOnYouTube(String videoId) async {
    final uri = Uri.parse(YouTubeUrl.watchUrl(videoId));
    var opened = false;
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
        opened = true;
      }
    } on Object {
      // A phone with nothing registered for a youtube.com link answers these two
      // calls with a PlatformException. It used to escape the screen and paint an
      // error page over the lesson instead of a plain message.
      opened = false;
    }
    if (opened || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Could not open YouTube on this device')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lesson = _current;
    final videoId = _videoIdOf(lesson);
    final nextPlayableId = _nextPlayableId();

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
        actions: [
          IconButton(
            tooltip: _bookmarked ? 'Remove bookmark' : 'Add bookmark',
            icon: Icon(
              _bookmarked
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (lesson.description.isNotEmpty) ...[
            Text(lesson.description, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 18),
          ],
          if (videoId != null)
            ..._playerSection(videoId, nextPlayableId)
          else if (lesson.youtubeUrl != null)
            Card(
              color: theme.colorScheme.errorContainer,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'This URL is not a verified YouTube address, so it will '
                  'not be opened. Admins, please add a proper youtube.com / youtu.be link.',
                ),
              ),
            )
          else
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No video is attached to this lesson yet.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ),
          const SizedBox(height: 26),
          _queueSection(theme),
        ],
      ),
    );
  }

  List<Widget> _playerSection(String videoId, String? nextPlayableId) {
    final theme = Theme.of(context);
    return [
      VideoEmbed(
        key: ValueKey(_playingId),
        videoId: videoId,
        controller: _player,
      ),
      const SizedBox(height: 12),
      ListenableBuilder(
        listenable: _player,
        builder: (context, _) => Text(
          _player.reportsEnded
              ? 'The next lesson starts on its own as soon as this video ends.'
              : 'This player cannot yet tell us when the video ends, so use '
                    'the Next lesson button.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          FilledButton.tonalIcon(
            onPressed: () => _openOnYouTube(videoId),
            icon: const Icon(Icons.open_in_new_rounded),
            label: const Text('Open on YouTube'),
          ),
          if (nextPlayableId != null)
            FilledButton.icon(
              onPressed: () => _play(nextPlayableId),
              icon: const Icon(Icons.skip_next_rounded),
              label: const Text('Next lesson'),
            ),
        ],
      ),
      if (_endOfQueueReached) ...[
        const SizedBox(height: 12),
        Text(
          'That was the last video in this chapter.',
          style: theme.textTheme.bodyMedium,
        ),
      ],
    ];
  }

  /// The chapter's other lessons. The ones with a video are thumbnail cards -
  /// the same cards as Home - and only a lesson with nothing to show keeps a
  /// text row, because inventing a picture for it would be a lie.
  Widget _queueSection(ThemeData theme) {
    if (_queueError != null) {
      return ErrorState(message: _queueError!, onRetry: _loadQueue);
    }
    if (_queue.isEmpty) {
      return Text(
        'This lesson is not part of a published chapter list yet.',
        style: theme.textTheme.bodyMedium,
      );
    }

    final videoIds = {for (final video in _videos) video.lesson.id};
    final others = [
      for (final lesson in _queue)
        if (!videoIds.contains(lesson.id)) lesson,
    ];
    if (_videos.isEmpty) {
      return Text(
        _queue.length < 2
            ? 'This is the only lesson published in this chapter so far.'
            : 'No lesson in this chapter has a video yet.',
        style: theme.textTheme.bodyMedium,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('Videos in this chapter (${_videos.length})'),
        VideoGrid(
          videos: _videos,
          playingId: _playingId,
          onTap: (video) => _play(video.lesson.id),
        ),
        if (others.isNotEmpty) ...[
          const SizedBox(height: 24),
          SectionTitle('Other lessons (${others.length})'),
          for (final lesson in others) _lessonRow(lesson, theme),
        ],
      ],
    );
  }

  Widget _lessonRow(Lesson lesson, ThemeData theme) {
    final isCurrent = lesson.id == _playingId;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: isCurrent ? theme.colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: ListTile(
        onTap: () => _play(lesson.id),
        leading: Icon(
          isCurrent ? Icons.play_circle_fill_rounded : Icons.article_outlined,
          color: isCurrent ? theme.colorScheme.primary : null,
        ),
        title: Text(lesson.title),
        subtitle: Text(
          isCurrent
              ? 'Now playing'
              : lesson.youtubeUrl != null
              ? 'The stored link is not a valid YouTube address'
              : 'No video attached to this lesson',
        ),
        trailing: isCurrent ? null : const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
