import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/local/database.dart';
import '../../data/local/tables.dart';
import '../../data/repositories/asset_downloader.dart';
import '../../data/repositories/catalog_repository.dart';
import '../../state/app_state.dart';
import '../common/content_refresh.dart';
import '../common/state_views.dart';
import 'resource_viewer_page.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key, this.onSync});

  /// Pull-to-refresh calls this before reloading from the local database. The
  /// sync engine can supply a callback that refreshes Supabase into drift; when
  /// it is null the refresh simply re-reads what is already stored.
  final Future<void> Function()? onSync;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with ContentRefresh {
  String? _subjectId;
  String? _kind;
  int? _year;
  final _searchController = TextEditingController();

  late Future<List<Subject>> _subjects = _loadSubjects();
  late Future<_LibraryData> _data = _load();

  /// A PDF the owner publishes while this page is open should appear without
  /// the student pulling to refresh — the same rule the class pages follow.
  @override
  void onContentChanged() {
    _subjects = observed(_loadSubjects());
    _data = observed(_load());
  }

  // Cached so the download map refreshes only when the student changes or a
  // download mutates, instead of on every rebuild.
  Future<List<Download>>? _downloadsFuture;
  String? _downloadsKey;

  Future<List<Download>> _downloadsFor(
    AppState state,
    String studentId,
    int revision,
  ) {
    final key = '$studentId|$revision';
    if (_downloadsKey != key) {
      _downloadsKey = key;
      _downloadsFuture = state.downloads.forStudent(studentId);
    }
    return _downloadsFuture!;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<Subject>> _loadSubjects() async {
    final classId = context.read<AppState>().selectedClassId;
    if (classId == null) return const [];
    return context.read<AppState>().catalog.subjectsForClass(classId);
  }

  Future<_LibraryData> _load() async {
    final catalog = context.read<AppState>().catalog;
    final classId = context.read<AppState>().selectedClassId;
    final resources = await catalog.resources(
      ResourceFilter(
        classId: classId,
        subjectId: _subjectId,
        kind: _kind,
        yearLabel: _year,
        search: _searchController.text,
      ),
    );
    final years = await catalog.resourceYears(
      classId: classId,
      subjectId: _subjectId,
    );
    return _LibraryData(resources: resources, years: years);
  }

  void _reload() => setState(() {
    _subjects = observed(_loadSubjects());
    _data = observed(_load());
  });
  Future<void> _onRefresh() async {
    try {
      await widget.onSync?.call();
    } on Object {
      // Refreshing is a retry, not a test: a failed pull belongs on the screen,
      // never in an uncaught future that kills the route.
    }
    if (!mounted) return;
    _reload();
    try {
      // Let the new queries settle so the indicator does not vanish instantly.
      await _data;
    } on Object {
      // The error branch in _buildBody shows the student what happened.
    }
  }

  AssetDownloader _downloader(AppState state) =>
      AssetDownloader(downloads: state.downloads, database: state.database);

  Future<void> _startOrRetry(AppState state, Resource resource) async {
    final student = state.currentStudent;
    if (student == null) return;
    try {
      final download = await state.downloads.enqueue(
        studentId: student.id,
        resourceId: resource.id,
      );
      await _downloader(state).download(download);
    } on Object {
      // Saving the row, or opening a file handle for it, can fail on a phone
      // whose storage is full. Network failures already land in the download
      // row's own error, so this is the rest.
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The file could not be saved on this device.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final classId = state.selectedClassId;
    final student = state.currentStudent;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: student == null
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 60),
                const EmptyState(
                  icon: Icons.person_rounded,
                  title: 'Tell us your name first',
                  message:
                      'Enter your name on the Home screen to open the Library.',
                ),
              ],
            )
          : ValueListenableBuilder<int>(
              valueListenable: state.downloads.changes,
              builder: (context, revision, _) {
                return FutureBuilder<List<Download>>(
                  future: _downloadsFor(state, student.id, revision),
                  builder: (context, snapshot) {
                    final downloads = snapshot.data ?? const <Download>[];
                    final byResource = <String, Download>{
                      for (final d in downloads) d.resourceId: d,
                    };
                    return _buildBody(state, classId, byResource);
                  },
                );
              },
            ),
    );
  }

  Widget _buildBody(
    AppState state,
    String? classId,
    Map<String, Download> byResource,
  ) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
      children: [
        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Search by title',
            prefixIcon: Icon(Icons.search_rounded),
          ),
          onSubmitted: (_) => _reload(),
        ),
        const SizedBox(height: 12),
        FutureBuilder<List<Subject>>(
          future: _subjects,
          builder: (context, snapshot) {
            final subjects = snapshot.data ?? const <Subject>[];
            if (subjects.isEmpty) {
              return const Text('No subjects available for this class.');
            }
            return DropdownButton<String?>(
              value: _subjectId,
              isExpanded: true,
              hint: const Text('Subject: all'),
              items: [
                const DropdownMenuItem(
                  value: null,
                  child: Text('All subjects'),
                ),
                for (final s in subjects)
                  DropdownMenuItem(value: s.id, child: Text(s.nameEnglish)),
              ],
              onChanged: (value) {
                setState(() => _subjectId = value);
                _reload();
              },
            );
          },
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            FilterChip(
              label: const Text('All types'),
              selected: _kind == null,
              onSelected: (_) {
                setState(() => _kind = null);
                _reload();
              },
            ),
            for (final kind in ResourceKinds.all)
              FilterChip(
                label: Text(_kindLabel(kind)),
                selected: _kind == kind,
                onSelected: (_) {
                  setState(() => _kind = kind);
                  _reload();
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        FutureBuilder<_LibraryData>(
          future: _data,
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (data == null || data.years.isEmpty) {
              return const SizedBox.shrink();
            }
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: const Text('All years'),
                  selected: _year == null,
                  onSelected: (_) {
                    setState(() => _year = null);
                    _reload();
                  },
                ),
                for (final y in data.years)
                  FilterChip(
                    label: Text('$y'),
                    selected: _year == y,
                    onSelected: (_) {
                      setState(() => _year = y);
                      _reload();
                    },
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 18),
        FutureBuilder<_LibraryData>(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              // Without this branch the `data!` below threw a naked null into
              // the build of every student whose local read failed.
              return ErrorState(
                message:
                    'The Library could not be read on this device. Pull down to '
                    'refresh, or try again.',
                onRetry: _reload,
              );
            }
            final items = snapshot.data?.resources ?? const <Resource>[];
            if (classId == null) {
              return const EmptyState(
                icon: Icons.class_rounded,
                title: 'Choose a class first',
                message: 'Content appears after you choose a class on the Home screen.',
              );
            }
            if (items.isEmpty) {
              return const EmptyState(
                icon: Icons.local_library_rounded,
                title: 'No files in this filter',
                message:
                    'Only files the admin has published for this class, subject '
                    'and year are shown.',
              );
            }
            return Column(
              children: [
                for (final resource in items)
                  _ResourceTile(
                    resource: resource,
                    download: byResource[resource.id],
                    canDownload:
                        AssetDownloader.supportsLocalFiles &&
                        AssetDownloader.allowedRemoteUri(resource.remoteUrl) !=
                            null,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => ResourceViewerPage(resource: resource),
                      ),
                    ),
                    onDownload: () => _startOrRetry(state, resource),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  String _kindLabel(String kind) => switch (kind) {
    ResourceKinds.notes => 'Notes',
    ResourceKinds.pdf => 'PDF',
    ResourceKinds.worksheet => 'Worksheet',
    ResourceKinds.previousYearPaper => 'Previous year papers',
    _ => kind,
  };
}

class _ResourceTile extends StatelessWidget {
  const _ResourceTile({
    required this.resource,
    required this.download,
    required this.canDownload,
    required this.onTap,
    required this.onDownload,
  });

  final Resource resource;
  final Download? download;
  final bool canDownload;
  final VoidCallback onTap;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final parts = <String>[
      _label(resource.kind),
      if (resource.yearLabel != null) '${resource.yearLabel}',
      _formatBytes(resource.fileSizeBytes),
    ];

    final status = download?.status;
    final saved = status == DownloadStatuses.complete;
    final running =
        status == DownloadStatuses.running || status == DownloadStatuses.queued;
    final failed = status == DownloadStatuses.failed;

    final trailing = _trailing(theme, saved, running, failed);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: onTap,
        leading: Icon(_icon(resource.kind)),
        title: Text(resource.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(parts.join('  \u2022  ')),
            if (running)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: LinearProgressIndicator(
                  value: download != null && download!.totalBytes > 0
                      ? (download!.downloadedBytes / download!.totalBytes)
                            .clamp(0.0, 1.0)
                      : null,
                ),
              ),
          ],
        ),
        trailing: trailing,
      ),
    );
  }

  Widget _trailing(ThemeData theme, bool saved, bool running, bool failed) {
    if (!AssetDownloader.supportsLocalFiles) {
      return Icon(
        Icons.chevron_right_rounded,
        color: theme.colorScheme.onSurfaceVariant,
      );
    }
    if (saved) {
      return Tooltip(
        message: 'Saved on this device. Tap to open.',
        child: Icon(
          Icons.check_circle_rounded,
          color: theme.colorScheme.primary,
        ),
      );
    }
    if (running) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: Padding(
          padding: EdgeInsets.all(2),
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      );
    }
    if (failed) {
      return IconButton(
        tooltip: 'Retry download',
        onPressed: canDownload ? onDownload : null,
        icon: Icon(Icons.refresh_rounded, color: theme.colorScheme.error),
      );
    }
    return IconButton(
      tooltip: canDownload ? 'Download for offline use' : 'No https link set',
      onPressed: canDownload ? onDownload : null,
      icon: const Icon(Icons.download_rounded),
    );
  }

  IconData _icon(String kind) => switch (kind) {
    ResourceKinds.pdf => Icons.picture_as_pdf_rounded,
    ResourceKinds.notes => Icons.description_rounded,
    ResourceKinds.worksheet => Icons.assignment_rounded,
    ResourceKinds.previousYearPaper => Icons.history_rounded,
    _ => Icons.insert_drive_file_rounded,
  };

  String _label(String kind) => switch (kind) {
    ResourceKinds.notes => 'Notes',
    ResourceKinds.pdf => 'PDF',
    ResourceKinds.worksheet => 'Worksheet',
    ResourceKinds.previousYearPaper => 'Previous year papers',
    _ => kind,
  };
}

String _formatBytes(int bytes) {
  if (bytes <= 0) return 'Size unknown';
  const kb = 1024;
  const mb = kb * 1024;
  if (bytes < kb) return '$bytes B';
  if (bytes < mb) return '${(bytes / kb).toStringAsFixed(1)} KB';
  return '${(bytes / mb).toStringAsFixed(1)} MB';
}

class _LibraryData {
  const _LibraryData({required this.resources, required this.years});

  final List<Resource> resources;
  final List<int> years;
}
