import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/pages/home_screen.dart';
import 'package:poke_app/pages/onboarding_screen.dart';
import 'package:poke_app/pages/splash_screen.dart';
import 'package:poke_app/providers/app_startup_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/splash',
    routes: [
      _fadeRoute(path: '/splash', child: const SplashScreen()),
      _fadeRoute(path: '/onboarding', child: const OnboardingScreen()),
      _fadeRoute(path: '/home', child: const HomeScreen()),
    ],
    redirect: (context, state) {
      final appStartupState = ref.watch(appStartupProvider);
      final isOnSplash = state.matchedLocation == '/splash';

      // If we're on splash but should show onboarding, redirect
      if (isOnSplash && appStartupState == AppStartupState.onboarding) {
        return '/onboarding';
      }

      return null;
    },
  );

  // Listen to provider changes and refresh router
  ref.listen<AppStartupState>(appStartupProvider, (previous, next) {
    router.refresh();
  });

  return router;
});

GoRoute _fadeRoute({required String path, required Widget child}) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondary, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}
