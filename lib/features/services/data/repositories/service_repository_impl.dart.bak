import 'package:dartz/dartz.dart';
import 'package:fix_it/features/services/data/models/service_model.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/service_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/service_repository.dart';
import '../datasources/service_local_data_source.dart';
import '../datasources/service_remote_data_source.dart';

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
