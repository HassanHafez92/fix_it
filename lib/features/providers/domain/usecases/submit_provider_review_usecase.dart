import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/review_entity.dart';
import '../repositories/provider_repository.dart';

/// SubmitProviderReviewUseCase
///
/// Submits a review for a provider.
///
/// Business Rules:
///  - Rating must be between accepted bounds (validated by repository/backend).
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

/// SubmitProviderReviewParams
///
/// Parameter details:
///  - providerId (required): id of the provider being reviewed.
///  - rating (required): numeric rating value.
///  - comment: optional textual feedback from the user.
///  - bookingId: optional booking id to link the review to a completed booking.
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
