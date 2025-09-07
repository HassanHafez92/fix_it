import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/provider_entity.dart';
import '../repositories/provider_repository.dart';

class GetProviderDetailsUseCase implements UseCase<ProviderEntity, GetProviderDetailsParams> {
  final ProviderRepository repository;

  GetProviderDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, ProviderEntity>> call(GetProviderDetailsParams params) async {
    return await repository.getProviderDetails(params.providerId);
  }
}

class GetProviderDetailsParams extends Equatable {
  final String providerId;

  const GetProviderDetailsParams({required this.providerId});

  @override
  List<Object?> get props => [providerId];
}
