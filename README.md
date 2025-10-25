# PokeApp

Una aplicación Flutter con experiencia de onboarding temática de Pokemon, componentes SVG animados personalizados, navegación fluida y gestión de estado con Riverpod.

## Descripción

PokeApp es una aplicación móvil construida con Flutter 3.32.4 que incluye:
- Experiencia de onboarding temática de Pokemon
- Animaciones personalizadas de pokeball en SVG
- Splash screen con transiciones automáticas (2 segundos)
- Sistema de navegación reactivo con GoRouter + Riverpod
- Internacionalización (i18n) para inglés y español
- Arquitectura modular de widgets
- Gestión de estado con Riverpod
- Native splash screen configurado
- Constantes centralizadas para configuración

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
```

### 3. Instalar Dependencias

```bash
fvm flutter pub get
```

### 4. Generar Archivos de Localización

```bash
fvm flutter gen-l10n
```

### 5. Generar Native Splash Screen

```bash
fvm flutter pub run flutter_native_splash:create
```

### 6. Ejecutar la Aplicación

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
│   └── constants.dart                  # Constantes centralizadas (duraciones, tamaños, etc.)
├── pages/
│   ├── splash_screen.dart             # Pantalla de splash inicial
│   └── onboarding_page.dart           # Pantalla de onboarding Pokemon
├── providers/
│   └── app_startup_provider.dart      # Provider para gestión de estado del splash
├── widgets/
│   └── pokeball_loading.dart          # Widget de carga con animación pokeball
├── exts/
│   ├── animated_svg.dart               # Widget SVG animado personalizado
│   └── animated_svg_controller.dart    # Controlador para animaciones SVG
└── l10n/
    ├── app_en.arb                      # Traducciones en inglés
    └── app_es.arb                      # Traducciones en español

assets/
├── svg/
│   ├── pokeball.svg                    # Asset principal pokeball
│   ├── pokeball1.svg                   # Variante de animación 1
│   └── pokeball2.svg                   # Variante de animación 2
└── png/
    ├── pokeball.png                    # Logo para native splash
    ├── onboarding.png                  # Imagen de onboarding 1
    └── onboarding2.png                 # Imagen de onboarding 2
```

## Características Principales

### Gestión de Estado con Riverpod
- **flutter_riverpod** (^3.0.3) para gestión de estado reactivo
- `AppStartupProvider` maneja la lógica de transición del splash
- Router reactivo que responde a cambios de estado
- Separación clara entre lógica de negocio y UI

### Internacionalización (i18n)
- Soporte completo para **inglés** y **español**
- Detección automática del idioma del dispositivo
- Archivos ARB para gestión de traducciones
- Generación automática de clases de localización
- Uso: `AppLocalizations.of(context)!.textoKey`

### Sistema de Navegación con GoRouter + Riverpod
- Navegación declarativa con `go_router` (^16.3.0)
- Integración con Riverpod para navegación reactiva
- Transiciones de página personalizadas con `FadeTransition`
- Redirección automática desde splash a onboarding (2 segundos)
- Rutas definidas: `/splash` y `/onboarding`

### Constantes Centralizadas
Todas las constantes de la aplicación centralizadas en `lib/core/constants.dart`:
- Duraciones de animaciones
- Tamaños de fuentes
- Dimensiones de componentes
- Rutas de assets
- Configuración UI

### Animaciones SVG Personalizadas
Sistema de animación SVG con soporte de controlador para animaciones suaves de pokeball con múltiples variantes.

### Native Splash Screen
Configurado con `flutter_native_splash` para una experiencia de inicio nativa en Android e iOS.

### Arquitectura Modular
- Widgets organizados en componentes reutilizables
- Separación de responsabilidades (UI, lógica, estado)
- Providers para lógica de negocio
- Constantes centralizadas

### Tema Pokemon
Experiencia de onboarding atractiva con visuales y animaciones temáticas de Pokemon.

## Desarrollo

### Ejecutar Tests

```bash
# Ejecutar todos los tests
fvm flutter test

# Ejecutar un archivo de test específico
fvm flutter test test/widget_test.dart

# Ejecutar con cobertura
fvm flutter test --coverage
```

### Calidad de Código

```bash
# Analizar código
fvm flutter analyze

# Formatear código
fvm flutter format .

# Formatear un archivo específico
fvm flutter format lib/main.dart
```

### Internacionalización

```bash
# Generar archivos de localización después de editar ARB
fvm flutter gen-l10n
```

### Construcción

