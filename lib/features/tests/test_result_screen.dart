import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/local/database.dart';
import '../../data/repositories/test_repository.dart';
import '../../state/app_state.dart';
import '../common/state_views.dart';
import 'test_formatting.dart';

/// Shows the persisted outcome of one attempt: totals, counts, time spent and
/// a per-question review with the student's choice, the right option and the
/// stored explanation when there is one.
class TestResultScreen extends StatefulWidget {
  const TestResultScreen({super.key, required this.attemptId});

  final String attemptId;

  @override
  State<TestResultScreen> createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
  late final TestRepository _repo;

  Future<_ResultData?>? _future;

  @override
  void initState() {
    super.initState();
    _repo = TestRepository(context.read<AppState>().database);
    _future = _load();
  }

  Future<_ResultData?> _load() async {
    final review = await _repo.reviewForAttempt(widget.attemptId);
    if (review == null) return null;
    final test = await _repo.testById(review.attempt.testId);
    return _ResultData(
      attempt: review.attempt,
      testTitle: test?.title ?? 'Test',
      items: review.items,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Test result')),
      body: FutureBuilder<_ResultData?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView(message: 'Loading your result...');
          }
          if (snapshot.hasError) {
            return ErrorState(
              message: 'The stored result could not be read from the device.',
              onRetry: () => setState(() => _future = observed(_load())),
            );
          }
          final data = snapshot.data;
          if (data == null) {
            return const ErrorState(
              message:
                  'This attempt could not be found in the local '
                  'database, so its result cannot be shown.',
            );
          }
          return _buildResult(theme, data);
        },
      ),
    );
  }

  Widget _buildResult(ThemeData theme, _ResultData data) {
    final attempt = data.attempt;
    final percent = scorePercent(attempt.score, attempt.totalMarks);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(data.testTitle, style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  '${formatMarks(attempt.score)} / '
                  '${formatMarks(attempt.totalMarks)}',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (percent != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '$percent% score',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _statChip(
                      theme,
                      'Correct ${attempt.correctCount}',
                      theme.colorScheme.primary,
                    ),
                    _statChip(
                      theme,
                      'Wrong ${attempt.wrongCount}',
                      theme.colorScheme.error,
                    ),
                    _statChip(
                      theme,
                      'Unanswered ${attempt.unansweredCount}',
                      theme.colorScheme.onSurfaceVariant,
                    ),
                    _statChip(
                      theme,
                      'Time ${formatClock(attempt.timeSpentSeconds)}',
                      theme.colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        const SectionTitle('Answer review'),
        for (var i = 0; i < data.items.length; i++)
          _reviewCard(theme, i + 1, data.items[i]),
      ],
    );
  }

  Widget _statChip(ThemeData theme, String label, Color color) {
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color.withValues(alpha: 0.4)),
      labelStyle: theme.textTheme.bodySmall?.copyWith(color: color),
    );
  }

  Widget _reviewCard(ThemeData theme, int number, AttemptReviewItem item) {
    final question = item.question;
    final selected = item.selectedOption;
    final correctOption = question.correctOption;

    Widget answerLine(String label, String option, Color color) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label: ',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                '$option - ${_optionText(question, option)}',
                style: theme.textTheme.bodyMedium?.copyWith(color: color),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Q$number ${item.isCorrect ? '(Correct)' : '(Incorrect)'}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: item.isCorrect
                    ? theme.colorScheme.primary
                    : theme.colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(question.prompt, style: theme.textTheme.bodyLarge),
            const SizedBox(height: 8),
            selected == null
                ? Text(
                    'Your answer: not answered',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                : answerLine(
                    'Your answer',
                    selected,
                    item.isCorrect
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
            if (selected != correctOption)
              answerLine(
                'Correct answer',
                correctOption,
                theme.colorScheme.primary,
              ),
            if (question.explanation.trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Explanation: ${question.explanation.trim()}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _optionText(TestQuestion q, String option) => switch (option) {
    'A' => q.optionA,
    'B' => q.optionB,
    'C' => q.optionC,
    _ => q.optionD,
  };
}

class _ResultData {
  const _ResultData({
    required this.attempt,
    required this.testTitle,
    required this.items,
  });

  final TestAttempt attempt;
  final String testTitle;
  final List<AttemptReviewItem> items;
}
