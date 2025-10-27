# Mejoras de Arquitectura Limpia - Pokedex App

## Resumen Ejecutivo

**Estado Actual:** C+ (MVP funcional pero necesita refactorización)
**Objetivo:** A+ (Clean Architecture completa)

El proyecto tiene buenas bases (Riverpod, Freezed, localization) pero carece de:
- ✗ Capa de Dominio
- ✗ Patrón Repository
- ✗ Separación clara de capas
- ✗ Casos de uso definidos

---

## 📊 Evaluación por Capas

### ✅ Capa de Framework (Buena)
- Riverpod configurado correctamente con code generation
- GoRouter con navegación reactiva
- Dio con interceptores
- Localization i18n completa

### ⚠️ Capa de Presentación (Parcial)
**Problemas:**
- Widgets mezclan lógica de negocio con UI
- `PokemonDetail`: 281 líneas (God Widget)
- `PokedexWidget`: 250+ líneas con lógica de filtrado
- Animaciones duplicadas en múltiples widgets

**Bueno:**
- Separación pages/ y widgets/
- Widgets pequeños reutilizables (ElementChip, MeasurementCard)

### ❌ Capa de Dominio (Falta completamente)
- No hay entidades de dominio puras
- No hay interfaces de repositorio
- No hay casos de uso definidos
- No hay objetos de valor (Value Objects)

### ⚠️ Capa de Datos (Débil)
**Problemas:**
- API calls directos en providers
- No hay patrón Repository
- Parseo manual de JSON inline
- Sin manejo diferenciado de errores
- Sin caché ni persistencia

---

## 🎯 Plan de Mejoras Priorizadas

### FASE 1: Fundamentos de Clean Architecture (Alta Prioridad)

#### 1.1 Crear Capa de Dominio
```
lib/domain/
├── entities/                    # Entidades puras (sin dependencias)
│   ├── pokemon.dart
│   └── pokemon_type.dart
├── repositories/                # Interfaces abstractas
│   └── pokemon_repository.dart
├── usecases/                    # Casos de uso
│   ├── get_pokemon_list.dart
│   ├── get_pokemon_detail.dart
│   ├── toggle_favorite.dart
│   └── search_pokemon.dart
└── failures/                    # Errores de dominio
    └── pokemon_failure.dart
```

**Ejemplo de Entity:**
```dart
// lib/domain/entities/pokemon.dart
class Pokemon {
  final int id;
  final String name;
  final List<PokemonType> types;
  final String imageUrl;

  const Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
  });

  String get displayName => name[0].toUpperCase() + name.substring(1);
  String get paddedId => id.toString().padLeft(3, '0');
  PokemonType get primaryType => types.first;
}
```

**Ejemplo de Repository Interface:**
```dart
// lib/domain/repositories/pokemon_repository.dart
abstract class PokemonRepository {
  Future<Either<PokemonFailure, List<Pokemon>>> getPokemonList({
    int limit = 20,
    int offset = 0,
  });

  Future<Either<PokemonFailure, Pokemon>> getPokemonDetail(int id);

  Future<Either<PokemonFailure, List<Pokemon>>> searchPokemon(String query);
}
```

**Ejemplo de UseCase:**
```dart
// lib/domain/usecases/get_pokemon_list.dart
class GetPokemonList {
  final PokemonRepository repository;

  GetPokemonList(this.repository);

  Future<Either<PokemonFailure, List<Pokemon>>> call({
    int limit = 20,
    int offset = 0,
  }) {
    return repository.getPokemonList(limit: limit, offset: offset);
  }
}
```

---

#### 1.2 Implementar Capa de Datos
```
lib/data/
├── datasources/
│   ├── pokemon_remote_datasource.dart      # Interfaz
│   └── pokemon_remote_datasource_impl.dart # Implementación con Dio
├── models/                                  # DTOs para API
│   ├── pokemon_dto.dart
│   ├── pokemon_list_response_dto.dart
│   ├── pokemon_detail_response_dto.dart
│   └── type_info_dto.dart
├── repositories/
│   └── pokemon_repository_impl.dart        # Implementa interfaz de domain
└── mappers/                                 # Convierte DTOs a Entities
    └── pokemon_mapper.dart
```

