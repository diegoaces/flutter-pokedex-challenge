import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/core/constants.dart';

enum AppStartupState { splash, onboarding }

/// Notifier para gestionar el estado de inicio de la aplicación.
/// Comienza en la pantalla de splash y después de un tiempo definido,
/// cambia al estado de onboarding.
class AppStartupNotifier extends Notifier<AppStartupState> {
  @override
  AppStartupState build() {
    _initialize();
    return AppStartupState.splash;
  }

  Future<void> _initialize() async {
    await Future.delayed(AppConstants.splashScreenDuration);
    state = AppStartupState.onboarding;
  }
}

final appStartupProvider =
    NotifierProvider<AppStartupNotifier, AppStartupState>(
      AppStartupNotifier.new,
    );
