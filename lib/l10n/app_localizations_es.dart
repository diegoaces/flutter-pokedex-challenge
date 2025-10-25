// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'PokeApp';

  @override
  String get onboardingTitle1 => 'Todos los Pokémon en \n un solo lugar';

  @override
  String get onboardingTitle2 => 'Mantén tu Pokédex \n actualizada';

  @override
  String get onboardingSubtitle1 =>
      'Accede a una amplia lista de Pokémon de \n todas las generaciones creadas por \n Nintendo';

  @override
  String get onboardingSubtitle2 =>
      'Registrate y guarda tu perfil, Pokémon \n favoritos, configuraciones y mucho más en la \n aplicación';

  @override
  String get continueButton => 'Continuar';

  @override
  String get letsStartButton => 'Empecemos';
}
