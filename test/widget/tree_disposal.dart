import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Unmounts the widget tree inside the test body and lets drift's
/// zero-duration stream-close timer fire.
///
/// The library and downloads screens watch drift queries with `StreamBuilder`.
/// Unmounting one schedules a short timer, and `flutter_test` fails a test that
/// ends with a timer still pending — but it disposes the tree before it checks,
/// so the tree has to be torn down here instead.
Future<void> disposeTree(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(seconds: 1));
}
