import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/provider_entity.dart';
import '../entities/review_entity.dart';

abstract class ProviderRepository {
  Future<Either<Failure, List<ProviderEntity>>> searchProviders({
    String? query,
    String? serviceCategory,
    double? latitude,
    double? longitude,
    double? radius,
    double? minRating,
    DateTime? availableAt,
    double? maxPrice,
    String? sort,
  });
  Future<Either<Failure, ProviderEntity>> getProviderDetails(String providerId);
  Future<Either<Failure, List<ReviewEntity>>> getProviderReviews(
      String providerId);
  Future<Either<Failure, ReviewEntity>> submitProviderReview(
      {required String providerId,
      required double rating,
      required String comment,
      String? bookingId});
  Future<Either<Failure, List<ProviderEntity>>> getNearbyProviders({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  });
  Future<Either<Failure, List<ProviderEntity>>> getFeaturedProviders();
  Future<Either<Failure, void>> addProviderToFavorites(String providerId);
  Future<Either<Failure, void>> removeProviderFromFavorites(String providerId);
  Future<Either<Failure, List<ProviderEntity>>> getFavoriteProviders();
}
