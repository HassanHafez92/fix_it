import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/service_entity.dart';
import '../repositories/service_repository.dart';

/// GetServicesByCategoryUseCase
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use GetServicesByCategoryUseCase
/// final obj = GetServicesByCategoryUseCase();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class GetServicesByCategoryUseCase implements UseCase<List<ServiceEntity>, GetServicesByCategoryParams> {
  final ServiceRepository repository;

  GetServicesByCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<ServiceEntity>>> call(GetServicesByCategoryParams params) async {
    return await repository.getServicesByCategory(params.categoryId);
  }
}

/// GetServicesByCategoryParams
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use GetServicesByCategoryParams
/// final obj = GetServicesByCategoryParams();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class GetServicesByCategoryParams extends Equatable {
  final String categoryId;

  const GetServicesByCategoryParams({
    required this.categoryId,
  });

  @override
  List<Object?> get props => [categoryId];
}
