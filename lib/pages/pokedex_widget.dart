import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poke_app/models/pokemon.dart';
import 'package:poke_app/pages/pokemon_list_tile.dart';
import 'package:poke_app/widgets/filter_preferences_modal.dart';

class PokedexWidget extends StatelessWidget {
  const PokedexWidget({super.key, required this.data});

  final Response? data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey[300]!, width: 1.5),
                    color: Colors.white,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Procurar Pokémon...',
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          'assets/svg/search.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            Colors.grey[400]!,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 8,
                      ),
                    ),
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                    onChanged: (value) {},
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    builder: (context) => FilterPreferencesModal(
                      onApplyFilters: (selectedTypes) {},
                    ),
                  );
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!, width: 1.5),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: SvgPicture.asset(
                      'assets/svg/search.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        Colors.grey[400]!,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: data?.data['results'].length ?? 0,
            itemBuilder: (context, index) {
              final pokemonData = data?.data['results'][index];
              final pokemonId =
                  int.parse(pokemonData['url'].toString().split('/')[6]);
              final pokemonName = pokemonData['name'].toString();
              final pokemon = Pokemon(id: pokemonId, name: pokemonName);
              return PokemonListTile(pokemon: pokemon);
            },
          ),
        ),
      ],
    );
  }
}
