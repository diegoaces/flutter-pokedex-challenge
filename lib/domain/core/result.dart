import 'package:poke_app/domain/failures/pokemon_failure.dart';

/// A Result type for functional error handling without external dependencies.
/// Inspired by Rust's Result and Kotlin's Result types.
///
/// Usage:
/// ```dart
/// Result<Pokemon> result = await repository.getPokemonById(1);
/// result.when(
///   success: (pokemon) => print('Got pokemon: ${pokemon.name}'),
///   failure: (error) => print('Error: $error'),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// Creates a success result with a value.
  const factory Result.success(T value) = Success<T>;

  /// Creates a failure result with an error.
  const factory Result.failure(PokemonFailure failure) = Failure<T>;

  /// Returns true if this is a Success.
  bool get isSuccess => this is Success<T>;

  /// Returns true if this is a Failure.
  bool get isFailure => this is Failure<T>;

  /// Gets the value if Success, throws if Failure.
  T get value {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    throw Exception('Called value on a Failure: ${(this as Failure<T>).error}');
  }

  /// Gets the failure if Failure, throws if Success.
  PokemonFailure get failure {
    if (this is Failure<T>) {
      return (this as Failure<T>).error;
    }
    throw Exception('Called failure on a Success');
  }

  /// Gets the value if Success, or null if Failure.
  T? get valueOrNull {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return null;
  }

  /// Gets the failure if Failure, or null if Success.
  PokemonFailure? get failureOrNull {
    if (this is Failure<T>) {
      return (this as Failure<T>).error;
    }
    return null;
  }

  /// Pattern matching for Result.
  R when<R>({
    required R Function(T value) success,
    required R Function(PokemonFailure failure) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else {
      return failure((this as Failure<T>).error);
    }
  }

  /// Pattern matching with optional handlers.
  R maybeWhen<R>({
    R Function(T value)? success,
    R Function(PokemonFailure failure)? failure,
    required R Function() orElse,
  }) {
    if (this is Success<T> && success != null) {
      return success((this as Success<T>).data);
    } else if (this is Failure<T> && failure != null) {
      return failure((this as Failure<T>).error);
    } else {
      return orElse();
    }
  }

  /// Maps the success value to another type.
  Result<R> map<R>(R Function(T value) transform) {
    return when(
      success: (value) => Result.success(transform(value)),
      failure: (error) => Result.failure(error),
    );
  }

  /// Chains another Result-returning operation.
  Result<R> flatMap<R>(Result<R> Function(T value) transform) {
    return when(
      success: (value) => transform(value),
      failure: (error) => Result.failure(error),
    );
  }

  /// Gets the value or returns a default.
  T getOrElse(T Function() defaultValue) {
    return when(success: (value) => value, failure: (_) => defaultValue());
  }
}

/// Success case of Result.
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success($data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// Failure case of Result.
class Failure<T> extends Result<T> {
  final PokemonFailure error;

  const Failure(this.error);

  @override
  String toString() => 'Failure($error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;
}
