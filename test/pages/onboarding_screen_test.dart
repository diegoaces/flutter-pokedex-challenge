import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:poke_app/l10n/app_localizations.dart';
import 'package:poke_app/presentation/pages/onboarding_screen.dart';

// Fake para Route
class FakeRoute extends Fake implements Route<dynamic> {}

// Mock para NavigatorObserver
class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  late MockNavigatorObserver mockObserver;
  setUpAll(() {
    registerFallbackValue(FakeRoute());
  });

  setUp(() {
    mockObserver = MockNavigatorObserver();
  });

  Widget makeTestableWidget() {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('es')],
      home: const OnboardingScreen(),
      navigatorObservers: [mockObserver],
    );
  }

  testWidgets('should show a onboarding screen', (tester) async {
    when(() => mockObserver.didPush(any(), any())).thenAnswer((_) async {});

    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);

    expect(find.byType(AnimatedContainer), findsNWidgets(2));
  });

  testWidgets('should show text when navigating through onboarding steps', (
    tester,
  ) async {
    when(() => mockObserver.didPush(any(), any())).thenAnswer((_) async {});

    await tester.pumpWidget(makeTestableWidget());
    await tester.pumpAndSettle();

    final context = tester.element(find.byType(OnboardingScreen));
    final l10n = AppLocalizations.of(context)!;

    // Verify initial state shows first title and continue button
    expect(find.text(l10n.onboardingTitle1), findsWidgets);
    expect(find.text(l10n.continueButton), findsOneWidget);

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // After navigation, second title should be visible
    // Note: AnimatedCrossFade keeps both widgets in tree, so we check for presence
    expect(find.text(l10n.onboardingTitle2), findsWidgets);
    expect(find.text(l10n.letsStartButton), findsOneWidget);
  });
}
