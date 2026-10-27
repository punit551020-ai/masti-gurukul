import 'dart:io' show Directory, File;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/youtube_url.dart';
import '../../data/local/database.dart';
import '../../data/local/tables.dart';
import '../../state/app_state.dart';

Future<void> _guard(
  BuildContext context,
  Future<void> Function() action,
) async {
  final messenger = ScaffoldMessenger.of(context);
  try {
    await action();
  } on Object catch (error) {
    messenger.showSnackBar(
      SnackBar(content: Text(error is StateError ? error.message : '$error')),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.controller,
    this.hint,
    this.maxLines = 1,
    this.keyboardType,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, hintText: hint),
      ),
    );
  }
}

Future<T?> _sheet<T>(
  BuildContext context,
  Widget Function(BuildContext) body,
) => showModalBottomSheet<T>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (sheetContext) => Padding(
    padding: EdgeInsets.only(
      left: 16,
      right: 16,
      bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 16,
    ),
    child: SingleChildScrollView(child: body(sheetContext)),
  ),
);

/// A subject the owner can file a chapter or a PDF under. The label carries the
/// class and board too, because "Mathematics" alone cannot tell a Bihar Board
/// list apart from the shared one.
class AdminSubjectChoice {
  const AdminSubjectChoice({required this.id, required this.label});

  final String id;
  final String label;
}

/// Says out loud which class, board and subject the item about to be saved will
/// appear under. Uploads were filed in the wrong subject before because a form
/// only ever showed the chapter name.
class _FilesUnderBanner extends StatelessWidget {
  const _FilesUnderBanner(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.folder_rounded,
            size: 16,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Files under: $label',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _subjectPicker(
  List<AdminSubjectChoice> choices,
  String value,
  ValueChanged<String?> onChanged,
) => DropdownButtonFormField<String>(
  initialValue: value,
  decoration: const InputDecoration(labelText: 'Move this to another subject'),
  isExpanded: true,
  items: [
    for (final choice in choices)
      DropdownMenuItem(value: choice.id, child: Text(choice.label)),
  ],
  onChanged: onChanged,
);

/// Subject create/edit.
///
/// This is the piece that makes a new board's list - Class 10, Bihar Board,
/// Science - something the owner can do in the panel instead of SQL. Leaving the
/// board as "All boards" keeps the subject in the shared list every board uses.
Future<void> showSubjectForm(
  BuildContext context, {
  required String classId,
  String? classLabel,
  required List<Board> boards,
  String? boardId,
  Subject? existing,
  required VoidCallback onSaved,
}) {
  const palette = <String, String>{
    'F1951A': 'Amber',
    '1B7A3D': 'Green',
    'B20308': 'Crimson',
    '091B71': 'Navy',
    '7A4A9E': 'Violet',
  };

  return _sheet(context, (sheetContext) {
    final english = TextEditingController(text: existing?.nameEnglish ?? '');
    final hindi = TextEditingController(text: existing?.nameHindi ?? '');
    final order = TextEditingController(text: '${existing?.displayOrder ?? 0}');
    var board = existing?.boardId ?? boardId;
    var color = existing?.accentColor ?? 'F1951A';

    return StatefulBuilder(
      builder: (sheetContext, setSheetState) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            existing == null ? 'New subject' : 'Edit subject',
            style: Theme.of(sheetContext).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            classLabel ?? classId.replaceAll('-', ' '),
            style: Theme.of(sheetContext).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String?>(
            initialValue: board,
            decoration: const InputDecoration(labelText: 'Board'),
            isExpanded: true,
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('All boards (shared)'),
              ),
              for (final b in boards)
                DropdownMenuItem(value: b.id, child: Text(b.nameEnglish)),
            ],
            onChanged: (v) => setSheetState(() => board = v),
          ),
          const SizedBox(height: 12),
          _Field(
            label: 'Name (English)',
            controller: english,
            hint: 'e.g., Science',
          ),
          _Field(label: 'Name (Hindi, optional)', controller: hindi),
          DropdownButtonFormField<String>(
            initialValue: color,
            decoration: const InputDecoration(labelText: 'Card colour'),
            isExpanded: true,
            items: [
              for (final entry in palette.entries)
                DropdownMenuItem(
                  value: entry.key,
                  child: Row(
                    children: [
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Color(int.parse('FF${entry.key}', radix: 16)),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(entry.value),
                    ],
                  ),
                ),
            ],
            onChanged: (v) => setSheetState(() => color = v ?? color),
          ),
          const SizedBox(height: 12),
          _Field(
            label: 'Order',
            controller: order,
            keyboardType: TextInputType.number,
          ),
          FilledButton(
            onPressed: () => _guard(sheetContext, () async {
              await context.read<AppState>().admin.saveSubject(
                id: existing?.id,
                classId: classId,
                boardId: board,
                nameEnglish: english.text,
                nameHindi: hindi.text,
                accentColor: color,
                displayOrder: int.tryParse(order.text.trim()) ?? 0,
              );
              if (sheetContext.mounted) Navigator.of(sheetContext).pop();
              onSaved();
            }),
            child: const Text('Save subject'),
          ),
        ],
      ),
    );
  });
}

