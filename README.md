# Pokedex App

Una aplicación Flutter completa de Pokédex con integración a PokeAPI, gestión de favoritos, filtrado por tipos, búsqueda en tiempo real y una interfaz dinámica con animaciones.

## Descripción

Pokedex App es una aplicación móvil construida con Flutter 3.32.4 que incluye:
- **Pokédex completa** con integración a PokeAPI
- **Sistema de favoritos** con persistencia en memoria
- **Búsqueda en tiempo real** de Pokémon por nombre o número
- **Filtrado por tipos** con modal de preferencias (18 tipos disponibles)
- **Colores y assets dinámicos** según el tipo de Pokémon
- **Detalle de Pokémon** con información completa y UI adaptativa
- **Animaciones suaves** en botones de favoritos con ScaleTransition
- **Deslizar para eliminar** favoritos con flutter_slidable
- Experiencia de onboarding temática de Pokemon
- Sistema de navegación reactivo con GoRouter + Riverpod
- Internacionalización (i18n) para inglés y español
- Arquitectura limpia con Freezed y json_serializable
- Gestión de estado con Riverpod (@riverpod annotations)
- Native splash screen configurado
- Theme centralizado con Google Fonts

## Requisitos Previos

- [FVM (Flutter Version Manager)](https://fvm.app/) - Requerido para gestión de versiones
- Flutter 3.32.4 (gestionado vía FVM)
- Dart SDK ^3.8.1

## Instalación

### 1. Instalar FVM

Si no tienes FVM instalado:

```bash
dart pub global activate fvm
```

### 2. Instalar la Versión de Flutter

```bash
fvm install 3.32.4
fvm use 3.32.4
```

### 3. Instalar Dependencias

```bash
fvm flutter pub get
```

### 4. Generar Código (Freezed, Riverpod, json_serializable)

```bash
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### 5. Generar Archivos de Localización

```bash
fvm flutter gen-l10n
```

### 6. Generar Native Splash Screen

```bash
fvm flutter pub run flutter_native_splash:create
```

### 7. Ejecutar la Aplicación

```bash
# Ejecutar en dispositivo por defecto
fvm flutter run

# Listar dispositivos disponibles
fvm flutter devices

# Ejecutar en dispositivo específico
fvm flutter run -d <device_id>

# Ejecutar en modo release
fvm flutter run --release
```

## Estructura del Proyecto

```
lib/
├── main.dart                           # Punto de entrada con ProviderScope
├── app_router.dart                     # Configuración de rutas con GoRouter + Riverpod
├── colors.dart                         # Paleta de colores de la app
├── core/
│   ├── constants.dart                  # Constantes centralizadas
│   ├── app_routes.dart                 # Rutas constantes
│   ├── app_theme.dart                  # Tema centralizado
│   ├── api_exception.dart              # Manejo de excepciones API
│   └── pokemon_type_helper.dart        # Helper para colores/assets de tipos
├── models/
│   ├── pokemon.dart                    # Modelo Pokemon (Freezed)
│   └── pokemon_list_response.dart      # Modelo de respuesta API (Freezed)
├── pages/
│   ├── splash_screen.dart             # Pantalla de splash inicial
│   ├── onboarding_screen.dart         # Pantalla de onboarding
│   ├── home_screen.dart               # Pantalla principal con tabs
│   ├── pokedex_screen.dart            # Pantalla del Pokédex
│   ├── pokedex_widget.dart            # Widget con búsqueda y filtros
│   ├── pokemon_list_tile.dart         # Tile de Pokémon en lista
│   ├── pokemon_detail.dart            # Detalle completo del Pokémon
│   ├── favorites_screen.dart          # Pantalla de favoritos
│   ├── regiones_screen.dart           # Pantalla de regiones
│   ├── profile_screen.dart            # Pantalla de perfil
│   ├── element_chip.dart              # Chip de tipo de Pokémon
│   └── measurement_card.dart          # Tarjeta de medidas
├── providers/
│   ├── app_startup_provider.dart      # Provider para gestión de estado del splash
│   ├── dio_provider.dart              # Provider de Dio (HTTP client)
│   ├── pokemon_provider.dart          # Provider para API de Pokémon
│   └── favorites_provider.dart        # Provider de favoritos
├── widgets/
│   ├── pokeball_loading.dart          # Widget de carga animado
│   ├── custom_bottom_navigation.dart  # Navegación inferior personalizada
│   ├── custom_default_button.dart     # Botón personalizado
│   ├── filter_preferences_modal.dart  # Modal de filtros por tipo
│   ├── pokemon_search_bar.dart        # Barra de búsqueda
│   └── error_widget.dart              # Widget de error
├── exts/
│   ├── animated_svg.dart               # Widget SVG animado personalizado
│   └── animated_svg_controller.dart    # Controlador para animaciones SVG
└── l10n/
    ├── app_en.arb                      # Traducciones en inglés
    └── app_es.arb                      # Traducciones en español

assets/
├── svg/
│   ├── pokeball.svg                    # Asset principal pokeball
│   ├── grass.svg, poison.svg           # Iconos de tipos
│   ├── water.svg, fire.svg, bug.svg    # Más iconos de tipos
│   ├── flying.svg, normal.svg          # Iconos adicionales
│   ├── fav.svg, fav_solid.svg          # Iconos de favoritos
│   └── search.svg                      # Icono de búsqueda
└── png/
    ├── pokeball.png                    # Logo para native splash
    ├── onboarding.png, onboarding2.png # Imágenes de onboarding
    ├── magikarp.png                    # Imagen de estado vacío
    └── regiones.png                    # Imagen de regiones
```

## Características Principales

### 1. Integración con PokeAPI

La app consume datos en tiempo real de [PokeAPI](https://pokeapi.co/):

- **Lista de Pokémon**: Obtiene los primeros 20 Pokémon con sus tipos
- **Detalles completos**: ID, nombre, tipos, imagen oficial
- **Parsing robusto**: Usando json_serializable y Freezed
- **Manejo de errores**: Con try-catch y ApiException personalizada

```dart
@riverpod
Future<List<Pokemon>> pokemonList(Ref ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get('pokemon', queryParameters: {'limit': 20});
  // Parseo con json_serializable...
}
```

### 2. Sistema de Favoritos

- **Añadir/quitar favoritos**: Botón de corazón con animación
- **Lista de favoritos**: Pantalla dedicada con todos los favoritos
- **Deslizar para eliminar**: Slidable con confirmación
- **Persistencia**: En memoria durante la sesión (Riverpod Notifier)
- **Indicador visual**: Corazón rojo cuando está en favoritos

```dart
class FavoritesNotifier extends Notifier<Map<int, Pokemon>> {
  void toggleFavorite(Pokemon pokemon) { /* ... */ }
  void addFavorite(Pokemon pokemon) { /* ... */ }
  void removeFavorite(int pokemonId) { /* ... */ }
}
```

### 3. Búsqueda y Filtrado

#### Búsqueda en Tiempo Real
- Campo de texto con búsqueda instantánea
- Filtra por nombre (case-insensitive) o número de Pokémon
- Botón para limpiar búsqueda
- Estado vacío cuando no hay resultados

#### Filtrado por Tipos
- Modal con 18 tipos de Pokémon disponibles
- Selección múltiple de tipos
- Filtro combinado con búsqueda de texto
- Indicador de cantidad de resultados
- Botón "Borrar filtro" para resetear

```dart
void _applyFilters() {
  var filtered = widget.pokemons;

  // Filtro por texto
  if (searchQuery.isNotEmpty) { /* ... */ }

  // Filtro por tipos
  if (selectedTypes.isNotEmpty) {
    filtered = filtered.where((pokemon) =>
      pokemon.types.any((type) => selectedTypes.contains(type))
    ).toList();
  }
}
```

### 4. UI Dinámica por Tipo

Cada Pokémon tiene colores y assets personalizados según su tipo primario:

- **Colores de fondo**: 18 colores únicos por tipo
- **Iconos SVG**: Assets específicos para cada tipo
- **Etiquetas traducidas**: Nombres en español e inglés
- **Chips de tipo**: Visualización elegante de tipos múltiples

```dart
class PokemonTypeHelper {
  static Color getTypeColor(String type) { /* grass, fire, water... */ }
  static String getTypeAsset(String type) { /* assets/svg/grass.svg... */ }
  static String getTypeLabel(String type) { /* Planta, Fuego, Agua... */ }
}
```

### 5. Detalle de Pokémon

Pantalla completa con:
- **Header colorido**: Fondo con color del tipo primario
- **Icono gigante**: SVG del tipo con gradiente
- **Imagen oficial**: Sprite del Pokémon de PokeAPI
- **Botones de acción**: Volver y agregar a favoritos con animación
- **Información básica**: Nombre, número, tipos
- **Diseño card**: Contenido con fondo blanco redondeado
- **Bottom navigation**: Acceso rápido a otras secciones

### 6. Animaciones

- **ScaleTransition**: Efecto de pulso en botones de favoritos (1.0x → 1.3x → 1.0x)
- **FadeTransition**: Transiciones suaves entre pantallas
- **Pokeball animada**: Loading con SVG animado personalizado
- **Slidable**: Deslizar para eliminar con animación fluida

### 7. Gestión de Estado con Riverpod

- **@riverpod annotations**: Para providers auto-generados
- **Notifier pattern**: Para favoritos (no StateNotifier legacy)
- **Provider.family**: Para verificar si un Pokémon es favorito
- **ref.watch()**: Para dependencias reactivas
- **ref.listen()**: Para efectos secundarios (ej: router.refresh())

```dart
@riverpod
Future<List<Pokemon>> pokemonList(Ref ref) async { /* ... */ }

final favoritesProvider = NotifierProvider<FavoritesNotifier, Map<int, Pokemon>>(
  () => FavoritesNotifier()
);

final isFavoriteProvider = Provider.family<bool, int>((ref, pokemonId) =>
  ref.watch(favoritesProvider).containsKey(pokemonId)
);
```

### 8. Internacionalización (i18n)

- Soporte completo para **inglés** y **español**
- Detección automática del idioma del dispositivo
- **Placeholders dinámicos**: `resultsFound(count)`, `confirmDeleteMessage(name)`
- Archivos ARB para gestión de traducciones
- Todos los textos de UI traducidos

Textos incluidos:
- Búsqueda y filtros
- Favoritos
- Botones de acción
- Mensajes de confirmación
- Estados vacíos
- Tipos de Pokémon

### 9. Modelos Inmutables con Freezed

```dart
@freezed
abstract class Pokemon with _$Pokemon {
  const Pokemon._();

  const factory Pokemon({
    required int id,
    required String name,
    @Default([]) List<String> types,
  }) = _Pokemon;

  factory Pokemon.fromJson(Map<String, dynamic> json) => _$PokemonFromJson(json);

  String nameCapitalizedFirstLetter() { /* ... */ }
  String idWithLeadingZeros() { /* ... */ }
}
```

### 10. Theme Centralizado

- **Google Fonts**: Poppins para toda la app
- **Color scheme**: Basado en colors.dart
- **AppBar theme**: Configuración consistente
- **Button theme**: Estilo de botones elevados
- **Bottom navigation theme**: Estilo personalizado
- **Card theme**: Elevación y bordes redondeados

## Dependencias

### Producción
- **flutter_svg** (^2.2.1) - Renderizado y animaciones SVG
- **go_router** (^16.3.0) - Navegación declarativa y routing
- **flutter_native_splash** (^2.4.7) - Splash screen nativo
- **flutter_riverpod** (^3.0.3) - Gestión de estado reactivo
- **riverpod_annotation** (^3.0.3) - Annotations para code generation
- **dio** (^5.9.0) - Cliente HTTP para APIs REST
- **freezed_annotation** (^3.1.0) - Modelos inmutables
- **json_annotation** (^4.9.0) - Serialización JSON
- **flutter_slidable** (^3.1.1) - Widget deslizable para listas
- **google_fonts** (^6.3.2) - Fuentes de Google
- **intl** (^0.20.2) - Internacionalización y formateo
- **flutter_localizations** (SDK) - Localizaciones de Flutter
- **cupertino_icons** (^1.0.8) - Iconos estilo iOS

### Desarrollo
- **flutter_lints** (^5.0.0) - Reglas de linting y calidad de código
- **build_runner** (^2.7.1) - Code generation
- **freezed** (^3.2.3) - Generator para modelos inmutables
- **json_serializable** (^6.8.0) - Generator para JSON
- **riverpod_generator** (^3.0.3) - Generator para providers
- **riverpod_lint** (^3.0.3) - Linting adicional para Riverpod
- **custom_lint** (^0.8.0) - Framework de linting personalizado

## Comandos Útiles

### Desarrollo
```bash
# Ejecutar app con hot reload
fvm flutter run

# Generar código (Freezed, Riverpod, json_serializable)
fvm flutter pub run build_runner build --delete-conflicting-outputs

# Generar código en modo watch (auto-regenera al cambiar archivos)
fvm flutter pub run build_runner watch --delete-conflicting-outputs

# Generar localizaciones
fvm flutter gen-l10n

# Analizar código
fvm flutter analyze

# Formatear código
fvm flutter format .
```

### Testing
```bash
# Ejecutar todos los tests
fvm flutter test

# Ejecutar con cobertura
fvm flutter test --coverage

# Ejecutar un test específico
fvm flutter test test/widget_test.dart
```

### Construcción
```bash
# Android APK
fvm flutter build apk

# Android App Bundle (para Play Store)
fvm flutter build appbundle

# iOS
fvm flutter build ios

# Web
fvm flutter build web

# macOS
fvm flutter build macos
```

## Flujo de Navegación

```
/splash (2 segundos automático)
    ↓
/onboarding
    ↓
Home (con bottom navigation)
    ├── /pokedex      → Lista de Pokémon con búsqueda/filtros
    │   └── /pokemon/:id → Detalle del Pokémon
    ├── /favoritos    → Lista de favoritos con slidable
    ├── /regiones     → Pantalla de regiones
    └── /profile      → Pantalla de perfil
```

## Arquitectura

### Patrón de Gestión de Estado

```dart
// Provider con @riverpod annotation
@riverpod
Future<List<Pokemon>> pokemonList(Ref ref) async {
  final dio = ref.watch(dioProvider);
  // Lógica de fetching...
}

// Notifier para favoritos
class FavoritesNotifier extends Notifier<Map<int, Pokemon>> {
  @override
  Map<int, Pokemon> build() => {};

  void toggleFavorite(Pokemon pokemon) { /* ... */ }
}

// Router reactivo
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    routes: [...],
    redirect: (context, state) {
      final appStartupState = ref.watch(appStartupProvider);
      // Lógica de redirección...
    },
  );

  ref.listen<AppStartupState>(appStartupProvider, (previous, next) {
    router.refresh();
  });

  return router;
});
```

### Capa de Modelos (Freezed)

```dart
@freezed
abstract class Pokemon with _$Pokemon {
  const Pokemon._();
  const factory Pokemon({
    required int id,
    required String name,
    @Default([]) List<String> types,
  }) = _Pokemon;