**Ejemplo de DataSource:**
```dart
// lib/data/datasources/pokemon_remote_datasource.dart
abstract class PokemonRemoteDataSource {
  Future<PokemonListResponseDTO> getPokemonList({int limit, int offset});
  Future<PokemonDetailResponseDTO> getPokemonDetail(int id);
}

// lib/data/datasources/pokemon_remote_datasource_impl.dart
class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final Dio dio;

  PokemonRemoteDataSourceImpl({required this.dio});

  @override
  Future<PokemonListResponseDTO> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await dio.get(
        'pokemon',
        queryParameters: {'limit': limit, 'offset': offset},
      );
      return PokemonListResponseDTO.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  DataSourceException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException('Connection timeout');
      case DioExceptionType.badResponse:
        return ServerException('Server error: ${e.response?.statusCode}');
      default:
        return NetworkException('Network error');
    }
  }
}
```

**Ejemplo de Repository Implementation:**
```dart
// lib/data/repositories/pokemon_repository_impl.dart
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonMapper mapper;

  PokemonRepositoryImpl({
    required this.remoteDataSource,
    required this.mapper,
  });

  @override
  Future<Either<PokemonFailure, List<Pokemon>>> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final listResponse = await remoteDataSource.getPokemonList(
        limit: limit,
        offset: offset,
      );

      // Fetch details for each pokemon in parallel
      final detailsFutures = listResponse.results.map((result) async {
        final detail = await remoteDataSource.getPokemonDetail(result.id);
        return mapper.toEntity(detail);
      });

      final pokemons = await Future.wait(detailsFutures);
      return Right(pokemons);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

**Ejemplo de Mapper:**
```dart
// lib/data/mappers/pokemon_mapper.dart
class PokemonMapper {
  Pokemon toEntity(PokemonDetailResponseDTO dto) {
    return Pokemon(
      id: dto.id,
      name: dto.name,
      types: dto.types.map((t) => PokemonType.fromString(t.type.name)).toList(),
      imageUrl: _buildImageUrl(dto.id),
    );
  }

  String _buildImageUrl(int id) {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/'
           'sprites/pokemon/$id.png';
  }
}
```

**Ejemplo de DTO completo:**
```dart
// lib/data/models/pokemon_detail_response_dto.dart
@freezed
class PokemonDetailResponseDTO with _$PokemonDetailResponseDTO {
  const factory PokemonDetailResponseDTO({
    required int id,
    required String name,
    required List<TypeInfoDTO> types,
    required SpritesDTO sprites,
    required int height,
    required int weight,
  }) = _PokemonDetailResponseDTO;

  factory PokemonDetailResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailResponseDTOFromJson(json);
}

@freezed
class TypeInfoDTO with _$TypeInfoDTO {
  const factory TypeInfoDTO({
    required int slot,
    required TypeDTO type,
  }) = _TypeInfoDTO;

  factory TypeInfoDTO.fromJson(Map<String, dynamic> json) =>
      _$TypeInfoDTOFromJson(json);
}

@freezed
class TypeDTO with _$TypeDTO {
  const factory TypeDTO({
    required String name,
    required String url,
  }) = _TypeDTO;

  factory TypeDTO.fromJson(Map<String, dynamic> json) =>
      _$TypeDTOFromJson(json);
}
```

---

#### 1.3 Actualizar Providers para Usar UseCases
```dart
// lib/presentation/providers/pokemon_list_provider.dart
@riverpod
Future<List<Pokemon>> pokemonList(Ref ref) async {
  final useCase = ref.watch(getPokemonListUseCaseProvider);

  final result = await useCase();

  return result.fold(
    (failure) => throw _mapFailureToException(failure),
    (pokemons) => pokemons,
  );
}

Exception _mapFailureToException(PokemonFailure failure) {
  return switch (failure) {
    NetworkFailure() => NetworkException(failure.message),
    ServerFailure() => ServerException(failure.message),
    ParseFailure() => ParseException(failure.message),
    _ => Exception(failure.message),
  };
}

