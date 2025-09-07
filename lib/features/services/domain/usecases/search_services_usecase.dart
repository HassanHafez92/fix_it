import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/service_entity.dart';
import '../repositories/service_repository.dart';

class SearchServicesUseCase implements UseCase<List<ServiceEntity>, SearchServicesParams> {
  final ServiceRepository repository;

  SearchServicesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ServiceEntity>>> call(SearchServicesParams params) async {
    return await repository.searchServices(params.query);
  }
}

class SearchServicesParams extends Equatable {
  final String query;

  const SearchServicesParams({required this.query});

  @override
  List<Object?> get props => [query];
}
