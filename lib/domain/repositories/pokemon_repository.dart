import 'package:poke_app/domain/core/result.dart';
import 'package:poke_app/domain/entities/pokemon_entity.dart';

/// Abstract repository interface for Pokemon data operations.
/// This defines the contract that the data layer must implement.
/// Uses Result type for functional error handling (Success/Failure).
abstract class PokemonRepository {
  /// Fetches a list of Pokemon from the data source.
  ///
  /// [limit] - Maximum number of Pokemon to fetch (default: 20)
  /// [offset] - Number of Pokemon to skip for pagination (default: 0)
  ///
  /// Returns:
  /// - Result.success(List<PokemonEntity>) on success
  /// - Result.failure(PokemonFailure) on error
  Future<Result<List<PokemonEntity>>> getPokemonList({
    int limit = 20,
    int offset = 0,
  });

  /// Fetches detailed information for a single Pokemon by ID.
  ///
  /// [id] - The Pokemon's ID
  ///
  /// Returns:
  /// - Result.success(PokemonEntity) on success
  /// - Result.failure(PokemonFailure) on error (e.g., NotFoundFailure if Pokemon doesn't exist)
  Future<Result<PokemonEntity>> getPokemonById(int id);

  /// Searches for Pokemon by name.
  ///
  /// [query] - The search query (case-insensitive)
  ///
  /// Returns:
  /// - Result.success(List<PokemonEntity>) on success (may be empty if no matches)
  /// - Result.failure(PokemonFailure) on error
  Future<Result<List<PokemonEntity>>> searchPokemon(String query);

  /// Filters Pokemon by their types.
  ///
  /// [types] - List of type names to filter by (e.g., ["fire", "water"])
  ///
  /// Returns:
  /// - Result.success(List<PokemonEntity>) on success
  /// - Result.failure(PokemonFailure) on error
  Future<Result<List<PokemonEntity>>> filterPokemonByTypes(List<String> types);
}
