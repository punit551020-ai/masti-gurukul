import 'package:flutter/material.dart';

import '../../data/local/database.dart';

class ClassPicker extends StatelessWidget {
  const ClassPicker({
    super.key,
    required this.classes,
    required this.selectedClassId,
    required this.onChanged,
    this.onRetry,
  });

  final List<SchoolClass> classes;
  final String? selectedClassId;
  final ValueChanged<String> onChanged;

  /// Shown when the device holds no classes yet. That is usually a sync that
  /// has not run rather than a broken app, so the student gets the honest
  /// reason and a way to ask again.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (classes.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'No classes are on this device yet. Content arrives from the '
            'school server, so this needs the internet once.',
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ],
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final item in classes)
          ChoiceChip(
            label: Text(item.nameEnglish),
            selected: item.id == selectedClassId,
            onSelected: (_) => onChanged(item.id),
          ),
      ],
    );
  }
}
