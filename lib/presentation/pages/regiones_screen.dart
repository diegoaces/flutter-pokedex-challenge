import 'package:flutter/material.dart';
import 'package:poke_app/presentation/widgets/custom_bottom_navigation.dart';

class RegionesScreen extends StatelessWidget {
  const RegionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigation(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/png/regiones.png',
                  width: 215,
                  height: 215,
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '¡Muy pronto disponible!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Estamos trabajando para traerte esta sección. Vuelve más adelante para descubrir todas las novedades.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            
          ],
        ),
      ),
    );
  }
}
