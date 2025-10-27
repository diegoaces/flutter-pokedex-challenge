abstract class DataException implements Exception {
  final String message;
  final dynamic originalError;

  const DataException(this.message, [this.originalError]);

  @override
  String toString() => message;
}

class NetworkException extends DataException {
  const NetworkException([super.message = 'Network error occurred', super.originalError]);
}

class ServerException extends DataException {
  final int? statusCode;

  const ServerException(
    String message, {
    this.statusCode,
    dynamic originalError,
  }) : super(message, originalError);

  @override
  String toString() => statusCode != null
      ? 'ServerException($statusCode): $message'
      : 'ServerException: $message';
}

class ParseException extends DataException {
  const ParseException([super.message = 'Failed to parse data', super.originalError]);
}

class NotFoundException extends DataException {
  const NotFoundException([super.message = 'Resource not found', super.originalError]);
}

class TimeoutException extends DataException {
  const TimeoutException([super.message = 'Request timed out', super.originalError]);
}

class CacheException extends DataException {
  const CacheException([super.message = 'Cache operation failed', super.originalError]);
}
