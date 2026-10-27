/// Accepts only real YouTube watch/share/embed URLs and returns the video id.
/// Anything else (including yout-ube lookalikes) is rejected so an admin
/// cannot smuggle an arbitrary iframe into the student app.
class YouTubeUrl {
  const YouTubeUrl._();

  static const _hosts = <String>{
    'youtube.com',
    'www.youtube.com',
    'm.youtube.com',
    'music.youtube.com',
    'youtu.be',
  };

  static final _videoId = RegExp(r'^[A-Za-z0-9_-]{11}$');

  static String? parseId(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null || uri.scheme != 'https' && uri.scheme != 'http') {
      return null;
    }
    if (!_hosts.contains(uri.host.toLowerCase())) return null;

    if (uri.host.toLowerCase() == 'youtu.be') {
      final id = uri.pathSegments.isEmpty ? '' : uri.pathSegments.first;
      return _videoId.hasMatch(id) ? id : null;
    }

    final segments = uri.pathSegments;
    if (segments.isNotEmpty) {
      final last = segments.last;
      if (_videoId.hasMatch(last) &&
          (segments.first == 'embed' ||
              segments.first == 'live' ||
              segments.first == 'shorts')) {
        return last;
      }
      if (segments.first == 'watch') {
        final id = uri.queryParameters['v'];
        if (id != null && _videoId.hasMatch(id)) return id;
      }
    }
    final listed = uri.queryParameters['list'];
    final id = uri.queryParameters['v'];
    if (id != null && _videoId.hasMatch(id) && listed == null) return id;
    return null;
  }

  static String embedUrl(String videoId) =>
      'https://www.youtube-nocookie.com/embed/$videoId';

  static String watchUrl(String videoId) =>
      'https://www.youtube.com/watch?v=$videoId';

  /// YouTube's own still frame for the video, so a card shows the real lesson
  /// instead of a made-up picture. Null when the link is not a YouTube video.
  static String? thumbnailUrl(String rawUrl) {
    final id = parseId(rawUrl);
    return id == null ? null : 'https://i.ytimg.com/vi/$id/hqdefault.jpg';
  }
}
