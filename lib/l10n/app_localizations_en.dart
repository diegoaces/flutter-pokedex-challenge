// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'PokeApp';

  @override
  String get onboardingTitle1 => 'All Pokémon in \n one place';

  @override
  String get onboardingTitle2 => 'Keep your Pokédex \n up to date';

  @override
  String get onboardingSubtitle1 =>
      'Access a wide list of Pokémon from \n all generations created by \n Nintendo';

  @override
  String get onboardingSubtitle2 =>
      'Sign up and save your profile, favorite \n Pokémon, settings and much more in the \n app';

  @override
  String get continueButton => 'Continue';

  @override
  String get letsStartButton => 'Let\'s Start';

  @override
  String get favoritesEmptyTitle =>
      'You haven\'t marked any \nPokémon as favorite';

  @override
  String get favoritesEmptySubtitle =>
      'Click on the heart icon of your \nfavorite Pokémon and they will appear here.';
}
