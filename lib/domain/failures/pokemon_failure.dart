/// Base class for all Pokemon-related failures in the domain layer.
/// Uses sealed classes (Dart 3.0+) for exhaustive pattern matching.
sealed class PokemonFailure {
  final String message;

  const PokemonFailure(this.message);

  @override
  String toString() => message;
}

/// Failure when there's a network connectivity issue.
class NetworkFailure extends PokemonFailure {
  const NetworkFailure([String message = 'Network connection failed'])
      : super(message);
}

/// Failure when the server returns an error response.
class ServerFailure extends PokemonFailure {
  final int? statusCode;

  const ServerFailure(String message, [this.statusCode]) : super(message);

  @override
  String toString() => statusCode != null
      ? 'Server Error ($statusCode): $message'
      : 'Server Error: $message';
}

/// Failure when parsing/deserializing data fails.
class ParseFailure extends PokemonFailure {
  const ParseFailure([String message = 'Failed to parse data']) : super(message);
}

/// Failure when data is not found (404).
class NotFoundFailure extends PokemonFailure {
  const NotFoundFailure([String message = 'Pokemon not found']) : super(message);
}

/// Failure when the request times out.
class TimeoutFailure extends PokemonFailure {
  const TimeoutFailure([String message = 'Request timed out']) : super(message);
}

/// Failure when local cache/storage fails.
class CacheFailure extends PokemonFailure {
  const CacheFailure([String message = 'Cache operation failed'])
      : super(message);
}

/// Failure for unknown/unexpected errors.
class UnknownFailure extends PokemonFailure {
  const UnknownFailure([String message = 'An unknown error occurred'])
      : super(message);
}
