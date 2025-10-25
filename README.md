# PokeApp

A Flutter application featuring a Pokemon-themed onboarding experience with custom animated SVG components and splash screen animations.

## Overview

PokeApp is a mobile application built with Flutter 3.32.4 that showcases:
- Pokemon-themed onboarding experience
- Custom animated pokeball loading animations
- Splash screen with smooth transitions
- Modular widget architecture
- SVG animation system

## Prerequisites

- [FVM (Flutter Version Manager)](https://fvm.app/) - Required for version management
- Flutter 3.32.4 (managed via FVM)
- Dart SDK ^3.8.1

## Getting Started

### 1. Install FVM

If you don't have FVM installed:

```bash
dart pub global activate fvm
```

### 2. Install Flutter Version

```bash
fvm install 3.32.4
```

### 3. Install Dependencies

```bash
fvm flutter pub get
```

### 4. Run the Application

```bash
# Run on default device
fvm flutter run

# List available devices
fvm flutter devices

# Run on specific device
fvm flutter run -d <device_id>
```

## Project Structure

```
lib/
├── main.dart                           # Application entry point
├── pages/
│   ├── onboarding_page.dart           # Pokemon onboarding screen
│   └── splash_page.dart               # Splash screen with animations
├── widgets/
│   └── pokeball_loading.dart         # Custom pokeball loading widget
└── exts/
    ├── animated_svg.dart              # Animated SVG widget
    └── animated_svg_controller.dart   # SVG animation controller

assets/
├── svg/
│   ├── pokeball.svg                   # Main pokeball asset
│   ├── pokeball1.svg                  # Animation variant 1
│   └── pokeball2.svg                  # Animation variant 2
└── png/
    └── onboarding.png                 # Onboarding image
```

## Key Features

### Custom SVG Animations
The app includes a custom animated SVG system with controller support for smooth pokeball animations.

### Modular Architecture
Widgets are organized into reusable components following Flutter best practices.

### Pokemon Theme
Engaging onboarding experience with Pokemon-themed visuals and animations.

## Development

### Running Tests

```bash
# Run all tests
fvm flutter test

# Run with coverage
fvm flutter test --coverage
```

### Code Quality

```bash
# Analyze code
fvm flutter analyze

# Format code
fvm flutter format .
```

### Building

```bash
# Android APK
fvm flutter build apk

# Android App Bundle
fvm flutter build appbundle

# iOS
fvm flutter build ios

# Web
fvm flutter build web
```

## Dependencies

- **flutter_svg** (^2.2.1) - SVG rendering and animations
- **cupertino_icons** (^1.0.8) - iOS-style icons
- **flutter_lints** (^5.0.0) - Code quality and linting

## Code Standards

This project follows Flutter best practices enforced by `flutter_lints`. Key guidelines:

- Use `const` constructors when possible
- Prefer `StatelessWidget` for stateless components
- Extract reusable widgets into separate files
- Properly dispose of animation controllers
- Add meaningful comments for complex logic

## Troubleshooting

**FVM not found**
```bash
dart pub global activate fvm
```

**Wrong Flutter version**
```bash
fvm install 3.32.4
fvm use 3.32.4
```

**Missing dependencies**
```bash
fvm flutter pub get
```

**SVG not rendering**
- Verify asset path in `pubspec.yaml`
- Ensure SVG file exists in `assets/svg/`
- Run `fvm flutter pub get` after adding assets

## Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [FVM Documentation](https://fvm.app/)
- [Flutter SVG Package](https://pub.dev/packages/flutter_svg)

## License

This project is part of a technical assessment for Global66.
