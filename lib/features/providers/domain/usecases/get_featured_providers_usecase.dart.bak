import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/provider_entity.dart';
import '../repositories/provider_repository.dart';

/// GetFeaturedProvidersUseCase
///
/// Usecase that returns featured providers for the home/landing screen.
///
/// Business Rules:
///  - Returns a short list of highlighted providers curated by the backend.
class GetFeaturedProvidersUseCase
    implements UseCase<List<ProviderEntity>, NoParams> {
  final ProviderRepository repository;

  GetFeaturedProvidersUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProviderEntity>>> call(NoParams params) async {
    return await repository.getFeaturedProviders();
  }
}
