import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poke_app/core/constants.dart';

enum AppStartupState {
  splash,
  onboarding,
}

class AppStartupNotifier extends Notifier<AppStartupState> {
  @override
  AppStartupState build() {
    _initialize();
    return AppStartupState.splash;
  }

  Future<void> _initialize() async {
    // Wait for splash screen duration before transitioning
    await Future.delayed(AppConstants.splashScreenDuration);
    state = AppStartupState.onboarding;
  }
}

final appStartupProvider =
    NotifierProvider<AppStartupNotifier, AppStartupState>(
  AppStartupNotifier.new,
);
