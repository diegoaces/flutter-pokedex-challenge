# Uso del Caso de Uso GetPokemonList

## Descripción

`GetPokemonList` es un caso de uso que encapsula la lógica de negocio para obtener una lista de Pokemon. Sigue los principios de Clean Architecture al separar la lógica de negocio de los detalles de implementación.

## Estructura Creada

```
lib/domain/
├── core/
│   └── result.dart                    # Type-safe Result para manejo de errores
├── entities/
│   └── pokemon_entity.dart            # Entidad de dominio pura
├── failures/
│   └── pokemon_failure.dart           # Tipos de error del dominio
├── repositories/
│   └── pokemon_repository.dart        # Interfaz abstracta del repositorio
└── usecases/
    └── get_pokemon_list.dart          # ✅ Caso de uso implementado
```

## Cómo Usar con Riverpod

### 1. Crear Provider del Repositorio (Implementación pendiente)

```dart
// lib/data/repositories/pokemon_repository_impl.dart
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;

  PokemonRepositoryImpl(this.remoteDataSource);

  @override
  Future<Result<List<PokemonEntity>>> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Fetch data from API
      final response = await remoteDataSource.fetchPokemonList(limit, offset);

      // Map to domain entities
      final entities = response.map((dto) => dto.toEntity()).toList();

      return Result.success(entities);
    } on NetworkException catch (e) {
      return Result.failure(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Result.failure(ServerFailure(e.message));
    } catch (e) {
      return Result.failure(UnknownFailure(e.toString()));
    }
  }

  // Otros métodos...
}
```

### 2. Crear Providers

```dart
// lib/presentation/providers/repository_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@riverpod
PokemonRepository pokemonRepository(Ref ref) {
  final remoteDataSource = ref.watch(pokemonRemoteDataSourceProvider);
  return PokemonRepositoryImpl(remoteDataSource);
}

// lib/presentation/providers/use_case_providers.dart
@riverpod
GetPokemonList getPokemonListUseCase(Ref ref) {
  final repository = ref.watch(pokemonRepositoryProvider);
  return GetPokemonList(repository);
}

// lib/presentation/providers/pokemon_list_provider.dart
@riverpod
Future<List<PokemonEntity>> pokemonList(Ref ref) async {
  final useCase = ref.watch(getPokemonListUseCaseProvider);

  final result = await useCase();

  return result.when(
    success: (pokemons) => pokemons,
    failure: (error) => throw Exception(error.message),
  );
}
```

### 3. Usar en un Widget

```dart
// lib/presentation/pages/pokedex_screen.dart
class PokedexScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPokemons = ref.watch(pokemonListProvider);

    return asyncPokemons.when(
      data: (pokemons) => ListView.builder(
        itemCount: pokemons.length,
        itemBuilder: (context, index) {
          final pokemon = pokemons[index];
          return ListTile(
            title: Text(pokemon.displayName),
            subtitle: Text('#${pokemon.paddedId}'),
            leading: Image.network(pokemon.spriteUrl),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
```

### 4. Paginación

```dart
@riverpod
class PaginatedPokemonList extends _$PaginatedPokemonList {
  int _currentPage = 0;

  @override
  Future<List<PokemonEntity>> build() async {
    return _fetchPage(0);
  }

  Future<void> loadMore() async {
    final useCase = ref.read(getPokemonListUseCaseProvider);
    _currentPage++;

    final result = await useCase.fetchPage(page: _currentPage, pageSize: 20);

    result.when(
      success: (newPokemons) {
        state = AsyncData([...state.value ?? [], ...newPokemons]);
      },
      failure: (error) {
        state = AsyncError(error, StackTrace.current);
      },
    );
  }

  Future<List<PokemonEntity>> _fetchPage(int page) async {
    final useCase = ref.read(getPokemonListUseCaseProvider);
    final result = await useCase.fetchPage(page: page, pageSize: 20);

    return result.when(
      success: (pokemons) => pokemons,
      failure: (error) => throw Exception(error.message),
    );
  }
}
```

## Métodos Disponibles

### 1. `call()` - Método Principal

```dart
final useCase = GetPokemonList(repository);

// Fetch con parámetros personalizados
final result = await useCase(limit: 50, offset: 0);

result.when(
  success: (pokemons) => print('Fetched ${pokemons.length} Pokemon'),
  failure: (error) => print('Error: $error'),
);
```

### 2. `fetchFirstPage()` - Primera Página

