import 'package:flutter/material.dart';
import 'package:poke_app/widgets/pokeball_loading.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [PokeballLoading()],
        ),
      ),
    );
  }
}