/// Chapter create/edit.
///
/// Only the title is required. Leaving the number blank takes the next free one
/// ([nextNumber]) so the save never dies on a FormatException.
///
/// [filesUnder] states in full where this chapter lands, because a chapter name
/// alone hid the fact that a Class 10 Geography video was being filed under
/// Mathematics. [subjectChoices] lets the owner move an existing chapter to
/// another subject without writing SQL.
Future<void> showChapterForm(
  BuildContext context, {
  required String subjectId,
  required String filesUnder,
  List<AdminSubjectChoice> subjectChoices = const [],
  Chapter? existing,
  int nextNumber = 1,
  required VoidCallback onSaved,
}) {
  return _sheet(context, (sheetContext) {
    final number = TextEditingController(
      text: existing == null ? '' : '${existing.number}',
    );
    final title = TextEditingController(text: existing?.title ?? '');
    final summary = TextEditingController(text: existing?.summary ?? '');
    var target = existing?.subjectId ?? subjectId;

    return StatefulBuilder(
      builder: (sheetContext, setSheetState) {
        final canMove =
            existing != null &&
            subjectChoices.length > 1 &&
            subjectChoices.any((c) => c.id == target);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              existing == null ? 'New chapter' : 'Edit chapter',
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            _FilesUnderBanner(filesUnder),
            if (canMove) ...[
              _subjectPicker(subjectChoices, target, (v) {
                if (v != null) setSheetState(() => target = v);
              }),
              const SizedBox(height: 12),
            ],
            _Field(
              label: 'Chapter number',
              controller: number,
              keyboardType: TextInputType.number,
              hint: 'Blank means $nextNumber',
            ),
            _Field(
              label: 'Title',
              controller: title,
              hint: 'e.g., Real Numbers',
            ),
            _Field(
              label: 'Summary (optional)',
              controller: summary,
              maxLines: 3,
            ),
            FilledButton(
              onPressed: () => _guard(sheetContext, () async {
                await context.read<AppState>().admin.saveChapter(
                  id: existing?.id,
                  subjectId: target,
                  number: int.tryParse(number.text.trim()) ?? nextNumber,
                  title: title.text,
                  summary: summary.text,
                );
                if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                onSaved();
              }),
              child: const Text('Save chapter'),
            ),
          ],
        );
      },
    );
  });
}

