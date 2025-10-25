import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/pages/onboarding_page.dart';
import 'package:poke_app/pages/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    _fadeRoute(path: '/splash', child: const SplashScreen()),
    _fadeRoute(path: '/onboarding', child: const OnboardingScreen()),
  ],
);

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
