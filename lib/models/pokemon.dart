import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon.freezed.dart';
part 'pokemon.g.dart';

@freezed
abstract class Pokemon with _$Pokemon {
  const Pokemon._();

  const factory Pokemon({required int id, required String name}) = _Pokemon;

  factory Pokemon.fromJson(Map<String, dynamic> json) =>
      _$PokemonFromJson(json);

  String nameCapitalizedFirstLetter() {
    if (name.isEmpty) return name;
    return '${name[0].toUpperCase()}${name.substring(1)}';
  }
  String idWithLeadingZeros() {
    return id.toString().padLeft(3, '0');
  }
}
