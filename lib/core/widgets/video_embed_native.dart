import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/youtube_url.dart';
import 'video_embed.dart';

/// Non-web implementation. Reachable only through the conditional export in
/// video_embed.dart, because webview_flutter has no web platform.
class VideoEmbedPlatformView extends VideoEmbedView {
  const VideoEmbedPlatformView({
    super.key,
    required super.videoId,
    required super.controller,
    required super.autoplay,
  });

  @override
  Widget build(BuildContext context) => _NativeYouTubePlayer(
    videoId: videoId,
    controller: controller,
    autoplay: autoplay,
  );
}

class _NativeYouTubePlayer extends StatefulWidget {
  const _NativeYouTubePlayer({
    required this.videoId,
    required this.controller,
    required this.autoplay,
  });

  final String videoId;
  final VideoEmbedController controller;
  final bool autoplay;

  @override
  State<_NativeYouTubePlayer> createState() => _NativeYouTubePlayerState();
}

class _NativeYouTubePlayerState extends State<_NativeYouTubePlayer> {
  static const _channel = 'MastiGurukulPlayer';

  WebViewController? _webViewController;
  Timer? _attachTimeout;

  @override
  void initState() {
    super.initState();
    _attachTimeout = Timer(const Duration(seconds: 25), _onAttachTimeout);
    // Reporting during initState would notify listeners inside the build phase,
    // so the webview is only started once the frame is on screen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _boot();
    });
  }

  void _onAttachTimeout() {
    if (!mounted) return;
    if (widget.controller.status == VideoEmbedStatus.loading) {
      widget.controller.reportStatus(
        VideoEmbedStatus.failed,
        failureMessage:
            'The video did not load. It needs a working internet connection.',
      );
    }
  }

  Future<void> _boot() async {
    try {
      final webViewController = WebViewController();
      await webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);
      await webViewController.setBackgroundColor(Colors.black);
      await webViewController.addJavaScriptChannel(
        _channel,
        onMessageReceived: _onHostMessage,
      );
      await webViewController.setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            if (!mounted) return;
            _stopWatching();
            widget.controller.reportStatus(
              VideoEmbedStatus.failed,
              failureMessage:
                  'The video could not be fetched: ${error.description}',
            );
          },
        ),
      );
      await webViewController.loadHtmlString(
        _wrapperHtml(),
        baseUrl: _embedOrigin,
      );
      if (!mounted) return;
      setState(() => _webViewController = webViewController);
    } on Object catch (_) {
      if (!mounted) return;
      _stopWatching();
      widget.controller.reportStatus(
        VideoEmbedStatus.failed,
        failureMessage: 'The video player could not be started on this device.',
      );
    }
  }

  void _stopWatching() => _attachTimeout?.cancel();

  String get _embedOrigin =>
      Uri.parse(YouTubeUrl.embedUrl(widget.videoId)).origin;

  /// The id reaching this string already went through `YouTubeUrl.parseId`, so
  /// it is exactly 11 characters of `[A-Za-z0-9_-]` and cannot break out of the
  /// JS string literal it is placed into.
  String _wrapperHtml() {
    final origin = _embedOrigin;
    final channel = _channel;
    final autoplay = widget.autoplay ? 1 : 0;
    return '''
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no">
<style>
  html, body { margin: 0; padding: 0; height: 100%; background: #000; overflow: hidden; }
  #player { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
</style>
</head>
<body>
<div id="player"></div>
<script>
  var booted = false;
  function send(message) {
    try { window.$channel.postMessage(message); } catch (e) {}
  }
  var script = document.createElement('script');
  script.src = 'https://www.youtube.com/iframe_api';
  script.onerror = function () { send('ERROR:SCRIPT'); };
  document.head.appendChild(script);
  setTimeout(function () { if (!booted) { send('ERROR:SCRIPT'); } }, 20000);
  function onYouTubeIframeAPIReady() {
    new YT.Player('player', {
      videoId: '${widget.videoId}',
      playerVars: {
        autoplay: $autoplay,
        enablejsapi: 1,
        playsinline: 1,
        rel: 0,
        modestbranding: 1,
        origin: '$origin'
      },
      events: {
        onReady: function () { booted = true; send('READY'); },
        onError: function (event) { booted = true; send('ERROR:' + event.data); },
        onStateChange: function (event) {
          if (event.data === YT.PlayerState.ENDED) { send('ENDED'); }
        }
      }
    });
  }
</script>
</body>
</html>
''';
  }

  void _onHostMessage(JavaScriptMessage message) {
    if (!mounted) return;
    _stopWatching();
    final payload = message.message;
    switch (payload) {
      case 'READY':
        widget.controller
          ..reportStatus(VideoEmbedStatus.ready)
          ..reportEndedChannelLive();
      case 'ENDED':
        widget.controller.reportEnded();
      default:
        if (payload.startsWith('ERROR:')) {
          widget.controller.reportStatus(
            VideoEmbedStatus.failed,
            failureMessage: payload == 'ERROR:SCRIPT'
                ? 'YouTube could not be reached. Check your internet '
                      'connection.'
                : 'YouTube reported a problem with this video '
                      '(code ${payload.substring(6)}).',
          );
        }
    }
  }

  @override
  void dispose() {
    _attachTimeout?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final webViewController = _webViewController;
    if (webViewController == null) {
      return const SizedBox.expand();
    }
    return WebViewWidget(
      controller: webViewController,
      layoutDirection: Directionality.of(context),
    );
  }
}
