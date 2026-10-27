import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/local/database.dart';
import '../../data/local/tables.dart';
import '../../state/app_state.dart';
import '../common/content_refresh.dart';
import '../common/state_views.dart';

class LiveClassesScreen extends StatefulWidget {
  const LiveClassesScreen({super.key});

  @override
  State<LiveClassesScreen> createState() => _LiveClassesScreenState();
}

class _LiveClassesScreenState extends State<LiveClassesScreen>
    with ContentRefresh {
  late Future<List<LiveClass>> _classes = _load();

  Future<List<LiveClass>> _load() {
    final state = context.read<AppState>();
    return state.catalog.liveClasses(classId: state.selectedClassId);
  }

  @override
  void onContentChanged() => _classes = observed(_load());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => setState(() => _classes = observed(_load())),
      child: FutureBuilder<List<LiveClass>>(
        future: _classes,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView(message: 'Loading live classes…');
          }
          final items = snapshot.data ?? const <LiveClass>[];
          if (items.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 80),
                const EmptyState(
                  icon: Icons.live_tv_rounded,
                  title: 'No live classes scheduled',
                  message:
                      'When the admin creates and publishes live classes, '
                      'their times will appear here. Internet is needed for live classes.',
                ),
              ],
            );
          }
          final now = DateTime.now();
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final started = item.actualStart ?? item.scheduledStart;
              final label = switch (item.status) {
                LiveClassStatuses.live => 'Live now',
                LiveClassStatuses.ended => 'Ended',
                LiveClassStatuses.cancelled => 'Cancelled',
                _ => item.scheduledStart.isAfter(now) ? 'Upcoming' : 'Started',
              };
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(child: Text(label.substring(0, 1))),
                  title: Text(item.title),
                  subtitle: Text('${_format(started)} · $label'),
                  trailing: item.youtubeUrl == null
                      ? null
                      : const Icon(Icons.smart_display_rounded),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _format(DateTime value) =>
      '${value.day}/${value.month}/${value.year} '
      '${value.hour.toString().padLeft(2, '0')}:${value.minute.toString().padLeft(2, '0')}';
}
