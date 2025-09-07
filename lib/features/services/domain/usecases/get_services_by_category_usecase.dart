import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/service_entity.dart';
import '../repositories/service_repository.dart';

class GetServicesByCategoryUseCase implements UseCase<List<ServiceEntity>, GetServicesByCategoryParams> {
  final ServiceRepository repository;

  GetServicesByCategoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<ServiceEntity>>> call(GetServicesByCategoryParams params) async {
    return await repository.getServicesByCategory(params.categoryId);
  }
}

class GetServicesByCategoryParams extends Equatable {
  final String categoryId;

  const GetServicesByCategoryParams({
    required this.categoryId,
  });

  @override
  List<Object?> get props => [categoryId];
}
