import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Base interface for all use cases in the application.
///
/// Implementations should encapsulate a single business operation.
/// Implementors return an Either&lt;Failure, T&gt; where [Failure] represents an
/// expected domain error and [T] represents the success value.
///
/// Keep implementations small and focused (one operation per use case).
abstract class UseCase<T, Params> {
  /// Execute the use case with the given [params].
  Future<Either<Failure, T>> call(Params params);
}

/// Use this type for use cases that do not require input parameters.
///
/// Example: getting the currently authenticated user.
abstract class NoParams extends Equatable {
  const NoParams();

  @override
  List<Object> get props => [];
}

/// Lightweight concrete instance for [NoParams]. Use this where a concrete
/// value is required (for example to call a use case) but no parameters exist.
class NoParamsImpl extends NoParams {
  const NoParamsImpl();
}
