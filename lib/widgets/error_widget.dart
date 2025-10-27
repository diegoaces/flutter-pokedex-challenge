import 'package:flutter/material.dart';
import 'package:poke_app/colors.dart';
import 'package:poke_app/core/constants.dart';

class PokedexErrorWidget extends StatelessWidget {
  const PokedexErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/png/magikarp.png', width: 215, height: 215),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Algo salió mal...',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'No pudimos cargar la información en este \nmomento. Verifica tu conexión o intenta nuevamente más tarde.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.defaultBorderRadius,
                        ),
                      ),
                      backgroundColor: primaryDefault,
                      elevation: 2,
                    ),
                    onPressed: () {
                      // Navigate to the next page or perform an action
                    },
                    child: Text(
                      "Reintentar",
                      style: const TextStyle(
                        fontSize: AppConstants.buttonFontSize,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
