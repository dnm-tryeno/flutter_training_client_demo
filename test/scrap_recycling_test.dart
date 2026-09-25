import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/feature/demos/chat/Scrap%20Recycling%20app/scrap_recycling_app.dart';

void main() {
  testWidgets('Scrap Recycling App loads Splash and navigates to Login and Home', (tester) async {
    await tester.pumpWidget(const ScrapRecyclingApp());

    // Check Splash screen branding
    expect(find.text('KABADA'), findsOneWidget);
    expect(find.text('कबाड़ा • स्मार्ट रीसाइक्लिंग'), findsOneWidget);

    // Tap Skip on Splash to proceed to Login Demo
    final skipButton = find.text('Skip');
    expect(skipButton, findsOneWidget);
    await tester.tap(skipButton);
    await tester.pump(const Duration(milliseconds: 600));

    // Check Login demo elements
    expect(find.text('Direct Entry'), findsOneWidget);

    // Tap Direct Entry into the app
    await tester.tap(find.text('Direct Entry'));
    await tester.pump(const Duration(milliseconds: 600));

    // Check Home screen loaded matching screenshots
    expect(find.text('DEMO MODE'), findsOneWidget);
    expect(find.text('What do you want to sell?'), findsOneWidget);
    expect(find.text('Sell scrap in\nseconds!'), findsOneWidget);
    expect(find.text('Rate List'), findsOneWidget);
    expect(find.text('Rewards'), findsOneWidget);
  });
}
