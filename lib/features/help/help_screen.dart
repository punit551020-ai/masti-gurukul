import 'package:flutter/material.dart';

import '../../core/branding/brand_config.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Help')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '${BrandConfig.appName} — ${BrandConfig.motto}',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          const _Block(
            title: 'How to use this app',
            lines: [
              '1. Choose your class (6 to 10) on the Home screen.',
              '2. In Classes, open subject → chapter → lesson.',
              '3. Filter and view notes/PDFs/worksheets in the Library.',
              '4. Change name, class and light/dark theme in Profile.',
            ],
          ),
          const SizedBox(height: 16),
          const _Block(
            title: 'What works in this version',
            lines: [
              '• Create a profile by name, saved on this same device',
              '• Browsing class/subject/chapter/lesson',
              '• Bookmarks, recently viewed, progress records',
              '• Library filters (subject, type, year)',
              '• Light/dark theme and layouts on both small and large screens',
            ],
          ),
          const SizedBox(height: 16),
          const _Block(
            title: 'Not available yet (no fake buttons)',
            lines: [
              '• In-app video player and live class stream',
              '• Offline PDF/lesson downloads',
              '• Taking tests and scores (once the question bank comes from the admin)',
              '• Admin panel and cloud sync (once Supabase is connected)',
            ],
          ),
          const SizedBox(height: 16),
          const _Block(
            title: 'Internet needs',
            lines: [
              '• Internet is required for live classes.',
              '• Downloaded files will open offline (this feature is coming).',
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.tertiaryContainer.withValues(
                alpha: 0.35,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'A contact/complaint number has not been added in this version '
              'because it is not verified yet. It will be added with the admin panel.',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _Block extends StatelessWidget {
  const _Block({required this.title, required this.lines});

  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium),
        const SizedBox(height: 6),
        for (final line in lines)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(line, style: theme.textTheme.bodyMedium),
          ),
      ],
    );
  }
}