/// Lesson create/edit with a validated YouTube link.
Future<void> showLessonForm(
  BuildContext context, {
  required Chapter chapter,
  required String filesUnder,
  Lesson? existing,
  required VoidCallback onSaved,
}) {
  return _sheet(context, (sheetContext) {
    final title = TextEditingController(text: existing?.title ?? '');
    final description = TextEditingController(
      text: existing?.description ?? '',
    );
    final url = TextEditingController(text: existing?.youtubeUrl ?? '');
    final order = TextEditingController(text: '${existing?.displayOrder ?? 0}');
    var published = existing?.isPublished ?? false;

    return StatefulBuilder(
      builder: (sheetContext, setSheetState) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            existing == null ? 'New lesson' : 'Edit lesson',
            style: Theme.of(sheetContext).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            chapter.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(sheetContext).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          _FilesUnderBanner('$filesUnder · Chapter ${chapter.number}'),
          _Field(label: 'Title', controller: title),
          _Field(
            label: 'Description (optional)',
            controller: description,
            maxLines: 3,
          ),
          _Field(
            label: 'YouTube link',
            controller: url,
            hint: 'https://www.youtube.com/watch?v=...',
            keyboardType: TextInputType.url,
          ),
          _Field(
            label: 'Order',
            controller: order,
            keyboardType: TextInputType.number,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: published,
            onChanged: (v) => setSheetState(() => published = v),
            title: const Text('Published (visible to students)'),
          ),
          FilledButton(
            onPressed: () => _guard(sheetContext, () async {
              final link = url.text.trim();
              if (link.isNotEmpty && YouTubeUrl.parseId(link) == null) {
                throw StateError(
                  'That is not a valid youtube.com / youtu.be video link.',
                );
              }
              await context.read<AppState>().admin.saveLesson(
                id: existing?.id,
                chapterId: chapter.id,
                title: title.text,
                description: description.text,
                youtubeUrl: link.isEmpty ? null : link,
                displayOrder: int.tryParse(order.text.trim()) ?? 0,
                isPublished: published,
              );
              if (sheetContext.mounted) Navigator.of(sheetContext).pop();
              onSaved();
            }),
            child: const Text('Save lesson'),
          ),
        ],
      ),
    );
  });
}

