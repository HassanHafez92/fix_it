import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/service_entity.dart';
import '../repositories/service_repository.dart';

class GetServiceDetailsUseCase implements UseCase<ServiceEntity, GetServiceDetailsParams> {
  final ServiceRepository repository;

  GetServiceDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, ServiceEntity>> call(GetServiceDetailsParams params) async {
    return await repository.getServiceDetails(params.serviceId);
  }
}

class GetServiceDetailsParams extends Equatable {
  final String serviceId;

  const GetServiceDetailsParams({required this.serviceId});

  @override
  List<Object?> get props => [serviceId];
}
