import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/core/app_routes.dart';
import 'package:poke_app/core/pokemon_type_helper.dart';
import 'package:poke_app/models/pokemon.dart';
import 'package:poke_app/pages/element_chip.dart';
import 'package:poke_app/providers/favorites_provider.dart';

class PokemonListTile extends ConsumerStatefulWidget {
  const PokemonListTile({
    super.key,
    required this.pokemon,
    this.showSlidable = false,
  });

  final Pokemon pokemon;
  final bool showSlidable;

  @override
  ConsumerState<PokemonListTile> createState() => _PokemonListTileState();
}

class _PokemonListTileState extends ConsumerState<PokemonListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onFavoriteTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    ref.read(favoritesProvider.notifier).toggleFavorite(widget.pokemon);
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(isFavoriteProvider(widget.pokemon.id));
    final primaryType = widget.pokemon.types.isNotEmpty
        ? widget.pokemon.types.first
        : 'normal';
    final backgroundColor = PokemonTypeHelper.getTypeColor(primaryType);

    final tile = GestureDetector(
      onTap: () {
        context.push(AppRoutes.pokemonDetailPath(widget.pokemon.id), extra: widget.pokemon);
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor.withAlpha(77),
          borderRadius: BorderRadius.circular(16),
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "N°00${widget.pokemon.id}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      widget.pokemon.nameCapitalizedFirstLetter(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: widget.pokemon.types.map((type) {
                        return ElementChip(
                          color: PokemonTypeHelper.getTypeColor(type),
                          title: PokemonTypeHelper.getTypeLabel(type),
                          element: PokemonTypeHelper.getTypeAsset(type),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        color: backgroundColor.withAlpha(128),
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
                          PokemonTypeHelper.getTypeAsset(primaryType),
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
                      onTap: _onFavoriteTap,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
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
                  ),

                  Center(
                    child: Image.network(
                      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.pokemon.id}.png',
                      height: 100,
                      width: 100,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox(
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
        ),
      ),
    );

    if (!widget.showSlidable) {
      return tile;
    }

    return Slidable(
      key: ValueKey(widget.pokemon.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(
          onDismissed: () {
            ref.read(favoritesProvider.notifier).removeFavorite(widget.pokemon.id);
          },
        ),
        children: [
          SlidableAction(
            onPressed: (context) {
              ref.read(favoritesProvider.notifier).removeFavorite(widget.pokemon.id);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
          ),
        ],
      ),
      child: tile,
    );
  }
}
