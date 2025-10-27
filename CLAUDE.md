# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Pokedex App** (poke_app) is a comprehensive Flutter application (Flutter 3.32.4, Dart SDK ^3.8.1) showcasing best practices in Flutter development. This is a fully-featured Pokedex app with PokeAPI integration. Key features include:

- **Full Pokedex** with PokeAPI integration (https://pokeapi.co/api/v2/)
- **Favorites system** with in-memory persistence
- **Real-time search** by Pokemon name or ID
- **Type filtering** with multi-select modal (18 Pokemon types)
- **Dynamic UI** with type-based colors and assets
- **Pokemon detail screen** with complete information and adaptive UI
- **Smooth animations** with ScaleTransition on favorite buttons
- **Swipe-to-delete** favorites with flutter_slidable
- Pokemon-themed onboarding experience with internationalization
- State management with **Riverpod** (^3.0.3) using @riverpod annotations
- Reactive navigation with **GoRouter** (^16.3.0) + Riverpod integration
- **i18n support** for English and Spanish with dynamic placeholders
- Custom animated SVG components (pokeball loading animations)
- Automatic splash screen navigation (2 seconds)
- Modular widget architecture with centralized constants
- Native splash screen support
- Clean architecture with **Freezed** (^3.2.3) and **json_serializable** (^6.8.0)
- Centralized theme with **Google Fonts** (^6.3.2) - Poppins
- HTTP client with **Dio** (^5.9.0)

## Architecture

### State Management Pattern
- **Riverpod** for reactive state management with code generation
- **@riverpod annotations** for auto-generated providers (not manual providers)
- **Notifier pattern** for stateful logic (e.g., FavoritesNotifier) - StateNotifier is deprecated
- **Provider.family** for parameterized providers (e.g., isFavoriteProvider)
- `AppStartupProvider` manages splash screen timing and navigation state
- `pokemonProvider` handles PokeAPI integration with Dio
- `favoritesProvider` manages favorites state with Map<int, Pokemon>
- `dioProvider` provides configured Dio instance
- Providers separated in `lib/providers/` directory with *.g.dart generated files
- Clean separation between UI and business logic

### Navigation Flow
1. App starts at `/splash`
2. `AppStartupProvider` waits `AppConstants.splashScreenDuration` (2 seconds)
3. State changes to `AppStartupState.onboarding`
4. `appRouterProvider` detects change and redirects to `/onboarding`
5. User completes onboarding → navigates to Home with bottom navigation
6. Home screen has 4 tabs:
   - `/pokedex` - Main Pokedex with search and filters
   - `/favorites` - Favorite Pokemon list with swipe-to-delete
   - `/regiones` - Regions screen
   - `/profile` - Profile screen
7. From Pokedex or Favorites, user can tap Pokemon to navigate to `/pokemon/:id` detail screen

### Internationalization
- Supports English (`en`) and Spanish (`es`)
- Auto-detection of device language
- ARB files in `lib/l10n/` for translations (app_en.arb, app_es.arb)
- Generated localizations in `lib/l10n/` (app_localizations*.dart)
- **Dynamic placeholders** for runtime values (e.g., resultsFound(count), confirmDeleteMessage(name))
- Use: `AppLocalizations.of(context)!.textKey` or `final l10n = AppLocalizations.of(context)!`
- All user-facing strings are localized including:
  - Search and filter UI
  - Favorite actions and confirmations
  - Empty states
  - Pokemon type names
  - Button labels

## Flutter Version Management

This project uses FVM (Flutter Version Manager) to lock the Flutter version:
- Flutter version: **3.32.4** (defined in `.fvmrc`)
- All Flutter commands should use the FVM-managed version: `fvm flutter <command>`

## Common Commands

### Setup and Dependencies
```bash
# Install dependencies
fvm flutter pub get

# Generate code (Freezed, Riverpod, json_serializable)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Generate code in watch mode (auto-regenerate on file changes)
fvm flutter pub run build_runner watch --delete-conflicting-outputs

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
  - `constants.dart` - Centralized constants (durations, sizes, fonts, asset paths, API base URL)
  - `app_routes.dart` - Route path constants
  - `app_theme.dart` - Centralized theme configuration with Google Fonts
  - `pokemon_type_helper.dart` - Helper for Pokemon type colors, assets, and labels
  - `api_exception.dart` - Custom exception for API errors
  - `extensions.dart` - Dart extensions (currently empty)

- `lib/models/` - Data models (Freezed + json_serializable)
  - `pokemon.dart` - Pokemon model with id, name, types
  - `pokemon.freezed.dart` - Auto-generated Freezed code
  - `pokemon.g.dart` - Auto-generated JSON serialization
  - `pokemon_list_response.dart` - PokeAPI list response model
  - `pokemon_list_response.freezed.dart` - Auto-generated Freezed code
  - `pokemon_list_response.g.dart` - Auto-generated JSON serialization

- `lib/providers/` - Riverpod providers
  - `app_startup_provider.dart` - Manages splash screen state and timing
  - `dio_provider.dart` - Provides configured Dio HTTP client (@riverpod)
  - `dio_provider.g.dart` - Auto-generated Riverpod code
  - `pokemon_provider.dart` - Fetches Pokemon list from PokeAPI (@riverpod)
  - `pokemon_provider.g.dart` - Auto-generated Riverpod code
  - `favorites_provider.dart` - Manages favorites with NotifierProvider

- `lib/pages/` - Application screens
  - `splash_screen.dart` - Initial splash screen
  - `onboarding_screen.dart` - Pokemon-themed onboarding with localization
  - `pokedex_screen.dart` - Main Pokedex screen (uses PokedexWidget)
  - `pokedex_widget.dart` - Pokedex list with search and filter functionality
  - `pokemon_list_tile.dart` - Individual Pokemon tile in list
  - `pokemon_detail.dart` - Pokemon detail screen with full information
  - `favorites_screen.dart` - Favorites list with swipe-to-delete
  - `regiones_screen.dart` - Regions screen
  - `profile_screen.dart` - Profile screen
  - `element_chip.dart` - Pokemon type chip widget
  - `measurement_card.dart` - Card for displaying measurements (height, weight)
  - `circle_clipper.dart` - Custom clipper for circular shapes

- `lib/widgets/` - Reusable widgets
  - `pokeball_loading.dart` - Custom pokeball loading animation widget
  - `custom_bottom_navigation.dart` - Custom bottom navigation bar
  - `custom_default_button.dart` - Reusable button widget
  - `filter_preferences_modal.dart` - Modal for filtering by Pokemon types
  - `pokemon_search_bar.dart` - Search bar with clear button
  - `error_widget.dart` - Custom error display widget

- `lib/l10n/` - Localization files
  - `app_en.arb` - English translations
  - `app_es.arb` - Spanish translations
  - `app_localizations.dart` - Generated localization class
  - `app_localizations_en.dart` - Generated English localizations
  - `app_localizations_es.dart` - Generated Spanish localizations

### Generated Files (must regenerate with build_runner)
- `lib/models/*.freezed.dart` - Freezed-generated model code
- `lib/models/*.g.dart` - json_serializable code
- `lib/providers/*.g.dart` - Riverpod generator code
- `lib/l10n/app_localizations*.dart` - Generated localization classes (committed to repo)

### Assets
- `assets/svg/` - SVG assets
  - `pokeball.svg`, `pokeball1.svg`, `pokeball2.svg`, `pokeball_2.svg` - Pokeball assets
  - **Type icons**: `grass.svg`, `poison.svg`, `water.svg`, `fire.svg`, `bug.svg`, `flying.svg`, `normal.svg`
  - **UI icons**: `heart.svg`, `globe.svg`, `home.svg`, `user.svg`, `fav.svg`, `fav_solid.svg`, `search.svg`
  - **Measurement icons**: `weight-hanging.svg`, `category.svg`, `column-height-outlined.svg`
  - **Pokemon sprites**: `magikarp.svg`

- `assets/png/` - PNG assets
  - `pokeball.png` - Native splash screen logo
  - `onboarding.png`, `onboarding2.png` - Onboarding images
  - `magikarp.png` - Empty state image
  - `pokemon1.png` - Sample Pokemon image
  - `regiones.png` - Regions screen image
  - `trash.png` - Delete action icon

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
- **riverpod_annotation** (^3.0.3) - Annotations for Riverpod code generation
- **dio** (^5.9.0) - HTTP client for REST APIs (PokeAPI integration)
- **freezed_annotation** (^3.1.0) - Annotations for immutable models
- **json_annotation** (^4.9.0) - Annotations for JSON serialization
- **flutter_slidable** (^3.1.1) - Swipeable list items
- **google_fonts** (^6.3.2) - Google Fonts integration (Poppins)
- **flutter_native_splash** (^2.4.7) - Native splash screen
- **flutter_launcher_icons** (^0.14.4) - App icon generation
- **intl** (^0.20.2) - Internationalization and formatting
- **flutter_localizations** (SDK) - Flutter localizations
- **cupertino_icons** (^1.0.8) - iOS-style icons

### Development
- **flutter_lints** (^5.0.0) - Linting rules for code quality
- **build_runner** (^2.7.1) - Code generation tool
- **freezed** (^3.2.3) - Code generator for immutable models
- **json_serializable** (^6.8.0) - Code generator for JSON serialization
- **riverpod_generator** (^3.0.3) - Code generator for Riverpod providers
- **riverpod_lint** (^3.0.3) - Additional linting for Riverpod
- **custom_lint** (^0.8.0) - Custom linting framework

## Development Guidelines

### Code Style
- Follow Flutter/Dart best practices as defined by `flutter_lints`
- Use meaningful variable and function names
- Add comments for complex logic
- Keep widgets small and focused on a single responsibility
- Use `const` constructors whenever possible
- Centralize constants in `AppConstants` class

### State Management with Riverpod
- Use **@riverpod** annotations for providers (auto-generated with build_runner)
- Use `ConsumerWidget` or `ConsumerStatefulWidget` when accessing providers
- Use **Notifier** pattern for stateful logic (NOT StateNotifier which is deprecated)
- Separate business logic into providers
- Use `ref.watch()` for reactive dependencies
- Use `ref.read()` for one-time reads in callbacks
- Use `ref.listen()` for side effects (e.g., router.refresh())
- Use `Provider.family` for parameterized providers

Example with @riverpod annotation:
```dart
@riverpod
Future<List<Pokemon>> pokemonList(Ref ref) async {
  final dio = ref.watch(dioProvider);
  // Fetch data from API...
  return pokemons;
}

// Usage in widget
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPokemons = ref.watch(pokemonListProvider);
    return asyncPokemons.when(
      data: (pokemons) => ListView(...),
      loading: () => PokeballLoading(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}
```

Example with Notifier:
```dart
final favoritesProvider = NotifierProvider<FavoritesNotifier, Map<int, Pokemon>>(
  () => FavoritesNotifier()
);

class FavoritesNotifier extends Notifier<Map<int, Pokemon>> {
  @override
  Map<int, Pokemon> build() => {};

  void toggleFavorite(Pokemon pokemon) {
    final favorites = {...state};
    if (favorites.containsKey(pokemon.id)) {
      favorites.remove(pokemon.id);
    } else {
      favorites[pokemon.id] = pokemon;
    }
    state = favorites;
  }
}
```

### Widget Development
- Prefer `StatelessWidget` when no state management or providers needed
- Use `ConsumerWidget` when you need access to providers
- Use `ConsumerStatefulWidget` when you need both local state and providers
- Extract reusable widgets into separate files in `lib/widgets/`
- Use `AppConstants` for hardcoded values (sizes, durations, etc.)
- Keep page-specific widgets in `lib/pages/` if they're not reusable
- Use `const` constructors aggressively for performance

### Navigation
- All routes defined in `lib/app_router.dart`
- Route paths as constants in `lib/core/app_routes.dart`
- Use `context.go('/path')` for navigation (GoRouter extension)
- Use `context.go(AppRoutes.pokedex)` with constants
- Router is reactive and responds to provider changes via `ref.listen()`
- Custom page transitions using `CustomTransitionPage` with FadeTransition
- Bottom navigation uses GoRouter's shell routes
- Pass parameters in routes like `/pokemon/:id` and access with `state.pathParameters['id']`

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
- Use SVG format for scalable graphics (type icons, UI icons)
- Use PNG/JPG for raster images (onboarding, empty states)
- Reference assets via helper methods (e.g., `PokemonTypeHelper.getTypeAsset()`)
- Use `flutter_svg` package for rendering SVGs
- Dynamic asset selection based on Pokemon type

### API Integration with PokeAPI
- Base URL configured in `AppConstants.apiBaseUrl`: `'https://pokeapi.co/api/v2/'`
- Dio provider configured with base URL and 30-second timeout
- Fetch Pokemon list from `/pokemon?limit=20`
- For each Pokemon, fetch details from `/pokemon/{id}` to get types
- Use `Future.wait()` to fetch details in parallel
- Parse responses using json_serializable models
- Handle errors with try-catch and `ApiException`

### Models with Freezed
- Use `@freezed` annotation for immutable data models
- Include `const` constructor with private constructor for methods
- Add custom methods in model class (e.g., `nameCapitalizedFirstLetter()`)
- Use `@Default([])` for default values
- Generate code with `build_runner`

Example:
```dart
@freezed
class Pokemon with _$Pokemon {
  const Pokemon._();

  const factory Pokemon({
    required int id,
    required String name,
    @Default([]) List<String> types,
  }) = _Pokemon;

  factory Pokemon.fromJson(Map<String, dynamic> json) => _$PokemonFromJson(json);

  String nameCapitalizedFirstLetter() {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }
}
```

## Important Files to Understand

### Entry Point Flow
1. `lib/main.dart` - Wraps app in `ProviderScope`, uses `appRouterProvider`
2. `lib/app_router.dart` - Defines routes and redirect logic based on `appStartupProvider`
3. `lib/providers/app_startup_provider.dart` - Manages splash timing and state transitions
4. `lib/core/app_theme.dart` - Centralized theme with Google Fonts (Poppins)
5. `lib/core/constants.dart` - All app constants including API base URL

### Data Flow
1. `lib/providers/dio_provider.dart` - Provides configured Dio HTTP client
2. `lib/providers/pokemon_provider.dart` - Fetches Pokemon from PokeAPI using Dio
3. `lib/models/pokemon.dart` - Pokemon data model (Freezed)
4. `lib/pages/pokedex_widget.dart` - Displays Pokemon list with search and filters
5. `lib/providers/favorites_provider.dart` - Manages favorite Pokemon state
6. `lib/pages/pokemon_detail.dart` - Displays Pokemon details

### Localization Flow
1. Edit `lib/l10n/app_en.arb` and `lib/l10n/app_es.arb`
2. Run `fvm flutter gen-l10n`
3. Generated files appear in `lib/l10n/` (app_localizations*.dart)
4. Import and use: `AppLocalizations.of(context)!.textKey`
5. For dynamic text use placeholders: `l10n.resultsFound(count)`

### Code Generation Flow
1. Add `@freezed` annotation to model in `lib/models/`
2. Add `@riverpod` annotation to provider function
3. Run `fvm flutter pub run build_runner build --delete-conflicting-outputs`
4. Generated files: `*.freezed.dart`, `*.g.dart`
5. Import generated code and use in your app

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
   - Generated files ARE committed to repo (in lib/l10n/)

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

9. **Code generation not working (Freezed/Riverpod)**:
   ```bash
   fvm flutter clean
   fvm flutter pub get
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```
   - Ensure annotations are correct (@freezed, @riverpod)
   - Check for import errors
   - Delete *.g.dart and *.freezed.dart files and regenerate

10. **Pokemon not loading from API**:
   - Check internet connection
   - Verify PokeAPI is accessible: https://pokeapi.co/api/v2/pokemon
   - Check Dio configuration in `dio_provider.dart`
   - Review console logs for API errors
   - Ensure `AppConstants.apiBaseUrl` has trailing slash

11. **Favorites not persisting**:
   - Favorites are stored in-memory only (Map<int, Pokemon>)
   - Data will be lost when app restarts
   - This is intentional for this demo app
   - To persist, implement shared_preferences or local database

## Testing Notes

- Widget tests should use `ProviderScope` wrapper
- Mock providers when testing components
- Test localization by changing device locale
- Test navigation flows with provider state changes
- Test favorites system (add, remove, toggle)
- Test search and filter functionality
- Test API error handling

## Performance Considerations

- Use `const` constructors extensively
- Minimize provider rebuilds with proper scoping
- Optimize SVG animations for smooth 60fps
- Use `RepaintBoundary` for complex animations if needed
- Use `ListView.builder` for long lists (lazy loading)
- Use `Future.wait()` for parallel API calls
- Cache images with Flutter's image cache
- Avoid rebuilding entire widget tree unnecessarily

## Key Features Implemented

### 1. PokeAPI Integration
- Fetches first 20 Pokemon from PokeAPI
- Parallel fetching of Pokemon details (types) using `Future.wait()`
- Dio HTTP client with 30-second timeout
- Error handling with `ApiException`

### 2. Search Functionality
- Real-time search as user types
- Filter by Pokemon name (case-insensitive)
- Filter by Pokemon ID
- Clear button (X) when search has text
- Empty state when no results found

### 3. Type Filtering
- Modal with 18 Pokemon types
- Multi-select type chips
- Combine with text search
- Results counter
- Clear filters button
- Dynamic UI with type colors

### 4. Favorites System
- Add/remove Pokemon to favorites
- Persistent state during app session (in-memory)
- Dedicated favorites screen
- Swipe-to-delete with flutter_slidable
- Animated favorite button with ScaleTransition
- Synchronization between list and detail views
- Visual indicator (red heart) when Pokemon is favorite

### 5. Dynamic UI by Type
- 18 unique colors for Pokemon types
- SVG icons for each type
- Type-based background colors in tiles
- Type chips with appropriate colors
- Localized type names (English/Spanish)

### 6. Pokemon Detail Screen
- Colorful header with type color
- Giant type icon with gradient
- Official Pokemon sprite from PokeAPI
- Back and favorite action buttons with animations
- Pokemon info: name, number, types
- White card design for content
- Bottom navigation for quick access

### 7. Animations
- ScaleTransition on favorite button (1.0x → 1.3x → 1.0x)
- FadeTransition for page transitions
- Pokeball loading animation
- Slidable animation for delete action
- Smooth navigation transitions

## Git Workflow

This project uses a comprehensive `.gitignore`:
- Build artifacts are excluded
- FVM cache is ignored
- Platform-specific build files are ignored
- Generated code IS committed (*.g.dart, *.freezed.dart, localization files)
- Keep ARB files, constants, and source code in version control

## Additional Notes for Claude Code

- This is a **complete, working Pokedex app** with all core features implemented
- The app follows **Flutter best practices** and **Clean Architecture principles** ✅
- All API integration is functional and tested
- All UI screens are implemented and navigable
- Internationalization is complete for English and Spanish
- The codebase is production-ready with proper error handling
- When making changes, always run `build_runner` after modifying models or providers
- When adding new strings, update both ARB files and regenerate localizations
- The Pokemon type system is extensible - add new types in `PokemonTypeHelper`
- Bottom navigation uses 4 tabs but only Pokedex and Favorites are fully functional

### ✅ Clean Architecture Implementation (NEW)

The project now has a **complete Clean Architecture implementation** with:

**Domain Layer** (`lib/domain/`):
- ✅ `core/result.dart` - Result<T> type for functional error handling
- ✅ `entities/pokemon_entity.dart` - Pure domain entity with business methods
- ✅ `failures/pokemon_failure.dart` - 7 types of domain failures (sealed classes)
- ✅ `repositories/pokemon_repository.dart` - Abstract repository interface
- ✅ `usecases/get_pokemon_list.dart` - Use case with input validation

**Data Layer** (`lib/data/`):
- ✅ `datasources/pokemon_remote_datasource.dart` - DataSource interface
- ✅ `datasources/pokemon_remote_datasource_impl.dart` - Dio implementation
- ✅ `exceptions/data_exceptions.dart` - 6 types of data exceptions
- ✅ `models/` - Complete DTOs with Freezed + json_serializable
- ✅ `mappers/pokemon_mapper.dart` - Bidirectional DTO ↔ Entity mapping
- ✅ `repositories/pokemon_repository_impl.dart` - Repository implementation

**Presentation Layer** (`lib/presentation/providers/`):
- ✅ `data_source_providers.dart` - DataSource provider
- ✅ `repository_providers.dart` - Repository provider
- ✅ `use_case_providers.dart` - UseCase provider
- ✅ `pokemon_list_clean_provider.dart` - UI provider with Clean Architecture

**Usage in Widgets:**
```dart
// Use the new Clean Architecture provider
final asyncPokemons = ref.watch(pokemonListCleanProvider);

asyncPokemons.when(
  data: (pokemons) => ListView.builder(
    itemBuilder: (_, i) => ListTile(
      title: Text(pokemons[i].displayName),    // "Bulbasaur"
      subtitle: Text('#${pokemons[i].paddedId}'), // "#001"
      leading: Image.network(pokemons[i].spriteUrl),
    ),
  ),
  loading: () => PokeballLoading(),
  error: (e, _) => ErrorWidget(error: e),
);
```

**Documentation:**
- 📖 `lib/domain/README.md` - Complete domain layer guide
- 📖 `lib/domain/usecases/USAGE_EXAMPLE.md` - Use case examples
- 📖 `lib/data/README.md` - Complete data layer guide
- 📖 `ARCHITECTURE_IMPROVEMENTS.md` - Full architecture analysis and improvements

**Benefits:**
- ✅ Highly testable (easy to mock repositories and use cases)
- ✅ Clear separation of concerns (Domain, Data, Presentation)
- ✅ Type-safe error handling with Result<T>
- ✅ Easy to scale and add new features
- ✅ Robust API error handling (Network, Server, Timeout, Parse, NotFound, etc.)
