import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/core/app_routes.dart';
import 'package:poke_app/domain/entities/pokemon.dart';
import 'package:poke_app/presentation/pages/favorites_screen.dart';
import 'package:poke_app/presentation/pages/pokedex_screen.dart';
import 'package:poke_app/presentation/pages/onboarding_screen.dart';
import 'package:poke_app/presentation/widgets/pokemon_detail.dart';
import 'package:poke_app/presentation/pages/profile_screen.dart';
import 'package:poke_app/presentation/pages/regiones_screen.dart';
import 'package:poke_app/presentation/pages/splash_screen.dart';
import 'package:poke_app/providers/app_startup_provider.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      _fadeRoute(path: AppRoutes.splash, child: const SplashScreen()),
      _fadeRoute(path: AppRoutes.onboarding, child: const OnboardingScreen()),
      _fadeRoute(path: AppRoutes.pokedex, child: const PokedexScreen()),
      _fadeRoute(path: AppRoutes.regiones, child: const RegionesScreen()),
      _fadeRoute(path: AppRoutes.favoritos, child: const FavoritesScreen()),
      _fadeRoute(path: AppRoutes.profile, child: const ProfileScreen()),
      GoRoute(
        path: AppRoutes.pokemonDetail,
        pageBuilder: (context, state) {
          final pokemon = state.extra as Pokemon;
          return CustomTransitionPage(
            key: state.pageKey,
            child: PokemonDetail(pokemon: pokemon),
            transitionsBuilder: (context, animation, secondary, child) =>
                FadeTransition(opacity: animation, child: child),
          );
        },
      ),
    ],
    redirect: (context, state) {
      final appStartupState = ref.watch(appStartupProvider);
      final isOnSplash = state.matchedLocation == AppRoutes.splash;

      // If we're on splash but should show onboarding, redirect
      if (isOnSplash && appStartupState == AppStartupState.onboarding) {
        return AppRoutes.onboarding;
      }

      return null;
    },
  );

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
