import 'package:dio/dio.dart';
import 'package:poke_app/data/datasources/pokemon_remote_datasource.dart';
import 'package:poke_app/data/exceptions/data_exceptions.dart';
import 'package:poke_app/data/models/pokemon_detail_response_dto.dart';
import 'package:poke_app/data/models/pokemon_list_response_dto.dart';

class PokemonRemoteDataSourceImpl implements PokemonRemoteDataSource {
  final Dio _dio;

  const PokemonRemoteDataSourceImpl(this._dio);

  @override
  Future<PokemonListResponseDTO> fetchPokemonList({
    required int limit,
    required int offset,
  }) async {
    try {
      final response = await _dio.get(
        'pokemon',
        queryParameters: {'limit': limit, 'offset': offset},
      );

      return PokemonListResponseDTO.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ParseException('Failed to parse Pokemon list: $e', e);
    }
  }

  @override
  Future<PokemonDetailResponseDTO> fetchPokemonDetail(int id) async {
    try {
      final response = await _dio.get('pokemon/$id');

      return PokemonDetailResponseDTO.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ParseException('Failed to parse Pokemon detail: $e', e);
    }
  }

  @override
  Future<PokemonDetailResponseDTO> fetchPokemonByName(String name) async {
    try {
      final response = await _dio.get('pokemon/${name.toLowerCase()}');

      return PokemonDetailResponseDTO.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ParseException('Failed to parse Pokemon detail: $e', e);
    }
  }

  /// Handles DioException and converts it to appropriate DataException.
  DataException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException('Request timed out: ${e.message}', e);

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;

        if (statusCode == 404) {
          return NotFoundException('Resource not found', e);
        }

        if (statusCode != null && statusCode >= 500) {
          return ServerException(
            'Server error occurred',
            statusCode: statusCode,
            originalError: e,
          );
        }

        return ServerException(
          'Bad response: ${e.response?.statusMessage}',
          statusCode: statusCode,
          originalError: e,
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return NetworkException('Network error: ${e.message}', e);

      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled', e);

      case DioExceptionType.badCertificate:
        return NetworkException('SSL certificate error', e);
    }
  }
}