/// PDF / notes / worksheet create/edit.
///
/// The title is the only thing the owner has to type. A file, a link, a chapter
/// and a description can all stay empty and 'Save file' still writes the row:
/// registering a handout before the PDF is ready is normal, and a student then
/// simply sees that the file is not on their device yet. The year field is gone
/// for the same reason - it was the one box that made people stop and wonder.
///
/// [filesUnder] names the class, board and subject this file will show up in,
/// and [subjectChoices] lets the owner move an existing file to another subject.
Future<void> showResourceForm(
  BuildContext context, {
  required String subjectId,
  required String filesUnder,
  List<AdminSubjectChoice> subjectChoices = const [],
  List<Chapter> chapters = const [],
  Resource? existing,
  required VoidCallback onSaved,
}) {
  return _sheet(context, (sheetContext) {
    final title = TextEditingController(text: existing?.title ?? '');
    final description = TextEditingController(
      text: existing?.description ?? '',
    );
    final url = TextEditingController(text: existing?.remoteUrl ?? '');
    var kind = existing?.kind ?? ResourceKinds.pdf;
    var target = existing?.subjectId ?? subjectId;
    var chapterId = existing?.chapterId;
    var localPath = existing?.localFilePath;
    // The address the file already lives at on the server, if any.
    var serverName = (existing?.remoteUrl ?? '').isEmpty
        ? null
        : existing!.remoteUrl;
    var sizeBytes = existing?.fileSizeBytes ?? 0;
    var published = existing?.isPublished ?? false;

    return StatefulBuilder(
      builder: (sheetContext, setSheetState) {
        final state = context.read<AppState>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              existing == null ? 'New file' : 'Edit file',
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Only the title is needed. Everything else can stay empty.',
              style: Theme.of(sheetContext).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            _FilesUnderBanner(filesUnder),
            if (existing != null &&
                subjectChoices.length > 1 &&
                subjectChoices.any((c) => c.id == target)) ...[
              _subjectPicker(subjectChoices, target, (v) {
                if (v == null) return;
                setSheetState(() {
                  target = v;
                  // The chapter list belongs to the subject being left, so a
                  // moved file goes back to "Whole subject" rather than to a
                  // chapter that students in the new subject cannot open.
                  chapterId = null;
                });
              }),
              const SizedBox(height: 12),
            ],
            _Field(label: 'Title', controller: title, hint: 'Required'),
            _Field(
              label: 'Description (optional)',
              controller: description,
              maxLines: 2,
            ),
            DropdownButtonFormField<String>(
              initialValue: kind,
              decoration: const InputDecoration(labelText: 'Type'),
              items: [
                for (final k in ResourceKinds.all)
                  DropdownMenuItem(value: k, child: Text(_kindLabel(k))),
              ],
              onChanged: (v) => setSheetState(() => kind = v ?? kind),
            ),
            const SizedBox(height: 12),
            if (chapters.isNotEmpty && target == subjectId)
              DropdownButtonFormField<String?>(
                initialValue: chapterId,
                decoration: const InputDecoration(
                  labelText: 'Chapter (optional)',
                ),
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text('Whole subject'),
                  ),
                  for (final c in chapters)
                    DropdownMenuItem(
                      value: c.id,
                      child: Text('${c.number}. ${c.title}'),
                    ),
                ],
                onChanged: (v) => setSheetState(() => chapterId = v),
              ),
            const SizedBox(height: 12),
            _Field(
              label: 'File link (optional)',
              controller: url,
              keyboardType: TextInputType.url,
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.attach_file_rounded),
              label: Text(
                localPath == null && serverName == null
                    ? 'Choose a file from this device'
                    : 'Attached: ${p.basename(localPath ?? serverName!)}',
              ),
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(sheetContext);
                final picked = await FilePicker.pickFile(
                  // A browser picker cannot filter by these extensions, and the
                  // browser has no folder to copy into, so web takes any type.
                  type: kIsWeb ? FileType.any : FileType.custom,
                  allowedExtensions: kIsWeb
                      ? null
                      : const ['pdf', 'epub', 'doc', 'docx'],
                );
                if (picked == null || !sheetContext.mounted) return;
                final bytes = await picked.readAsBytes();
                // 1. A copy on this device, which is what lets the file open
                //    with no network. Only Android and iOS have a place for it.
                if (!kIsWeb) {
                  final dir = await getApplicationDocumentsDirectory();
                  final targetDir = Directory(p.join(dir.path, 'library'));
                  if (!targetDir.existsSync()) {
                    await targetDir.create(recursive: true);
                  }
                  final dot = picked.extension == null
                      ? ''
                      : '.${picked.extension}';
                  final target = File(
                    p.join(targetDir.path, '${const Uuid().v4()}$dot'),
                  );
                  await target.writeAsBytes(bytes);
                  localPath = target.path;
                }
                // 2. A copy on the server - the only copy students on other
                //    devices can reach, and the one that arrives live.
                String notice;
                if (!state.admin.isLive) {
                  notice = kIsWeb
                      ? 'This build has no server connected and a browser '
                            'cannot keep the file. Paste a file link instead.'
                      : 'No server is connected, so this file stayed on this '
                            'device only. Students on other devices will not '
                            'see it.';
                } else {
                  try {
                    final uploaded = await state.admin.uploadFile(
                      fileName: picked.name,
                      bytes: bytes,
                      contentType: _contentTypeOf(picked.name),
                    );
                    if (uploaded == null || uploaded.isEmpty) {
                      notice =
                          'The server accepted the file but sent no '
                          'address back. Check the Supabase Storage settings.';
                    } else {
                      serverName = uploaded;
                      url.text = uploaded;
                      notice =
                          'Stored on the server. Students see it as soon as '
                          'their list refreshes - no app update needed.';
                    }
                  } on Object catch (error) {
                    notice =
                        'Upload failed: '
                        '${error is StateError ? error.message : '$error'}';
                  }
                }
                if (!sheetContext.mounted) return;
                setSheetState(() => sizeBytes = bytes.length);
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(notice),
                    duration: const Duration(seconds: 5),
                  ),
                );
              },
            ),
            if (sizeBytes > 0)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Size: ${(sizeBytes / 1024 / 1024).toStringAsFixed(2)} MB',
                  style: Theme.of(sheetContext).textTheme.bodySmall,
                ),
              ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: published,
              onChanged: (v) => setSheetState(() => published = v),
              title: const Text('Published (visible to students)'),
            ),
            FilledButton(
              onPressed: () => _guard(sheetContext, () async {
                await state.admin.saveResource(
                  id: existing?.id,
                  subjectId: target,
                  chapterId: chapterId,
                  title: title.text,
                  description: description.text,
                  kind: kind,
                  // The form no longer asks for a year, so an edit carries the
                  // one the row already has instead of wiping it.
                  yearLabel: existing?.yearLabel,
                  localFilePath: localPath,
                  remoteUrl: url.text.trim().isEmpty ? null : url.text.trim(),
                  fileSizeBytes: sizeBytes,
                  isPublished: published,
                );
                if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                onSaved();
              }),
              child: const Text('Save file'),
            ),
          ],
        );
      },
    );
  });
}

