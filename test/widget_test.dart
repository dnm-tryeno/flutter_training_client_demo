// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/feature/launcher/launcher_app.dart';

void main() {
  testWidgets('launcher includes FitCore gym demo', (tester) async {
    await tester.pumpWidget(const LauncherApp());

    expect(find.text('Flutter Demos'), findsOneWidget);
    expect(find.text('FitCore'), findsOneWidget);
    expect(find.text('Gym, Diet & Membership'), findsOneWidget);
  });
}
