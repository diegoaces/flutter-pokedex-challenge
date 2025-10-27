import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/pages/pokemon_list_tile.dart';
import 'package:poke_app/providers/pokemon_provider.dart';
import 'package:poke_app/widgets/custom_bottom_navigation.dart';
import 'package:poke_app/widgets/error_widget.dart';
import 'package:poke_app/widgets/pokeball_loading.dart';

class PokedexScreen extends ConsumerWidget {
  const PokedexScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemonsAsync = ref.watch(pokemonListProvider);

    return Scaffold(
      body: SafeArea(
        child: pokemonsAsync.when(
          data: (pokemons) => ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              return PokemonListTile(pokemon: pokemons[index]);
            },
          ),
          loading: () => Center(
            child: SizedBox(height: 50, width: 50, child: PokeballLoading()),
          ),
          error: (error, stack) => PokedexErrorWidget(),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
