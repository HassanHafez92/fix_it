import '../../../../core/network/api_client.dart';
import '../models/provider_model.dart';
import '../models/review_model.dart';

abstract class ProviderRemoteDataSource {
  Future<List<ProviderModel>> searchProviders({
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
  Future<ProviderModel> getProviderDetails(String providerId);
  Future<List<ReviewModel>> getProviderReviews(String providerId);
  Future<ReviewModel> submitProviderReview({
    required String providerId,
    required double rating,
    required String comment,
    String? bookingId,
  });
  Future<List<ProviderModel>> getNearbyProviders({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  });
  Future<List<ProviderModel>> getFeaturedProviders();
  Future<void> addProviderToFavorites(String providerId);
  Future<void> removeProviderFromFavorites(String providerId);
  Future<List<ProviderModel>> getFavoriteProviders();
}

class ProviderRemoteDataSourceImpl implements ProviderRemoteDataSource {
  final ApiClient apiClient;

  ProviderRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ProviderModel>> searchProviders({
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
    final models = await apiClient.searchProviders(
      query,
      serviceCategory,
      latitude,
      longitude,
      radius,
      minRating,
      availableAt?.toIso8601String(),
      maxPrice,
      sort,
    );
    // Convert models to entity-compatible form if repository expects entities
    return models.map((m) => ProviderModel.fromEntity(m.toEntity())).toList();
  }

  @override
  Future<ProviderModel> getProviderDetails(String providerId) async {
    final model = await apiClient.getProviderDetails(providerId);
    return ProviderModel.fromEntity(model.toEntity());
  }

  @override
  Future<List<ReviewModel>> getProviderReviews(String providerId) async {
    final models = await apiClient.getProviderReviews(providerId);
    return models.map((m) => ReviewModel.fromEntity(m.toEntity())).toList();
  }

  @override
  Future<ReviewModel> submitProviderReview({
    required String providerId,
    required double rating,
    required String comment,
    String? bookingId,
  }) async {
    final reviewData = {
      'rating': rating,
      'comment': comment,
      if (bookingId != null) 'bookingId': bookingId,
    };
    final model = await apiClient.submitProviderReview(
      providerId,
      reviewData,
    );
    return ReviewModel.fromEntity(model.toEntity());
  }

  @override
  Future<List<ProviderModel>> getNearbyProviders({
    required double latitude,
    required double longitude,
    double radius = 10.0,
  }) async {
    final models =
        await apiClient.getNearbyProviders(latitude, longitude, radius);
    return models.map((m) => ProviderModel.fromEntity(m.toEntity())).toList();
  }

  @override
  Future<List<ProviderModel>> getFeaturedProviders() async {
    final models = await apiClient.getFeaturedProviders();
    return models.map((m) => ProviderModel.fromEntity(m.toEntity())).toList();
  }

  @override
  Future<void> addProviderToFavorites(String providerId) async {
    await apiClient.addProviderToFavorites(providerId);
  }

  @override
  Future<void> removeProviderFromFavorites(String providerId) async {
    await apiClient.removeProviderFromFavorites(providerId);
  }

  @override
  Future<List<ProviderModel>> getFavoriteProviders() async {
    final models = await apiClient.getFavoriteProviders();
    return models.map((m) => ProviderModel.fromEntity(m.toEntity())).toList();
  }
}
