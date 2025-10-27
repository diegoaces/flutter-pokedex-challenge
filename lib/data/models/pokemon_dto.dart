import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_dto.freezed.dart';
part 'pokemon_dto.g.dart';

@freezed
abstract class PokemonDTO with _$PokemonDTO {
  const factory PokemonDTO({
    required int id,
    required String name,
    @Default([]) List<String> types,
  }) = _PokemonDTO;

  factory PokemonDTO.fromJson(Map<String, dynamic> json) =>
      _$PokemonDTOFromJson(json);
}
