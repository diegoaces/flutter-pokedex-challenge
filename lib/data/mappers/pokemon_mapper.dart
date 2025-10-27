import 'package:poke_app/data/models/pokemon_detail_response_dto.dart';
import 'package:poke_app/data/models/pokemon_dto.dart';
import 'package:poke_app/domain/entities/pokemon_entity.dart';

class PokemonMapper {
  PokemonEntity dtoToEntity(PokemonDTO dto) {
    return PokemonEntity(id: dto.id, name: dto.name, types: dto.types);
  }

  PokemonEntity detailResponseToEntity(PokemonDetailResponseDTO dto) {
    final types = dto.types.map((typeSlot) => typeSlot.type.name).toList();

    return PokemonEntity(id: dto.id, name: dto.name, types: types);
  }

  PokemonDTO entityToDto(PokemonEntity entity) {
    return PokemonDTO(id: entity.id, name: entity.name, types: entity.types);
  }

  List<PokemonEntity> dtoListToEntityList(List<PokemonDTO> dtos) {
    return dtos.map((dto) => dtoToEntity(dto)).toList();
  }

  List<PokemonEntity> detailResponseListToEntityList(
    List<PokemonDetailResponseDTO> dtos,
  ) {
    return dtos.map((dto) => detailResponseToEntity(dto)).toList();
  }

  List<PokemonDTO> entityListToDtoList(List<PokemonEntity> entities) {
    return entities.map((entity) => entityToDto(entity)).toList();
  }
}
