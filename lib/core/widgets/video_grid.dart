import 'package:flutter/material.dart';

import '../../data/repositories/catalog_repository.dart';
import 'video_card.dart';

/// The measurements behind every video thumbnail grid in the app.
///
/// Home, subject, chapter, lesson-queue and recently-viewed all lay videos out
/// with these numbers, so a lesson looks like the same object wherever a student
/// meets it. Column count follows the width instead of the screen name: about
/// one card per 160 dp, which gives a phone two columns and a wide browser
/// window several, with no per-device branch anywhere.
class VideoGridLayout {
  /// Roughly how wide one thumbnail card wants to be.
  static const tileTargetWidth = 160.0;

  /// Gap between columns.
  static const gap = 12.0;

  /// Gap between rows.
  static const rowSpacing = 14.0;

  /// The two title lines and the subject line under a thumbnail.
  static const captionHeight = 64.0;

  static int columnsFor(double width) =>
      (width / tileTargetWidth).floor().clamp(1, 5);

  /// A tile is a 16:9 thumbnail plus its caption, so a row is as tall as the
  /// cards in it need rather than a number someone guessed.
  static SliverGridDelegateWithFixedCrossAxisCount delegateFor(double width) {
    final columns = columnsFor(width);
    final tileWidth = (width - (columns - 1) * gap) / columns;
    return SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: columns,
      crossAxisSpacing: gap,
      mainAxisSpacing: rowSpacing,
      mainAxisExtent: tileWidth * 9 / 16 + captionHeight,
    );
  }
}

/// What a screen does when a student taps one of the thumbnails.
typedef VideoCardTap = void Function(VideoLesson video);

/// The thumbnail grid, as a sliver, for a `CustomScrollView`.
///
/// This is the lazy one: with a few hundred published lessons only the cards
/// near the viewport are ever built, so scrolling stays smooth and nothing at
/// the end of the list is ever left out. There is no cap and no sideways drag.
class VideoGridSliver extends StatelessWidget {
  const VideoGridSliver({
    super.key,
    required this.videos,
    required this.onTap,
    this.playingId,
  });

  final List<VideoLesson> videos;
  final VideoCardTap onTap;

  /// The lesson already on screen, so the student can see which one is playing.
  final String? playingId;

  @override
  Widget build(BuildContext context) => SliverLayoutBuilder(
    builder: (context, constraints) => SliverGrid.builder(
      gridDelegate: VideoGridLayout.delegateFor(constraints.crossAxisExtent),
      itemCount: videos.length,
      itemBuilder: (context, index) => _card(videos[index]),
    ),
  );

  Widget _card(VideoLesson video) => VideoCard(
    item: video,
    nowPlaying: video.lesson.id == playingId,
    onTap: () => onTap(video),
  );
}

/// The same grid, as a plain widget, for a `ListView` or `Column`.
///
/// It sizes itself to its content and never scrolls on its own, so it nests in a
/// screen that already scrolls without trapping the student in a second bar.
class VideoGrid extends StatelessWidget {
  const VideoGrid({
    super.key,
    required this.videos,
    required this.onTap,
    this.playingId,
  });

  final List<VideoLesson> videos;
  final VideoCardTap onTap;
  final String? playingId;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: VideoGridLayout.delegateFor(constraints.maxWidth),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return VideoCard(
          item: video,
          nowPlaying: video.lesson.id == playingId,
          onTap: () => onTap(video),
        );
      },
    ),
  );
}