// lib/presentation/providers/use_case_providers.dart
@riverpod
GetPokemonList getPokemonListUseCase(Ref ref) {
  final repository = ref.watch(pokemonRepositoryProvider);
  return GetPokemonList(repository);
}

@riverpod
PokemonRepository pokemonRepository(Ref ref) {
  final remoteDataSource = ref.watch(pokemonRemoteDataSourceProvider);
  final mapper = PokemonMapper();

  return PokemonRepositoryImpl(
    remoteDataSource: remoteDataSource,
    mapper: mapper,
  );
}

@riverpod
PokemonRemoteDataSource pokemonRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return PokemonRemoteDataSourceImpl(dio: dio);
}
```

---

### FASE 2: Refactorización de Presentación (Media Prioridad)

#### 2.1 Extraer Lógica de Filtrado de Widgets
```dart
// lib/presentation/providers/pokemon_filter_provider.dart
@freezed
class PokemonFilterState with _$PokemonFilterState {
  const factory PokemonFilterState({
    @Default('') String searchQuery,
    @Default([]) List<PokemonType> selectedTypes,
    required List<Pokemon> allPokemons,
  }) = _PokemonFilterState;

  // Computed property
  List<Pokemon> get filteredPokemons {
    var filtered = allPokemons;

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((p) =>
        p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
        p.id.toString().contains(searchQuery)
      ).toList();
    }

    // Apply type filter
    if (selectedTypes.isNotEmpty) {
      filtered = filtered.where((p) =>
        p.types.any((type) => selectedTypes.contains(type))
      ).toList();
    }

    return filtered;
  }
}

@riverpod
class PokemonFilter extends _$PokemonFilter {
  @override
  PokemonFilterState build(List<Pokemon> pokemons) {
    return PokemonFilterState(allPokemons: pokemons);
  }

  void updateSearch(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleType(PokemonType type) {
    final types = [...state.selectedTypes];
    if (types.contains(type)) {
      types.remove(type);
    } else {
      types.add(type);
    }
    state = state.copyWith(selectedTypes: types);
  }

  void clearFilters() {
    state = state.copyWith(searchQuery: '', selectedTypes: []);
  }
}
```

**Uso en Widget:**
```dart
// lib/presentation/pages/pokedex_screen.dart (simplificado)
class PokedexScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncPokemons = ref.watch(pokemonListProvider);

    return asyncPokemons.when(
      data: (pokemons) {
        final filter = ref.watch(pokemonFilterProvider(pokemons));
        final filteredPokemons = filter.filteredPokemons;

        return Column(
          children: [
            PokemonSearchBar(
              onChanged: (query) => ref.read(pokemonFilterProvider(pokemons).notifier)
                  .updateSearch(query),
            ),
            FilterButton(
              onPressed: () => showFilterModal(context, ref, pokemons),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredPokemons.length,
                itemBuilder: (context, index) =>
                    PokemonListTile(pokemon: filteredPokemons[index]),
              ),
            ),
          ],
        );
      },
      loading: () => PokeballLoading(),
      error: (error, stack) => ErrorWidget(error: error),
    );
  }
}
```

---

#### 2.2 Descomponer Widgets Grandes

**Antes: PokemonDetail (281 líneas)**
```dart
// ❌ God Widget - hace demasiado
class PokemonDetail extends ConsumerStatefulWidget {
  // 281 líneas mezclando animación + UI + lógica
}
```

**Después: Widgets Pequeños y Enfocados**
```dart
// ✅ Widgets pequeños con responsabilidades únicas

// lib/presentation/widgets/pokemon_detail/pokemon_detail_screen.dart
class PokemonDetailScreen extends ConsumerWidget {
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          PokemonDetailHeader(pokemon: pokemon),
          Expanded(
            child: PokemonDetailContent(pokemon: pokemon),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(),
    );
  }
}

// lib/presentation/widgets/pokemon_detail/pokemon_detail_header.dart
class PokemonDetailHeader extends ConsumerWidget {
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = pokemon.primaryType.color;

