import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'PokeApp'**
  String get appTitle;

  /// Title of the first onboarding step
  ///
  /// In en, this message translates to:
  /// **'All Pokémon in \n one place'**
  String get onboardingTitle1;

  /// Title of the second onboarding step
  ///
  /// In en, this message translates to:
  /// **'Keep your Pokédex \n up to date'**
  String get onboardingTitle2;

  /// Subtitle of the first onboarding step
  ///
  /// In en, this message translates to:
  /// **'Access a wide list of Pokémon from \n all generations created by \n Nintendo'**
  String get onboardingSubtitle1;

  /// Subtitle of the second onboarding step
  ///
  /// In en, this message translates to:
  /// **'Sign up and save your profile, favorite \n Pokémon, settings and much more in the \n app'**
  String get onboardingSubtitle2;

  /// Continue button text
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Let's start button text
  ///
  /// In en, this message translates to:
  /// **'Let\'s Start'**
  String get letsStartButton;

  /// Title shown when favorites list is empty
  ///
  /// In en, this message translates to:
  /// **'You haven\'t marked any \nPokémon as favorite'**
  String get favoritesEmptyTitle;

  /// Subtitle shown when favorites list is empty
  ///
  /// In en, this message translates to:
  /// **'Click on the heart icon of your \nfavorite Pokémon and they will appear here.'**
  String get favoritesEmptySubtitle;

  /// Search field placeholder for Pokémon
  ///
  /// In en, this message translates to:
  /// **'Search Pokémon...'**
  String get searchPokemon;

  /// Message when there are no search results
  ///
  /// In en, this message translates to:
  /// **'No Pokémon found'**
  String get noResultsFound;

  /// Suggestion when there are no search results
  ///
  /// In en, this message translates to:
  /// **'Try another name or number'**
  String get tryAnotherSearch;

  /// Message with the number of results found
  ///
  /// In en, this message translates to:
  /// **'{count} results found'**
  String resultsFound(int count);

  /// Text for clear filter button
  ///
  /// In en, this message translates to:
  /// **'Clear filter'**
  String get clearFilter;

  /// Title of the filter modal
  ///
  /// In en, this message translates to:
  /// **'Filter by your preferences'**
  String get filterByPreferences;

  /// Type label in the filter modal
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get type;

  /// Apply button text
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Favorites screen title
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Deletion confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get confirmDelete;

  /// Favorite deletion confirmation message
  ///
  /// In en, this message translates to:
  /// **'Do you want to remove {name} from your favorites?'**
  String confirmDeleteMessage(String name);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