/// Live class create/edit (YouTube stream link only).
Future<void> showLiveClassForm(
  BuildContext context, {
  required String subjectId,
  LiveClass? existing,
  required VoidCallback onSaved,
}) {
  return _sheet(context, (sheetContext) {
    final title = TextEditingController(text: existing?.title ?? '');
    final description = TextEditingController(
      text: existing?.description ?? '',
    );
    final url = TextEditingController(text: existing?.youtubeUrl ?? '');
    var date =
        existing?.scheduledStart ??
        DateTime.now().add(const Duration(hours: 1));
    var published = existing?.isPublished ?? false;

    return StatefulBuilder(
      builder: (sheetContext, setSheetState) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            existing == null ? 'Schedule live class' : 'Edit live class',
            style: Theme.of(sheetContext).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _Field(label: 'Title', controller: title),
          _Field(
            label: 'Description (optional)',
            controller: description,
            maxLines: 2,
          ),
          _Field(
            label: 'YouTube live / video link',
            controller: url,
            keyboardType: TextInputType.url,
            hint: 'https://www.youtube.com/live/...',
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.schedule_rounded),
            title: Text('Starts: ${_formatDate(date)}'),
            subtitle: const Text('Tap to change date and time'),
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: sheetContext,
                initialDate: date,
                firstDate: DateTime.now().subtract(const Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
              );
              if (pickedDate == null || !sheetContext.mounted) return;
              final pickedTime = await showTimePicker(
                context: sheetContext,
                initialTime: TimeOfDay.fromDateTime(date),
              );
              setSheetState(() {
                date = DateTime(
                  pickedDate.year,
                  pickedDate.month,
                  pickedDate.day,
                  pickedTime?.hour ?? date.hour,
                  pickedTime?.minute ?? date.minute,
                );
              });
            },
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: published,
            onChanged: (v) => setSheetState(() => published = v),
            title: const Text('Published (visible to students)'),
          ),
          FilledButton(
            onPressed: () => _guard(sheetContext, () async {
              final link = url.text.trim();
              if (link.isNotEmpty && YouTubeUrl.parseId(link) == null) {
                throw StateError(
                  'Live links must be a valid YouTube URL so the player can embed it.',
                );
              }
              await context.read<AppState>().admin.saveLiveClass(
                id: existing?.id,
                subjectId: subjectId,
                title: title.text,
                description: description.text,
                scheduledStart: date,
                youtubeUrl: link.isEmpty ? null : link,
                status: existing?.status ?? LiveClassStatuses.scheduled,
                isPublished: published,
              );
              if (sheetContext.mounted) Navigator.of(sheetContext).pop();
              onSaved();
            }),
            child: const Text('Save live class'),
          ),
        ],
      ),
    );
  });
}

