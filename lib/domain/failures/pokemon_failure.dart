/// Base class for all Pokemon-related failures in the domain layer.
/// Uses sealed classes (Dart 3.0+) for exhaustive pattern matching.
sealed class PokemonFailure {
  final String message;

  const PokemonFailure(this.message);

  @override
  String toString() => message;
}

class NetworkFailure extends PokemonFailure {
  const NetworkFailure([super.message = 'Network connection failed']);
}

class ServerFailure extends PokemonFailure {
  final int? statusCode;

  const ServerFailure(super.message, [this.statusCode]);

  @override
  String toString() => statusCode != null
      ? 'Server Error ($statusCode): $message'
      : 'Server Error: $message';
}

class ParseFailure extends PokemonFailure {
  const ParseFailure([super.message = 'Failed to parse data']);
}

class NotFoundFailure extends PokemonFailure {
  const NotFoundFailure([super.message = 'Pokemon not found']);
}

class TimeoutFailure extends PokemonFailure {
  const TimeoutFailure([super.message = 'Request timed out']);
}

class CacheFailure extends PokemonFailure {
  const CacheFailure([super.message = 'Cache operation failed']);
}

class UnknownFailure extends PokemonFailure {
  const UnknownFailure([super.message = 'An unknown error occurred']);
}
