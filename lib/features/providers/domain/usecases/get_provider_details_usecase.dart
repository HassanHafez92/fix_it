import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/provider_entity.dart';
import '../repositories/provider_repository.dart';

/// GetProviderDetailsUseCase
///
/// Fetches the full provider profile and related details.
///
/// Business Rules:
///  - The providerId must be a valid identifier previously stored in the system.
class GetProviderDetailsUseCase
    implements UseCase<ProviderEntity, GetProviderDetailsParams> {
  final ProviderRepository repository;

  GetProviderDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, ProviderEntity>> call(
      GetProviderDetailsParams params) async {
    return await repository.getProviderDetails(params.providerId);
  }
}

/// GetProviderDetailsParams
///
/// Parameter details:
///  - providerId (required): id of the provider whose details will be retrieved.
class GetProviderDetailsParams extends Equatable {
  final String providerId;

  const GetProviderDetailsParams({required this.providerId});

  @override
  List<Object?> get props => [providerId];
}