/// Announcement create/edit.
Future<void> showAnnouncementForm(
  BuildContext context, {
  List<SchoolClass> classes = const [],
  String? classId,
  Announcement? existing,
  required VoidCallback onSaved,
}) {
  return _sheet(context, (sheetContext) {
    final title = TextEditingController(text: existing?.title ?? '');
    final body = TextEditingController(text: existing?.body ?? '');
    var targetClassId = existing?.classId;
    var priority = existing?.priority ?? 'NORMAL';
    var active = existing?.isActive ?? true;

    return StatefulBuilder(
      builder: (sheetContext, setSheetState) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            existing == null ? 'New announcement' : 'Edit announcement',
            style: Theme.of(sheetContext).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          _Field(label: 'Title', controller: title),
          _Field(label: 'Message', controller: body, maxLines: 4),
          if (classes.isNotEmpty)
            DropdownButtonFormField<String?>(
              initialValue: targetClassId,
              decoration: const InputDecoration(labelText: 'Audience'),
              items: [
                const DropdownMenuItem(value: null, child: Text('All classes')),
                for (final c in classes)
                  DropdownMenuItem(value: c.id, child: Text(c.nameEnglish)),
              ],
              onChanged: (v) => setSheetState(() => targetClassId = v),
            ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'NORMAL', label: Text('Normal')),
              ButtonSegment(value: 'URGENT', label: Text('Urgent')),
            ],
            selected: {priority},
            onSelectionChanged: (s) => setSheetState(() => priority = s.first),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: active,
            onChanged: (v) => setSheetState(() => active = v),
            title: const Text('Show to students'),
          ),
          FilledButton(
            onPressed: () => _guard(sheetContext, () async {
              await context.read<AppState>().admin.saveAnnouncement(
                id: existing?.id,
                title: title.text,
                body: body.text,
                classId: targetClassId,
                priority: priority,
                isActive: active,
              );
              if (sheetContext.mounted) Navigator.of(sheetContext).pop();
              onSaved();
            }),
            child: const Text('Save announcement'),
          ),
        ],
      ),
    );
  });
}

String _kindLabel(String kind) => switch (kind) {
  ResourceKinds.notes => 'Notes',
  ResourceKinds.pdf => 'PDF',
  ResourceKinds.worksheet => 'Worksheet',
  ResourceKinds.previousYearPaper => 'Previous year paper',
  _ => kind,
};

/// Whole numbers print without a trailing ".0" in a text field.
String _plainNumber(double value) => value == value.roundToDouble()
    ? value.toStringAsFixed(0)
    : value.toString();

/// The type the server hands back to the browser. A PDF saved as
/// "application/octet-stream" downloads instead of opening in the viewer, so
/// this has to be right.
String _contentTypeOf(String fileName) => switch (p
    .extension(fileName)
    .toLowerCase()) {
  '.pdf' => 'application/pdf',
  '.epub' => 'application/epub+zip',
  '.doc' => 'application/msword',
  '.docx' =>
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  '.txt' => 'text/plain',
  '.png' => 'image/png',
  '.jpg' || '.jpeg' => 'image/jpeg',
  _ => 'application/octet-stream',
};

