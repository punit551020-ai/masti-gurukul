import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/branding/brand_config.dart';
import '../core/widgets/brand_logo.dart';
import '../data/repositories/sync_repository.dart';
import '../features/admin/hidden_trigger.dart';
import '../features/announcements/announcements_screen.dart';
import '../features/classes/classes_screen.dart';
import '../features/downloads/downloads_screen.dart';
import '../features/help/help_screen.dart';
import '../features/home/home_screen.dart';
import '../features/library/library_screen.dart';
import '../features/live/live_classes_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/progress/progress_screen.dart';
import '../features/tests/tests_screen.dart';
import '../state/app_state.dart';

class Destinations {
  const Destinations({
    required this.label,
    required this.icon,
    required this.builder,
    this.shortLabel,
    this.hasOwnScaffold = false,
  });

  final String label;
  final IconData icon;
  final WidgetBuilder builder;

  /// The bottom bar has little room per tab, so long names get a short form
  /// there while the app bar and the side rail keep the full label.
  final String? shortLabel;

  /// True when the screen draws its own Scaffold/AppBar (it needs AppBar
  /// actions). Everything else gets a standard Scaffold from the shell.
  final bool hasOwnScaffold;

  String get tabLabel => shortLabel ?? label;
}

const primaryTabs = <Destinations>[
  Destinations(label: 'Home', icon: Icons.home_rounded, builder: _home),
  Destinations(
    label: 'Classes',
    icon: Icons.menu_book_rounded,
    builder: _classes,
  ),
  Destinations(label: 'Tests', icon: Icons.fact_check_rounded, builder: _tests),
  Destinations(
    label: 'Downloads',
    icon: Icons.download_rounded,
    builder: _downloads,
  ),
  Destinations(label: 'Profile', builder: _profile, icon: Icons.person_rounded),
];

const drawerItems = <Destinations>[
  Destinations(
    label: 'Library',
    icon: Icons.local_library_rounded,
    builder: _library,
  ),
  Destinations(
    label: 'Live Classes',
    icon: Icons.live_tv_rounded,
    builder: _live,
  ),
  Destinations(
    label: 'Progress',
    icon: Icons.insights_rounded,
    builder: _progress,
  ),
  Destinations(
    label: 'Announcements',
    icon: Icons.campaign_rounded,
    builder: _announcements,
  ),
  Destinations(
    label: 'Help',
    icon: Icons.help_rounded,
    builder: _help,
    hasOwnScaffold: true,
  ),
];

Widget _home(_) => const HomeScreen();
Widget _classes(_) => const ClassesScreen();
Widget _tests(_) => const TestsScreen();
Widget _downloads(_) => const DownloadsScreen();
Widget _profile(_) => const ProfileScreen();
Widget _library(BuildContext context) =>
    LibraryScreen(onSync: context.read<AppState>().refreshContent);
Widget _live(_) => const LiveClassesScreen();
Widget _progress(_) => const ProgressScreen();
Widget _announcements(_) => const AnnouncementsScreen();
Widget _help(_) => const HelpScreen();

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  void _openDestination(Destinations destination) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (routeContext) => destination.hasOwnScaffold
            ? destination.builder(routeContext)
            : Scaffold(
                appBar: AppBar(title: Text(destination.label)),
                body: SafeArea(child: destination.builder(routeContext)),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final student = context.watch<AppState>().currentStudent;
    final wide = MediaQuery.sizeOf(context).width >= 1000;

    final body = IndexedStack(
      index: _index,
      children: [for (final t in primaryTabs) t.builder(context)],
    );

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 12,
        title: Row(
          children: [
            const BrandLogo(height: 34),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${primaryTabs[_index].label} · ${student?.displayName ?? ''}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          const _SyncBadge(),
          IconButton(
            tooltip: 'Announcements',
            icon: const Icon(Icons.notifications_rounded),
            onPressed: () => _openDestination(drawerItems[3]),
          ),
          const SizedBox(width: 4),
        ],
      ),
      drawer: wide ? null : _buildDrawer(context),
      body: Row(
        children: [
          if (wide)
            NavigationRail(
              extended: MediaQuery.sizeOf(context).width >= 1280,
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const BrandLogo(height: 44),
              ),
              destinations: [
                for (final t in primaryTabs)
                  NavigationRailDestination(
                    icon: Icon(t.icon),
                    label: Text(t.label),
                  ),
              ],
            ),
          if (wide) const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (i) => setState(() => _index = i),
              destinations: [
                for (final t in primaryTabs)
                  NavigationDestination(icon: Icon(t.icon), label: t.tabLabel),
              ],
            ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  HiddenAdminTrigger(child: const BrandLogo(height: 48)),
                  const SizedBox(height: 8),
                  Flexible(
                    child: Text(
                      BrandConfig.appName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      BrandConfig.motto,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            for (final item in drawerItems)
              ListTile(
                leading: Icon(item.icon),
                title: Text(item.label),
                onTap: () {
                  Navigator.of(context).pop();
                  _openDestination(item);
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// A plain statement about where the content on screen came from.
///
/// When the sync fails the student sees exactly the same list they saw before,
/// so without this badge "the school added two new videos" and "this phone has
/// not talked to the server since Tuesday" look identical. It stays silent while
/// things are healthy, and tapping it is the retry.
class _SyncBadge extends StatelessWidget {
  const _SyncBadge();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    if (!state.isLive) return const SizedBox.shrink();
    final phase = state.syncPhase;
    if (phase == SyncPhase.running) {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    final trouble = phase == SyncPhase.offline || phase == SyncPhase.failed;
    if (!trouble) return const SizedBox.shrink();
    return Tooltip(
      message: state.syncError ?? 'The school server could not be reached.',
      child: TextButton.icon(
        style: TextButton.styleFrom(
          visualDensity: VisualDensity.compact,
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        onPressed: () => state.refreshContent(),
        icon: const Icon(Icons.refresh_rounded, size: 16),
        label: const Text(
          'Offline',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
