import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/review_entity.dart';
import '../repositories/provider_repository.dart';

/// GetProviderReviewsUseCase
///
/// Retrieves reviews for a given provider.
///
/// Business Rules:
///  - Returns reviews sorted by date (most recent first).
class GetProviderReviewsUseCase
    implements UseCase<List<ReviewEntity>, GetProviderReviewsParams> {
  final ProviderRepository repository;

  GetProviderReviewsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ReviewEntity>>> call(
      GetProviderReviewsParams params) async {
    return await repository.getProviderReviews(params.providerId);
  }
}

/// GetProviderReviewsParams
///
/// Parameter details:
///  - providerId (required): id of the provider whose reviews will be fetched.
class GetProviderReviewsParams extends Equatable {
  final String providerId;

  const GetProviderReviewsParams({required this.providerId});

  @override
  List<Object?> get props => [providerId];
}
