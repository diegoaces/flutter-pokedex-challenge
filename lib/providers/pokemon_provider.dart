import 'package:poke_app/models/pokemon.dart';
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

    final results = response.data['results'] as List;

    final pokemons = results.map((pokemonData) {
      // Extraer el ID de la URL
      final url = pokemonData['url'] as String;
      final id = int.parse(url.split('/')[6]);
      final name = pokemonData['name'] as String;

      return Pokemon(id: id, name: name);
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
