# PokeApp

Una aplicación Flutter con experiencia de onboarding temática de Pokemon, componentes SVG animados personalizados y navegación fluida.

## Descripción

PokeApp es una aplicación móvil construida con Flutter 3.32.4 que incluye:
- Experiencia de onboarding temática de Pokemon
- Animaciones personalizadas de pokeball en SVG
- Splash screen con transiciones suaves
- Sistema de navegación con GoRouter
- Arquitectura modular de widgets
- Native splash screen configurado

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

### 4. Generar Native Splash Screen

```bash
fvm flutter pub run flutter_native_splash:create
```

### 5. Ejecutar la Aplicación

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
├── main.dart                           # Punto de entrada de la aplicación
├── app_router.dart                     # Configuración de rutas con GoRouter
├── colors.dart                         # Paleta de colores de la app
├── pages/
│   ├── splash_screen.dart             # Pantalla de splash inicial
│   └── onboarding_page.dart           # Pantalla de onboarding Pokemon
├── widgets/
│   └── pokeball_loading.dart          # Widget de carga con animación pokeball
└── exts/
    ├── animated_svg.dart               # Widget SVG animado personalizado
    └── animated_svg_controller.dart    # Controlador para animaciones SVG

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

### Sistema de Navegación con GoRouter
- Navegación declarativa con `go_router` (^16.3.0)
- Transiciones de página personalizadas con `FadeTransition`
- Rutas definidas: `/splash` y `/onboarding`
- Navegación fluida entre pantallas

### Animaciones SVG Personalizadas
Sistema de animación SVG con soporte de controlador para animaciones suaves de pokeball con múltiples variantes.

### Native Splash Screen
Configurado con `flutter_native_splash` para una experiencia de inicio nativa en Android e iOS.

### Arquitectura Modular
Widgets organizados en componentes reutilizables siguiendo las mejores prácticas de Flutter.

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
- **cupertino_icons** (^1.0.8) - Iconos estilo iOS

### Desarrollo
- **flutter_lints** (^5.0.0) - Reglas de linting y calidad de código

## Estándares de Código

Este proyecto sigue las mejores prácticas de Flutter aplicadas por `flutter_lints`. Directrices clave:

- Usar constructores `const` cuando sea posible
- Preferir `StatelessWidget` para componentes sin estado
- Extraer widgets reutilizables en archivos separados
- Disponer correctamente de los controladores de animación
- Agregar comentarios significativos para lógica compleja
- Seguir la convención de nomenclatura de Dart

## Navegación

La aplicación utiliza GoRouter para gestión de rutas:

```dart
/splash      -> SplashScreen (ruta inicial)
/onboarding  -> OnboardingScreen
```

Todas las transiciones de página utilizan `FadeTransition` para una experiencia fluida.

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
fvm flutter run
```

## Recursos

- [Documentación de Flutter](https://docs.flutter.dev/)
- [Documentación de FVM](https://fvm.app/)
- [GoRouter Package](https://pub.dev/packages/go_router)
- [Flutter SVG Package](https://pub.dev/packages/flutter_svg)
- [Flutter Native Splash](https://pub.dev/packages/flutter_native_splash)

## Versión

- **Versión de la App**: 1.0.0+1
- **Flutter**: 3.32.4
- **Dart SDK**: ^3.8.1

## Licencia

Este proyecto es parte de una evaluación técnica para Global66.
