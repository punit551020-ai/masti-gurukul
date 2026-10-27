import 'dart:async';

import 'package:path/path.dart' as p;

import '../local/database.dart';
import 'download_repository.dart';

// The heavy lifting (HTTP streaming + writing files to the app's documents
// folder) needs `dart:io`, which does not exist on the web. The two files
// behind this conditional import expose the exact same top-level functions; the
// web one refuses instead of pretending. Same technique as video_embed.dart.
import 'asset_downloader_io.dart'
    if (dart.library.js_interop) 'asset_downloader_web.dart'
    as io;

/// A successful byte stream pulled from a remote URL. [contentLength] is null
/// when the server did not advertise a length.
class ByteResponse {
  const ByteResponse({required this.contentLength, required this.bytes});

  final int? contentLength;
  final Stream<List<int>> bytes;
}

/// A write-ahead byte sink for the destination file. `dart:io` provides the
/// real one; the web build never reaches this.
abstract class LocalSink {
  void add(List<int> chunk);
  Future<void> close();
}

/// A download that could not be carried out for a clear reason. The message is
/// stored verbatim as `Downloads.lastError`, so it must be plain English.
class DownloadFailure implements Exception {
  const DownloadFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Where the bytes come from. Tests inject a fake source so they never hit the
/// network; production uses the `dart:io` HttpClient behind the conditional
/// import.
typedef ByteSource = Future<ByteResponse> Function(String url);

/// Downloads a resource's bytes into a per-app documents subfolder and keeps
/// the `Downloads` row honest as it goes (QUEUED -> RUNNING -> COMPLETE /
/// FAILED). It refuses to write anywhere outside its own directory and never
/// marks an empty or non-PDF file as COMPLETE.
class AssetDownloader {
  AssetDownloader({
    required DownloadRepository downloads,
    required AppDatabase database,
    ByteSource? source,
    String? documentsDirOverride,
  }) : _repo = downloads,
       _db = database,
       _byteSource = source,
       _dirOverride = documentsDirOverride;

  final DownloadRepository _repo;
  final AppDatabase _db;
  final ByteSource? _byteSource;
  final String? _dirOverride;

  static const _pdfSignature = <int>[0x25, 0x50, 0x44, 0x46]; // %PDF

  /// True only on builds that can save files inside the app folder (Android).
  /// The web build downloads through the browser instead, so it returns false.
  static bool get supportsLocalFiles => io.canStoreFiles;

  // ---------------------------------------------------------------------------
  // Pure security + path rules. Unit-testable without touching the network.
  // ---------------------------------------------------------------------------

  /// Only https links the admin typed are allowed, and only if the last path
  /// segment looks like a real file (a short alphanumeric extension). Anything
  /// else - http, file:, data:, a bare host, or a page URL - is rejected.
  static Uri? allowedRemoteUri(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return null;
    final uri = Uri.tryParse(value);
    if (uri == null) return null;
    if (uri.scheme != 'https') return null;
    if (uri.host.isEmpty) return null;
    if (uri.userInfo.isNotEmpty) return null;
    if (uri.hasPort && (uri.port <= 0 || uri.port > 65535)) return null;
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.isEmpty) return null;
    final last = segments.last;
    final looksLikeFile =
        last.contains('.') && RegExp(r'\.[A-Za-z0-9]{2,5}$').hasMatch(last);
    if (!looksLikeFile) return null;
    return uri;
  }

  /// The destination file name for a resource: its id, stripped down to a
  /// safe set of characters, with a `.pdf` extension.
  static String safeFileName(Resource resource) {
    final cleaned = resource.id.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
    final trimmed = cleaned.replaceAll('.', '_');
    final base = trimmed.isEmpty ? 'resource' : trimmed;
    return '${base.substring(0, base.length > 80 ? 80 : base.length)}.pdf';
  }

  /// Joins [fileName] under [baseDir] and returns the normalized path, or null
  /// when the result would not land inside [baseDir]. Rejects absolute paths,
  /// parent traversal, separators, NUL bytes and empty names.
  static String? resolvedSafePath(String baseDir, String fileName) {
    if (fileName.isEmpty || fileName.contains('\u0000')) return null;
    if (p.isAbsolute(fileName)) return null;
    // The name must be a single, flat component: no separators, no `..`.
    if (fileName != p.basename(fileName)) return null;
    if (fileName == '.' || fileName == '..') return null;
    final normalizedBase = p.normalize(baseDir);
    final joined = p.normalize(p.join(normalizedBase, fileName));
    if (!p.isWithin(normalizedBase, joined)) return null;
    return joined;
  }

  /// True only when the leading bytes contain the `%PDF` magic. An empty buffer
  /// or a corrupt payload is rejected so we never call it a completed download.
  static bool looksLikePdf(List<int> head) {
    if (head.length < _pdfSignature.length) return false;
    for (var i = 0; i + _pdfSignature.length <= head.length; i++) {
      var matched = true;
      for (var j = 0; j < _pdfSignature.length; j++) {
        if (head[i + j] != _pdfSignature[j]) {
          matched = false;
          break;
        }
      }
      if (matched) return true;
    }
    return false;
  }

