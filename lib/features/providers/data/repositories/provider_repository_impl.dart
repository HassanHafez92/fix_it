import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/provider_entity.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/provider_repository.dart';
import '../datasources/provider_local_data_source.dart';
import '../datasources/provider_remote_data_source.dart';

class ProviderRepositoryImpl implements ProviderRepository {
  final ProviderRemoteDataSource remoteDataSource;
  final ProviderLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProviderRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
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
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final providers = await remoteDataSource.searchProviders(
          query: query,
          serviceCategory: serviceCategory,
          latitude: latitude,
          longitude: longitude,
          radius: radius,
          minRating: minRating,
          availableAt: availableAt,
          maxPrice: maxPrice,
          sort: sort,
        );
        await localDataSource.cacheProviders(providers);
        return Right(providers.map((m) => m.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final providers = await localDataSource.getCachedProviders();
        return Right(providers.map((m) => m.toEntity()).toList());
      } catch (e) {
        return Left(CacheFailure('No cached providers available'));
      }
    }
  }

  @override
  Future<Either<Failure, ProviderEntity>> getProviderDetails(
      String providerId) async {
    if (await networkInfo.isConnected) {
      try {
        final provider = await remoteDataSource.getProviderDetails(providerId);
        await localDataSource.cacheProviderDetails(provider);
        return Right(provider.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final provider =
            await localDataSource.getCachedProviderDetails(providerId);
        if (provider != null) {
          return Right(provider.toEntity());
        } else {
          return Left(CacheFailure('No cached provider details available'));
        }
      } catch (e) {
        return Left(CacheFailure('No cached provider details available'));
      }
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getProviderReviews(
      String providerId) async {
    if (await networkInfo.isConnected) {
      try {
        final reviews = await remoteDataSource.getProviderReviews(providerId);
        await localDataSource.cacheProviderReviews(providerId, reviews);
        return Right(reviews);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final reviews =
            await localDataSource.getCachedProviderReviews(providerId);
        return Right(reviews);
      } catch (e) {
        return Left(CacheFailure('No cached reviews available'));
      }
    }
  }

  @override
  Future<Either<Failure, ReviewEntity>> submitProviderReview({
    required String providerId,
    required double rating,
    required String comment,
    String? bookingId,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final reviewModel = await remoteDataSource.submitProviderReview(
            providerId: providerId,
            rating: rating,
            comment: comment,
            bookingId: bookingId);
        // Optionally append to cached reviews
        try {
          final cached =
              await localDataSource.getCachedProviderReviews(providerId);
          final updated = [reviewModel, ...cached];
          await localDataSource.cacheProviderReviews(providerId, updated);
        } catch (_) {}
        return Right(reviewModel);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ProviderEntity>>> getNearbyProviders({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        final providers = await remoteDataSource.getNearbyProviders(
          latitude: latitude,
          longitude: longitude,
          radius: radius,
        );
        return Right(providers.map((m) => m.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, List<ProviderEntity>>> getFeaturedProviders() async {
    if (await networkInfo.isConnected) {
      try {
        final providers = await remoteDataSource.getFeaturedProviders();
        await localDataSource.cacheFeaturedProviders(providers);
        return Right(providers.map((m) => m.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final providers = await localDataSource.getCachedFeaturedProviders();
        return Right(providers.map((m) => m.toEntity()).toList());
      } catch (e) {
        return Left(CacheFailure('No cached featured providers available'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> addProviderToFavorites(
      String providerId) async {
    try {
      await localDataSource.addFavoriteProvider(providerId);
      if (await networkInfo.isConnected) {
        await remoteDataSource.addProviderToFavorites(providerId);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeProviderFromFavorites(
      String providerId) async {
    try {
      await localDataSource.removeFavoriteProvider(providerId);
      if (await networkInfo.isConnected) {
        await remoteDataSource.removeProviderFromFavorites(providerId);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ProviderEntity>>> getFavoriteProviders() async {
    if (await networkInfo.isConnected) {
      try {
        final providers = await remoteDataSource.getFavoriteProviders();
        return Right(providers.map((m) => m.toEntity()).toList());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      try {
        final favoriteIds = await localDataSource.getFavoriteProviderIds();
        final List<ProviderEntity> providers = [];
        for (final id in favoriteIds) {
          final provider = await localDataSource.getCachedProviderDetails(id);
          if (provider != null) {
            providers.add(provider.toEntity());
          }
        }
        return Right(providers);
      } catch (e) {
        return Left(CacheFailure('No cached favorite providers available'));
      }
    }
  }
}
