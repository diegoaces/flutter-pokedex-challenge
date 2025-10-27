import 'package:poke_app/data/datasources/pokemon_remote_datasource.dart';
import 'package:poke_app/data/exceptions/data_exceptions.dart';
import 'package:poke_app/data/mappers/pokemon_mapper.dart';
import 'package:poke_app/domain/core/result.dart';
import 'package:poke_app/domain/entities/pokemon_entity.dart';
import 'package:poke_app/domain/failures/pokemon_failure.dart';
import 'package:poke_app/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource _remoteDataSource;
  final PokemonMapper _mapper;

  const PokemonRepositoryImpl({
    required PokemonRemoteDataSource remoteDataSource,
    required PokemonMapper mapper,
  })  : _remoteDataSource = remoteDataSource,
        _mapper = mapper;

  @override
  Future<Result<List<PokemonEntity>>> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final listResponse = await _remoteDataSource.fetchPokemonList(
        limit: limit,
        offset: offset,
      );

      final detailFutures = listResponse.results.map((item) async {
        return await _remoteDataSource.fetchPokemonDetail(item.id);
      });

      final details = await Future.wait(detailFutures);

      final entities = _mapper.detailResponseListToEntityList(details);

      return Result.success(entities);
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, e.statusCode));
    } on TimeoutException catch (e) {
      return Result.failure(TimeoutFailure(e.message));
    } on ParseException catch (e) {
      return Result.failure(ParseFailure(e.message));
    } on NotFoundException catch (e) {
      return Result.failure(NotFoundFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Result<PokemonEntity>> getPokemonById(int id) async {
    try {
      final detail = await _remoteDataSource.fetchPokemonDetail(id);
      final entity = _mapper.detailResponseToEntity(detail);

      return Result.success(entity);
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message, e.statusCode));
    } on TimeoutException catch (e) {
      return Result.failure(TimeoutFailure(e.message));
    } on ParseException catch (e) {
      return Result.failure(ParseFailure(e.message));
    } on NotFoundException catch (e) {
      return Result.failure(NotFoundFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Result<List<PokemonEntity>>> searchPokemon(String query) async {
    try {
      final result = await getPokemonList(limit: 151); // Gen 1 Pokemon

      return result.map((pokemons) {
        final lowercaseQuery = query.toLowerCase();

        return pokemons.where((pokemon) {
          return pokemon.name.toLowerCase().contains(lowercaseQuery) ||
              pokemon.id.toString().contains(query);
        }).toList();
      });
    } catch (e) {
      return Result.failure(UnknownFailure('Search failed: $e'));
    }
  }

  @override
  Future<Result<List<PokemonEntity>>> filterPokemonByTypes(
    List<String> types,
  ) async {
    try {
      if (types.isEmpty) {
        return await getPokemonList();
      }

      final result = await getPokemonList(limit: 151); // Gen 1 Pokemon

      return result.map((pokemons) {
        return pokemons.where((pokemon) {
          return pokemon.types.any((type) =>
              types.any((filterType) =>
                  type.toLowerCase() == filterType.toLowerCase()));
        }).toList();
      });
    } catch (e) {
      return Result.failure(UnknownFailure('Filter failed: $e'));
    }
  }
}
