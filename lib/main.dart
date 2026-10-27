import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/branding/brand_config.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/brand_logo.dart';
import 'features/welcome/welcome_screen.dart';
import 'navigation/app_shell.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Everything before runApp is outside Flutter's own error handling: a database
  // that will not open or a backend that will not initialise used to leave the
  // student staring at a blank screen, which is the worst thing a Play Store
  // listing can do. Say so plainly instead, with no fake retry button.
  final AppState state;
  try {
    state = await AppState.bootstrap();
  } on Object catch (error) {
    runApp(_FailureApp(message: '$error'));
    return;
  }
  runApp(
    ChangeNotifierProvider<AppState>.value(
      value: state,
      child: const MastiGurukulApp(),
    ),
  );
}

/// Shown when the app could not start at all.
class _FailureApp extends StatelessWidget {
  const _FailureApp({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: BrandConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      home: Scaffold(
        backgroundColor: AppColors.cream,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BrandLogo(height: 96),
                const SizedBox(height: 18),
                Text(
                  'Masti Gurukul could not start on this device.',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Close the app and open it again. If it keeps happening, the '
                  'problem is in the local storage or the backend connection, '
                  'not in your class content.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MastiGurukulApp extends StatelessWidget {
  const MastiGurukulApp({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return MaterialApp(
      title: BrandConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: state.themeMode,
      home: state.ready ? const _Gate() : const _BootScreen(),
    );
  }
}

class _Gate extends StatelessWidget {
  const _Gate();

  @override
  Widget build(BuildContext context) {
    final student = context.watch<AppState>().currentStudent;
    return student == null ? const WelcomeScreen() : const AppShell();
  }
}

class _BootScreen extends StatelessWidget {
  const _BootScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BrandLogo(height: 120),
            const SizedBox(height: 18),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