/// MCQ test create/edit. A test always belongs to a chapter.
Future<void> showTestForm(
  BuildContext context, {
  required List<Chapter> chapters,
  String? chapterId,
  Test? existing,
  required VoidCallback onSaved,
}) {
  return _sheet(context, (sheetContext) {
    final title = TextEditingController(text: existing?.title ?? '');
    final timeLimit = TextEditingController(
      text: '${existing?.timeLimitMinutes ?? 20}',
    );
    final marks = TextEditingController(
      text: _plainNumber(existing?.marksPerQuestion ?? 1),
    );
    final negative = TextEditingController(
      text: _plainNumber(existing?.negativeMarking ?? 0),
    );
    var chapter = existing?.chapterId ?? chapterId;
    var published = existing?.isPublished ?? false;

    return StatefulBuilder(
      builder: (sheetContext, setSheetState) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            existing == null ? 'New test' : 'Edit test',
            style: Theme.of(sheetContext).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Students take this test from the chapter it belongs to.',
            style: Theme.of(sheetContext).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          if (chapters.isNotEmpty)
            DropdownButtonFormField<String>(
              initialValue: chapter,
              decoration: const InputDecoration(labelText: 'Chapter'),
              isExpanded: true,
              items: [
                for (final c in chapters)
                  DropdownMenuItem(
                    value: c.id,
                    child: Text('${c.number}. ${c.title}'),
                  ),
              ],
              onChanged: (v) => setSheetState(() => chapter = v ?? chapter),
            )
          else
            Text(
              'This subject has no chapters yet. Add a chapter first.',
              style: TextStyle(color: Theme.of(sheetContext).colorScheme.error),
            ),
          const SizedBox(height: 12),
          _Field(
            label: 'Title',
            controller: title,
            hint: 'e.g., Real Numbers - Practice Test',
          ),
          _Field(
            label: 'Time limit (optional)',
            controller: timeLimit,
            keyboardType: TextInputType.number,
            hint: 'Minutes, 1 to 300. Blank means 20.',
          ),
          _Field(
            label: 'Marks per question (optional)',
            controller: marks,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hint: 'Blank means 1.',
          ),
          _Field(
            label: 'Negative marking per wrong answer (optional)',
            controller: negative,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            hint: 'Blank or 0 for no penalty',
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: published,
            onChanged: (v) => setSheetState(() => published = v),
            title: const Text('Published (students can take this test)'),
          ),
          FilledButton(
            onPressed: () => _guard(sheetContext, () async {
              final trimmed = title.text.trim();
              if (trimmed.isEmpty) throw StateError('Title is required.');
              // The title is the only must. Clearing a number box is not an
              // error, it is the owner saying "use the normal value", so each
              // box falls back to the number the form opened with. A box with
              // something unreadable in it still stops the save, because the
              // server would reject that row anyway.
              final minutesText = timeLimit.text.trim();
              final minutes = int.tryParse(minutesText);
              if (minutesText.isNotEmpty &&
                  (minutes == null || minutes < 1 || minutes > 300)) {
                throw StateError(
                  'Time limit must be between 1 and 300 minutes, or blank for '
                  '20.',
                );
              }
              final marksText = marks.text.trim();
              final marksPerQuestion = double.tryParse(marksText);
              if (marksText.isNotEmpty &&
                  (marksPerQuestion == null || marksPerQuestion <= 0)) {
                throw StateError(
                  'Marks per question must be more than zero, or blank for 1.',
                );
              }
              final negativeText = negative.text.trim();
              final negativeMarking = double.tryParse(negativeText);
              if (negativeText.isNotEmpty &&
                  (negativeMarking == null || negativeMarking < 0)) {
                throw StateError(
                  'Negative marking must be 0 or more, or blank for no penalty.',
                );
              }
              final perQuestion = marksPerQuestion ?? 1;
              final penalty = negativeMarking ?? 0;
              if (penalty > perQuestion) {
                throw StateError(
                  'Negative marking cannot be more than the marks per question.',
                );
              }
              final targetChapter =
                  chapter ?? (chapters.isEmpty ? null : chapters.first.id);
              if (targetChapter == null) {
                throw StateError('Add a chapter before creating a test.');
              }
              await context.read<AppState>().admin.saveTest(
                id: existing?.id,
                chapterId: targetChapter,
                title: trimmed,
                timeLimitMinutes: minutes ?? 20,
                marksPerQuestion: perQuestion,
                negativeMarking: penalty,
                isPublished: published,
              );
              if (sheetContext.mounted) Navigator.of(sheetContext).pop();
              onSaved();
            }),
            child: const Text('Save test'),
          ),
        ],
      ),
    );
  });
}

