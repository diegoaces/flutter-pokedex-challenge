/// Application-wide constants
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // API constants
  static const String apiBaseUrl = 'https://pokeapi.co/api/v2';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Timing constants
  static const Duration splashScreenDuration = Duration(seconds: 2);
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // UI constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 24.0;
  static const double imageWidth = 342.0;
  static const double imageHeight = 265.0;

  // Animation constants
  static const int indicatorWidth = 28;
  static const int indicatorHeight = 9;
  static const int indicatorWidthSmall = 9;
  static const double indicatorBorderRadius = 11.0;
  static const double indicatorSpacing = 8.0;

  // Font sizes
  static const double titleFontSize = 26.0;
  static const double subtitleFontSize = 14.0;
  static const double buttonFontSize = 16.0;

  // Assets paths
  static const String onboardingImage1 = 'assets/png/onboarding.png';
  static const String onboardingImage2 = 'assets/png/onboarding2.png';
  static const String pokeballSvg = 'assets/svg/pokeball.svg';
  static const String pokeball1Svg = 'assets/svg/pokeball1.svg';
  static const String pokeball2Svg = 'assets/svg/pokeball2.svg';

  // Font family
  static const String fontFamily = 'Poppins';
}
