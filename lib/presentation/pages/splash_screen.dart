import 'package:flutter/material.dart';
import 'package:poke_app/presentation/widgets/pokeball_loading.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: PokeballLoading()));
  }
}
