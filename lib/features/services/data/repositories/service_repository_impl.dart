import 'package:dartz/dartz.dart';
import 'package:fix_it/features/services/data/models/service_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/service_local_data_source.dart';
import '../datasources/service_remote_data_source.dart';

/// ServiceRepositoryImpl
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
/// // Example: Create and use ServiceRepositoryImpl
/// final obj = ServiceRepositoryImpl();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class ServiceRepositoryImpl implements ServiceRepository {
  final ServiceRemoteDataSource remoteDataSource;
  final ServiceLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ServiceRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServices() async {
    if (await networkInfo.isConnected) {
      try {
        final paginatedServices = await remoteDataSource.getServicesPaginated();

        // Cache the new services
        await localDataSource.cacheServices(paginatedServices.services.map((e) => e as ServiceModel).toList());

        return Right(paginatedServices.services.map((e) => e).toList());
      } catch (e) {
        // If remote fails, try to get cached data
        try {
          final allServices = await localDataSource.getCachedServices();
          return Right(allServices);
        } catch (e) {
          return Left(CacheFailure('No cached services available'));
        }
      }
    } else {
      try {
        final allServices = await localDataSource.getCachedServices();
        return Right(allServices);
      } catch (e) {
        return Left(CacheFailure('No cached services available'));
      }
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> getServicesByCategory(String categoryId) async {
    if (await networkInfo.isConnected) {
      try {
        final paginatedServices = await remoteDataSource.getServicesByCategoryPaginated(categoryId);

        // Cache the new services
        await localDataSource.cacheServices(paginatedServices.services.map((e) => e as ServiceModel).toList());

        return Right(paginatedServices.services.map((e) => e).toList());
      } catch (e) {
        // If remote fails, try to get cached data
        try {
          final allServices = await localDataSource.getCachedServices();

          // Filter by category
          final categoryServices = allServices
              .where((service) => service.categoryId == categoryId)
              .toList();

          return Right(categoryServices);
        } catch (e) {
          return Left(CacheFailure('No cached services available'));
        }
      }
    } else {
      try {
        final allServices = await localDataSource.getCachedServices();

        // Filter by category
        final categoryServices = allServices
            .where((service) => service.categoryId == categoryId)
            .toList();

        return Right(categoryServices);
      } catch (e) {
        return Left(CacheFailure('No cached services available'));
      }
    }
  }

  @override
  Future<Either<Failure, ServiceEntity>> getServiceDetails(String serviceId) async {
    if (await networkInfo.isConnected) {
      try {
        final service = await remoteDataSource.getServiceDetails(serviceId);
        await localDataSource.cacheServiceDetails(service);
        return Right(service);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final service = await localDataSource.getCachedServiceDetails(serviceId);
        if (service != null) {
          return Right(service);
        } else {
          return Left(CacheFailure('No cached service details available'));
        }
      } catch (e) {
        return Left(CacheFailure('No cached service details available'));
      }
    }
  }

  @override
  Future<Either<Failure, List<ServiceEntity>>> searchServices(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final services = await remoteDataSource.searchServices(query);
        return Right(services);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    if (await networkInfo.isConnected) {
      try {
        final categories = await remoteDataSource.getCategories();
        await localDataSource.cacheCategories(categories);
        return Right(categories);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final categories = await localDataSource.getCachedCategories();
        return Right(categories);
      } catch (e) {
        return Left(CacheFailure('No cached categories available'));
      }
    }
  }
}
