import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/service_entity.dart';
import '../entities/category_entity.dart';

abstract class ServiceRepository {
  Future<Either<Failure, List<ServiceEntity>>> getServices();
  Future<Either<Failure, List<ServiceEntity>>> getServicesByCategory(String categoryId);
  Future<Either<Failure, ServiceEntity>> getServiceDetails(String serviceId);
  Future<Either<Failure, List<ServiceEntity>>> searchServices(String query);
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
}