```bash
# Android APK
fvm flutter build apk

# Android App Bundle (recomendado para Play Store)
fvm flutter build appbundle

# iOS
fvm flutter build ios

# Web
fvm flutter build web

# macOS
fvm flutter build macos
```

## Dependencias

### Producción
- **flutter_svg** (^2.2.1) - Renderizado y animaciones SVG
- **go_router** (^16.3.0) - Navegación declarativa y routing
- **flutter_native_splash** (^2.4.7) - Splash screen nativo
- **flutter_riverpod** (^3.0.3) - Gestión de estado reactivo
- **intl** (^0.20.2) - Internacionalización y formateo
- **flutter_localizations** (SDK) - Localizaciones de Flutter
- **cupertino_icons** (^1.0.8) - Iconos estilo iOS

### Desarrollo
- **flutter_lints** (^5.0.0) - Reglas de linting y calidad de código

## Arquitectura

### Patrón de Gestión de Estado

```dart
// Provider define el estado
final appStartupProvider = NotifierProvider<AppStartupNotifier, AppStartupState>(
  AppStartupNotifier.new,
);

// Router reactivo escucha cambios
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    redirect: (context, state) {
      final appStartupState = ref.watch(appStartupProvider);
      // Lógica de redirección basada en estado
    },
  );

  ref.listen<AppStartupState>(appStartupProvider, (previous, next) {
    router.refresh();
  });

  return router;
});
```

### Flujo de Navegación

1. App inicia en `/splash`
2. `AppStartupProvider` espera 2 segundos (`AppConstants.splashScreenDuration`)
3. Estado cambia a `AppStartupState.onboarding`
4. Router detecta el cambio y redirige a `/onboarding`
5. Usuario navega por los pasos de onboarding

## Estándares de Código

Este proyecto sigue las mejores prácticas de Flutter aplicadas por `flutter_lints`. Directrices clave:

- Usar constructores `const` cuando sea posible
- Preferir `StatelessWidget` para componentes sin estado
- Extraer widgets reutilizables en archivos separados
- Usar providers para lógica de negocio
- Centralizar constantes en `AppConstants`
- Disponer correctamente de los controladores de animación
- Agregar comentarios significativos para lógica compleja
- Seguir la convención de nomenclatura de Dart
- Usar `ConsumerWidget` cuando se necesita acceso a providers

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
Text(AppLocalizations.of(context)!.nuevoTexto)
```

## Navegación

La aplicación utiliza GoRouter integrado con Riverpod:

```dart
/splash      -> SplashScreen (ruta inicial, auto-redirige después de 2s)
/onboarding  -> OnboardingScreen
```

Todas las transiciones de página utilizan `FadeTransition` para una experiencia fluida.

## Configuración

Todas las configuraciones centralizadas en `lib/core/constants.dart`:

```dart
AppConstants.splashScreenDuration      // Duration(seconds: 2)
AppConstants.animationDuration         // Duration(milliseconds: 300)
AppConstants.defaultPadding            // 16.0
AppConstants.titleFontSize             // 26.0
// ... y más
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
fvm flutter pub get
```

### Archivos de localización no generados
```bash
fvm flutter gen-l10n
```

### SVG no se renderiza
- Verificar ruta del asset en `pubspec.yaml`
- Asegurar que el archivo SVG existe en `assets/svg/`
- Ejecutar `fvm flutter pub get` después de agregar assets

### Splash screen no aparece
```bash
fvm flutter pub run flutter_native_splash:create
```

### Errores de compilación
```bash
# Limpiar y reconstruir
fvm flutter clean
fvm flutter pub get
fvm flutter gen-l10n
fvm flutter run
```

### Provider no encontrado
Asegúrate de que `ProviderScope` envuelve la app en `main.dart`:
```dart
void main() {
  runApp(const ProviderScope(child: MyApp()));
}
```

## Recursos

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Documentación de FVM](https://fvm.app/)
- [GoRouter Package](https://pub.dev/packages/go_router)
- [Riverpod Documentation](https://riverpod.dev/)
- [Flutter SVG Package](https://pub.dev/packages/flutter_svg)
- [Flutter Native Splash](https://pub.dev/packages/flutter_native_splash)
- [Flutter Internationalization](https://docs.flutter.dev/development/accessibility-and-localization/internationalization)

## Versión

- **Versión de la App**: 1.0.0+1
- **Flutter**: 3.32.4
- **Dart SDK**: ^3.8.1

## Licencia

Este proyecto es parte de una evaluación técnica y para fines educativos.