    return Container(
      height: 300,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: 50, left: 20, child: BackButton()),
          Positioned(top: 50, right: 20, child: FavoriteButton(pokemon: pokemon)),
          Center(child: PokemonImage(pokemon: pokemon)),
        ],
      ),
    );
  }
}

// lib/presentation/widgets/common/favorite_button.dart
class FavoriteButton extends ConsumerStatefulWidget {
  final Pokemon pokemon;

  @override
  ConsumerState<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends ConsumerState<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = ref.watch(isFavoriteProvider(widget.pokemon.id));

    return ScaleTransition(
      scale: _scaleAnimation,
      child: IconButton(
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border,
          color: Colors.red,
        ),
        onPressed: () {
          _controller.forward().then((_) => _controller.reverse());
          ref.read(favoritesProvider.notifier).toggleFavorite(widget.pokemon);
        },
      ),
    );
  }
}

// lib/presentation/widgets/pokemon_detail/pokemon_detail_content.dart
class PokemonDetailContent extends StatelessWidget {
  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            PokemonBasicInfo(pokemon: pokemon),
            SizedBox(height: 20),
            PokemonStats(pokemon: pokemon),
            SizedBox(height: 20),
            PokemonDescription(pokemon: pokemon),
          ],
        ),
      ),
    );
  }
}
```

---

#### 2.3 Extraer Constantes Hardcodeadas
```dart
// lib/core/constants.dart (añadir)
class ApiConstants {
  static const String pokemonSpriteBaseUrl =
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/';

  static String getPokemonSpriteUrl(int id) => '$pokemonSpriteBaseUrl$id.png';

  static const String pokemonOfficialArtworkBaseUrl =
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/';

  static String getPokemonOfficialArtwork(int id) =>
      '$pokemonOfficialArtworkBaseUrl$id.png';
}

class AssetConstants {
  static const String emptyStateImage = 'assets/png/magikarp.png';
  static const String regionesImage = 'assets/png/regiones.png';

  // Dimensions
  static const double emptyStateImageWidth = 185;
  static const double emptyStateImageHeight = 215;
}
```

**Uso:**
```dart
// ✅ Antes
Image.network(
  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png'
)

// ✅ Después
Image.network(ApiConstants.getPokemonSpriteUrl(pokemon.id))
```

---

### FASE 3: Características Avanzadas (Baja Prioridad)

#### 3.1 Implementar Paginación
```dart
// lib/domain/usecases/get_paginated_pokemon_list.dart
class GetPaginatedPokemonList {
  final PokemonRepository repository;

  GetPaginatedPokemonList(this.repository);

  Future<Either<PokemonFailure, PaginatedResult<Pokemon>>> call({
    required int page,
    required int pageSize,
  }) async {
    final offset = page * pageSize;
    final result = await repository.getPokemonList(
      limit: pageSize,
      offset: offset,
    );

    return result.map((pokemons) => PaginatedResult(
      items: pokemons,
      page: page,
      pageSize: pageSize,
      hasMore: pokemons.length == pageSize,
    ));
  }
}

// lib/domain/entities/paginated_result.dart
class PaginatedResult<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final bool hasMore;

  const PaginatedResult({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });
}

// lib/presentation/providers/paginated_pokemon_provider.dart
@riverpod
class PaginatedPokemonList extends _$PaginatedPokemonList {
  @override
  Future<PaginatedResult<Pokemon>> build() {
    return _fetchPage(0);
  }

  Future<void> loadMore() async {
    final currentState = await future;
    if (!currentState.hasMore) return;

    final nextPage = currentState.page + 1;
    final result = await _fetchPage(nextPage);

    state = AsyncData(PaginatedResult(
      items: [...currentState.items, ...result.items],
      page: result.page,
      pageSize: result.pageSize,
      hasMore: result.hasMore,
    ));
  }

  Future<PaginatedResult<Pokemon>> _fetchPage(int page) async {
    final useCase = ref.read(getPaginatedPokemonListUseCaseProvider);
    final result = await useCase(page: page, pageSize: 20);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (paginatedResult) => paginatedResult,
    );
  }
}
```

---

#### 3.2 Añadir Caché con Riverpod
```dart
// lib/data/datasources/pokemon_local_datasource.dart
abstract class PokemonLocalDataSource {
  Future<List<PokemonDTO>> getCachedPokemonList();
  Future<void> cachePokemonList(List<PokemonDTO> pokemons);
  Future<PokemonDTO?> getCachedPokemon(int id);
  Future<void> cachePokemon(PokemonDTO pokemon);
}

