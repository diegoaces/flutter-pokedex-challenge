# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**PokeApp** (flutter-pokedex-challenge) is a Flutter application (Flutter 3.32.4, Dart SDK ^3.8.1) showcasing best practices in Flutter development. This project features:

- Pokemon-themed onboarding experience with internationalization
- State management with **Riverpod** (^3.0.3)
- Reactive navigation with **GoRouter** (^16.3.0) + Riverpod integration
- **i18n support** for English and Spanish
- Custom animated SVG components (pokeball loading animations)
- Automatic splash screen navigation (2 seconds)
- Modular widget architecture with centralized constants
- Native splash screen support

## Architecture

### State Management Pattern
- **Riverpod** for reactive state management
- `AppStartupProvider` manages splash screen timing and navigation state
- Providers separated in `lib/providers/` directory
- Clean separation between UI and business logic

### Navigation Flow
1. App starts at `/splash`
2. `AppStartupProvider` waits `AppConstants.splashScreenDuration` (2 seconds)
3. State changes to `AppStartupState.onboarding`
4. `appRouterProvider` detects change and redirects to `/onboarding`
5. User navigates through Pokemon-themed onboarding steps

### Internationalization
- Supports English (`en`) and Spanish (`es`)
- Auto-detection of device language
- ARB files in `lib/l10n/` for translations
- Generated localizations in `.dart_tool/flutter_gen/gen_l10n/`
- Use: `AppLocalizations.of(context)!.textKey`

## Flutter Version Management

This project uses FVM (Flutter Version Manager) to lock the Flutter version:
- Flutter version: **3.32.4** (defined in `.fvmrc`)
- All Flutter commands should use the FVM-managed version: `fvm flutter <command>`

## Common Commands

### Setup and Dependencies
```bash
# Install dependencies
fvm flutter pub get

# Generate localization files
fvm flutter gen-l10n

# Generate native splash screen
fvm flutter pub run flutter_native_splash:create

# Update dependencies
fvm flutter pub upgrade
```

### Running the Application
```bash
# Run on default device
fvm flutter run

# Run on specific device
fvm flutter run -d <device_id>

# Run in release mode
fvm flutter run --release

# List available devices
fvm flutter devices
```

### Internationalization
```bash
# Generate localization files after editing ARB files
fvm flutter gen-l10n

# Files to edit:
# - lib/l10n/app_en.arb (English)
# - lib/l10n/app_es.arb (Spanish)
```

### Testing
```bash
# Run all tests
fvm flutter test

# Run a specific test file
fvm flutter test test/widget_test.dart

# Run tests with coverage
fvm flutter test --coverage
```

### Code Quality
```bash
# Analyze code for issues
fvm flutter analyze

# Format code
fvm flutter format .

# Format a specific file
fvm flutter format lib/main.dart
```

### Building
```bash
# Build for Android (APK)
fvm flutter build apk

# Build for Android (App Bundle)
fvm flutter build appbundle

# Build for iOS
fvm flutter build ios

# Build for macOS
fvm flutter build macos

# Build for web
fvm flutter build web
```

## Project Structure

### Core Files
- `lib/main.dart` - Application entry point with `ProviderScope` and `ConsumerWidget`
- `lib/app_router.dart` - GoRouter configuration with Riverpod integration
- `lib/colors.dart` - Color palette constants

### Architecture Folders
- `lib/core/` - Core application files
  - `constants.dart` - Centralized constants (durations, sizes, fonts, asset paths)

- `lib/providers/` - Riverpod providers
  - `app_startup_provider.dart` - Manages splash screen state and timing

- `lib/pages/` - Application screens
  - `splash_screen.dart` - Initial splash screen
  - `onboarding_page.dart` - Pokemon-themed onboarding with localization

- `lib/widgets/` - Reusable widgets
  - `pokeball_loading.dart` - Custom pokeball loading animation widget

- `lib/exts/` - Extensions and utilities
  - `animated_svg.dart` - Custom animated SVG widget implementation
  - `animated_svg_controller.dart` - Controller for SVG animations

- `lib/l10n/` - Localization files
  - `app_en.arb` - English translations
  - `app_es.arb` - Spanish translations

### Generated Files (not in version control)
- `.dart_tool/flutter_gen/gen_l10n/` - Generated localization classes
- `lib/l10n/app_localizations*.dart` - Auto-generated (ignored in .gitignore)

### Assets
- `assets/svg/` - SVG assets
  - `pokeball.svg` - Main pokeball asset
  - `pokeball1.svg` - Animation variant 1
  - `pokeball2.svg` - Animation variant 2
- `assets/png/` - PNG assets
  - `pokeball.png` - Native splash screen logo
  - `onboarding.png` - Onboarding screen image 1
  - `onboarding2.png` - Onboarding screen image 2

### Configuration
- `pubspec.yaml` - Project dependencies and configuration
- `l10n.yaml` - Localization configuration
- `analysis_options.yaml` - Dart analyzer configuration using `flutter_lints`
- `.fvmrc` - FVM Flutter version lock file
- `.gitignore` - Git ignore rules for Flutter project
- `test/` - Widget and unit tests
- `android/`, `ios/`, `macos/`, `web/` - Platform-specific configurations

## Key Dependencies

