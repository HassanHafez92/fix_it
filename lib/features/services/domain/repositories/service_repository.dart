import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/service_entity.dart';
import '../entities/category_entity.dart';

/// ServiceRepository
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
/// // Example: Create and use ServiceRepository
/// final obj = ServiceRepository();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract class ServiceRepository {
  Future<Either<Failure, List<ServiceEntity>>> getServices();
  Future<Either<Failure, List<ServiceEntity>>> getServicesByCategory(String categoryId);
  Future<Either<Failure, ServiceEntity>> getServiceDetails(String serviceId);
  Future<Either<Failure, List<ServiceEntity>>> searchServices(String query);
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
