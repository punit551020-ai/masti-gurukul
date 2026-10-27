import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/local/database.dart';
import '../../data/local/tables.dart';
import '../../data/repositories/test_repository.dart';
import '../../state/app_state.dart';
import '../common/state_views.dart';
import 'test_formatting.dart';
import 'test_runner_screen.dart';

class TestsScreen extends StatefulWidget {
  const TestsScreen({super.key});

  @override
  State<TestsScreen> createState() => _TestsScreenState();
}

typedef _TestsKey = ({String? classId, String? studentId, int content});

class _TestsScreenState extends State<TestsScreen> {
  Future<_TestData>? _future;
  _TestsKey? _futureKey;

  Future<_TestData> _load(_TestsKey key) async {
    final state = context.read<AppState>();
    final repo = TestRepository(state.database);
    final classId = key.classId;
    if (classId == null) return const _TestData.empty();

    final summaries = await repo.publishedTestSummariesForClass(classId);
    final attempts = key.studentId == null
        ? const <TestAttempt>[]
        : await repo.attemptsForStudent(key.studentId!);
    final best = <String, double>{};
    for (final attempt in attempts) {
      final current = best[attempt.testId];
      if (current == null || attempt.score > current) {
        best[attempt.testId] = attempt.score;
      }
    }
    return _TestData(summaries: summaries, bestScores: best);
  }

  void _startLoad(_TestsKey key) {
    _futureKey = key;
    _future = _load(key);
  }

  Future<void> _refresh() async {
    final state = context.read<AppState>();
    final key =
        _futureKey ??
        (
          classId: state.selectedClassId,
          studentId: state.currentStudent?.id,
          content: state.contentVersion,
        );
    setState(() => _startLoad(key));
    try {
      await _future;
    } on Object {
      // The builder's error branch is what the student reads. Re-throwing here
      // would turn a pressed button into an uncaught error.
    }
  }

  Future<void> _openTest(PublishedTestSummary summary) async {
    final state = context.read<AppState>();
    final student = state.currentStudent;
    if (student != null) {
      await state.catalog.markViewed(
        studentId: student.id,
        targetKind: TrackableKinds.test,
        targetId: summary.test.id,
      );
    }
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TestRunnerScreen(testId: summary.test.id),
      ),
    );
    // Scores may have changed while the runner was open.
    if (mounted) await _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final key = (
      classId: state.selectedClassId,
      studentId: state.currentStudent?.id,
      content: state.contentVersion,
    );
    final previous = _futureKey;
    if (_future == null ||
        previous == null ||
        previous.classId != key.classId ||
        previous.studentId != key.studentId ||
        previous.content != key.content) {
      _startLoad(key);
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder<_TestData>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView(message: 'Loading tests...');
          }
          if (snapshot.hasError) {
            return _Scrollable(
              child: ErrorState(
                message:
                    'The published tests could not be loaded. '
                    'Check that the content sync has run, then try again.',
                onRetry: _refresh,
              ),
            );
          }
          final data = snapshot.data ?? const _TestData.empty();
          if (key.classId == null) {
            return const _Scrollable(
              child: EmptyState(
                icon: Icons.class_rounded,
                title: 'Choose a class first',
                message:
                    'Pick your class on the Home screen, then tests will '
                    'appear here.',
              ),
            );
          }
          if (data.summaries.isEmpty) {
            return const _Scrollable(
              child: EmptyState(
                icon: Icons.fact_check_rounded,
                title: 'No published tests yet',
                message:
                    'Tests appear here as soon as they are published for '
                    'your class. Nothing is shown until real questions exist.',
              ),
            );
          }
          return _buildList(data);
        },
      ),
    );
  }

  Widget _buildList(_TestData data) {
    final sections = <Widget>[];
    String? lastChapter;
    for (final summary in data.summaries) {
      if (summary.chapter.id != lastChapter) {
        lastChapter = summary.chapter.id;
        sections.add(
          Padding(
            padding: const EdgeInsets.only(top: 14, bottom: 6),
            child: SectionTitle(
              summary.chapter.title,
              trailing: Text(
                summary.subject.nameEnglish,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
        );
      }
      sections.add(_testTile(summary, data.bestScores[summary.test.id]));
    }

    return ListView(
      key: const PageStorageKey('tests-list'),
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: sections,
    );
  }

  Widget _testTile(PublishedTestSummary summary, double? bestScore) {
    final theme = Theme.of(context);
    final test = summary.test;
    final hasQuestions = summary.questionCount > 0;

    final details = <String>[
      '${summary.questionCount} '
          '${summary.questionCount == 1 ? 'question' : 'questions'}',
      if (hasQuestions) '${formatMarks(summary.totalMarks)} marks',
      '${test.timeLimitMinutes} min',
      if (test.negativeMarking > 0)
        '-${formatMarks(test.negativeMarking)} per wrong answer',
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        onTap: hasQuestions ? () => _openTest(summary) : null,
        enabled: hasQuestions,
        leading: const Icon(Icons.quiz_rounded),
        title: Text(test.title),
        subtitle: Text(
          hasQuestions ? details.join(' - ') : 'No questions added yet',
          style: theme.textTheme.bodySmall,
        ),
        trailing: hasQuestions
            ? (bestScore != null
                  ? Chip(
                      label: Text('Best ${formatMarks(bestScore)}'),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: theme.colorScheme.secondaryContainer,
                    )
                  : const Icon(Icons.chevron_right_rounded))
            : null,
      ),
    );
  }
}

class _TestData {
  const _TestData({required this.summaries, required this.bestScores});

  const _TestData.empty() : summaries = const [], bestScores = const {};

  final List<PublishedTestSummary> summaries;
  final Map<String, double> bestScores;
}

class _Scrollable extends StatelessWidget {
  const _Scrollable({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [const SizedBox(height: 60), child],
    );
  }
}
