import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/core/pokemon_type_helper.dart';
import 'package:poke_app/models/pokemon.dart';
import 'package:poke_app/widgets/circle_clipper.dart';
import 'package:poke_app/widgets/element_chip.dart';
import 'package:poke_app/widgets/measurement_card.dart';
import 'package:poke_app/providers/favorites_provider.dart';
import 'package:poke_app/widgets/custom_bottom_navigation.dart';

class PokemonDetail extends ConsumerStatefulWidget {
  const PokemonDetail({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  ConsumerState<PokemonDetail> createState() => _PokemonDetailState();
}

class _PokemonDetailState extends ConsumerState<PokemonDetail>
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

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header con imagen
              SizedBox(
                height: 260,
                child: Stack(
                  children: [
                    // Fondo decorativo con circulo recortado
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: ClipPath(
                        clipper: CircleClipper(),
                        child: Container(
                          height: 350,
                          width: double.infinity,
                          color: backgroundColor,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
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
                              width: 180,
                              height: 180,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.network(
                          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${widget.pokemon.id}.png',
                          height: 200,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_not_supported,
                              size: 160,
                              color: Colors.white,
                            );
                          },
                        ),
                      ],
                    ),
                    // Contenido
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Botones de arriba
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  context.pop();
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              GestureDetector(
                                onTap: _onFavoriteTap,
                                child: ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite
                                        ? Colors.redAccent
                                        : Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pokemon.nameCapitalizedFirstLetter(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'N°${widget.pokemon.idWithLeadingZeros()}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    Row(
                      children: widget.pokemon.types.map((type) {
                        return ElementChip(
                          color: PokemonTypeHelper.getTypeColor(type),
                          title: PokemonTypeHelper.getTypeLabel(type),
                          element: PokemonTypeHelper.getTypeAsset(type),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Tiene una semilla de planta en la espalda\ndesde que nace. La semilla crece lentamente.',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Divider(),
                    Row(
                      children: const [
                        Expanded(
                          child: MeasurementCard(
                            assetName: 'assets/svg/weight-hanging.svg',
                            label: 'PESO',
                            value: '6,9 kg',
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: MeasurementCard(
                            assetName: 'assets/svg/column-height-outlined.svg',
                            label: 'ALTURA',
                            value: '0,7 m',
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        MeasurementCard(
                          assetName: 'assets/svg/category.svg',
                          label: 'CATEGORÍA',
                          value: 'SEMILLA',
                        ),
                        SizedBox(width: 16),
                        MeasurementCard(
                          assetName: 'assets/svg/pokeball_2.svg',
                          label: 'HABILIDAD',
                          value: 'ESPESURA',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Debilidades',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElementChip(
                          color: PokemonTypeHelper.getTypeColor('fire'),
                          title: 'Fuego',
                          element: PokemonTypeHelper.getTypeAsset('fire'),
                        ),
                        ElementChip(
                          color: PokemonTypeHelper.getTypeColor('psychic'),
                          title: 'Psíquico',
                          element: PokemonTypeHelper.getTypeAsset('psychic'),
                        ),
                        ElementChip(
                          color: PokemonTypeHelper.getTypeColor('electric'),
                          title: 'Hielo',
                          element: PokemonTypeHelper.getTypeAsset('electric'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}
