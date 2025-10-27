// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pokedex App';

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

  @override
  String get searchPokemon => 'Search Pokémon...';

  @override
  String get noResultsFound => 'No Pokémon found';

  @override
  String get tryAnotherSearch => 'Try another name or number';

  @override
  String resultsFound(int count) {
    return '$count results found';
  }

  @override
  String get clearFilter => 'Clear filter';

  @override
  String get filterByPreferences => 'Filter by your preferences';

  @override
  String get type => 'Type';

  @override
  String get apply => 'Apply';

  @override
  String get cancel => 'Cancel';

  @override
  String get favorites => 'Favorites';

  @override
  String get delete => 'Delete';

  @override
  String get confirmDelete => 'Confirm deletion';

  @override
  String confirmDeleteMessage(String name) {
    return 'Do you want to remove $name from your favorites?';
  }
}