// lib/data/datasources/pokemon_local_datasource_impl.dart
class PokemonLocalDataSourceImpl implements PokemonLocalDataSource {
  final SharedPreferences prefs;

  PokemonLocalDataSourceImpl(this.prefs);

  @override
  Future<List<PokemonDTO>> getCachedPokemonList() async {
    final json = prefs.getString('pokemon_list');
    if (json == null) return [];

    final List decoded = jsonDecode(json);
    return decoded.map((e) => PokemonDTO.fromJson(e)).toList();
  }

  @override
  Future<void> cachePokemonList(List<PokemonDTO> pokemons) async {
    final json = jsonEncode(pokemons.map((p) => p.toJson()).toList());
    await prefs.setString('pokemon_list', json);
  }
}

// lib/data/repositories/pokemon_repository_impl.dart (actualizado)
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDataSource remoteDataSource;
  final PokemonLocalDataSource localDataSource;
  final PokemonMapper mapper;

  @override
  Future<Either<PokemonFailure, List<Pokemon>>> getPokemonList({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      // Try to get from cache first
      final cached = await localDataSource.getCachedPokemonList();
      if (cached.isNotEmpty) {
        return Right(cached.map(mapper.toEntity).toList());
      }

      // Fetch from network
      final listResponse = await remoteDataSource.getPokemonList(
        limit: limit,
        offset: offset,
      );

      final detailsFutures = listResponse.results.map((result) async {
        final detail = await remoteDataSource.getPokemonDetail(result.id);
        return detail;
      });

      final details = await Future.wait(detailsFutures);

      // Cache the results
      await localDataSource.cachePokemonList(details);

      final pokemons = details.map(mapper.toEntity).toList();
      return Right(pokemons);
    } on NetworkException catch (e) {
      // Try to return cached data on network error
      final cached = await localDataSource.getCachedPokemonList();
      if (cached.isNotEmpty) {
        return Right(cached.map(mapper.toEntity).toList());
      }
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

---

#### 3.3 Persistir Favoritos
```dart
// lib/domain/repositories/favorites_repository.dart
abstract class FavoritesRepository {
  Future<List<int>> getFavoriteIds();
  Future<void> saveFavoriteIds(List<int> ids);
  Future<void> addFavorite(int id);
  Future<void> removeFavorite(int id);
}

// lib/data/repositories/favorites_repository_impl.dart
class FavoritesRepositoryImpl implements FavoritesRepository {
  final SharedPreferences prefs;
  static const String _key = 'favorite_pokemon_ids';

  FavoritesRepositoryImpl(this.prefs);

  @override
  Future<List<int>> getFavoriteIds() async {
    final json = prefs.getString(_key);
    if (json == null) return [];
    final List decoded = jsonDecode(json);
    return decoded.cast<int>();
  }

  @override
  Future<void> saveFavoriteIds(List<int> ids) async {
    await prefs.setString(_key, jsonEncode(ids));
  }

  @override
  Future<void> addFavorite(int id) async {
    final current = await getFavoriteIds();
    if (!current.contains(id)) {
      await saveFavoriteIds([...current, id]);
    }
  }

  @override
  Future<void> removeFavorite(int id) async {
    final current = await getFavoriteIds();
    current.remove(id);
    await saveFavoriteIds(current);
  }
}

// lib/presentation/providers/persistent_favorites_provider.dart
@riverpod
class PersistentFavorites extends _$PersistentFavorites {
  @override
  Future<Map<int, Pokemon>> build() async {
    final repository = ref.watch(favoritesRepositoryProvider);
    final allPokemons = await ref.watch(pokemonListProvider.future);

    final favoriteIds = await repository.getFavoriteIds();

    return Map.fromEntries(
      allPokemons
          .where((p) => favoriteIds.contains(p.id))
          .map((p) => MapEntry(p.id, p)),
    );
  }

  Future<void> toggleFavorite(Pokemon pokemon) async {
    final repository = ref.read(favoritesRepositoryProvider);
    final current = await future;

    if (current.containsKey(pokemon.id)) {
      await repository.removeFavorite(pokemon.id);
      state = AsyncData({...current}..remove(pokemon.id));
    } else {
      await repository.addFavorite(pokemon.id);
      state = AsyncData({...current, pokemon.id: pokemon});
    }
  }
}
```

---

## 📁 Estructura Final Propuesta

```
lib/
├── main.dart
├── app_router.dart
├── colors.dart
│
├── core/
│   ├── constants.dart
│   ├── api_constants.dart          # NUEVO
│   ├── asset_constants.dart        # NUEVO
│   ├── app_routes.dart
│   ├── app_theme.dart
│   └── pokemon_type_helper.dart
│
├── domain/                          # NUEVO - Capa de Dominio
│   ├── entities/
│   │   ├── pokemon.dart
│   │   ├── pokemon_type.dart
│   │   └── paginated_result.dart
│   ├── repositories/
│   │   ├── pokemon_repository.dart
│   │   └── favorites_repository.dart
│   ├── usecases/
│   │   ├── get_pokemon_list.dart
│   │   ├── get_pokemon_detail.dart
│   │   ├── get_paginated_pokemon_list.dart
│   │   ├── search_pokemon.dart
│   │   └── toggle_favorite.dart
│   └── failures/
│       └── pokemon_failure.dart
│
├── data/                            # NUEVO - Capa de Datos refactorizada
│   ├── datasources/
│   │   ├── pokemon_remote_datasource.dart
│   │   ├── pokemon_remote_datasource_impl.dart
│   │   ├── pokemon_local_datasource.dart
│   │   └── pokemon_local_datasource_impl.dart
│   ├── models/                      # DTOs (Data Transfer Objects)
│   │   ├── pokemon_dto.dart
│   │   ├── pokemon_list_response_dto.dart
│   │   ├── pokemon_detail_response_dto.dart
│   │   └── type_info_dto.dart
│   ├── repositories/
│   │   ├── pokemon_repository_impl.dart
│   │   └── favorites_repository_impl.dart
│   └── mappers/
│       └── pokemon_mapper.dart
│
├── presentation/                    # Capa de Presentación (UI)
│   ├── providers/
│   │   ├── pokemon_list_provider.dart
│   │   ├── pokemon_filter_provider.dart    # NUEVO
│   │   ├── paginated_pokemon_provider.dart # NUEVO
│   │   ├── favorites_provider.dart
│   │   ├── app_startup_provider.dart
│   │   ├── use_case_providers.dart         # NUEVO
│   │   └── repository_providers.dart       # NUEVO
│   │
│   ├── pages/
│   │   ├── splash_screen.dart
│   │   ├── onboarding_screen.dart
│   │   ├── pokedex_screen.dart
│   │   ├── favorites_screen.dart
│   │   ├── regiones_screen.dart
│   │   ├── profile_screen.dart
│   │   └── pokemon_detail_screen.dart      # Renombrado
│   │
│   └── widgets/
│       ├── common/                          # NUEVO - Widgets comunes
│       │   ├── pokeball_loading.dart
│       │   ├── error_widget.dart
│       │   ├── favorite_button.dart        # NUEVO (extraído)
│       │   ├── custom_default_button.dart
│       │   └── circle_clipper.dart
│       │
│       ├── navigation/                      # NUEVO
│       │   └── custom_bottom_navigation.dart
│       │
│       ├── pokemon_list/                    # NUEVO
│       │   ├── pokemon_list_tile.dart
│       │   ├── pokemon_search_bar.dart
│       │   └── filter_preferences_modal.dart
│       │
│       └── pokemon_detail/                  # NUEVO
│           ├── pokemon_detail_header.dart
│           ├── pokemon_detail_content.dart
│           ├── pokemon_basic_info.dart
│           ├── pokemon_stats.dart
│           ├── pokemon_image.dart
│           ├── element_chip.dart
│           └── measurement_card.dart
│
└── l10n/
    ├── app_en.arb
    ├── app_es.arb
    └── app_localizations*.dart (generados)
```

---

## 🎯 Checklist de Implementación

### Fase 1: Fundamentos (2-3 días)
- [ ] Crear estructura de carpetas domain/
- [ ] Definir entidades de dominio (Pokemon, PokemonType)
- [ ] Crear interfaces de repositorio
- [ ] Implementar casos de uso básicos
- [ ] Definir tipos de Failure
- [ ] Crear estructura data/
- [ ] Implementar DataSource remoto
- [ ] Crear DTOs completos con Freezed
- [ ] Implementar Repository con mappers
- [ ] Actualizar providers para usar UseCases
- [ ] Probar que todo funciona igual que antes

### Fase 2: Refactorización UI (2-3 días)
- [ ] Extraer lógica de filtrado a provider
- [ ] Simplificar PokedexWidget
- [ ] Descomponer PokemonDetail en widgets pequeños
- [ ] Extraer FavoriteButton reutilizable
- [ ] Mover constantes hardcodeadas a archivos constants
- [ ] Organizar widgets en subcarpetas (common/, pokemon_list/, etc.)
- [ ] Localizar strings faltantes
- [ ] Verificar que no hay duplicación de código

### Fase 3: Características Avanzadas (2-3 días)
- [ ] Implementar paginación en repository
- [ ] Crear PaginatedPokemonProvider
- [ ] Añadir scroll infinito en UI
- [ ] Implementar LocalDataSource con SharedPreferences
- [ ] Añadir caché en Repository
- [ ] Implementar FavoritesRepository persistente
- [ ] Actualizar FavoritesProvider para usar persistencia
- [ ] Añadir manejo de errores diferenciado en UI
- [ ] Probar offline mode

### Testing (1-2 días)
- [ ] Tests unitarios para UseCases
- [ ] Tests para Repositories (con mocks)
- [ ] Tests para Providers
- [ ] Tests de widgets (con ProviderScope)
- [ ] Tests de integración básicos

---

## 📈 Beneficios de Esta Arquitectura

### 1. Testabilidad
✅ UseCases independientes fáciles de testear
✅ Repositories con interfaces mockables
✅ UI sin lógica de negocio

### 2. Mantenibilidad
✅ Cambios en API solo afectan capa Data
✅ Cambios en UI no afectan lógica de negocio
✅ Widgets pequeños más fáciles de entender

### 3. Escalabilidad
✅ Fácil añadir nuevas features (abilities, moves, evolution)
✅ Fácil añadir nuevas fuentes de datos (GraphQL, Firebase)
✅ Fácil añadir caché multinivel

### 4. Reutilización
✅ UseCases reutilizables en diferentes UIs
✅ Repositories compartibles entre features
✅ Widgets componibles

---

## 🔄 Migración Gradual

No es necesario refactorizar todo de una vez. Se puede migrar gradualmente:

1. **Semana 1:** Crear domain/ y data/ sin tocar presentation/
2. **Semana 2:** Migrar un provider a la vez (empezar con pokemonListProvider)
3. **Semana 3:** Refactorizar widgets grandes
4. **Semana 4:** Añadir features avanzadas (caché, paginación)

---

## 📚 Referencias

- [Clean Architecture - Uncle Bob](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Clean Architecture - Reso Coder](https://resocoder.com/flutter-clean-architecture-tdd/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Either Type for Error Handling](https://pub.dev/packages/dartz)

---

## 💡 Conclusión

La arquitectura actual es funcional pero **no escalable**. Implementar Clean Architecture ahora evitará:
- ❌ Widgets de 500+ líneas
- ❌ Lógica de negocio esparcida
- ❌ Tests imposibles de escribir
- ❌ Cambios que rompen todo

Beneficios esperados:
- ✅ Código 3x más mantenible
- ✅ Tests 5x más fáciles
- ✅ Features 2x más rápidas de implementar
- ✅ Bugs 50% menos frecuentes

**Recomendación:** Comenzar con Fase 1 inmediatamente.