/// Question create/edit for one test. Four options, one correct.
Future<void> showQuestionForm(
  BuildContext context, {
  required Test test,
  TestQuestion? existing,
  int defaultOrder = 0,
  required VoidCallback onSaved,
}) {
  return _sheet(context, (sheetContext) {
    final prompt = TextEditingController(text: existing?.prompt ?? '');
    final optionA = TextEditingController(text: existing?.optionA ?? '');
    final optionB = TextEditingController(text: existing?.optionB ?? '');
    final optionC = TextEditingController(text: existing?.optionC ?? '');
    final optionD = TextEditingController(text: existing?.optionD ?? '');
    final explanation = TextEditingController(
      text: existing?.explanation ?? '',
    );
    final marks = TextEditingController(
      text: _plainNumber(existing?.marks ?? test.marksPerQuestion),
    );
    final order = TextEditingController(
      text: '${existing?.displayOrder ?? defaultOrder}',
    );
    var correct = existing?.correctOption;

    return StatefulBuilder(
      builder: (sheetContext, setSheetState) {
        Widget optionRow(String letter, TextEditingController controller) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Radio<String>(value: letter),
              Expanded(
                child: _Field(label: 'Option $letter', controller: controller),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              existing == null ? 'New question' : 'Edit question',
              style: Theme.of(sheetContext).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(test.title, style: Theme.of(sheetContext).textTheme.bodySmall),
            const SizedBox(height: 16),
            _Field(label: 'Question', controller: prompt, maxLines: 3),
            Text(
              'Fill all four options, then tap the circle next to the correct one.',
              style: Theme.of(sheetContext).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            RadioGroup<String>(
              groupValue: correct,
              onChanged: (v) => setSheetState(() => correct = v),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  optionRow('A', optionA),
                  optionRow('B', optionB),
                  optionRow('C', optionC),
                  optionRow('D', optionD),
                ],
              ),
            ),
            _Field(
              label: 'Explanation (optional)',
              controller: explanation,
              maxLines: 2,
              hint: 'Shown to the student after they answer.',
            ),
            _Field(
              label: 'Marks',
              controller: marks,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            _Field(
              label: 'Order number',
              controller: order,
              keyboardType: TextInputType.number,
              hint: 'Smaller numbers appear first.',
            ),
            FilledButton(
              onPressed: () => _guard(sheetContext, () async {
                if (prompt.text.trim().isEmpty) {
                  throw StateError('Question text is required.');
                }
                final options = [
                  optionA.text.trim(),
                  optionB.text.trim(),
                  optionC.text.trim(),
                  optionD.text.trim(),
                ];
                if (options.any((o) => o.isEmpty)) {
                  throw StateError('All four options are required.');
                }
                final seen = <String>{};
                for (final option in options) {
                  if (!seen.add(option.toLowerCase())) {
                    throw StateError(
                      'Option "$option" appears more than once. The four '
                      'options must all say something different.',
                    );
                  }
                }
                final answer = correct;
                if (answer == null) {
                  throw StateError(
                    'Mark one option as correct (A, B, C or D).',
                  );
                }
                final marksText = marks.text.trim();
                final questionMarks = double.tryParse(marksText);
                if (marksText.isNotEmpty &&
                    (questionMarks == null || questionMarks <= 0)) {
                  throw StateError(
                    'Marks must be more than zero, or blank to use the test '
                    'default.',
                  );
                }
                await context.read<AppState>().admin.saveQuestion(
                  id: existing?.id,
                  testId: test.id,
                  prompt: prompt.text,
                  optionA: optionA.text,
                  optionB: optionB.text,
                  optionC: optionC.text,
                  optionD: optionD.text,
                  correctOption: answer,
                  explanation: explanation.text,
                  marks: questionMarks ?? test.marksPerQuestion,
                  displayOrder: int.tryParse(order.text.trim()) ?? 0,
                );
                if (sheetContext.mounted) Navigator.of(sheetContext).pop();
                onSaved();
              }),
              child: const Text('Save question'),
            ),
          ],
        );
      },
    );
  });
}

String _formatDate(DateTime value) =>
    '${value.day}/${value.month}/${value.year} '
    '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
