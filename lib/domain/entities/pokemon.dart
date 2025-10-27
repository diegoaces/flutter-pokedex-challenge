class Pokemon {
  final int id;
  final String name;
  final List<String> types;

  Pokemon({required this.id, required this.name, required this.types});

  String displayName() {
    if (name.isEmpty) return name;
    return '${name[0].toUpperCase()}${name.substring(1)}';
  }

  String displayNumber() {
    return id.toString().padLeft(3, '0');
  }
}