### Production
- **flutter_svg** (^2.2.1) - SVG rendering and animations
- **go_router** (^16.3.0) - Declarative navigation and routing
- **flutter_riverpod** (^3.0.3) - Reactive state management
- **flutter_native_splash** (^2.4.7) - Native splash screen
- **intl** (^0.20.2) - Internationalization and formatting
- **flutter_localizations** (SDK) - Flutter localizations
- **cupertino_icons** (^1.0.8) - iOS-style icons

### Development
- **flutter_lints** (^5.0.0) - Linting rules for code quality

## Development Guidelines

### Code Style
- Follow Flutter/Dart best practices as defined by `flutter_lints`
- Use meaningful variable and function names
- Add comments for complex logic
- Keep widgets small and focused on a single responsibility
- Use `const` constructors whenever possible
- Centralize constants in `AppConstants` class

### State Management with Riverpod
- Use `ConsumerWidget` or `Consumer` when accessing providers
- Separate business logic into providers
- Use `ref.watch()` for reactive dependencies
- Use `ref.read()` for one-time reads
- Use `ref.listen()` for side effects

Example:
```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    return Text(state.toString());
  }
}
```

### Widget Development
- Prefer `StatelessWidget` when state management is not needed
- Use `ConsumerWidget` when you need access to providers
- Extract reusable widgets into separate files in `lib/widgets/`
- Use `AppConstants` for hardcoded values (sizes, durations, etc.)

### Navigation
- All routes defined in `lib/app_router.dart`
- Use `context.go('/path')` for navigation
- Router is reactive and responds to provider changes
- Custom page transitions using `CustomTransitionPage`

### Internationalization
- All user-facing strings must be in ARB files
- Never hardcode strings in widgets
- Use descriptive keys: `onboardingTitle1`, not `title1`
- Always provide `@description` in ARB files
- Run `fvm flutter gen-l10n` after editing ARB files

Example:
```dart
// lib/l10n/app_en.arb
{
  "welcomeMessage": "Welcome to PokeApp",
  "@welcomeMessage": {
    "description": "Welcome message shown on first launch"
  }
}

// Usage in code
Text(AppLocalizations.of(context)!.welcomeMessage)
```

### Constants Management
- All constants in `lib/core/constants.dart`
- Use `AppConstants.constantName` in code
- Categories: timing, UI, animations, typography, assets
- Update constants instead of changing hardcoded values

Example:
```dart
// Use this:
Duration(seconds: 2) // ❌
AppConstants.splashScreenDuration // ✅

// Use this:
fontSize: 26.0 // ❌
fontSize: AppConstants.titleFontSize // ✅
```

### Animation Best Practices
- Use controllers for complex animations (see `animated_svg_controller.dart`)
- Dispose of animation controllers properly to prevent memory leaks
- Use `AppConstants` for animation durations
- Consider performance implications of frequent redraws

### Asset Management
- All assets must be declared in `pubspec.yaml` under `assets:` section
- Use SVG format for scalable graphics (pokeball animations)
- Use PNG/JPG for raster images (onboarding screens)
- Reference assets via `AppConstants` for centralized management

## Important Files to Understand

### Entry Point Flow
1. `lib/main.dart` - Wraps app in `ProviderScope`, uses `appRouterProvider`
2. `lib/app_router.dart` - Defines routes and redirect logic based on `appStartupProvider`
3. `lib/providers/app_startup_provider.dart` - Manages splash timing and state transitions

### Localization Flow
1. Edit `lib/l10n/app_en.arb` and `lib/l10n/app_es.arb`
2. Run `fvm flutter gen-l10n`
3. Generated files appear in `.dart_tool/flutter_gen/gen_l10n/`
4. Import and use: `AppLocalizations.of(context)!.textKey`

## Troubleshooting

### Common Issues

1. **FVM not found**:
   ```bash
   dart pub global activate fvm
   ```

2. **Flutter version mismatch**:
   ```bash
   fvm install 3.32.4
   fvm use 3.32.4
   ```

3. **Dependencies not found**:
   ```bash
   fvm flutter pub get
   ```

4. **Localization files not generated**:
   ```bash
   fvm flutter gen-l10n
   ```
   - Check `l10n.yaml` configuration
   - Ensure ARB files are valid JSON
   - Generated files should not be committed (in .gitignore)

5. **Provider not found errors**:
   - Ensure `ProviderScope` wraps the app in `main.dart`
   - Check provider is imported correctly
   - Verify using `ConsumerWidget` or `Consumer`

6. **SVG not rendering**:
   - Ensure asset path is correct in `pubspec.yaml`
   - Verify file exists in `assets/svg/`
   - Run `fvm flutter pub get` after adding assets

7. **Navigation not working**:
   - Check `appRouterProvider` is used in `MaterialApp.router`
   - Verify route paths in `app_router.dart`
   - Ensure `ref.watch(appRouterProvider)` is used

8. **Splash screen doesn't redirect**:
   - Check `AppStartupProvider` is working
   - Verify `AppConstants.splashScreenDuration`
   - Check router `redirect` logic in `app_router.dart`

## Testing Notes

- Widget tests should use `ProviderScope` wrapper
- Mock providers when testing components
- Test localization by changing device locale
- Test navigation flows with provider state changes

## Performance Considerations

- Use `const` constructors extensively
- Minimize provider rebuilds with proper scoping
- Optimize SVG animations for smooth 60fps
- Use `RepaintBoundary` for complex animations if needed

## Git Workflow

This project uses a comprehensive `.gitignore`:
- Generated files are excluded (localization, build artifacts)
- FVM cache is ignored
- Platform-specific build files are ignored
- Keep ARB files, constants, and source code in version control
