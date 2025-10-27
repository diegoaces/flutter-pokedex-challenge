import 'package:poke_app/domain/entities/pokemon_entity.dart';
import 'package:poke_app/presentation/providers/use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_list_clean_provider.g.dart';

/// Provider for fetching the Pokemon list using Clean Architecture.
/// This provider uses the GetPokemonList use case from the domain layer.
///
/// Usage in widgets:
/// ```dart
/// final asyncPokemons = ref.watch(pokemonListCleanProvider);
///
/// asyncPokemons.when(
///   data: (pokemons) => ListView(...),
///   loading: () => PokeballLoading(),
///   error: (error, stack) => ErrorWidget(error),
/// );
/// ```
@riverpod
Future<List<PokemonEntity>> pokemonListClean(Ref ref) async {
  final useCase = ref.watch(getPokemonListUseCaseProvider);

  // Execute the use case
  final result = await useCase();

  // Convert Result to AsyncValue by throwing on failure
  return result.when(
    success: (pokemons) => pokemons,
    failure: (error) => throw Exception(error.message),
  );
}

/// Provider for paginated Pokemon list.
/// Allows loading more Pokemon as the user scrolls.
@riverpod
class PaginatedPokemonList extends _$PaginatedPokemonList {
  int _currentPage = 0;
  static const int _pageSize = 20;

  @override
  Future<List<PokemonEntity>> build() async {
    return _fetchPage(0);
  }

  /// Loads the next page of Pokemon and appends to the existing list.
  Future<void> loadMore() async {
    // Don't load if already loading
    if (state.isLoading) return;

    final useCase = ref.read(getPokemonListUseCaseProvider);
    _currentPage++;

    final result = await useCase.fetchPage(
      page: _currentPage,
      pageSize: _pageSize,
    );

    result.when(
      success: (newPokemons) {
        final currentList = state.value ?? [];
        state = AsyncData([...currentList, ...newPokemons]);
      },
      failure: (error) {
        state = AsyncError(error, StackTrace.current);
      },
    );
  }

  /// Refreshes the entire list by resetting to page 0.
  Future<void> refresh() async {
    _currentPage = 0;
    ref.invalidateSelf();
  }

  Future<List<PokemonEntity>> _fetchPage(int page) async {
    final useCase = ref.read(getPokemonListUseCaseProvider);

    final result = await useCase.fetchPage(page: page, pageSize: _pageSize);

    return result.when(
      success: (pokemons) => pokemons,
      failure: (error) => throw Exception(error.message),
    );
  }
}
