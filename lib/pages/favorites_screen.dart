import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/l10n/app_localizations.dart';
import 'package:poke_app/pages/pokemon_list_tile.dart';
import 'package:poke_app/providers/favorites_provider.dart';
import 'package:poke_app/widgets/custom_bottom_navigation.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final favoritesList = ref.watch(favoritesListProvider);

    return Scaffold(
      body: favoritesList.isEmpty
          ? _buildEmptyState(l10n)
          : _buildFavoritesList(favoritesList),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/png/magikarp.png', width: 185, height: 215),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            l10n.favoritesEmptyTitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.favoritesEmptySubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List favorites) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Favoritos',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final pokemon = favorites[index];
                  return PokemonListTile(pokemon: pokemon, showSlidable: true);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
