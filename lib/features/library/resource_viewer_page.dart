import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/pdf_view.dart';
import '../../data/local/database.dart';
import '../../data/local/tables.dart';
import '../../data/repositories/asset_downloader.dart';
import '../../state/app_state.dart';
import '../common/state_views.dart';

/// Opens one Library resource. On Android it shows a downloaded file with the
/// in-app PDF viewer, or offers a real download when it is not saved yet. On
/// the web it embeds the admin's https link in the browser's PDF viewer.
class ResourceViewerPage extends StatefulWidget {
  const ResourceViewerPage({super.key, required this.resource});

  final Resource resource;

  @override
  State<ResourceViewerPage> createState() => _ResourceViewerPageState();
}

class _ResourceViewerPageState extends State<ResourceViewerPage> {
  final PdfViewerController _viewer = PdfViewerController();

  // Single-row download cache so the viewer updates on progress without holding
  // a live drift stream (which would leak a cleanup timer in widget tests).
  Future<Download?>? _downloadFuture;
  String? _downloadKey;

  Future<Download?> _downloadFor(
    AppState state,
    String studentId,
    String resourceId,
    int revision,
  ) {
    final key = '$studentId|$resourceId|$revision';
    if (_downloadKey != key) {
      _downloadKey = key;
      _downloadFuture = state.downloads.forStudentAndResource(
        studentId,
        resourceId,
      );
    }
    return _downloadFuture!;
  }

  @override
  void dispose() {
    _viewer.dispose();
    super.dispose();
  }

  AssetDownloader _downloader(AppState state) =>
      AssetDownloader(downloads: state.downloads, database: state.database);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final student = state.currentStudent;
    final resource = widget.resource;
    final canStreamFromWeb =
        AssetDownloader.allowedRemoteUri(resource.remoteUrl) != null;

