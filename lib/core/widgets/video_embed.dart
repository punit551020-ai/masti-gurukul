import 'dart:async';

import 'package:flutter/material.dart';

import 'video_embed_native.dart'
    if (dart.library.js_interop) 'video_embed_web.dart'
    as platform_view;

export 'video_embed_native.dart'
    if (dart.library.js_interop) 'video_embed_web.dart'
    show VideoEmbedPlatformView;

enum VideoEmbedStatus { loading, ready, failed }

/// Owns the state of one player slot: load status, retry, and the "video
/// finished" signal reported by the platform implementation.
class VideoEmbedController extends ChangeNotifier {
  VideoEmbedStatus _status = VideoEmbedStatus.loading;
  String? _failureMessage;
  bool _endedChannelLive = false;
  int _reloadToken = 0;
  final StreamController<void> _ended = StreamController<void>.broadcast();

  VideoEmbedStatus get status => _status;

  String? get failureMessage => _failureMessage;

  /// True only once the platform has proven that its "ended" listener is
  /// actually attached to the running player. UI must not promise
  /// auto-advance before this, hence the manual "Next lesson" escape hatch.
  bool get reportsEnded => _endedChannelLive;

  int get reloadToken => _reloadToken;

  Stream<void> get onEnded => _ended.stream;

  void reportStatus(VideoEmbedStatus status, {String? failureMessage}) {
    if (status == _status && _failureMessage == failureMessage) {
      return;
    }
    _status = status;
    _failureMessage = failureMessage;
    notifyListeners();
  }

  void reportEndedChannelLive() {
    if (_endedChannelLive) return;
    _endedChannelLive = true;
    notifyListeners();
  }

  void reportEnded() {
    if (_ended.isClosed) return;
    _ended.add(null);
  }

  /// Called when a different video is handed to the same slot. Silent on
  /// purpose: it runs from initState / didUpdateWidget, and notifying a
  /// listening ancestor mid-build would corrupt its element.
  void beginVideo() {
    _status = VideoEmbedStatus.loading;
    _failureMessage = null;
    _endedChannelLive = false;
  }

  void reload() {
    _reloadToken++;
    _status = VideoEmbedStatus.loading;
    _failureMessage = null;
    _endedChannelLive = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _ended.close();
    super.dispose();
  }
}

/// The platform-specific piece of [VideoEmbed]. Each implementation extends
/// this in its own file and is selected by the conditional export above.
abstract class VideoEmbedView extends StatelessWidget {
  const VideoEmbedView({
    super.key,
    required this.videoId,
    required this.controller,
    required this.autoplay,
  });

  final String videoId;
  final VideoEmbedController controller;
  final bool autoplay;

  factory VideoEmbedView.build({
    Key? key,
    required String videoId,
    required VideoEmbedController controller,
    bool autoplay = true,
  }) => platform_view.VideoEmbedPlatformView(
    key: key,
    videoId: videoId,
    controller: controller,
    autoplay: autoplay,
  );
}

/// Plays a YouTube video inside the app for an id already validated by
/// `YouTubeUrl.parseId`; the id is the only thing that reaches the embed.
class VideoEmbed extends StatefulWidget {
  const VideoEmbed({
    super.key,
    required this.videoId,
    required this.controller,
    this.autoplay = true,
    this.failureHint =
        'The video did not load. Check your internet connection and try again.',
  });

  final String videoId;
  final VideoEmbedController controller;
  final bool autoplay;
  final String failureHint;

  @override
  State<VideoEmbed> createState() => _VideoEmbedState();
}

class _VideoEmbedState extends State<VideoEmbed> {
  @override
  void initState() {
    super.initState();
    widget.controller.beginVideo();
  }

  @override
  void didUpdateWidget(VideoEmbed oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoId != widget.videoId ||
        oldWidget.controller != widget.controller) {
      widget.controller.beginVideo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ColoredBox(
        color: Colors.black,
        child: ListenableBuilder(
          listenable: widget.controller,
          builder: (context, _) {
            final status = widget.controller.status;
            return Stack(
              fit: StackFit.expand,
              children: [
                // The view is keyed on the reload token so a retry throws away
                // the old webview / iframe instead of reusing a dead one.
                VideoEmbedView.build(
                  key: ValueKey(
                    '${widget.videoId}:${widget.controller.reloadToken}',
                  ),
                  videoId: widget.videoId,
                  controller: widget.controller,
                  autoplay: widget.autoplay,
                ),
                if (status == VideoEmbedStatus.loading)
                  const Center(child: CircularProgressIndicator()),
                if (status == VideoEmbedStatus.failed)
                  _FailureOverlay(
                    message:
                        widget.controller.failureMessage ?? widget.failureHint,
                    onRetry: widget.controller.reload,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FailureOverlay extends StatelessWidget {
  const _FailureOverlay({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off_rounded, color: theme.colorScheme.error),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
              const SizedBox(height: 10),
              Text(
                'The Open on YouTube button below still works.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
