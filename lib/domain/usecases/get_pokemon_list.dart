import 'package:poke_app/domain/core/result.dart';
import 'package:poke_app/domain/entities/pokemon_entity.dart';
import 'package:poke_app/domain/repositories/pokemon_repository.dart';

class GetPokemonList {
  final PokemonRepository _repository;

  const GetPokemonList(this._repository);

  Future<Result<List<PokemonEntity>>> call({
    int limit = 20,
    int offset = 0,
  }) async {
    if (limit <= 0) {
      limit = 20;
    }

    if (limit > 100) {
      limit = 100;
    }

    if (offset < 0) {
      offset = 0; 
    }

    return await _repository.getPokemonList(limit: limit, offset: offset);
  }

  Future<Result<List<PokemonEntity>>> fetchFirstPage() {
    return call(limit: 20, offset: 0);
  }

  Future<Result<List<PokemonEntity>>> fetchPage({
    required int page,
    int pageSize = 20,
  }) {
    final offset = page * pageSize;
    return call(limit: pageSize, offset: offset);
  }

  Future<Result<List<PokemonEntity>>> fetchAll({int maxCount = 151}) async {
    const pageSize = 20;
    final List<PokemonEntity> allPokemons = [];

    for (int offset = 0; offset < maxCount; offset += pageSize) {
      final remaining = maxCount - offset;
      final limit = remaining < pageSize ? remaining : pageSize;

      final result = await call(limit: limit, offset: offset);

      if (result.isFailure) {
        return result;
      }

      allPokemons.addAll(result.value);
    }

    return Result.success(allPokemons);
  }
}
