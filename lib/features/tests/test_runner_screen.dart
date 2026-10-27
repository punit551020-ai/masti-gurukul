import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/local/database.dart';
import '../../data/repositories/test_repository.dart';
import '../../state/app_state.dart';
import '../common/state_views.dart';
import 'test_formatting.dart';
import 'test_result_screen.dart';

/// One-question-at-a-time MCQ runner with a live countdown, a question
/// palette, mark-for-review and a submit confirmation that counts the
/// unanswered questions. Persists through [TestRepository] on submit.
class TestRunnerScreen extends StatefulWidget {
  const TestRunnerScreen({super.key, required this.testId});

  final String testId;

  @override
  State<TestRunnerScreen> createState() => _TestRunnerScreenState();
}

class _TestRunnerScreenState extends State<TestRunnerScreen> {
  late final TestRepository _repo;

  Test? _test;
  List<TestQuestion> _questions = const [];
  String? _loadError;
  bool _loading = true;

  final Map<String, String?> _selections = {};
  final Set<String> _markedForReview = {};
  int _index = 0;

  int _totalSeconds = 0;
  int _remainingSeconds = 0;
  Timer? _ticker;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _repo = TestRepository(context.read<AppState>().database);
    _load();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final state = context.read<AppState>();
      if (state.currentStudent == null) {
        if (mounted) {
          setState(() {
            _loading = false;
            _loadError =
                'No student profile yet. Open the Profile tab and add '
                'yourself before taking a test.';
          });
        }
        return;
      }
      final test = await _repo.testById(widget.testId);
      if (test == null || !test.isPublished) {
        if (mounted) {
          setState(() {
            _loading = false;
            _loadError =
                'This test is no longer published, so it cannot be '
                'started.';
          });
        }
        return;
      }
      final questions = await _repo.questionsForTest(test.id);
      if (!mounted) return;
      setState(() {
        _test = test;
        _questions = questions;
        _loading = false;
        if (questions.isEmpty) {
          _loadError =
              'This test has no questions yet, so it cannot be '
              'started. Please ask the admin to add questions.';
        }
      });
      if (questions.isNotEmpty) {
        _startClock(test.timeLimitMinutes);
      }
    } on Object catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = 'The test questions could not be loaded from the device.';
      });
    }
  }

  void _startClock(int minutes) {
    // The admin form only accepts 1-300, but this number arrives from the
    // server, and a 0 or a negative one would either auto-submit the paper on
    // the first tick or throw inside the progress clamp.
    final safeMinutes = minutes.clamp(1, 300);
    _totalSeconds = safeMinutes * 60;
    _remainingSeconds = _totalSeconds;
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_remainingSeconds > 0) _remainingSeconds--;
      });
      if (_remainingSeconds == 0 && !_finished) {
        timer.cancel();
        _finish(auto: true);
      }
    });
  }

  // ------------------------------------------------------------------ answers

  void _select(String questionId, String option) {
    setState(() {
      if (_selections[questionId] == option) {
        _selections.remove(questionId);
      } else {
        _selections[questionId] = option;
      }
    });
  }

  void _clearCurrent() {
    setState(() => _selections.remove(_questions[_index].id));
  }

  void _toggleMarkCurrent() {
    setState(() {
      final id = _questions[_index].id;
      if (_markedForReview.contains(id)) {
        _markedForReview.remove(id);
      } else {
        _markedForReview.add(id);
      }
    });
  }

  int get _answeredCount =>
      _questions.where((q) => (_selections[q.id] ?? '').isNotEmpty).length;

  // ------------------------------------------------------------------- submit

  Future<void> _confirmSubmit() async {
    final unanswered = _questions.length - _answeredCount;
    final unansweredText = unanswered == 0
        ? 'All ${_questions.length} questions are answered.'
        : '$unanswered of ${_questions.length} questions '
              '${unanswered == 1 ? 'is' : 'are'} still unanswered.';
    final reviewText = _markedForReview.isEmpty
        ? ''
        : ' ${_markedForReview.length} '
              '${_markedForReview.length == 1 ? 'question is' : 'questions are'}'
              ' still marked for review.';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Submit test?'),
        content: Text(
          '$unansweredText$reviewText Once submitted, the answers cannot be '
          'changed.',
        ),
        actions: [
          TextButton(
            key: const Key('submit-cancel'),
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep working'),
          ),
          FilledButton(
            key: const Key('submit-confirm'),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Submit now'),
          ),
        ],
      ),
    );
    if (confirmed == true) await _finish(auto: false);
  }

  Future<void> _finish({required bool auto}) async {
    if (_finished) return;
    setState(() => _finished = true);
    _ticker?.cancel();

    final test = _test;
    final student = context.read<AppState>().currentStudent;
    if (test == null || student == null) return;

    final timeSpent = (_totalSeconds - _remainingSeconds)
        .clamp(0, _totalSeconds)
        .toInt();
    try {
      final attempt = await _repo.saveAttempt(
        testId: test.id,
        studentId: student.id,
        selectedOptions: Map<String, String?>.of(_selections),
        timeSpentSeconds: timeSpent,
      );
      if (!mounted) return;
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => TestResultScreen(attemptId: attempt.id),
        ),
      );
    } on Object catch (_) {
      if (!mounted) return;
      setState(() => _finished = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'The attempt could not be saved. Check the connection to the '
            'local database and try submitting again.',
          ),
        ),
      );
    }
  }

  // --------------------------------------------------------------------- view

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Test')),
        body: const LoadingView(message: 'Loading questions...'),
      );
    }
    final test = _test;
    if (_loadError != null || test == null || _questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(test?.title ?? 'Test')),
        body: ErrorState(message: _loadError ?? 'This test cannot be started.'),
      );
    }

    final question = _questions[_index];
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(test.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                'Time left ${formatClock(_remainingSeconds)}',
                key: const Key('countdown'),
                style: theme.textTheme.titleSmall?.copyWith(
                  color: _remainingSeconds <= 30
                      ? theme.colorScheme.error
                      : theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _palette(theme),
                const SizedBox(height: 16),
                Text(
                  'Question ${_index + 1} of ${_questions.length}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Text(question.prompt, style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  '${formatMarks(question.marks)} marks'
                  '${test.negativeMarking > 0 ? ' · '
                            '-${formatMarks(test.negativeMarking)} for a wrong '
                            'answer' : ''}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 14),
                for (final option in const ['A', 'B', 'C', 'D'])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _optionTile(option, question),
                  ),
                if ((_selections[question.id] ?? '').isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      key: const Key('clear-response'),
                      onPressed: _clearCurrent,
                      child: const Text('Clear response'),
                    ),
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    key: const Key('mark-review'),
                    onPressed: _toggleMarkCurrent,
                    icon: Icon(
                      _markedForReview.contains(question.id)
                          ? Icons.bookmarks_rounded
                          : Icons.bookmark_border_rounded,
                      size: 18,
                    ),
                    label: Text(
                      _markedForReview.contains(question.id)
                          ? 'Remove review flag'
                          : 'Mark for review',
                    ),
                  ),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('previous'),
                      onPressed: _index > 0
                          ? () => setState(() => _index--)
                          : null,
                      icon: const Icon(Icons.arrow_back_rounded, size: 18),
                      label: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      key: const Key('next'),
                      onPressed: _index < _questions.length - 1
                          ? () => setState(() => _index++)
                          : null,
                      icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                      label: const Text('Next'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      key: const Key('submit-test'),
                      onPressed: _finished ? null : _confirmSubmit,
                      child: const Text('Submit test'),
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

  Widget _optionTile(String option, TestQuestion question) {
    final theme = Theme.of(context);
    final optionText = switch (option) {
      'A' => question.optionA,
      'B' => question.optionB,
      'C' => question.optionC,
      _ => question.optionD,
    };
    final selected = _selections[question.id] == option;

    return Material(
      color: selected
          ? theme.colorScheme.primaryContainer
          : theme.colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        key: Key('option-$option'),
        borderRadius: BorderRadius.circular(12),
        onTap: () => _select(question.id, option),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? theme.colorScheme.primary : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 13,
                backgroundColor: theme.colorScheme.onPrimaryContainer
                    .withValues(alpha: 0.12),
                child: Text(
                  option,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(optionText)),
              if (selected)
                Icon(
                  Icons.check_circle_rounded,
                  color: theme.colorScheme.primary,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _palette(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Question palette', style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < _questions.length; i++) _paletteChip(i, theme),
          ],
        ),
      ],
    );
  }

  Widget _paletteChip(int i, ThemeData theme) {
    final question = _questions[i];
    final answered = (_selections[question.id] ?? '').isNotEmpty;
    final marked = _markedForReview.contains(question.id);
    final current = i == _index;

    Color background;
    if (answered) {
      background = theme.colorScheme.primary;
    } else if (marked) {
      background = theme.colorScheme.tertiaryContainer;
    } else {
      background = theme.colorScheme.surfaceContainerHighest;
    }
    final foreground = answered
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return InkWell(
      key: Key('palette-$i'),
      onTap: () => setState(() => _index = i),
      child: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: current ? theme.colorScheme.error : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          '${i + 1}',
          style: theme.textTheme.labelMedium?.copyWith(
            color: foreground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
