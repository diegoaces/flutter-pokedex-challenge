import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_detail_response_dto.freezed.dart';
part 'pokemon_detail_response_dto.g.dart';

@freezed
abstract class PokemonDetailResponseDTO with _$PokemonDetailResponseDTO {
  const factory PokemonDetailResponseDTO({
    required int id,
    required String name,
    @Default([]) List<TypeSlotDTO> types,
    SpritesDTO? sprites,
    int? height,
    int? weight,
  }) = _PokemonDetailResponseDTO;

  factory PokemonDetailResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$PokemonDetailResponseDTOFromJson(json);
}

@freezed
abstract class TypeSlotDTO with _$TypeSlotDTO {
  const factory TypeSlotDTO({required int slot, required TypeInfoDTO type}) =
      _TypeSlotDTO;

  factory TypeSlotDTO.fromJson(Map<String, dynamic> json) =>
      _$TypeSlotDTOFromJson(json);
}

@freezed
abstract class TypeInfoDTO with _$TypeInfoDTO {
  const factory TypeInfoDTO({required String name, required String url}) =
      _TypeInfoDTO;

  factory TypeInfoDTO.fromJson(Map<String, dynamic> json) =>
      _$TypeInfoDTOFromJson(json);
}

@freezed
abstract class SpritesDTO with _$SpritesDTO {
  const factory SpritesDTO({
    @JsonKey(name: 'front_default') String? frontDefault,
    @JsonKey(name: 'front_shiny') String? frontShiny,
    @JsonKey(name: 'back_default') String? backDefault,
    @JsonKey(name: 'back_shiny') String? backShiny,
    OtherSpritesDTO? other,
  }) = _SpritesDTO;

  factory SpritesDTO.fromJson(Map<String, dynamic> json) =>
      _$SpritesDTOFromJson(json);
}

/// DTO for other sprite sources.
@freezed
/// DTO for type information.
abstract class OtherSpritesDTO with _$OtherSpritesDTO {
  const factory OtherSpritesDTO({
    @JsonKey(name: 'official-artwork') OfficialArtworkDTO? officialArtwork,
  }) = _OtherSpritesDTO;

  factory OtherSpritesDTO.fromJson(Map<String, dynamic> json) =>
      _$OtherSpritesDTOFromJson(json);
}

/// DTO for official artwork sprites.
@freezed
abstract class OfficialArtworkDTO with _$OfficialArtworkDTO {
  const factory OfficialArtworkDTO({
    @JsonKey(name: 'front_default') String? frontDefault,
    @JsonKey(name: 'front_shiny') String? frontShiny,
  }) = _OfficialArtworkDTO;

  factory OfficialArtworkDTO.fromJson(Map<String, dynamic> json) =>
      _$OfficialArtworkDTOFromJson(json);
}