  factory Pokemon.fromJson(Map<String, dynamic> json) => _$PokemonFromJson(json);
}
```

### Capa de Datos (Dio + json_serializable)

```dart
@riverpod
Future<List<Pokemon>> pokemonList(Ref ref) async {
  final dio = ref.watch(dioProvider);

  try {
    final response = await dio.get('pokemon', queryParameters: {'limit': 20});
    final pokemonListResponse = PokemonListResponse.fromJson(response.data);

    // Fetch detalles de cada Pokémon (tipos)
    final pokemonsFutures = pokemonListResponse.results.map((result) async {
      final detailResponse = await dio.get('pokemon/${result.id}');
      final types = (detailResponse.data['types'] as List)
          .map((typeInfo) => typeInfo['type']['name'] as String)
          .toList();

      return Pokemon(id: result.id, name: result.name, types: types);
    });

    return await Future.wait(pokemonsFutures);
  } catch (e) {
    throw ApiException('Error al cargar pokemones: $e');
  }
}
```

## Estándares de Código

Este proyecto sigue las mejores prácticas de Flutter aplicadas por `flutter_lints` y `riverpod_lint`:

- Usar constructores `const` cuando sea posible
- Preferir `ConsumerWidget` o `ConsumerStatefulWidget` cuando se necesita providers
- Usar `@freezed` para modelos inmutables
- Usar `@riverpod` annotations para providers auto-generados
- Extraer widgets reutilizables en archivos separados
- Centralizar constantes en clases helper
- Disponer correctamente de los controladores de animación
- Agregar comentarios significativos para lógica compleja
- Seguir la convención de nomenclatura de Dart
- Usar `Notifier` (no `StateNotifier` que está deprecated)
- Implementar manejo de errores con try-catch
- Usar `Provider.family` para providers parametrizados

## Localización

### Idiomas Soportados
- **Inglés (en)** - Por defecto
- **Español (es)**

### Agregar Nuevos Textos

1. Editar `lib/l10n/app_en.arb`:
```json
{
  "nuevoTexto": "New Text",
  "@nuevoTexto": {
    "description": "Description of the text"
  }
}
```

2. Editar `lib/l10n/app_es.arb`:
```json
{
  "nuevoTexto": "Nuevo Texto",
  "@nuevoTexto": {
    "description": "Descripción del texto"
  }
}
```

3. Generar archivos:
```bash
fvm flutter gen-l10n
```

4. Usar en código:
```dart
final l10n = AppLocalizations.of(context)!;
Text(l10n.nuevoTexto)
```

### Placeholders Dinámicos

```json
{
  "resultsFound": "Se han encontrado {count} resultados",
  "@resultsFound": {
    "description": "Mensaje con la cantidad de resultados encontrados",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

```dart
Text(l10n.resultsFound(filteredPokemons.length))
```

## Solución de Problemas

### FVM no encontrado
```bash
dart pub global activate fvm
```

### Versión incorrecta de Flutter
```bash
fvm install 3.32.4
fvm use 3.32.4
```

### Dependencias faltantes
```bash
fvm flutter clean
fvm flutter pub get
```

### Archivos generados faltantes
```bash
# Regenerar todo
fvm flutter pub run build_runner build --delete-conflicting-outputs
fvm flutter gen-l10n
```

### Error: "The getter 'X' isn't defined for type 'AppLocalizations'"
```bash
# Regenerar localizaciones
fvm flutter gen-l10n
```

### Error de compilación con Freezed/json_serializable
```bash
# Limpiar y regenerar
fvm flutter clean
fvm flutter pub get
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### Pokémon no se cargan desde la API
- Verificar conexión a internet
- Comprobar que PokeAPI está disponible: https://pokeapi.co/api/v2/pokemon
- Revisar logs de Dio en la consola
- Verificar que `apiBaseUrl` en constants.dart tenga la barra final: `'https://pokeapi.co/api/v2/'`

### SVG no se renderiza
- Verificar ruta del asset en `pubspec.yaml`
- Asegurar que el archivo SVG existe en `assets/svg/`
- Ejecutar `fvm flutter pub get` después de agregar assets
- Verificar que `PokemonTypeHelper.getTypeAsset()` devuelve una ruta válida

### Provider no encontrado
Asegúrate de que `ProviderScope` envuelve la app en `main.dart`:
```dart
void main() {
  runApp(const ProviderScope(child: MyApp()));
}
```

### Bottom navigation no funciona
- Verificar que `appRouterProvider` está siendo usado
- Comprobar que las rutas en `app_routes.dart` están correctas
- Asegurar que `context.go()` está recibiendo rutas válidas

## Características Adicionales Implementadas

### 1. Búsqueda Inteligente
- Filtra por nombre (case-insensitive) y por ID
- Actualización en tiempo real mientras escribes
- Botón de limpiar (X) cuando hay texto
- Estado vacío informativo

### 2. Filtro por Tipos
- Modal con 18 tipos de Pokémon
- Selección múltiple de tipos
- Filtro se combina con búsqueda de texto
- Contador de resultados encontrados
- Botón para limpiar todos los filtros

### 3. Sistema de Favoritos Completo
- Añadir/quitar con animación de pulso
- Lista dedicada de favoritos
- Deslizar para eliminar (Slidable)
- Sincronización entre lista y detalle
- Indicador visual en tiles

### 4. UI Adaptativa
- Colores dinámicos según tipo de Pokémon
- Assets SVG específicos por tipo
- Barra superior con color del tipo
- Chips de tipo con colores correctos
- Fondo del tile con transparencia del color del tipo

### 5. Optimizaciones
- `Future.wait()` para cargar tipos en paralelo
- Uso de `const` constructors
- `IntrinsicHeight` para layouts consistentes
- Lazy loading con `ListView.builder`
- Separación de lógica en helpers

## Recursos

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Documentación de FVM](https://fvm.app/)
- [GoRouter Package](https://pub.dev/packages/go_router)
- [Riverpod Documentation](https://riverpod.dev/)
- [Freezed Package](https://pub.dev/packages/freezed)
- [Dio HTTP Client](https://pub.dev/packages/dio)
- [Flutter SVG Package](https://pub.dev/packages/flutter_svg)
- [Flutter Slidable](https://pub.dev/packages/flutter_slidable)
- [PokeAPI Documentation](https://pokeapi.co/docs/v2)
- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

## Versión

- **Versión de la App**: 1.0.0+1
- **Flutter**: 3.32.4
- **Dart SDK**: ^3.8.1

## Licencia

Este proyecto es parte de una evaluación técnica y para fines educativos.

## Autor

Desarrollado como prueba técnica para demostrar conocimientos en Flutter, Riverpod, Freezed, integración de APIs REST, y mejores prácticas de desarrollo móvil.
