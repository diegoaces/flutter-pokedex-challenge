import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/domain/entities/pokemon.dart';

/// Notifier que maneja la lista de pokemones favoritos
class FavoritesNotifier extends Notifier<Map<int, Pokemon>> {
  @override
  Map<int, Pokemon> build() {
    return {};
  }

  /// Agrega un pokemon a favoritos
  void addFavorite(Pokemon pokemon) {
    state = {...state, pokemon.id: pokemon};
  }

  /// Remueve un pokemon de favoritos
  void removeFavorite(int pokemonId) {
    final newState = Map<int, Pokemon>.from(state);
    newState.remove(pokemonId);
    state = newState;
  }

  /// Toggle: agrega si no existe, remueve si existe
  void toggleFavorite(Pokemon pokemon) {
    if (state.containsKey(pokemon.id)) {
      removeFavorite(pokemon.id);
    } else {
      addFavorite(pokemon);
    }
  }

  /// Verifica si un pokemon está en favoritos
  bool isFavorite(int pokemonId) {
    return state.containsKey(pokemonId);
  }

  /// Obtiene un pokemon favorito por ID
  Pokemon? getFavorite(int pokemonId) {
    return state[pokemonId];
  }

  /// Limpia todos los favoritos
  void clearFavorites() {
    state = {};
  }

  /// Obtiene la cantidad de favoritos
  int get count => state.length;

  /// Obtiene la lista de pokemones favoritos
  List<Pokemon> get favoritesList => state.values.toList();
}

/// Provider principal para manejar favoritos
final favoritesProvider =
    NotifierProvider<FavoritesNotifier, Map<int, Pokemon>>(() {
      return FavoritesNotifier();
    });

/// Provider para verificar si un pokemon específico es favorito
final isFavoriteProvider = Provider.family<bool, int>((ref, pokemonId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.containsKey(pokemonId);
});

/// Provider para obtener la cantidad de favoritos
final favoritesCountProvider = Provider<int>((ref) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.length;
});

/// Provider para obtener la lista de pokemones favoritos
final favoritesListProvider = Provider<List<Pokemon>>((ref) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.values.toList();
});
