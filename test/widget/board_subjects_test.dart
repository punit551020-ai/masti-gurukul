import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masti_gurukul/data/local/database.dart';
import 'package:masti_gurukul/features/classes/classes_screen.dart';
import 'package:masti_gurukul/features/classes/subject_screen.dart';
import 'package:masti_gurukul/state/app_state.dart';
import 'package:provider/provider.dart';

import 'tree_disposal.dart';

void main() {
  late AppDatabase db;
  late AppState state;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    state = AppState.forTesting(db);
    await state.catalog.seedStructureIfEmpty();
    await state.startStudent(name: 'Asha', classId: 'class-10');
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> pumpClasses(WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: state,
        child: const MaterialApp(home: Scaffold(body: ClassesScreen())),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('a board-pinned subject shows its board on the tile', (
    tester,
  ) async {
    final id = await state.admin.saveSubject(
      classId: 'class-10',
      boardId: 'board-bihar',
      nameEnglish: 'Science',
      nameHindi: 'विज्ञान',
      accentColor: '1B7A3D',
    );
    expect(id, 'sub-class-10-bihar-science');

    await pumpClasses(tester);

    // The board name appears once: only the pinned subject carries a badge.
    expect(find.text('Bihar Board'), findsOneWidget);
    expect(find.text('Science'), findsWidgets);
    await disposeTree(tester);
  });

  testWidgets('the subject page keeps saying which board it is', (
    tester,
  ) async {
    await state.admin.saveSubject(
      classId: 'class-10',
      boardId: 'board-bihar',
      nameEnglish: 'Science',
      accentColor: '1B7A3D',
    );
    await pumpClasses(tester);

    await tester.tap(find.text('Bihar Board'));
    await tester.pumpAndSettle();

    expect(find.byType(SubjectScreen), findsOneWidget);
    expect(find.text('Bihar Board'), findsOneWidget);
    await disposeTree(tester);
  });

  testWidgets('shared subjects show no board badge', (tester) async {
    await pumpClasses(tester);

    expect(find.text('Bihar Board'), findsNothing);
    expect(find.text('Mathematics'), findsOneWidget);
    await disposeTree(tester);
  });
}
