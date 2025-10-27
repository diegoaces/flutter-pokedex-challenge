import 'package:poke_app/domain/core/result.dart';
import 'package:poke_app/domain/entities/pokemon_entity.dart';
import 'package:poke_app/domain/repositories/pokemon_repository.dart';

/// Use case for fetching a list of Pokemon.
///
/// This encapsulates the business logic for retrieving Pokemon data.
/// It follows the Single Responsibility Principle - it does one thing and does it well.
///
/// Usage:
/// ```dart
/// final useCase = GetPokemonList(repository);
/// final result = await useCase(limit: 20, offset: 0);
///
/// result.when(
///   success: (pokemons) => print('Fetched ${pokemons.length} Pokemon'),
///   failure: (error) => print('Error: $error'),
/// );
/// ```
class GetPokemonList {
  final PokemonRepository _repository;

  /// Creates a new instance of [GetPokemonList].
  ///
  /// [_repository] - The repository to fetch Pokemon data from.
  const GetPokemonList(this._repository);

  /// Executes the use case to fetch a list of Pokemon.
  ///
  /// [limit] - Maximum number of Pokemon to fetch (default: 20, max recommended: 100)
  /// [offset] - Number of Pokemon to skip for pagination (default: 0)
  ///
  /// Returns:
  /// - Result.success with List<PokemonEntity> containing the fetched Pokemon
  /// - Result.failure with PokemonFailure if an error occurs
  ///
  /// Common failures:
  /// - [NetworkFailure] - Network connectivity issues
  /// - [ServerFailure] - Server-side errors (500, 503, etc.)
  /// - [TimeoutFailure] - Request took too long
  /// - [ParseFailure] - Invalid response format
  /// - [UnknownFailure] - Unexpected errors
  Future<Result<List<PokemonEntity>>> call({
    int limit = 20,
    int offset = 0,
  }) async {
    // Input validation
    if (limit <= 0) {
      limit = 20; // Default to 20 if invalid
    }

    if (limit > 100) {
      limit = 100; // Cap at 100 to prevent API abuse
    }

    if (offset < 0) {
      offset = 0; // Ensure non-negative offset
    }

    // Delegate to repository
    return await _repository.getPokemonList(
      limit: limit,
      offset: offset,
    );
  }

  /// Convenience method to fetch the first page of Pokemon.
  /// Equivalent to calling `call()` with default parameters.
  Future<Result<List<PokemonEntity>>> fetchFirstPage() {
    return call(limit: 20, offset: 0);
  }

  /// Convenience method to fetch a specific page of Pokemon.
  ///
  /// [page] - The page number (0-indexed)
  /// [pageSize] - Number of Pokemon per page (default: 20)
  ///
  /// Example: To get page 2 with 20 items per page:
  /// ```dart
  /// final result = await useCase.fetchPage(page: 1, pageSize: 20);
  /// // This fetches Pokemon 21-40
  /// ```
  Future<Result<List<PokemonEntity>>> fetchPage({
    required int page,
    int pageSize = 20,
  }) {
    final offset = page * pageSize;
    return call(limit: pageSize, offset: offset);
  }

  /// Fetches all Pokemon up to a certain limit.
  /// Note: This can be slow for large limits. Consider using pagination instead.
  ///
  /// [maxCount] - Maximum number of Pokemon to fetch (default: 151 for Gen 1)
  Future<Result<List<PokemonEntity>>> fetchAll({int maxCount = 151}) async {
    const pageSize = 20;
    final List<PokemonEntity> allPokemons = [];

    for (int offset = 0; offset < maxCount; offset += pageSize) {
      final remaining = maxCount - offset;
      final limit = remaining < pageSize ? remaining : pageSize;

      final result = await call(limit: limit, offset: offset);

      // If any page fails, return the failure
      if (result.isFailure) {
        return result;
      }

      allPokemons.addAll(result.value);
    }

    return Result.success(allPokemons);
  }
}
