import 'package:poke_app/domain/usecases/get_pokemon_list.dart';
import 'package:poke_app/presentation/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_case_providers.g.dart';

@riverpod
GetPokemonList getPokemonListUseCase(Ref ref) {
  final repository = ref.watch(pokemonRepositoryProvider);
  return GetPokemonList(repository);
}