  // ---------------------------------------------------------------------------
  // Orchestration.
  // ---------------------------------------------------------------------------

  Future<Download> enqueue(Resource resource, String studentId) =>
      _repo.enqueue(studentId: studentId, resourceId: resource.id);

  /// Downloads [download]'s resource from scratch. If a previous attempt left a
  /// partial file it is overwritten, not treated as resumable - a truncated
  /// PDF cannot be trusted.
  Future<void> download(Download download) async {
    if (!supportsLocalFiles) {
      await _repo.markFailed(
        downloadId: download.id,
        error:
            'This build does not save files inside the app. On the web, '
            'open the file and let your browser download it instead.',
      );
      return;
    }

    final resource = await (_db.select(
      _db.resources,
    )..where((t) => t.id.equals(download.resourceId))).getSingleOrNull();
    if (resource == null) {
      await _repo.markFailed(
        downloadId: download.id,
        error: 'That file is no longer available in the Library.',
      );
      return;
    }

    final uri = allowedRemoteUri(resource.remoteUrl);
    if (uri == null) {
      await _repo.markFailed(
        downloadId: download.id,
        error:
            'This file has no secure (https) download link, so it cannot '
            'be saved for offline use.',
      );
      return;
    }

    final String baseDir;
    try {
      baseDir = _dirOverride ?? await io.resolveBaseDir();
    } on Object {
      // Reaching the app's own folder is a platform call, and it fails on a
      // phone whose storage is full or not mounted yet. That belongs in the
      // download row as a message, not as an exception in the Library tab.
      await _repo.markFailed(
        downloadId: download.id,
        error:
            'The app could not reach its own storage folder. Free up space on '
            'this device and try again.',
      );
      return;
    }
    final dest = resolvedSafePath(baseDir, safeFileName(resource));
    if (dest == null) {
      await _repo.markFailed(
        downloadId: download.id,
        error:
            'The save location falls outside the app folder, so the '
            'download was refused.',
      );
      return;
    }

    final knownTotal = resource.fileSizeBytes > 0
        ? resource.fileSizeBytes
        : null;
    await _repo.markRunning(
      downloadId: download.id,
      localPath: dest,
      totalBytes: knownTotal,
    );

    LocalSink? sink;
    var written = 0;
    var started = false;
    try {
      final source = _byteSource ?? io.openUrlStream;
      final response = await source(uri.toString());
      final total = response.contentLength ?? knownTotal;
      sink = await io.openSink(dest);
      started = true;
      await for (final chunk in response.bytes) {
        if (chunk.isEmpty) continue;
        sink.add(chunk);
        written += chunk.length;
        await _repo.updateProgress(
          downloadId: download.id,
          downloadedBytes: written,
          totalBytes: total,
        );
      }
      await sink.close();
      sink = null;

      if (written == 0) {
        await io.deleteFile(dest);
        await _repo.markFailed(
          downloadId: download.id,
          error: 'The server returned an empty file.',
        );
        return;
      }

      final head = await io.readHead(dest, 1024);
      if (!looksLikePdf(head)) {
        await io.deleteFile(dest);
        await _repo.markFailed(
          downloadId: download.id,
          error:
              'The downloaded file is not a readable PDF and may be '
              'corrupt. It was not saved as complete.',
        );
        return;
      }

      await _repo.markComplete(
        downloadId: download.id,
        localPath: dest,
        downloadedBytes: written,
        totalBytes: total ?? written,
      );
    } on DownloadFailure catch (failure) {
      await _cleanup(sink, dest, started);
      await _repo.markFailed(downloadId: download.id, error: failure.message);
    } on Object catch (error) {
      await _cleanup(sink, dest, started);
      await _repo.markFailed(
        downloadId: download.id,
        error: 'The download could not finish: $error',
      );
    }
  }

  Future<void> _cleanup(LocalSink? sink, String dest, bool started) async {
    if (sink != null) {
      try {
        await sink.close();
      } on Object catch (_) {
        // Best effort; the row already says FAILED.
      }
    }
    if (started) {
      try {
        await io.deleteFile(dest);
      } on Object catch (_) {
        // Ignore: nothing else we can do about a half-written file.
      }
    }
  }

  Future<void> retry(Download attempt) => download(attempt);

  /// Deletes the saved file (if any) and removes the row.
  Future<void> remove(Download download) async {
    final path = download.localPath;
    if (path != null && supportsLocalFiles) {
      try {
        await io.deleteFile(path);
      } on Object catch (_) {
        // The file may already be gone; dropping the row is what matters.
      }
    }
    await _repo.forget(download.id);
  }
}
