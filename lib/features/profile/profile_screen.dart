import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/branding/brand_config.dart';
import '../../data/local/database.dart';
import '../../features/welcome/welcome_screen.dart' show validateStudentName;
import '../../state/app_state.dart';
import '../common/state_views.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Future<List<SchoolClass>> _classes = _loadClasses();
  late final Future<List<Student>> _students = _loadStudents();

  Future<List<SchoolClass>> _loadClasses() =>
      context.read<AppState>().catalog.classes();

  Future<List<Student>> _loadStudents() async {
    final db = context.read<AppState>().database;
    return db.select(db.students).get();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final student = state.currentStudent;
    if (student == null) {
      return const EmptyState(
        icon: Icons.person_rounded,
        title: 'No profile',
        message: 'Open the app again and enter your name.',
      );
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: CircleAvatar(
              radius: 26,
              child: Text(
                student.avatarEmoji,
                style: const TextStyle(fontSize: 24),
              ),
            ),
            title: Text(
              student.displayName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            subtitle: Text('Member since ${_formatDate(student.createdAt)}'),
            trailing: IconButton(
              icon: const Icon(Icons.edit_rounded),
              tooltip: 'Edit profile',
              onPressed: () => _editProfile(student),
            ),
            onTap: () => _editProfile(student),
          ),
        ),
        const SizedBox(height: 16),
        const SectionTitle('Class'),
        FutureBuilder<List<SchoolClass>>(
          future: _classes,
          builder: (context, snapshot) {
            final classes = snapshot.data ?? const <SchoolClass>[];
            if (classes.isEmpty) return const Text('Classes did not load.');
            return Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final item in classes)
                  ChoiceChip(
                    label: Text(item.nameEnglish),
                    selected: item.id == state.selectedClassId,
                    onSelected: (_) async {
                      await state.updateProfile(classId: item.id);
                      await state.setSelectedClassId(item.id);
                    },
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        const SectionTitle('Theme'),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
              value: 'system',
              label: Text('System'),
              icon: Icon(Icons.brightness_auto_rounded),
            ),
            ButtonSegment(
              value: 'light',
              label: Text('Light'),
              icon: Icon(Icons.light_mode_rounded),
            ),
            ButtonSegment(
              value: 'dark',
              label: Text('Dark'),
              icon: Icon(Icons.dark_mode_rounded),
            ),
          ],
          selected: {state.themeMode.name},
          onSelectionChanged: (set) {
            final mode = switch (set.first) {
              'light' => ThemeMode.light,
              'dark' => ThemeMode.dark,
              _ => ThemeMode.system,
            };
            state.setThemeMode(mode);
          },
        ),
        const SizedBox(height: 20),
        const SectionTitle('Other profiles on this device'),
        FutureBuilder<List<Student>>(
          future: _students,
          builder: (context, snapshot) {
            final list = (snapshot.data ?? const <Student>[])
                .where((s) => s.id != student.id)
                .toList();
            if (list.isEmpty) {
              return const Text('No other profile on this device yet.');
            }
            return Column(
              children: [
                for (final other in list)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(child: Text(other.avatarEmoji)),
                    title: Text(other.displayName),
                    trailing: const Icon(Icons.swap_horiz_rounded),
                    onTap: () => state.switchStudent(other),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        const SectionTitle('Session'),
        OutlinedButton.icon(
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Sign out'),
          onPressed: () => _signOut(state, student.displayName),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiaryContainer
                .withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Security note: typing a name in ${BrandConfig.appName} does not '
            'verify who you are. This profile stays only in this device\'s DB. '
            'Secure accounts and cloud sync will be added later.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ],
    );
  }

  /// Renames the student. The name is the only thing a student can change
  /// here, and it is the same rule the welcome screen applies, so a name that
  /// passes here would also have passed at sign-in.
  Future<void> _editProfile(Student student) async {
    final formKey = GlobalKey<FormState>();
    var draft = student.displayName;
    var saving = false;

    // No TextEditingController: the dialog's field outlives the pop by one
    // exit animation, and a controller disposed here would be used after
    // disposal while that animation runs.
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Edit profile'),
          content: Form(
            key: formKey,
            child: TextFormField(
              initialValue: draft,
              autofocus: true,
              keyboardType: TextInputType.name,
              textCapitalization: TextCapitalization.words,
              // Deliberately no autofillHints: with AutofillHints.name plus
              // autofocus, Chrome filled this field with the browser's own
              // stored name on open, so a student could save a name they never
              // typed. This is a display name, not a shipping address.
              decoration: const InputDecoration(
                labelText: 'Display name',
                helperText: 'Home will greet you as "Hello, <name>".',
              ),
              validator: validateStudentName,
              onChanged: (value) => draft = value,
              onFieldSubmitted: (_) {
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context, draft.trim());
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      if (!formKey.currentState!.validate()) return;
                      setDialogState(() => saving = true);
                      final name = draft.trim();
                      await context.read<AppState>().updateProfile(
                        displayName: name,
                      );
                      if (context.mounted) Navigator.pop(context, name);
                    },
              child: const Text('Save name'),
            ),
          ],
        ),
      ),
    );

    if (newName == null || !mounted) return;
    final changed = newName != student.displayName;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            changed ? 'Hello, $newName — name updated.' : 'Name unchanged.',
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 2),
        ),
      );
  }

  /// Clears only the signed-in marker, then lets `main.dart`'s gate hand the
  /// app back to the Welcome screen. Nothing here is deleted, so this is
  /// reversible by signing in again.
  Future<void> _signOut(AppState state, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign out'),
        content: Text(
          'This device forgets that $name is signed in, and the app opens on '
          'the Welcome screen. Their class, bookmarks, downloads and test '
          'results stay on this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sign out'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    // No context use after this: the gate swaps the whole app to Welcome and
    // unmounts this screen.
    await state.signOut();
  }

  String _formatDate(DateTime value) =>
      '${value.day}/${value.month}/${value.year}';
}
