import 'package:freezed_annotation/freezed_annotation.dart';

part 'pokemon_list_response.freezed.dart';
part 'pokemon_list_response.g.dart';

@freezed
abstract class PokemonListResponse with _$PokemonListResponse {
  const factory PokemonListResponse({
    required int count,
    String? next,
    String? previous,
    required List<ApiResult> results,
  }) = _PokemonListResponse;

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) =>
      _$PokemonListResponseFromJson(json);
}

@freezed
abstract class ApiResult with _$ApiResult {
  const ApiResult._();

  const factory ApiResult({required String name, required String url}) =
      _ApiResult;

  factory ApiResult.fromJson(Map<String, dynamic> json) =>
      _$ApiResultFromJson(json);

  /// Extrae el ID del Pokemon de la URL
  int get id {
    final segments = url.split('/');
    return int.parse(segments[segments.length - 2]);
  }
}
