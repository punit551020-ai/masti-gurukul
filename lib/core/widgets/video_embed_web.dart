import 'dart:convert';
import 'dart:js_interop';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import '../utils/youtube_url.dart';
import 'video_embed.dart';

/// Web implementation, reachable only through the conditional export in
/// video_embed.dart: it pulls in dart:ui_web and package:web, which do not
/// exist on Android.
class VideoEmbedPlatformView extends VideoEmbedView {
  const VideoEmbedPlatformView({
    super.key,
    required super.videoId,
    required super.controller,
    required super.autoplay,
  });

  @override
  Widget build(BuildContext context) => _WebYouTubePlayer(
    videoId: videoId,
    controller: controller,
    autoplay: autoplay,
  );
}

class _WebYouTubePlayer extends StatefulWidget {
  const _WebYouTubePlayer({
    required this.videoId,
    required this.controller,
    required this.autoplay,
  });

  final String videoId;
  final VideoEmbedController controller;
  final bool autoplay;

  @override
  State<_WebYouTubePlayer> createState() => _WebYouTubePlayerState();
}

class _WebYouTubePlayerState extends State<_WebYouTubePlayer> {
  /// A fresh id per instance: two players alive at the same time must not share
  /// one registered html element.
  static int _serial = 0;

  static const _endedPlayerState = 0;

  static const _allow =
      'accelerometer; autoplay; clipboard-write; encrypted-media; '
      'gyroscope; picture-in-picture';

  late final String _viewTypeId;
  late final web.HTMLIFrameElement _frame;
  late final JSFunction _onMessage;
  late final JSFunction _onOffline;

  @override
  void initState() {
    super.initState();
    _serial++;
    _viewTypeId = 'masti-gurukul-youtube-embed-$_serial';
    _frame = _buildFrame();
    ui_web.platformViewRegistry.registerViewFactory(
      _viewTypeId,
      (int viewId) => _frame,
    );

    _onMessage = ((web.MessageEvent event) => _handleMessage(event)).toJS;
    _onOffline = (() => _handleNetworkChange()).toJS;
    web.window.addEventListener('message', _onMessage);
    web.window.addEventListener('offline', _onOffline);

    // initState runs inside the build phase, so the first status has to wait
    // for the frame to end before notifying listening ancestors.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _reportNetwork();
    });
  }

  web.HTMLIFrameElement _buildFrame() =>
      (web.document.createElement('iframe') as web.HTMLIFrameElement)
        ..src = _embedSrc()
        ..allow = _allow
        ..allowFullscreen = true
        ..title = 'YouTube lesson'
        ..style.cssText =
            'width:100%;height:100%;border:0;display:block;background:#000;';

  String _embedSrc() => Uri.parse(YouTubeUrl.embedUrl(widget.videoId))
      .replace(
        queryParameters: {
          'autoplay': widget.autoplay ? '1' : '0',
          'enablejsapi': '1',
          'playsinline': '1',
          'rel': '0',
          'modestbranding': '1',
        },
      )
      .toString();

  /// The embed runs cross-origin, so Dart cannot read its player state. The
  /// only truthful observations here are the browser network state and the
  /// messages the player posts into this page.
  void _reportNetwork() {
    if (web.window.navigator.onLine) {
      widget.controller.reportStatus(VideoEmbedStatus.ready);
    } else {
      widget.controller.reportStatus(
        VideoEmbedStatus.failed,
        failureMessage: 'You appear to be offline, so the video cannot load.',
      );
    }
  }

  void _handleNetworkChange() {
    if (!mounted) return;
    _reportNetwork();
  }

  void _handleMessage(web.MessageEvent event) {
    if (!mounted) return;
    if (!_isFromThisPlayer(event)) return;
    final payload = _decode(event.data);
    if (payload == null) return;

    switch (payload['event']) {
      case 'onReady':
      case 'infoDelivery':
        // A message we can attribute to this exact iframe proves the player is
        // alive, which is what makes auto-advance an honest promise.
        widget.controller.reportEndedChannelLive();
      case 'onError':
        widget.controller.reportStatus(
          VideoEmbedStatus.failed,
          failureMessage:
              'YouTube refused to play this video (code ${payload['info']}). '
              'It may have been removed or made private.',
        );
      case 'onStateChange':
        widget.controller.reportEndedChannelLive();
        if (_isEnded(payload['info'])) widget.controller.reportEnded();
    }
  }

  bool _isFromThisPlayer(web.MessageEvent event) {
    final source = event.source;
    final own = _frame.contentWindow;
    if (source == null || own == null || source != own) return false;
    final host = Uri.tryParse(event.origin)?.host.toLowerCase() ?? '';
    return host == 'youtube.com' ||
        host.endsWith('.youtube.com') ||
        host == 'youtube-nocookie.com' ||
        host.endsWith('.youtube-nocookie.com');
  }

  Map<String, dynamic>? _decode(JSAny? data) {
    final raw = data?.dartify();
    if (raw is Map<String, dynamic>) return raw;
    if (raw is! String) return null;
    try {
      final decoded = jsonDecode(raw);
      return decoded is Map<String, dynamic> ? decoded : null;
    } on FormatException {
      return null;
    }
  }

  bool _isEnded(Object? info) {
    if (info is num) return info.toInt() == _endedPlayerState;
    if (info is Map) {
      final state = info['playerState'];
      if (state is num && state.toInt() == _endedPlayerState) return true;
      final ended = info['ended'];
      if (ended == true) return true;
      if (ended is num && ended.toInt() == 1) return true;
    }
    return false;
  }

  @override
  void dispose() {
    web.window.removeEventListener('message', _onMessage);
    web.window.removeEventListener('offline', _onOffline);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HtmlElementView(viewType: _viewTypeId);
}
