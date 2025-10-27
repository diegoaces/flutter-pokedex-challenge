import 'package:poke_app/data/mappers/pokemon_mapper.dart';
import 'package:poke_app/data/repositories/pokemon_repository_impl.dart';
import 'package:poke_app/domain/repositories/pokemon_repository.dart';
import 'package:poke_app/presentation/providers/data_source_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@riverpod
PokemonRepository pokemonRepository(Ref ref) {
  final remoteDataSource = ref.watch(pokemonRemoteDataSourceProvider);
  final mapper = PokemonMapper();

  return PokemonRepositoryImpl(
    remoteDataSource: remoteDataSource,
    mapper: mapper,
  );
}
