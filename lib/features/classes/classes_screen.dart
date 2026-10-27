import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/subject_art.dart';
import '../../data/local/database.dart';
import '../../state/app_state.dart';
import '../common/content_refresh.dart';
import '../common/state_views.dart';
import '../home/class_picker.dart';
import 'subject_screen.dart';

class ClassesScreen extends StatefulWidget {
  const ClassesScreen({super.key});

  @override
  State<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> with ContentRefresh {
  late Future<List<SchoolClass>> _classes = _loadClasses();
  late Future<_Subjects> _subjects = _loadSubjects();

  Future<List<SchoolClass>> _loadClasses() =>
      context.read<AppState>().catalog.classes();

  /// Subjects carry a board id only when pinned to one syllabus, so the board
  /// names travel with them to label the tile.
  Future<_Subjects> _loadSubjects() async {
    final state = context.read<AppState>();
    final classId = state.selectedClassId;
    if (classId == null) {
      return (
        subjects: const <Subject>[],
        boardNames: const <String, String>{},
      );
    }
    final (subjects, boards) = await (
      state.catalog.subjectsForClass(classId),
      state.catalog.boards(),
    ).wait;
    return (
      subjects: subjects,
      boardNames: {for (final b in boards) b.id: b.nameEnglish},
    );
  }

  void _refresh() {
    _classes = observed(_loadClasses());
    _subjects = observed(_loadSubjects());
  }

  void _reload() => setState(_refresh);

  /// This tab is where a student looks when no content has appeared, so a dead
  /// read must say so and offer the one fix available: ask the server for the
  /// catalogue again. Without it the tab would spin forever.
  Future<void> _onRefresh() async {
    await context.read<AppState>().refreshContent();
    if (!mounted) return;
    _reload();
  }

  Future<void> _chooseClass(AppState state, String id) async {
    try {
      await state.setSelectedClassId(id);
    } on Object {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Your class choice could not be saved on this device.'),
        ),
      );
      return;
    }
    if (!mounted) return;
    _reload();
  }

  /// A sync landed while this tab was open: re-query, no setState needed
  /// because this frame is already being rebuilt.
  @override
  void onContentChanged() => _refresh();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return FutureBuilder<List<SchoolClass>>(
      future: _classes,
      builder: (context, classSnapshot) {
        if (classSnapshot.hasError) {
          return ErrorState(
            message: 'Classes could not be read from this device.',
            onRetry: _reload,
          );
        }
        if (!classSnapshot.hasData) {
          return const LoadingView(message: 'Loading classes…');
        }
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            children: [
              const SectionTitle('Choose your class'),
              ClassPicker(
                classes: classSnapshot.data!,
                selectedClassId: state.selectedClassId,
                onChanged: (id) => _chooseClass(state, id),
                onRetry: _onRefresh,
              ),
              const SizedBox(height: 24),
              const SectionTitle('Subjects'),
              FutureBuilder<_Subjects>(
                future: _subjects,
                builder: (context, subjectSnapshot) {
                  if (subjectSnapshot.connectionState != ConnectionState.done) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  if (subjectSnapshot.hasError) {
                    return ErrorState(
                      message: 'Subjects could not be read from this device.',
                      onRetry: _reload,
                    );
                  }
                  final data =
                      subjectSnapshot.data ??
                      (subjects: const <Subject>[], boardNames: const {});
                  final subjects = data.subjects;
                  if (state.selectedClassId == null) {
                    return const EmptyState(
                      icon: Icons.class_rounded,
                      title: 'Choose a class first',
                      message: 'Pick your class from the list above.',
                    );
                  }
                  if (subjects.isEmpty) {
                    return const EmptyState(
                      icon: Icons.book_rounded,
                      title: 'No subjects for this class',
                      message:
                          'No subjects have been added for this class yet.',
                    );
                  }
                  return GridView.count(
                    crossAxisCount: MediaQuery.sizeOf(context).width > 700
                        ? 4
                        : 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      for (final subject in subjects)
                        SubjectCard(
                          nameEnglish: subject.nameEnglish,
                          nameHindi: subject.nameHindi,
                          colorHex: subject.accentColor,
                          board: data.boardNames[subject.boardId],
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SubjectScreen(subject: subject),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

typedef _Subjects = ({List<Subject> subjects, Map<String, String> boardNames});
