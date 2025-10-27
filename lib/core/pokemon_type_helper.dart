import 'package:flutter/material.dart';
import 'package:poke_app/colors.dart';

class PokemonTypeHelper {
  PokemonTypeHelper._();

  static Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return grassPrimary;
      case 'poison':
        return poisonPrimary;
      case 'fire':
        return const Color(0xFFF44336);
      case 'water':
        return const Color(0xFF2196F3);
      case 'bug':
        return const Color(0xFF8BC34A);
      case 'normal':
        return const Color(0xFF9E9E9E);
      case 'electric':
        return const Color(0xFFFFC107);
      case 'ground':
        return const Color(0xFF795548);
      case 'fairy':
        return const Color(0xFFE91E63);
      case 'fighting':
        return const Color(0xFFFF5722);
      case 'psychic':
        return const Color(0xFF9C27B0);
      case 'rock':
        return const Color(0xFF607D8B);
      case 'ghost':
        return const Color(0xFF673AB7);
      case 'ice':
        return const Color(0xFF00BCD4);
      case 'dragon':
        return const Color(0xFF3F51B5);
      case 'dark':
        return const Color(0xFF424242);
      case 'steel':
        return const Color(0xFF9E9E9E);
      case 'flying':
        return const Color(0xFF03A9F4);
      default:
        return Colors.grey;
    }
  }

  static String getTypeAsset(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return 'assets/svg/grass.svg';
      case 'poison':
        return 'assets/svg/poison.svg';
      case 'water':
        return 'assets/svg/water.svg';
      case 'fire':
        return 'assets/svg/fire.svg';
      case 'bug':
        return 'assets/svg/bug.svg';
      case 'flying':
        return 'assets/svg/flying.svg';
      case 'normal':
        return 'assets/svg/normal.svg';
      default:
        return 'assets/svg/grass.svg';
    }
  }

  static String getTypeLabel(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return 'Planta';
      case 'poison':
        return 'Veneno';
      case 'fire':
        return 'Fuego';
      case 'water':
        return 'Agua';
      case 'bug':
        return 'Bicho';
      case 'normal':
        return 'Normal';
      case 'electric':
        return 'Eléctrico';
      case 'ground':
        return 'Tierra';
      case 'fairy':
        return 'Hada';
      case 'fighting':
        return 'Lucha';
      case 'psychic':
        return 'Psíquico';
      case 'rock':
        return 'Roca';
      case 'ghost':
        return 'Fantasma';
      case 'ice':
        return 'Hielo';
      case 'dragon':
        return 'Dragón';
      case 'dark':
        return 'Siniestro';
      case 'steel':
        return 'Acero';
      case 'flying':
        return 'Volador';
      default:
        return type;
    }
  }
}
