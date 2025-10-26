import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/pages/pokedex_widget.dart';
import 'package:poke_app/widgets/custom_bottom_navigation.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(child: PokedexWidget()),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}
