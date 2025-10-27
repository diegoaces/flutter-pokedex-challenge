import 'package:poke_app/data/datasources/pokemon_remote_datasource.dart';
import 'package:poke_app/data/datasources/pokemon_remote_datasource_impl.dart';
import 'package:poke_app/providers/dio_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'data_source_providers.g.dart';

/// Provider for the Pokemon remote data source.
/// This provides the implementation that uses Dio for API calls.
@riverpod
PokemonRemoteDataSource pokemonRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return PokemonRemoteDataSourceImpl(dio);
}