    return Scaffold(
      appBar: AppBar(title: Text(resource.title, maxLines: 2)),
      body: SafeArea(
        child: student == null
            ? const Center(child: Text('Enter your name first.'))
            : Column(
                children: [
                  _MetaBar(resource: resource),
                  Expanded(
                    child: ValueListenableBuilder<int>(
                      valueListenable: state.downloads.changes,
                      builder: (context, revision, _) {
                        return FutureBuilder<Download?>(
                          future: _downloadFor(
                            state,
                            student.id,
                            resource.id,
                            revision,
                          ),
                          builder: (context, snapshot) {
                            final download = snapshot.data;
                            return _bodyFor(
                              state,
                              resource,
                              download,
                              canStreamFromWeb,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _bodyFor(
    AppState state,
    Resource resource,
    Download? download,
    bool canStreamFromWeb,
  ) {
    final saved =
        download != null &&
        download.status == DownloadStatuses.complete &&
        (download.localPath?.isNotEmpty ?? false);

    // Native build: only hand the viewer a file once the download is complete.
    final localPath = AssetDownloader.supportsLocalFiles && saved
        ? download.localPath
        : null;

    final busy =
        download != null &&
        (download.status == DownloadStatuses.queued ||
            download.status == DownloadStatuses.running);

    // A row can now be saved with only a title, so the file may genuinely not
    // exist yet. Saying that is better than a blank page and a dead Download
    // button, and it is the same sentence on every platform.
    if (!canStreamFromWeb && !saved && (resource.localFilePath ?? '').isEmpty) {
      return const EmptyState(
        icon: Icons.upload_file_rounded,
        title: 'The file is not here yet',
        message:
            'This entry has no document attached to it yet. The owner can add '
            'the file later, and it will appear here automatically.',
      );
    }

    return Column(
      children: [
        if (busy)
          _ProgressStrip(
            downloaded: download.downloadedBytes,
            total: download.totalBytes,
          ),
        if (!busy && download?.status == DownloadStatuses.failed)
          _FailureStrip(message: download!.lastError ?? 'The download failed.'),
        if (!AssetDownloader.supportsLocalFiles && !saved)
          _WebHintStrip(resource: resource, canDownload: canStreamFromWeb),
        Expanded(
          child: PdfViewer(
            controller: _viewer,
            title: resource.title,
            localFilePath: localPath,
            remoteUrl: resource.remoteUrl,
            canDownload: canStreamFromWeb,
          ),
        ),
        _ActionDock(
          resource: resource,
          download: download,
          saved: saved,
          busy: busy,
          canStreamFromWeb: canStreamFromWeb,
          onStartDownload: () => _startOrRetry(state, resource),
        ),
      ],
    );
  }

  Future<void> _startOrRetry(AppState state, Resource resource) async {
    final student = state.currentStudent;
    if (student == null) return;
    final download = await state.downloads.enqueue(
      studentId: student.id,
      resourceId: resource.id,
    );
    await _downloader(state).download(download);
    // The changes counter rebuilds the body, so no manual reload is needed.
  }
}

class _MetaBar extends StatelessWidget {
  const _MetaBar({required this.resource});

  final Resource resource;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = <String>[
      _kindLabel(resource.kind),
      if (resource.yearLabel != null) '${resource.yearLabel}',
      if (resource.fileSizeBytes > 0) _formatBytes(resource.fileSizeBytes),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            parts.join('  \u2022  '),
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (resource.description.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(resource.description, style: theme.textTheme.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _ProgressStrip extends StatelessWidget {
  const _ProgressStrip({required this.downloaded, required this.total});

  final int downloaded;
  final int total;

  @override
  Widget build(BuildContext context) {
    final fraction = total > 0 ? (downloaded / total).clamp(0.0, 1.0) : null;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            total > 0
                ? 'Downloading  ${_formatBytes(downloaded)} of ${_formatBytes(total)}'
                : 'Downloading  ${_formatBytes(downloaded)} so far',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(value: fraction),
        ],
      ),
    );
  }
}

class _FailureStrip extends StatelessWidget {
  const _FailureStrip({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WebHintStrip extends StatelessWidget {
  const _WebHintStrip({required this.resource, required this.canDownload});

  final Resource resource;
  final bool canDownload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        canDownload
            ? 'On the web this file is shown from its link using your browser. '
                  'To read it offline, use the Android app.'
            : 'This file has no https link, so the browser cannot open it here. '
                  'Use the Android app to download and read it offline.',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ActionDock extends StatelessWidget {
  const _ActionDock({
    required this.resource,
    required this.download,
    required this.saved,
    required this.busy,
    required this.canStreamFromWeb,
    required this.onStartDownload,
  });

  final Resource resource;
  final Download? download;
  final bool saved;
  final bool busy;
  final bool canStreamFromWeb;
  final VoidCallback onStartDownload;

  @override
  Widget build(BuildContext context) {
    final failed =
        download != null && download!.status == DownloadStatuses.failed;

    // Web build: the browser does the download, so we do not offer an in-app
    // offline save that could not actually write a file.
    if (!AssetDownloader.supportsLocalFiles) {
      return const SizedBox.shrink();
    }

    final Widget button;
    if (saved) {
      button = FilledButton.icon(
        onPressed: null,
        icon: const Icon(Icons.check_circle_rounded),
        label: const Text('Opened from download'),
      );
    } else if (busy) {
      button = FilledButton.icon(
        onPressed: null,
        icon: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
        label: const Text('Downloading'),
      );
    } else if (failed) {
      button = FilledButton.icon(
        onPressed: canStreamFromWeb ? onStartDownload : null,
        icon: const Icon(Icons.refresh_rounded),
        label: const Text('Retry download'),
      );
    } else {
      button = FilledButton.icon(
        onPressed: canStreamFromWeb ? onStartDownload : null,
        icon: const Icon(Icons.download_rounded),
        label: const Text('Download'),
      );
    }

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            if (!canStreamFromWeb && !saved)
              Expanded(
                child: Text(
                  'No https link was set for this file, so it cannot be '
                  'downloaded.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              )
            else
              const Spacer(),
            const SizedBox(width: 12),
            button,
          ],
        ),
      ),
    );
  }
}

String _kindLabel(String kind) => switch (kind) {
  ResourceKinds.notes => 'Notes',
  ResourceKinds.pdf => 'PDF',
  ResourceKinds.worksheet => 'Worksheet',
  ResourceKinds.previousYearPaper => 'Previous year papers',
  _ => kind,
};

String _formatBytes(int bytes) {
  if (bytes <= 0) return 'Unknown size';
  const kb = 1024;
  const mb = kb * 1024;
  if (bytes < kb) return '$bytes B';
  if (bytes < mb) return '${(bytes / kb).toStringAsFixed(1)} KB';
  return '${(bytes / mb).toStringAsFixed(1)} MB';
}