```dart
// Atajo para obtener los primeros 20 Pokemon
final result = await useCase.fetchFirstPage();
```

### 3. `fetchPage()` - Paginación

```dart
// Obtener página específica
final page2 = await useCase.fetchPage(page: 1, pageSize: 20); // Pokemon 21-40
final page3 = await useCase.fetchPage(page: 2, pageSize: 20); // Pokemon 41-60
```

### 4. `fetchAll()` - Todos los Pokemon

```dart
// ⚠️ Puede ser lento - usa con precaución
final allGen1 = await useCase.fetchAll(maxCount: 151);
```

## Validación de Inputs

El caso de uso valida automáticamente los parámetros:

```dart
// ❌ limit negativo → se corrige a 20
await useCase(limit: -10);  // Usará limit: 20

// ❌ limit muy grande → se limita a 100
await useCase(limit: 1000); // Usará limit: 100

// ❌ offset negativo → se corrige a 0
await useCase(offset: -5);  // Usará offset: 0
```

## Manejo de Errores con Result

El tipo `Result` permite manejar errores de forma type-safe:

```dart
final result = await useCase.fetchFirstPage();

// Patrón when (exhaustivo)
result.when(
  success: (pokemons) {
    // Manejar caso exitoso
    print('Got ${pokemons.length} Pokemon');
  },
  failure: (error) {
    // Manejar errores
    if (error is NetworkFailure) {
      print('No internet connection');
    } else if (error is ServerFailure) {
      print('Server error: ${error.statusCode}');
    }
  },
);

// Obtener valor o lanzar excepción
try {
  final pokemons = result.value; // Lanza si es Failure
} catch (e) {
  print(e);
}

// Obtener valor o null
final pokemons = result.valueOrNull; // null si es Failure

// Obtener valor o default
final pokemons = result.getOrElse(() => <PokemonEntity>[]);

// Mapear resultado
final names = result.map((pokemons) => pokemons.map((p) => p.name).toList());

// Encadenar operaciones
final result2 = result.flatMap((pokemons) async {
  // Hacer algo más con los pokemons...
  return Result.success(processedData);
});
```

## Testing

```dart
// test/domain/usecases/get_pokemon_list_test.dart
void main() {
  late MockPokemonRepository mockRepository;
  late GetPokemonList useCase;

  setUp(() {
    mockRepository = MockPokemonRepository();
    useCase = GetPokemonList(mockRepository);
  });

  group('GetPokemonList', () {
    test('should return list of Pokemon when repository succeeds', () async {
      // Arrange
      final mockPokemons = [
        PokemonEntity(id: 1, name: 'bulbasaur', types: ['grass', 'poison']),
        PokemonEntity(id: 2, name: 'ivysaur', types: ['grass', 'poison']),
      ];
      when(() => mockRepository.getPokemonList(limit: 20, offset: 0))
          .thenAnswer((_) async => Result.success(mockPokemons));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isSuccess, true);
      expect(result.value.length, 2);
      expect(result.value.first.name, 'bulbasaur');
    });

    test('should return NetworkFailure when repository fails', () async {
      // Arrange
      when(() => mockRepository.getPokemonList(limit: 20, offset: 0))
          .thenAnswer((_) async => Result.failure(NetworkFailure()));

      // Act
      final result = await useCase();

      // Assert
      expect(result.isFailure, true);
      expect(result.failure, isA<NetworkFailure>());
    });

    test('should validate and cap limit at 100', () async {
      // Arrange
      when(() => mockRepository.getPokemonList(limit: 100, offset: 0))
          .thenAnswer((_) async => Result.success([]));

      // Act
      await useCase(limit: 1000); // Intentar con 1000

      // Assert
      verify(() => mockRepository.getPokemonList(limit: 100, offset: 0)).called(1);
    });
  });
}
```

## Próximos Pasos

1. **Implementar el Repository**
   - Crear `PokemonRepositoryImpl` en la capa de datos
   - Implementar `PokemonRemoteDataSource` con Dio
   - Crear DTOs y mappers

2. **Crear Providers de Riverpod**
   - Provider del repositorio
   - Provider del caso de uso
   - Provider del estado de la lista

3. **Actualizar UI**
   - Migrar `pokemon_provider.dart` actual para usar el caso de uso
   - Actualizar widgets para usar `PokemonEntity`

4. **Añadir Tests**
   - Tests unitarios para el caso de uso
   - Tests de integración con el repositorio mock
