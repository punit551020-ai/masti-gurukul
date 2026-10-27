import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/features/admin/hidden_trigger.dart';
import 'package:masti_gurukul/features/welcome/welcome_screen.dart';
import 'package:masti_gurukul/navigation/app_shell.dart';
import 'package:masti_gurukul/state/app_state.dart';
import 'package:provider/provider.dart';

import 'tree_disposal.dart';

/// Mirrors main.dart's private gate so the test exercises the real switch:
/// no student -> welcome screen, a student -> the app shell.
class _GateLike extends StatelessWidget {
  const _GateLike();

  @override
  Widget build(BuildContext context) {
    final student = context.watch<AppState>().currentStudent;
    return student == null ? const WelcomeScreen() : const AppShell();
  }
}

void main() {
  late AppDatabase db;
  late AppState state;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    state = AppState.forTesting(db);
    await state.catalog.seedStructureIfEmpty();
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> pumpWelcome(WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(home: Scaffold(body: _GateLike())),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The campus art is a real band at the bottom of the screen rather than a
  /// backdrop, so on a short window the form scrolls above it. Reach the button
  /// the way a student would instead of tapping through the artwork.
  Future<void> revealStartButton(WidgetTester tester) async {
    await tester.ensureVisible(find.text('Start Learning'));
    await tester.pumpAndSettle();
  }

  testWidgets('login screen shows the wording from the design reference', (
    tester,
  ) async {
    await pumpWelcome(tester);

    expect(find.text('सीखो • बढ़ो • सफल बनो'), findsOneWidget);
    expect(find.text('अपना नाम लिखें'), findsOneWidget);
    expect(find.text('जैसे: Ankit Raj'), findsOneWidget);
    expect(find.text('Start Learning'), findsOneWidget);
    expect(find.text('बस अपना नाम लिखें और शुरू करें'), findsOneWidget);
    // The badge stays tappable three times for the hidden admin panel.
    expect(find.byType(HiddenAdminTrigger), findsOneWidget);

    await disposeTree(tester);
  });

  testWidgets('a name alone signs the student in', (tester) async {
    await pumpWelcome(tester);

    await tester.enterText(find.byType(TextField), 'Ankit Raj');
    await revealStartButton(tester);
    await tester.tap(find.text('Start Learning'));
    await tester.pumpAndSettle();

    expect(find.byType(AppShell), findsOneWidget);
    final stored = await state.students.currentStudent();
    expect(stored, isNotNull);
    expect(stored!.displayName, 'Ankit Raj');

    await disposeTree(tester);
  });

  testWidgets('the campus art sits below the form without covering it', (
    tester,
  ) async {
    // A phone is what the artwork has to survive: the band keeps the file's own
    // ratio there, so the towers and the students are never cut off.
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await pumpWelcome(tester);

    final art = tester.getRect(
      find.byWidgetPredicate((widget) {
        if (widget is! Image) return false;
        final image = widget.image;
        return image is AssetImage &&
            image.assetName == 'assets/brand/welcome_campus.png';
      }),
    );
    expect(art.width, 390);
    expect(art.height, closeTo(390 * 419 / 755, 1));

    // The art is the last item in the same column as the form, so nothing a
    // student types or taps can ever end up painted on top of the buildings.
    for (final finder in [
      find.byType(TextField),
      find.text('Start Learning'),
      find.text('बस अपना नाम लिखें और शुरू करें'),
    ]) {
      expect(tester.getRect(finder).bottom, lessThanOrEqualTo(art.top + 0.5));
    }

    await disposeTree(tester);
  });

  testWidgets('an empty name is refused and keeps the student out', (
    tester,
  ) async {
    await pumpWelcome(tester);

    await revealStartButton(tester);
    await tester.tap(find.text('Start Learning'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(state.currentStudent, isNull);
    expect(find.byType(WelcomeScreen), findsOneWidget);

    await disposeTree(tester);
  });
}
