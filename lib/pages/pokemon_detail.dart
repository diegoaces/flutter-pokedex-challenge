import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/models/pokemon.dart';
import 'package:poke_app/widgets/custom_bottom_navigation.dart';

class PokemonDetail extends StatelessWidget {
  const PokemonDetail({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(pokemon.nameCapitalizedFirstLetter()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Pokemon #${pokemon.id}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              pokemon.nameCapitalizedFirstLetter(),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Image.network(
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png',
              height: 200,
              width: 200,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.broken_image,
                size: 100,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation()
    );
  }
}