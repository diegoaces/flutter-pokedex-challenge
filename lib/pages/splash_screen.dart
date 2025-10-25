import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poke_app/widgets/pokeball_loading.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _navigateAfterDelay(BuildContext context) {
    Timer(const Duration(seconds: 2), () {
      context.go('/onboarding');
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigateAfterDelay(context);
    });

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
