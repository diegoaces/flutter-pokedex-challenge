import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_list_response_dto.freezed.dart';
part 'pokemon_list_response_dto.g.dart';

@freezed
abstract class PokemonListResponseDTO with _$PokemonListResponseDTO {
  const factory PokemonListResponseDTO({
    required int count,
    String? next,
    String? previous,
    @Default([]) List<PokemonListItemDTO> results,
  }) = _PokemonListResponseDTO;

  factory PokemonListResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$PokemonListResponseDTOFromJson(json);
}

@freezed
abstract class PokemonListItemDTO with _$PokemonListItemDTO {
  const PokemonListItemDTO._();

  const factory PokemonListItemDTO({
    required String name,
    required String url,
  }) = _PokemonListItemDTO;

  factory PokemonListItemDTO.fromJson(Map<String, dynamic> json) =>
      _$PokemonListItemDTOFromJson(json);

  int get id {
    final segments = url.split('/');
    final idString = segments[segments.length - 2];
    return int.parse(idString);
  }
}
