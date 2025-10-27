import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/colors.dart';
import 'package:poke_app/models/pokemon.dart';
import 'package:poke_app/widgets/custom_bottom_navigation.dart';

class PokemonDetail extends StatelessWidget {
  const PokemonDetail({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header con imagen
              SizedBox(
                height: 380,
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
                          height: 280,
                          width: double.infinity,
                          color: grassPrimary,
                        ),
                      ),
                    ),
                    Center(
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
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: Image.network(
                        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            size: 200,
                            color: Colors.white,
                          );
                        },
                      ),
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
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: const Icon(
                                  Icons.favorite_border,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),

                          // Imagen del Pokémon
                        ],
                      ),
                    ),
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

class CircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    // Creates a path with an oval that fills the given size
    path.addArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, 0),
        radius: size.width / 1.5,
      ),
      0,
      2 * 3.14159265358979323846,
    );
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
