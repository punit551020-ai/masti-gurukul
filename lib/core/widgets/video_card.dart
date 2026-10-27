import 'package:flutter/material.dart';
import 'package:masti_gurukul/data/repositories/catalog_repository.dart';

import '../theme/app_theme.dart';
import '../utils/youtube_url.dart';

/// A lesson tile for the video feed.
///
/// The picture is YouTube's own frame for the linked video, so it is the real
/// lesson rather than a stock image. When there is nothing to show — offline,
/// or a lesson that only has a downloaded file — the tile falls back to the
/// subject colour instead of pretending.
class VideoCard extends StatelessWidget {
  const VideoCard({
    super.key,
    required this.item,
    required this.onTap,
    this.nowPlaying = false,
  });

  final VideoLesson item;
  final VoidCallback onTap;

  /// Marks the lesson the student is already watching, so a queue of thumbnails
  /// still answers "which one is this?".
  final bool nowPlaying;

  static String? durationLabel(int seconds) {
    if (seconds <= 0) return null;
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    final mm = m.toString().padLeft(2, '0');
    final ss = s.toString().padLeft(2, '0');
    return h > 0 ? '$h:$mm:$ss' : '$m:$ss';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = colorFromHex(item.subject.accentColor);
    final youtubeUrl = item.lesson.youtubeUrl;
    final thumbUrl = youtubeUrl == null
        ? null
        : YouTubeUrl.thumbnailUrl(youtubeUrl);
    final duration = durationLabel(item.lesson.durationSeconds);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (thumbUrl == null)
                      _ColourFallback(accent: accent)
                    else
                      Image.network(
                        thumbUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            _ColourFallback(accent: accent),
                        loadingBuilder: (context, child, progress) =>
                            progress == null
                            ? child
                            : Container(color: accent.withValues(alpha: 0.16)),
                      ),
                    Center(
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(
                            alpha: 0.90,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: accent,
                          size: 26,
                        ),
                      ),
                    ),
                    if (duration != null)
                      Positioned(
                        right: 6,
                        bottom: 6,
                        child: _Pill(label: duration, tone: _PillTone.dark),
                      ),
                    if (nowPlaying)
                      Positioned(
                        left: 6,
                        bottom: 6,
                        child: _Pill(
                          label: 'Now playing',
                          tone: _PillTone.dark,
                        ),
                      ),
                    if (item.lesson.localVideoPath != null)
                      Positioned(
                        left: 6,
                        top: 6,
                        child: _Pill(label: 'On device', tone: _PillTone.light),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2, 8, 2, 0),
              child: Text(
                item.lesson.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            Text(
              '${item.subject.nameEnglish} · Ch ${item.chapter.number}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: accent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColourFallback extends StatelessWidget {
  const _ColourFallback({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            accent.withValues(alpha: 0.55),
            accent.withValues(alpha: 0.20),
          ],
        ),
      ),
      child: Icon(
        Icons.smart_display_outlined,
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.75),
        size: 34,
      ),
    );
  }
}

enum _PillTone { dark, light }

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.tone});

  final String label;
  final _PillTone tone;

  @override
  Widget build(BuildContext context) {
    final dark = tone == _PillTone.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: dark
            ? Colors.black.withValues(alpha: 0.72)
            : Theme.of(context).colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: dark ? Colors.white : AppColors.navy,
        ),
      ),
    );
  }
}
