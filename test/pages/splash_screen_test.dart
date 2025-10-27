import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:poke_app/presentation/pages/splash_screen.dart';
import 'package:poke_app/presentation/widgets/pokeball_loading.dart';

void main() {
  Widget makeTestableWidget() {
    return MaterialApp(home: SplashScreen());
  }

  testWidgets('splash screen should show a pokeball loading indicator', (
    tester,
  ) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(PokeballLoading), findsOneWidget);
  });

  testWidgets('splash screen should be centered', (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    final centerFinder = find.byType(Center);
    expect(centerFinder, findsOneWidget);

    final centerWidget = tester.widget<Center>(centerFinder);
    expect(centerWidget.child, isA<PokeballLoading>());
  });

  testWidgets('should not have an app bar', (tester) async {
    await tester.pumpWidget(makeTestableWidget());
    await tester.pump();

    expect(find.byType(AppBar), findsNothing);
  });
}
