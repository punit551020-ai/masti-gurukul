import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/local/database.dart';
import '../../data/local/tables.dart';
import '../../data/repositories/asset_downloader.dart';
import '../../state/app_state.dart';
import '../common/state_views.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  AssetDownloader _downloader(AppState state) =>
      AssetDownloader(downloads: state.downloads, database: state.database);

  Future<void> _retry(AppState state, Download download) async {
    await _downloader(state).download(download);
  }

  Future<void> _remove(AppState state, Download download) async {
    await _downloader(state).remove(download);
  }

  // The rows and their titles are loaded together in one query so the cards
  // never flash between states. We re-run it whenever the student changes or a
  // download mutates (the [DownloadRepository.changes] counter bumps).
  Future<_DownloadsData>? _future;
  String? _futureKey;

  Future<_DownloadsData> _loadData(AppState state, String studentId) async {
    final items = await state.downloads.forStudent(studentId);
    final ids = items.map((d) => d.resourceId).toSet().toList();
    Map<String, Resource> resources = const {};
    if (ids.isNotEmpty) {
      final db = state.database;
      final rows = await (db.select(
        db.resources,
      )..where((t) => t.id.isIn(ids))).get();
      resources = {for (final r in rows) r.id: r};
    }
    return _DownloadsData(items: items, resources: resources);
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final student = state.currentStudent;
    if (student == null) {
      return const EmptyState(
        icon: Icons.download_rounded,
        title: 'No downloads',
        message: 'Enter your name first.',
      );
    }

    return ValueListenableBuilder<int>(
      valueListenable: state.downloads.changes,
      builder: (context, revision, _) {
        final key = '${student.id}|$revision';
        if (_futureKey != key) {
          _futureKey = key;
          _future = _loadData(state, student.id);
        }
        return FutureBuilder<_DownloadsData>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const ErrorState(
                message:
                    'Your saved files could not be listed on this device. '
                    'Close the tab and open it again.',
              );
            }
            if (!snapshot.hasData) {
              return const LoadingView(message: 'Checking\u2026');
            }
            final items = snapshot.data!.items;
            final resources = snapshot.data!.resources;
            final used = _bytesUsed(items);
            if (items.isEmpty) {
              return ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: const [
                  SizedBox(height: 60),
                  EmptyState(
                    icon: Icons.download_for_offline_rounded,
                    title: 'No offline files yet',
                    message:
                        'Files you download from the Library appear here and open '
                        'without internet. On the web, files are shown straight from '
                        'their link instead.',
                  ),
                ],
              );
            }
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 90),
              children: [
                _SpaceHeader(items: items, usedBytes: used),
                const SizedBox(height: 8),
                for (final download in items)
                  _DownloadCard(
                    download: download,
                    resource: resources[download.resourceId],
                    canRetry:
                        AssetDownloader.supportsLocalFiles &&
                        AssetDownloader.allowedRemoteUri(
                              resources[download.resourceId]?.remoteUrl,
                            ) !=
                            null,
                    onRetry: () => _retry(state, download),
                    onRemove: () => _remove(state, download),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  int _bytesUsed(List<Download> items) {
    var total = 0;
    for (final d in items) {
      if (d.status == DownloadStatuses.complete) {
        total += d.downloadedBytes > 0 ? d.downloadedBytes : d.totalBytes;
      }
    }
    return total;
  }
}

class _DownloadsData {
  const _DownloadsData({required this.items, required this.resources});

  final List<Download> items;
  final Map<String, Resource> resources;
}

class _SpaceHeader extends StatelessWidget {
  const _SpaceHeader({required this.items, required this.usedBytes});

  final List<Download> items;
  final int usedBytes;

  @override
  Widget build(BuildContext context) {
    final saved = items
        .where((d) => d.status == DownloadStatuses.complete)
        .length;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$saved saved  \u2022  ${_formatBytes(usedBytes)} used on this device',
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }
}

class _DownloadCard extends StatelessWidget {
  const _DownloadCard({
    required this.download,
    required this.resource,
    required this.canRetry,
    required this.onRetry,
    required this.onRemove,
  });

  final Download download;
  final Resource? resource;
  final bool canRetry;
  final VoidCallback onRetry;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = resource?.title ?? download.resourceId;
    final total = download.totalBytes;
    final fraction = total > 0
        ? (download.downloadedBytes / total).clamp(0.0, 1.0)
        : null;

    final String statusText;
    final Color statusColor;
    switch (download.status) {
      case DownloadStatuses.queued:
        statusText = 'Waiting to start';
        statusColor = theme.colorScheme.onSurfaceVariant;
      case DownloadStatuses.running:
        statusText = total > 0
            ? 'Downloading  ${_formatBytes(download.downloadedBytes)} of ${_formatBytes(total)}'
            : 'Downloading  ${_formatBytes(download.downloadedBytes)}';
        statusColor = theme.colorScheme.primary;
      case DownloadStatuses.complete:
        statusText = 'Saved for offline use';
        statusColor = theme.colorScheme.primary;
      case DownloadStatuses.failed:
        statusText = download.lastError ?? 'The download failed';
        statusColor = theme.colorScheme.error;
      default:
        statusText = download.status;
        statusColor = theme.colorScheme.onSurfaceVariant;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_icon(download.status), color: statusColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              statusText,
              style: theme.textTheme.bodySmall?.copyWith(color: statusColor),
            ),
            if (download.status == DownloadStatuses.running) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(value: fraction),
            ],
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (download.status == DownloadStatuses.failed)
                  TextButton.icon(
                    onPressed: canRetry ? onRetry : null,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                TextButton.icon(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _icon(String status) => switch (status) {
    DownloadStatuses.complete => Icons.check_circle_rounded,
    DownloadStatuses.running => Icons.downloading_rounded,
    DownloadStatuses.queued => Icons.hourglass_empty_rounded,
    DownloadStatuses.failed => Icons.error_outline_rounded,
    _ => Icons.download_rounded,
  };
}

String _formatBytes(int bytes) {
  if (bytes <= 0) return '0 B';
  const kb = 1024;
  const mb = kb * 1024;
  if (bytes < kb) return '$bytes B';
  if (bytes < mb) return '${(bytes / kb).toStringAsFixed(1)} KB';
  return '${(bytes / mb).toStringAsFixed(1)} MB';
}
