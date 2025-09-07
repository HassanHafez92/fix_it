import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/review_entity.dart';
import '../repositories/provider_repository.dart';

class SubmitProviderReviewUseCase
    implements UseCase<ReviewEntity, SubmitProviderReviewParams> {
  final ProviderRepository repository;

  SubmitProviderReviewUseCase(this.repository);

  @override
  Future<Either<Failure, ReviewEntity>> call(
      SubmitProviderReviewParams params) async {
    return await repository.submitProviderReview(
      providerId: params.providerId,
      rating: params.rating,
      comment: params.comment,
      bookingId: params.bookingId,
    );
  }
}

class SubmitProviderReviewParams extends Equatable {
  final String providerId;
  final double rating;
  final String comment;
  final String? bookingId;

  const SubmitProviderReviewParams({
    required this.providerId,
    required this.rating,
    required this.comment,
    this.bookingId,
  });

  @override
  List<Object?> get props => [providerId, rating, comment, bookingId];
}
