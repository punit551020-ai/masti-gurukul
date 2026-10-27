import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/local/database.dart';
import '../../data/repositories/test_repository.dart';
import '../../state/app_state.dart';
import '../common/content_refresh.dart';
import '../common/state_views.dart';
import '../tests/test_formatting.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with ContentRefresh {
  late Future<_ProgressData> _data = _load();

  @override
  void onContentChanged() => _data = observed(_load());

  Future<_ProgressData> _load() async {
    final state = context.read<AppState>();
    final student = state.currentStudent;
    if (student == null) return const _ProgressData.empty();

    final rows = await state.catalog.allProgress(student.id);
    final titles = <String, String>{};
    for (final row in rows) {
      final lesson = await state.catalog.lessonById(row.lessonId);
      titles[row.lessonId] = lesson?.title ?? '(lesson removed)';
    }

    final repo = TestRepository(state.database);
    final attempts = await repo.attemptsForStudent(student.id);
    final testTitles = <String, String>{};
    for (final attempt in attempts) {
      if (testTitles.containsKey(attempt.testId)) continue;
      final test = await repo.testById(attempt.testId);
      testTitles[attempt.testId] = test?.title ?? '(test removed)';
    }

    return _ProgressData(
      rows: rows,
      titles: titles,
      attempts: attempts,
      testTitles: testTitles,
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => setState(() => _data = observed(_load())),
      child: FutureBuilder<_ProgressData>(
        future: _data,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView(message: 'Loading progress...');
          }
          final data = snapshot.data ?? const _ProgressData.empty();
          final completed = data.rows.where((r) => r.completed).length;
          if (data.rows.isEmpty && data.attempts.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 80),
                const EmptyState(
                  icon: Icons.insights_rounded,
                  title: 'No progress yet',
                  message: 'Once you watch lessons fully or take tests, the numbers will fill in here.',
                ),
              ],
            );
          }
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              _testStatsSection(data),
              const SizedBox(height: 22),
              SectionTitle('Completed lessons: $completed'),
              for (final row in data.rows)
                Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    title: Text(data.titles[row.lessonId] ?? '—'),
                    subtitle: LinearProgressIndicator(value: row.percent / 100),
                    trailing: Text('${row.percent.round()}%'),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _testStatsSection(_ProgressData data) {
    final theme = Theme.of(context);
    final attempts = data.attempts;

    if (attempts.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('Tests'),
          Card(
            margin: EdgeInsets.zero,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No tests taken yet. Published tests appear on the Tests tab.',
              ),
            ),
          ),
        ],
      );
    }

    final percents = attempts
        .map((a) => scorePercent(a.score, a.totalMarks))
        .whereType<int>()
        .toList();
    final average = percents.isEmpty
        ? null
        : (percents.reduce((x, y) => x + y) / percents.length).round();
    var best = attempts.first;
    for (final attempt in attempts) {
      if (attempt.score > best.score) best = attempt;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle('Tests'),
        Card(
          margin: const EdgeInsets.only(bottom: 10),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attempts taken: ${attempts.length}',
                  style: theme.textTheme.titleSmall,
                ),
                if (average != null) ...[
                  const SizedBox(height: 4),
                  Text('Average score: $average% of marks'),
                ],
                const SizedBox(height: 4),
                Text(
                  'Best score: ${formatMarks(best.score)} / '
                  '${formatMarks(best.totalMarks)} '
                  '(${data.testTitles[best.testId] ?? '(test removed)'})',
                ),
              ],
            ),
          ),
        ),
        for (final attempt in attempts.take(5))
          Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              dense: true,
              leading: const Icon(Icons.fact_check_outlined),
              title: Text(data.testTitles[attempt.testId] ?? '(test removed)'),
              subtitle: Text(
                'Correct ${attempt.correctCount} · Wrong '
                '${attempt.wrongCount} · Unanswered '
                '${attempt.unansweredCount} · '
                'Time ${formatClock(attempt.timeSpentSeconds)}',
                style: theme.textTheme.bodySmall,
              ),
              trailing: Text(
                '${formatMarks(attempt.score)} / '
                '${formatMarks(attempt.totalMarks)}',
                style: theme.textTheme.titleSmall,
              ),
            ),
          ),
      ],
    );
  }
}

class _ProgressData {
  const _ProgressData({
    required this.rows,
    required this.titles,
    required this.attempts,
    required this.testTitles,
  });

  const _ProgressData.empty()
    : rows = const [],
      titles = const {},
      attempts = const [],
      testTitles = const {};

  final List<LessonProgressRow> rows;
  final Map<String, String> titles;
  final List<TestAttempt> attempts;
  final Map<String, String> testTitles;
}
