# Domain Layer - Clean Architecture

## 📁 Estructura Creada

```
lib/domain/
├── core/
│   └── result.dart                    # ✅ Type-safe Result<T> para manejo de errores
│
├── entities/
│   └── pokemon_entity.dart            # ✅ Entidad de dominio pura (sin dependencias externas)
│
├── failures/
│   └── pokemon_failure.dart           # ✅ Tipos de error del dominio (sealed classes)
│
├── repositories/
│   └── pokemon_repository.dart        # ✅ Interfaz abstracta (contrato del repositorio)
│
└── usecases/
    ├── get_pokemon_list.dart          # ✅ Caso de uso implementado
    └── USAGE_EXAMPLE.md               # ✅ Ejemplos de uso completos
```

## 🎯 ¿Qué es la Capa de Dominio?

La capa de **Dominio** es el corazón de Clean Architecture. Contiene:

- **Entidades**: Objetos de negocio puros
- **Casos de Uso**: Lógica de negocio específica de la aplicación
- **Repositorios (interfaces)**: Contratos que la capa de datos debe cumplir
- **Failures**: Tipos de error del dominio
- **Tipos de valor**: Result, Either, etc.

### Características Clave:

✅ **Independiente de frameworks** (sin Flutter, Riverpod, Dio)
✅ **Testeable** (fácil de hacer unit tests)
✅ **Reutilizable** (se puede usar en diferentes UIs)
✅ **Estable** (raramente cambia)

## 📦 Componentes Implementados

### 1. Result<T> - Manejo de Errores Type-Safe

Ubicación: `lib/domain/core/result.dart`

Un tipo Result inspirado en Rust/Kotlin que reemplaza excepciones:

```dart
// ✅ En lugar de try-catch
try {
  final pokemons = await fetchPokemons();
} catch (e) {
  print(e);
}

// ✅ Usar Result
final result = await fetchPokemons();
result.when(
  success: (pokemons) => print('Got ${pokemons.length} Pokemon'),
  failure: (error) => print('Error: $error'),
);
```

**Métodos disponibles:**
- `when()` - Pattern matching exhaustivo
- `map()` - Transformar valor de éxito
- `flatMap()` - Encadenar operaciones
- `getOrElse()` - Valor por defecto
- `valueOrNull` - Obtener valor o null

### 2. PokemonEntity - Entidad de Dominio

Ubicación: `lib/domain/entities/pokemon_entity.dart`

Entidad pura sin dependencias de frameworks:

```dart
class PokemonEntity {
  final int id;
  final String name;
  final List<String> types;

  // Métodos de negocio
  String get displayName;      // "Bulbasaur"
  String get paddedId;         // "001"
  String get primaryType;      // "grass"
  String get spriteUrl;        // URL de la imagen
  bool hasType(String type);   // Verificar tipo
}
```

**Diferencia con Pokemon del modelo actual:**
- ❌ Modelo actual: `Pokemon` con Freezed + JSON (capa de datos)
- ✅ Nueva entidad: `PokemonEntity` pura (capa de dominio)

### 3. PokemonFailure - Tipos de Error

Ubicación: `lib/domain/failures/pokemon_failure.dart`

Errores tipados con sealed classes:

```dart
sealed class PokemonFailure { ... }

// Tipos específicos:
- NetworkFailure      // Sin conexión
- ServerFailure       // Error del servidor (500, 503)
- TimeoutFailure      // Timeout de request
- ParseFailure        // Error al parsear respuesta
- NotFoundFailure     // Pokemon no encontrado (404)
- CacheFailure        // Error de caché local
- UnknownFailure      // Error desconocido
```

**Uso con pattern matching:**
```dart
result.when(
  success: (data) => showData(data),
  failure: (error) {
    switch (error) {
      case NetworkFailure():
        showMessage('Sin conexión a internet');
      case ServerFailure(statusCode: final code):
        showMessage('Error del servidor: $code');
      case TimeoutFailure():
        showMessage('La petición tardó demasiado');
      default:
        showMessage('Error: ${error.message}');
    }
  },
);
```

### 4. PokemonRepository - Contrato

Ubicación: `lib/domain/repositories/pokemon_repository.dart`

Interfaz abstracta que define el contrato:

```dart
abstract class PokemonRepository {
  // Obtener lista
  Future<Result<List<PokemonEntity>>> getPokemonList({
    int limit = 20,
    int offset = 0,
  });

  // Obtener por ID
  Future<Result<PokemonEntity>> getPokemonById(int id);

  // Buscar por nombre
  Future<Result<List<PokemonEntity>>> searchPokemon(String query);

  // Filtrar por tipos
  Future<Result<List<PokemonEntity>>> filterPokemonByTypes(List<String> types);
}
```

**La implementación estará en la capa de datos:**
```
lib/data/repositories/pokemon_repository_impl.dart  (pendiente)
```

### 5. GetPokemonList - Caso de Uso

Ubicación: `lib/domain/usecases/get_pokemon_list.dart`

Encapsula la lógica de negocio para obtener Pokemon:

```dart
class GetPokemonList {
  final PokemonRepository _repository;

  const GetPokemonList(this._repository);

  // Método principal
  Future<Result<List<PokemonEntity>>> call({
    int limit = 20,
    int offset = 0,
  });

  // Métodos de conveniencia
  Future<Result<List<PokemonEntity>>> fetchFirstPage();
  Future<Result<List<PokemonEntity>>> fetchPage({required int page, int pageSize = 20});
  Future<Result<List<PokemonEntity>>> fetchAll({int maxCount = 151});
}
```

