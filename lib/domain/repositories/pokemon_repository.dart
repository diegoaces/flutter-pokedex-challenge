import 'package:poke_app/domain/core/result.dart';
import 'package:poke_app/domain/entities/pokemon_entity.dart';

abstract class PokemonRepository {
  Future<Result<List<PokemonEntity>>> getPokemonList({
    int limit = 20,
    int offset = 0,
  });

  Future<Result<PokemonEntity>> getPokemonById(int id);
  Future<Result<List<PokemonEntity>>> searchPokemon(String query);
  Future<Result<List<PokemonEntity>>> filterPokemonByTypes(List<String> types);
}
