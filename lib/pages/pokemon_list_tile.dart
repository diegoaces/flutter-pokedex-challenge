import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:poke_app/colors.dart';
import 'package:poke_app/models/pokemon.dart';
import 'package:poke_app/pages/element_chip.dart';
import 'package:poke_app/providers/favorites_provider.dart';

class PokemonListTile extends ConsumerWidget {
  const PokemonListTile({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(pokemon.id));
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),

      decoration: BoxDecoration(
        color: Colors.greenAccent.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "N°00${pokemon.id}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  pokemon.nameCapitalizedFirstLetter(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    ElementChip(
                      color: grassPrimary,
                      title: 'Planta',
                      element: 'assets/svg/grass.svg',
                    ),
                    ElementChip(
                      color: poisonPrimary,
                      title: 'Veneno',
                      element: 'assets/svg/poison.svg',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: grassSolid,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Center(
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white,
                            Colors.white.withAlpha(200),
                            Colors.white.withAlpha(26),
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.srcIn,
                      child: SvgPicture.asset(
                        'assets/svg/grass.svg',
                        width: 94,
                        height: 94,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(favoritesProvider.notifier)
                          .toggleFavorite(pokemon);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isFavorite ? Colors.red : Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SvgPicture.asset(
                          isFavorite
                              ? 'assets/svg/fav_solid.svg'
                              : 'assets/svg/fav.svg',
                          fit: BoxFit.contain,
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Center(
                  child: Image.network(
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png',
                    height: 100,
                    width: 100,
                    errorBuilder: (context, error, stackTrace) => const SizedBox(
                      width: 100,
                      height: 100,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(Icons.broken_image, size: 50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


