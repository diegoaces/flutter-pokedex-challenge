import 'package:poke_app/models/pokemon.dart';
import 'package:poke_app/models/pokemon_list_response.dart';
import 'package:poke_app/providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pokemon_provider.g.dart';

/// Provider para obtener la lista de pokemones
@riverpod
Future<List<Pokemon>> pokemonList(Ref ref) async {
  final dio = ref.watch(dioProvider);

  try {
    final response = await dio.get(
      'pokemon',
      queryParameters: {'limit': 20, 'offset': 0},
    );

    // Parsear la respuesta usando json_serializable
    final pokemonListResponse = PokemonListResponse.fromJson(
      response.data as Map<String, dynamic>,
    );

    // Convertir ApiResult a Pokemon
    final pokemons = pokemonListResponse.results.map((result) {
      return Pokemon(id: result.id, name: result.name);
    }).toList();

    return pokemons;
  } catch (e) {
    throw Exception('Error al cargar pokemones: $e');
  }
}

/// Provider para obtener un pokemon específico por ID
@riverpod
Future<Pokemon> pokemon(Ref ref, int id) async {
  final dio = ref.watch(dioProvider);

  try {
    final response = await dio.get('pokemon/$id');

    return Pokemon(
      id: response.data['id'] as int,
      name: response.data['name'] as String,
    );
  } catch (e) {
    throw Exception('Error al cargar pokemon $id: $e');
  }
}
