import 'package:poke_app/data/models/pokemon_detail_response_dto.dart';
import 'package:poke_app/data/models/pokemon_list_response_dto.dart';

abstract class PokemonRemoteDataSource {
  Future<PokemonListResponseDTO> fetchPokemonList({
    required int limit,
    required int offset,
  });

  Future<PokemonDetailResponseDTO> fetchPokemonDetail(int id);
  Future<PokemonDetailResponseDTO> fetchPokemonByName(String name);
}
