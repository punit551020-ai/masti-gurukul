import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/local/database.dart';
import '../../data/remote/content_gateway.dart';
import '../../state/app_state.dart';
import 'admin_forms.dart';

/// Runs one admin write so a server refusal is a message instead of a crash.
///
/// `AdminRepository` rolls the local row back and throws a [RemoteFailure] when
/// the server rejects a change. Called straight from a button, that exception
/// would escape into the zone: the owner would see no reason, and the list on
/// screen would keep showing the change that never landed.
Future<void> _write(
  BuildContext context,
  Future<void> Function() operation,
  void Function() reload,
) async {
  String? failure;
  try {
    await operation();
  } on RemoteFailure catch (error) {
    failure = error.message;
  } on Object {
    failure =
        'The change could not be saved. Check the internet connection and try '
        'again.';
  }
  if (!context.mounted) return;
  if (failure != null) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(failure)));
  }
  // Re-read either way: what the panel shows must match the device, whether or
  // not the server took the change.
  reload();
}

/// Owner-facing content manager. Reachable only through the hidden triple-tap
/// on the logo, so nothing here appears in the student navigation.
class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 5, vsync: this);

  List<SchoolClass> _classes = const [];
  List<Board> _boards = const [];
  List<Subject> _subjects = const [];
  String? _classId;
  String? _boardId;
  String? _subjectId;
  int _revision = 0;

  /// Read once at open, because `context` is not usable in [dispose].
  ContentGateway? _gateway;

  @override
  void initState() {
    super.initState();
    _gateway = context.read<AppState>().gateway;
    _load();
  }

  @override
  void dispose() {
    // Leaving the panel ends the admin session. Without this, the session lives
    // for the whole app run, so anyone holding the owner's device could walk
    // back to the logo, triple-tap, and be inside the panel with no password.
    // The next open then asks for the credentials again by design.
    final gateway = _gateway;
    if (gateway != null) {
      unawaited(gateway.signOutAdmin().catchError((Object _) {}));
    }
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final catalog = context.read<AppState>().catalog;
    // The admin list starts with "All Classes": content filed there reaches
    // every class instead of being uploaded five times.
    final classes = await catalog.classesForAdmin();
    if (!mounted) return;
    setState(() {
      _classes = classes;
      // The panel still opens on the newest real class: "All Classes" is a
      // choice the owner makes on purpose, never a default that quietly files
      // Class 10 homework in front of Class 6.
      _classId ??= classes.length < 2 ? classes.first.id : classes.last.id;
    });
    await _loadSubjects();
  }

  Future<void> _loadSubjects() async {
    final classId = _classId;
    if (classId == null) return;
    final catalog = context.read<AppState>().catalog;
    // Every board, not just the ones already used in this class: the admin has
    // to be able to pick "Bihar Board" before its first subject exists.
    final boards = await catalog.boards();
    // A board that has no subjects in this class is not a choice any more, so
    // the pick falls back to "all boards" instead of showing an empty list.
    var boardId = _boardId;
    if (boardId != null && !boards.any((b) => b.id == boardId)) boardId = null;
    final subjects = await catalog.subjectsForClass(classId, boardId: boardId);
    if (!mounted) return;
    setState(() {
      _boards = boards;
      _boardId = boardId;
      _subjects = subjects;
      if (!subjects.any((s) => s.id == _subjectId)) {
        _subjectId = subjects.isEmpty ? null : subjects.first.id;
      }
      _revision++;
    });
  }

  void _refresh() => setState(() => _revision++);

  /// Board name for a subject label; the id is better than nothing if the
  /// board list has not arrived yet.
  String _boardName(String? boardId) {
    if (boardId == null) return '';
    final matches = _boards.where((b) => b.id == boardId);
    return matches.isEmpty ? boardId : matches.first.nameEnglish;
  }

  String _className(String classId) {
    final matches = _classes.where((c) => c.id == classId);
    return matches.isEmpty ? classId : matches.first.nameEnglish;
  }

  /// The full address of a subject: "Class 10 · Bihar Board · Mathematics".
  ///
  /// Every write form shows this, because a chapter title on its own hid which
  /// subject an upload was really filed under and content ended up in the wrong
  /// place - videos in Mathematics that students expected under Social Science.
  String _subjectLabel(Subject subject) => [
    _className(subject.classId),
    if (subject.boardId != null) _boardName(subject.boardId),
    subject.nameEnglish,
  ].join(' · ');

  /// What the currently picked subject is filed under, or a prompt when the
  /// owner has not picked one yet.
  String get _filesUnder {
    final subject = _subjects.where((s) => s.id == _subjectId);
    return subject.isEmpty ? 'Pick a subject' : _subjectLabel(subject.first);
  }

  /// The subjects the owner can move a chapter or a file to: exactly the list
  /// the panel is showing, so a move stays inside the class and board in view.
  List<AdminSubjectChoice> get _subjectChoices => [
    for (final s in _subjects)
      AdminSubjectChoice(id: s.id, label: _subjectLabel(s)),
  ];

  Future<void> _signOut() async {
    final state = context.read<AppState>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out'),
        content: const Text(
          'Sign out of the admin panel and return to the student app?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final gateway = state.gateway;
    if (gateway != null) {
      try {
        await gateway.signOutAdmin();
      } on Object catch (error) {
        // Signing out is a local call, but the auth plugin can still refuse it.
        // Only RemoteFailure was caught before, so that threw straight out of the
        // button. Leaving the panel ends the session anyway — dispose() signs
        // out — so the owner is told what happened instead of seeing nothing.
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              'Sign out did not finish cleanly: $error. Closing the panel ends '
              'the admin session either way.',
            ),
          ),
        );
        return;
      }
    }
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLive = context.read<AppState>().isLive;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin panel'),
        actions: [
          IconButton(
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout_rounded),
            onPressed: _signOut,
          ),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Chapters & lessons'),
            Tab(text: 'Files'),
            Tab(text: 'Live classes'),
            Tab(text: 'Announcements'),
            Tab(text: 'Tests'),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: theme.colorScheme.tertiaryContainer,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              isLive
                  ? 'Signed in to the backend. Saves go to the server and reach '
                        'students after their next sync.'
                  : 'Saved on this device only. No backend is connected here, '
                        'so these changes stay on this device and students on '
                        'other devices will not see them.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onTertiaryContainer,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _classId,
                        decoration: const InputDecoration(labelText: 'Class'),
                        isExpanded: true,
                        items: [
                          for (final c in _classes)
                            DropdownMenuItem(
                              value: c.id,
                              child: Text(c.nameEnglish),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() => _classId = value);
                          _loadSubjects();
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        initialValue: _boardId,
                        decoration: const InputDecoration(labelText: 'Board'),
                        isExpanded: true,
                        // "All boards" shows the shared list; picking a board
                        // narrows it to that syllabus plus the shared subjects.
                        items: [
                          const DropdownMenuItem(
                            value: null,
                            child: Text('All boards'),
                          ),
                          for (final b in _boards)
                            DropdownMenuItem(
                              value: b.id,
                              child: Text(b.nameEnglish),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() => _boardId = value);
                          _loadSubjects();
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _subjectId,
                        decoration: const InputDecoration(labelText: 'Subject'),
                        isExpanded: true,
                        items: [
                          for (final s in _subjects)
                            DropdownMenuItem(
                              value: s.id,
                              child: Text(
                                s.boardId == null
                                    ? s.nameEnglish
                                    : '${s.nameEnglish} · ${_boardName(s.boardId)}',
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() => _subjectId = value);
                          _refresh();
                        },
                      ),
                    ),
                    IconButton(
                      tooltip: 'Add a subject for this class and board',
                      icon: const Icon(Icons.add_rounded),
                      onPressed: _classId == null
                          ? null
                          : () => showSubjectForm(
                              context,
                              classId: _classId!,
                              classLabel: _className(_classId!),
                              boards: _boards,
                              boardId: _boardId,
                              onSaved: _loadSubjects,
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: _subjectId == null && _classId == null
                ? const Center(child: Text('Loading…'))
                : TabBarView(
                    controller: _tabs,
                    children: [
                      _LessonsTab(
                        subjectId: _subjectId,
                        filesUnder: _filesUnder,
                        subjectChoices: _subjectChoices,
                        revision: _revision,
                        onChanged: _refresh,
                      ),
                      _FilesTab(
                        subjectId: _subjectId,
                        filesUnder: _filesUnder,
                        subjectChoices: _subjectChoices,
                        revision: _revision,
                        onChanged: _refresh,
                      ),
                      _LiveTab(
                        subjectId: _subjectId,
                        revision: _revision,
                        onChanged: _refresh,
                      ),
                      _NewsTab(
                        classId: _classId,
                        classes: _classes,
                        revision: _revision,
                        onChanged: _refresh,
                      ),
                      _TestsTab(
                        subjectId: _subjectId,
                        revision: _revision,
                        onChanged: _refresh,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

/// What a row in the Files tab says about itself. Only the title is required to
/// save, so a row with neither a link nor a local copy is a place-holder the
/// owner still has to fill - and the panel has to say that out loud.
List<String> _resourceTags(Resource resource) => [
  resource.kind,
  if (resource.yearLabel != null) '${resource.yearLabel}',
  if ((resource.remoteUrl ?? '').isNotEmpty) 'link',
  if ((resource.localFilePath ?? '').isNotEmpty) 'on device',
  if ((resource.remoteUrl ?? '').isEmpty &&
      (resource.localFilePath ?? '').isEmpty)
    'no file attached yet',
];

class _EmptyHint extends StatelessWidget {
  const _EmptyHint(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(message, textAlign: TextAlign.center),
    ),
  );
}

class _PublishChip extends StatelessWidget {
  const _PublishChip({required this.published, required this.onToggle});

  final bool published;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ActionChip(
      onPressed: onToggle,
      avatar: Icon(
        published ? Icons.visibility_rounded : Icons.visibility_off_rounded,
        size: 18,
      ),
      label: Text(published ? 'Published' : 'Draft'),
      backgroundColor: published
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
    );
  }
}

class _LessonsTab extends StatefulWidget {
  const _LessonsTab({
    required this.subjectId,
    required this.filesUnder,
    required this.subjectChoices,
    required this.revision,
    required this.onChanged,
  });

  final String? subjectId;
  final String filesUnder;
  final List<AdminSubjectChoice> subjectChoices;
  final int revision;
  final VoidCallback onChanged;

  @override
  State<_LessonsTab> createState() => _LessonsTabState();
}

class _LessonsTabState extends State<_LessonsTab> {
  List<Chapter> _chapters = const [];
  Map<String, List<Lesson>> _lessonsByChapter = const {};

  @override
  void didUpdateWidget(covariant _LessonsTab old) {
    super.didUpdateWidget(old);
    if (old.revision != widget.revision || old.subjectId != widget.subjectId) {
      _load();
    }
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final subjectId = widget.subjectId;
    if (subjectId == null) {
      setState(() {
        _chapters = const [];
        _lessonsByChapter = const {};
      });
      return;
    }
    final admin = context.read<AppState>().admin;
    final chapters = await admin.chapters(subjectId);
    final lessons = <String, List<Lesson>>{};
    for (final chapter in chapters) {
      lessons[chapter.id] = await admin.lessons(chapter.id);
    }
    if (!mounted) return;
    setState(() {
      _chapters = chapters;
      _lessonsByChapter = lessons;
    });
  }

  /// Saving a chapter can move it to another subject, which changes what every
  /// other tab shows for this subject too - so the whole panel re-reads.
  void _afterChapterSave() {
    _load();
    widget.onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.read<AppState>().admin;
    if (widget.subjectId == null) {
      return const _EmptyHint('Pick a subject first.');
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showChapterForm(
          context,
          subjectId: widget.subjectId!,
          filesUnder: widget.filesUnder,
          subjectChoices: widget.subjectChoices,
          nextNumber: _chapters.isEmpty
              ? 1
              : _chapters.map((c) => c.number).reduce((a, b) => a > b ? a : b) +
                    1,
          onSaved: _afterChapterSave,
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Chapter'),
      ),
      body: _chapters.isEmpty
          ? const _EmptyHint(
              'No chapters yet. Add a chapter, then put lessons inside it.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              children: [
                for (final chapter in _chapters)
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: Text('${chapter.number}. ${chapter.title}'),
                    subtitle: Text(
                      '${_lessonsByChapter[chapter.id]?.length ?? 0} lessons',
                    ),
                    children: [
                      ListTile(
                        dense: true,
                        title: Text('Files under: ${widget.filesUnder}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit_rounded),
                          tooltip: 'Rename or move this chapter',
                          onPressed: () => showChapterForm(
                            context,
                            subjectId: widget.subjectId!,
                            filesUnder: widget.filesUnder,
                            subjectChoices: widget.subjectChoices,
                            existing: chapter,
                            onSaved: _afterChapterSave,
                          ),
                        ),
                      ),
                      for (final lesson
                          in _lessonsByChapter[chapter.id] ?? <Lesson>[])
                        ListTile(
                          dense: true,
                          title: Text(lesson.title),
                          subtitle: Text(
                            lesson.youtubeUrl == null
                                ? 'No video link'
                                : lesson.youtubeUrl!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _PublishChip(
                                published: lesson.isPublished,
                                onToggle: () => _write(
                                  context,
                                  () => admin.setLessonPublished(
                                    lesson.id,
                                    !lesson.isPublished,
                                  ),
                                  _load,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_rounded),
                                onPressed: () => showLessonForm(
                                  context,
                                  chapter: chapter,
                                  filesUnder: widget.filesUnder,
                                  existing: lesson,
                                  onSaved: _load,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline_rounded),
                                onPressed: () => _write(
                                  context,
                                  () => admin.deleteLesson(lesson.id),
                                  _load,
                                ),
                              ),
                            ],
                          ),
                        ),
                      TextButton.icon(
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add lesson'),
                        onPressed: () => showLessonForm(
                          context,
                          chapter: chapter,
                          filesUnder: widget.filesUnder,
                          onSaved: _load,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}

class _FilesTab extends StatefulWidget {
  const _FilesTab({
    required this.subjectId,
    required this.filesUnder,
    required this.subjectChoices,
    required this.revision,
    required this.onChanged,
  });

  final String? subjectId;
  final String filesUnder;
  final List<AdminSubjectChoice> subjectChoices;
  final int revision;
  final VoidCallback onChanged;

  @override
  State<_FilesTab> createState() => _FilesTabState();
}

class _FilesTabState extends State<_FilesTab> {
  List<Resource> _resources = const [];
  List<Chapter> _chapters = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _FilesTab old) {
    super.didUpdateWidget(old);
    if (old.revision != widget.revision || old.subjectId != widget.subjectId) {
      _load();
    }
  }

  Future<void> _load() async {
    final subjectId = widget.subjectId;
    if (subjectId == null) return;
    final admin = context.read<AppState>().admin;
    final resources = await admin.resources(subjectId: subjectId);
    final chapters = await admin.chapters(subjectId);
    if (!mounted) return;
    setState(() {
      _resources = resources;
      _chapters = chapters;
    });
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.read<AppState>().admin;
    if (widget.subjectId == null) {
      return const _EmptyHint('Pick a subject first.');
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showResourceForm(
          context,
          subjectId: widget.subjectId!,
          filesUnder: widget.filesUnder,
          subjectChoices: widget.subjectChoices,
          chapters: _chapters,
          onSaved: _load,
        ),
        icon: const Icon(Icons.upload_file_rounded),
        label: const Text('Add file'),
      ),
      body: _resources.isEmpty
          ? const _EmptyHint(
              'No files yet. Add a PDF, notes sheet or worksheet for this '
              'subject.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              children: [
                for (final resource in _resources)
                  Card(
                    child: ListTile(
                      title: Text(resource.title),
                      subtitle: Text(_resourceTags(resource).join(' • ')),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _PublishChip(
                            published: resource.isPublished,
                            onToggle: () => _write(
                              context,
                              () => admin.setResourcePublished(
                                resource.id,
                                !resource.isPublished,
                              ),
                              _load,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_rounded),
                            onPressed: () => showResourceForm(
                              context,
                              subjectId: resource.subjectId,
                              filesUnder: widget.filesUnder,
                              subjectChoices: widget.subjectChoices,
                              chapters: _chapters,
                              existing: resource,
                              // An edit can move the file to another subject, so
                              // the rest of the panel re-reads as well.
                              onSaved: () {
                                _load();
                                widget.onChanged();
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () => _write(
                              context,
                              () => admin.deleteResource(resource.id),
                              _load,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _LiveTab extends StatefulWidget {
  const _LiveTab({
    required this.subjectId,
    required this.revision,
    required this.onChanged,
  });

  final String? subjectId;
  final int revision;
  final VoidCallback onChanged;

  @override
  State<_LiveTab> createState() => _LiveTabState();
}

class _LiveTabState extends State<_LiveTab> {
  List<LiveClass> _classes = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _LiveTab old) {
    super.didUpdateWidget(old);
    if (old.revision != widget.revision) _load();
  }

  Future<void> _load() async {
    final admin = context.read<AppState>().admin;
    final subjectId = widget.subjectId;
    final all = await admin.liveClasses();
    if (!mounted) return;
    setState(
      () => _classes = subjectId == null
          ? const []
          : all.where((c) => c.subjectId == subjectId).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.read<AppState>().admin;
    if (widget.subjectId == null) {
      return const _EmptyHint('Pick a subject first.');
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showLiveClassForm(
          context,
          subjectId: widget.subjectId!,
          onSaved: _load,
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Live class'),
      ),
      body: _classes.isEmpty
          ? const _EmptyHint('No live classes scheduled for this subject.')
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              children: [
                for (final live in _classes)
                  Card(
                    child: ListTile(
                      title: Text(live.title),
                      subtitle: Text(
                        '${live.status} • ${live.scheduledStart.toLocal()} '
                        '${live.youtubeUrl == null ? '' : '• link set'}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _PublishChip(
                            published: live.isPublished,
                            onToggle: () => _write(
                              context,
                              () => admin.setLiveClassPublished(
                                live.id,
                                !live.isPublished,
                              ),
                              _load,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_rounded),
                            onPressed: () => showLiveClassForm(
                              context,
                              subjectId: live.subjectId,
                              existing: live,
                              onSaved: _load,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () => _write(
                              context,
                              () => admin.deleteLiveClass(live.id),
                              _load,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

class _NewsTab extends StatefulWidget {
  const _NewsTab({
    required this.classId,
    required this.classes,
    required this.revision,
    required this.onChanged,
  });

  final String? classId;
  final List<SchoolClass> classes;
  final int revision;
  final VoidCallback onChanged;

  @override
  State<_NewsTab> createState() => _NewsTabState();
}

class _NewsTabState extends State<_NewsTab> {
  List<Announcement> _items = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _NewsTab old) {
    super.didUpdateWidget(old);
    if (old.revision != widget.revision) _load();
  }

  Future<void> _load() async {
    final items = await context.read<AppState>().admin.announcements();
    if (!mounted) return;
    setState(() => _items = items);
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.read<AppState>().admin;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showAnnouncementForm(
          context,
          classes: widget.classes,
          classId: widget.classId,
          onSaved: _load,
        ),
        icon: const Icon(Icons.campaign_rounded),
        label: const Text('Announce'),
      ),
      body: _items.isEmpty
          ? const _EmptyHint('No announcements yet.')
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              children: [
                for (final item in _items)
                  Card(
                    child: ListTile(
                      title: Text(item.title),
                      subtitle: Text(item.body, maxLines: 2),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _PublishChip(
                            published: item.isActive,
                            onToggle: () => _write(
                              context,
                              () => admin.setAnnouncementActive(
                                item.id,
                                !item.isActive,
                              ),
                              _load,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_rounded),
                            onPressed: () => showAnnouncementForm(
                              context,
                              classes: widget.classes,
                              existing: item,
                              onSaved: _load,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () => _write(
                              context,
                              () => admin.deleteAnnouncement(item.id),
                              _load,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

/// Runs a repository call and shows the backend's own rejection message when
/// it refuses, so a rejected delete never surfaces as a generic failure.
Future<void> _runGuarded(
  BuildContext context,
  Future<void> Function() action,
) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    await action();
  } on Object catch (error) {
    final message = switch (error) {
      RemoteFailure() => error.message,
      StateError() => error.message,
      _ => '$error',
    };
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }
}

/// 4 instead of 4.0, 0.5 as is.
String _marksText(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toString();

String _countText(int count, String noun) =>
    '$count ${count == 1 ? noun : '${noun}s'}';

class _TestSummary {
  const _TestSummary(this.questionCount, this.totalMarks);

  final int questionCount;
  final double totalMarks;
}

class _TestsTab extends StatefulWidget {
  const _TestsTab({
    required this.subjectId,
    required this.revision,
    required this.onChanged,
  });

  final String? subjectId;
  final int revision;
  final VoidCallback onChanged;

  @override
  State<_TestsTab> createState() => _TestsTabState();
}

class _TestsTabState extends State<_TestsTab> {
  List<Chapter> _chapters = const [];
  Map<String, List<Test>> _testsByChapter = const {};
  Map<String, _TestSummary> _summaries = const {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(covariant _TestsTab old) {
    super.didUpdateWidget(old);
    if (old.revision != widget.revision || old.subjectId != widget.subjectId) {
      _load();
    }
  }

  Future<void> _load() async {
    final subjectId = widget.subjectId;
    if (subjectId == null) {
      setState(() {
        _chapters = const [];
        _testsByChapter = const {};
        _summaries = const {};
      });
      return;
    }
    final admin = context.read<AppState>().admin;
    final chapters = await admin.chapters(subjectId);
    final testsByChapter = <String, List<Test>>{};
    final summaries = <String, _TestSummary>{};
    for (final chapter in chapters) {
      final tests = await admin.tests(chapterId: chapter.id);
      testsByChapter[chapter.id] = tests;
      for (final test in tests) {
        final questions = await admin.questions(test.id);
        final totalMarks = questions.fold<double>(0, (sum, q) => sum + q.marks);
        summaries[test.id] = _TestSummary(questions.length, totalMarks);
      }
    }
    if (!mounted) return;
    setState(() {
      _chapters = chapters;
      _testsByChapter = testsByChapter;
      _summaries = summaries;
    });
  }

  /// After any successful write: re-read this screen and let the app pull the
  /// backend's view so the student side catches up.
  Future<void> _afterWrite(Future<void> Function() write) async {
    final state = context.read<AppState>();
    await _runGuarded(context, () async {
      await write();
      await state.refreshContent();
    });
    _load();
  }

  /// Used as the form's onSaved: the repository write already succeeded when
  /// the form calls this, so only the refresh and reload are left.
  Future<void> _afterSave() async {
    final state = context.read<AppState>();
    await state.refreshContent();
    _load();
  }

  void _openTestForm({Test? existing, String? chapterId}) {
    if (_chapters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'A test belongs to a chapter. Add a chapter first on the '
            'Chapters & lessons tab.',
          ),
        ),
      );
      return;
    }
    showTestForm(
      context,
      chapters: _chapters,
      chapterId: chapterId ?? _chapters.first.id,
      existing: existing,
      onSaved: _afterSave,
    );
  }

  Future<void> _openQuestions(Test test) async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => _TestQuestionsScreen(test: test)));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.read<AppState>().admin;
    if (widget.subjectId == null) {
      return const _EmptyHint('Pick a subject first.');
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openTestForm(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Test'),
      ),
      body: _chapters.isEmpty
          ? const _EmptyHint(
              'No chapters yet. Tests belong to a chapter, so add a chapter '
              'on the Chapters & lessons tab first.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              children: [
                for (final chapter in _chapters)
                  ExpansionTile(
                    initiallyExpanded: true,
                    title: Text('${chapter.number}. ${chapter.title}'),
                    subtitle: Text(
                      _countText(
                        _testsByChapter[chapter.id]?.length ?? 0,
                        'test',
                      ),
                    ),
                    children: [
                      for (final test
                          in _testsByChapter[chapter.id] ?? <Test>[])
                        Card(
                          child: ListTile(
                            onTap: () => _openQuestions(test),
                            title: Text(test.title),
                            subtitle: Text(
                              [
                                _countText(
                                  _summaries[test.id]?.questionCount ?? 0,
                                  'question',
                                ),
                                '${_marksText(_summaries[test.id]?.totalMarks ?? 0)} marks',
                                '${test.timeLimitMinutes} min',
                                if (test.negativeMarking > 0)
                                  '-${_marksText(test.negativeMarking)} per wrong answer',
                              ].join(' • '),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _PublishChip(
                                  published: test.isPublished,
                                  onToggle: () => _afterWrite(
                                    () => admin.setTestPublished(
                                      test.id,
                                      !test.isPublished,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded),
                                  onPressed: () =>
                                      _openTestForm(existing: test),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline_rounded,
                                  ),
                                  onPressed: () => _afterWrite(
                                    () => admin.deleteTest(test.id),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      TextButton.icon(
                        icon: const Icon(Icons.add_rounded),
                        label: const Text('Add test'),
                        onPressed: () => _openTestForm(chapterId: chapter.id),
                      ),
                    ],
                  ),
              ],
            ),
    );
  }
}

/// Question list for one test: add, edit, delete, reorder through the order
/// number on each question.
class _TestQuestionsScreen extends StatefulWidget {
  const _TestQuestionsScreen({required this.test});

  final Test test;

  @override
  State<_TestQuestionsScreen> createState() => _TestQuestionsScreenState();
}

class _TestQuestionsScreenState extends State<_TestQuestionsScreen> {
  List<TestQuestion> _questions = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final questions = await context.read<AppState>().admin.questions(
      widget.test.id,
    );
    if (!mounted) return;
    setState(() => _questions = questions);
  }

  Future<void> _afterWrite(Future<void> Function() write) async {
    final state = context.read<AppState>();
    await _runGuarded(context, () async {
      await write();
      await state.refreshContent();
    });
    _load();
  }

  Future<void> _afterSave() async {
    final state = context.read<AppState>();
    await state.refreshContent();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final admin = context.read<AppState>().admin;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(30),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                '${widget.test.title} • ${widget.test.timeLimitMinutes} min '
                '• ${_countText(_questions.length, 'question')}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showQuestionForm(
          context,
          test: widget.test,
          defaultOrder: _questions.length,
          onSaved: _afterSave,
        ),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Question'),
      ),
      body: _questions.isEmpty
          ? const _EmptyHint(
              'No questions yet. An unpublished or empty test stays hidden from '
              'students, so add the questions first.',
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
              children: [
                for (var i = 0; i < _questions.length; i++)
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 14,
                        child: Text(
                          '${i + 1}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      title: Text(
                        _questions[i].prompt,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'Answer ${_questions[i].correctOption} • '
                        '${_marksText(_questions[i].marks)} marks • '
                        'order ${_questions[i].displayOrder}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_rounded),
                            onPressed: () => showQuestionForm(
                              context,
                              test: widget.test,
                              existing: _questions[i],
                              onSaved: _afterSave,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            onPressed: () => _afterWrite(
                              () => admin.deleteQuestion(_questions[i].id),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
