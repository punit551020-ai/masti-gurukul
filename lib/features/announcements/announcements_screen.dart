import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/local/database.dart';
import '../../state/app_state.dart';
import '../common/content_refresh.dart';
import '../common/state_views.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen>
    with ContentRefresh {
  late Future<List<Announcement>> _items = _load();

  Future<List<Announcement>> _load() {
    final state = context.read<AppState>();
    return state.catalog.activeAnnouncements(classId: state.selectedClassId);
  }

  @override
  void onContentChanged() => _items = observed(_load());

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => setState(() => _items = observed(_load())),
      child: FutureBuilder<List<Announcement>>(
        future: _items,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingView(message: 'Loading announcements…');
          }
          final items = snapshot.data ?? const <Announcement>[];
          if (items.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 80),
                const EmptyState(
                  icon: Icons.campaign_rounded,
                  title: 'No announcements',
                  message: 'New announcements from the admin panel will appear here.',
                ),
              ],
            );
          }
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: Icon(
                    item.priority == 'URGENT'
                        ? Icons.priority_high_rounded
                        : Icons.campaign_rounded,
                    color: item.priority == 'URGENT' ? Colors.red : null,
                  ),
                  title: Text(item.title),
                  subtitle: Text(item.body),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