**Características:**
- ✅ Validación de inputs (limit, offset)
- ✅ Métodos de conveniencia para casos comunes
- ✅ Documentación exhaustiva
- ✅ Fácil de testear

**Uso:**
```dart
final useCase = GetPokemonList(repository);
final result = await useCase(limit: 20);

result.when(
  success: (pokemons) => print('Got ${pokemons.length} Pokemon'),
  failure: (error) => print('Error: $error'),
);
```

## 🔄 Flujo de Datos (Clean Architecture)

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│  (UI, Widgets, Providers, Controllers)                   │
│                                                           │
│  ┌──────────────┐         ┌─────────────────┐          │
│  │   Widget     │ watches │ Riverpod        │          │
│  │ (PokedexUI)  │────────>│ Provider        │          │
│  └──────────────┘         └─────────┬───────┘          │
└────────────────────────────────────┼─────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────┐
│                     DOMAIN LAYER ✅                      │
│  (Business Logic, Entities, Use Cases)                   │
│                                                           │
│  ┌────────────────┐         ┌──────────────────┐       │
│  │   Use Case     │────────>│   Repository     │       │
│  │ GetPokemonList │   uses  │   (interface)    │       │
│  └────────────────┘         └──────────────────┘       │
│         │                            ▲                   │
│         │ returns                    │ implements        │
│         ▼                            │                   │
│  Result<List<PokemonEntity>>        │                   │
└────────────────────────────────────┼─────────────────────┘
                                     │
                                     ▼
┌─────────────────────────────────────────────────────────┐
│                     DATA LAYER (Pendiente)               │
│  (API, Database, DTOs, Mappers)                          │
│                                                           │
│  ┌─────────────────┐        ┌──────────────────┐       │
│  │  Repository     │───────>│  Remote          │       │
│  │  Implementation │  uses  │  DataSource      │       │
│  └─────────────────┘        └────────┬─────────┘       │
│         │                             │                  │
│         │ maps                        │ fetches          │
│         ▼                             ▼                  │
│  PokemonEntity                   Dio + PokeAPI          │
│   ← PokemonDTO                                           │
└─────────────────────────────────────────────────────────┘
```

## 📝 Próximos Pasos

Para completar la arquitectura limpia, falta implementar:

### Capa de Datos (Data Layer)

```
lib/data/
├── datasources/
│   ├── pokemon_remote_datasource.dart          # TODO: Interface
│   └── pokemon_remote_datasource_impl.dart     # TODO: Implementación con Dio
│
├── models/
│   ├── pokemon_dto.dart                        # TODO: DTO para serialización
│   ├── pokemon_detail_response_dto.dart        # TODO: Respuesta completa
│   └── type_info_dto.dart                      # TODO: Información de tipos
│
├── repositories/
│   └── pokemon_repository_impl.dart            # TODO: Implementa interfaz de domain
│
└── mappers/
    └── pokemon_mapper.dart                     # TODO: DTO → Entity
```

### Providers de Riverpod

```
lib/presentation/providers/
├── repository_providers.dart     # TODO: Provider del repositorio
├── use_case_providers.dart       # TODO: Provider del caso de uso
└── pokemon_list_provider.dart    # TODO: Actualizar para usar caso de uso
```

## 🧪 Testing

Con esta arquitectura, los tests son muy simples:

```dart
// test/domain/usecases/get_pokemon_list_test.dart
void main() {
  late MockPokemonRepository mockRepo;
  late GetPokemonList useCase;

  setUp(() {
    mockRepo = MockPokemonRepository();
    useCase = GetPokemonList(mockRepo);
  });

  test('should return Pokemon list on success', () async {
    // Arrange
    final mockPokemons = [
      PokemonEntity(id: 1, name: 'bulbasaur', types: ['grass']),
    ];
    when(() => mockRepo.getPokemonList(limit: 20, offset: 0))
        .thenAnswer((_) async => Result.success(mockPokemons));

    // Act
    final result = await useCase();

    // Assert
    expect(result.isSuccess, true);
    expect(result.value.length, 1);
  });
}
```

## 📚 Referencias

- [Clean Architecture - Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture - Reso Coder](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Domain-Driven Design](https://martinfowler.com/bliki/DomainDrivenDesign.html)

## ✅ Checklist de Implementación

### Domain Layer (Completo)
- [x] Result type para manejo de errores
- [x] PokemonEntity (entidad de dominio)
- [x] PokemonFailure (tipos de error)
- [x] PokemonRepository (interfaz)
- [x] GetPokemonList (caso de uso)
- [x] Documentación completa

### Data Layer (Pendiente)
- [ ] PokemonRemoteDataSource + Implementación
- [ ] DTOs con Freezed + json_serializable
- [ ] PokemonRepositoryImpl
- [ ] PokemonMapper (DTO → Entity)
- [ ] Manejo de errores (try-catch → Failures)

### Presentation Layer (Pendiente)
- [ ] Providers de Riverpod
- [ ] Actualizar widgets para usar PokemonEntity
- [ ] Manejo de UI con Result.when()
- [ ] Tests de integración

---

**Estado Actual:** ✅ Capa de Dominio completada
**Siguiente Paso:** Implementar Data Layer (Repository + DataSource + DTOs)
