/// Domain entity for Pokemon.
/// This is a pure business logic class with no dependencies on external packages.
/// It differs from the data layer's Pokemon model which includes Freezed/JSON serialization.
class PokemonEntity {
  final int id;
  final String name;
  final List<String> types;

  const PokemonEntity({
    required this.id,
    required this.name,
    required this.types,
  });

  /// Returns the Pokemon name with the first letter capitalized.
  String get displayName {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  /// Returns the Pokemon ID padded with leading zeros (e.g., "001", "025").
  String get paddedId => id.toString().padLeft(3, '0');

  /// Returns the primary type (first type in the list).
  String get primaryType => types.isNotEmpty ? types.first : '';

  /// Returns the URL for the Pokemon's official sprite image.
  String get spriteUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  /// Returns the URL for the Pokemon's official artwork.
  String get officialArtworkUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  /// Checks if the Pokemon has multiple types.
  bool get hasMultipleTypes => types.length > 1;

  /// Checks if the Pokemon has a specific type.
  bool hasType(String type) => types.contains(type.toLowerCase());

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PokemonEntity(id: $id, name: $name, types: $types)';

  /// Creates a copy of this Pokemon with the given fields replaced.
  PokemonEntity copyWith({
    int? id,
    String? name,
    List<String>? types,
  }) {
    return PokemonEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      types: types ?? this.types,
    );
  }
}
