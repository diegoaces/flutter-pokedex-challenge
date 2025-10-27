class PokemonEntity {
  final int id;
  final String name;
  final List<String> types;

  const PokemonEntity({
    required this.id,
    required this.name,
    required this.types,
  });

  String get displayName {
    if (name.isEmpty) return name;
    return name[0].toUpperCase() + name.substring(1);
  }

  String get paddedId => id.toString().padLeft(3, '0');

  String get primaryType => types.isNotEmpty ? types.first : '';

  String get spriteUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';

  String get officialArtworkUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';

  bool get hasMultipleTypes => types.length > 1;

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

  PokemonEntity copyWith({int? id, String? name, List<String>? types}) {
    return PokemonEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      types: types ?? this.types,
    );
  }
}
