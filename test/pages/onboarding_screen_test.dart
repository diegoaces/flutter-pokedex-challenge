import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poke_app/presentation/pages/onboarding_screen.dart';

void main() {
  Widget makeTestableWidget() {
    return MaterialApp(home: OnboardingScreen());
  }
  testWidgets('onboarding screen ...', (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    
  });
}