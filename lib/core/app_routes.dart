class AppRoutes {
  AppRoutes._();
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String pokedex = '/pokedex';
  static const String regiones = '/regiones';
  static const String favoritos = '/favoritos';
  static const String profile = '/profile';
  static const String pokemonDetail = '/pokemon/:id';

  static String pokemonDetailPath(int id) => '/pokemon/$id';
}
