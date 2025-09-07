import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/service_entity.dart';
import '../repositories/service_repository.dart';

class GetServicesUseCase implements UseCase<List<ServiceEntity>, void> {
  final ServiceRepository repository;

  GetServicesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ServiceEntity>>> call(void params) async {
    return await repository.getServices();
  }
}
