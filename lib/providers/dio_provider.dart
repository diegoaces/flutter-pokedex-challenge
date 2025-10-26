import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:poke_app/core/constants.dart';

part 'dio_provider.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.apiBaseUrl,
      connectTimeout: AppConstants.apiTimeout,
      receiveTimeout: AppConstants.apiTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
      requestHeader: true,
      responseHeader: false,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) {
        _handleError(error);
        handler.next(error);
      },
    ),
  );

  return dio;
}

void _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      print('Timeout error: ${error.message}');
      break;
    case DioExceptionType.badResponse:
      print('Bad response: ${error.response?.statusCode}');
      break;
    case DioExceptionType.cancel:
      print('Request cancelled');
      break;
    case DioExceptionType.connectionError:
      print('Connection error: ${error.message}');
      break;
    case DioExceptionType.unknown:
      print('Unknown error: ${error.message}');
      break;
    default:
      print('Error: ${error.message}');
  }
}
