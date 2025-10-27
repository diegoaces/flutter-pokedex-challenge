// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Pokedex App';

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

  @override
  String get favoritesEmptyTitle =>
      'No has marcado ningún \nPokémon como favorito';

  @override
  String get favoritesEmptySubtitle =>
      'Haz clic en el ícono de corazón de tus \nPokémon favoritos y aparecerán aquí.';

  @override
  String get searchPokemon => 'Procurar Pokémon...';

  @override
  String get noResultsFound => 'No se encontraron Pokémon';

  @override
  String get tryAnotherSearch => 'Intenta con otro nombre o número';

  @override
  String resultsFound(int count) {
    return 'Se han encontrado $count resultados';
  }

  @override
  String get clearFilter => 'Borrar filtro';

  @override
  String get filterByPreferences => 'Filtra por tus preferencias';

  @override
  String get type => 'Tipo';

  @override
  String get apply => 'Aplicar';

  @override
  String get cancel => 'Cancelar';

  @override
  String get favorites => 'Favoritos';

  @override
  String get delete => 'Eliminar';

  @override
  String get confirmDelete => 'Confirmar eliminación';

  @override
  String confirmDeleteMessage(String name) {
    return '¿Deseas eliminar a $name de tus favoritos?';
  }
}
