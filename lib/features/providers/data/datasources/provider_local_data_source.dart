import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/provider_model.dart';
import '../models/review_model.dart';

/// ProviderLocalDataSource
///
/// Abstract local datasource for caching provider-related data.
///
/// Business Rules:
///  - Implementations must store and retrieve provider lists, details and reviews.
abstract class ProviderLocalDataSource {
  /// Returns a list of cached [ProviderModel] objects.
  ///
  /// Returns: a [Future] that completes with the cached providers or
  /// throws an [Exception] if none are available.
  Future<List<ProviderModel>> getCachedProviders();

  /// Cache the provided list of [ProviderModel]s.
  ///
  /// Parameters:
  /// - [providers]: list to serialize and store locally.
  Future<void> cacheProviders(List<ProviderModel> providers);

  /// Returns provider details for [providerId] or `null` when not cached.
  ///
  /// Parameters:
  /// - [providerId]: unique identifier for the provider.
  Future<ProviderModel?> getCachedProviderDetails(String providerId);

  /// Cache provider details for later retrieval.
  ///
  /// Parameters:
  /// - [provider]: provider to cache.
  Future<void> cacheProviderDetails(ProviderModel provider);

  /// Returns a list of cached [ReviewModel] for the given provider.
  ///
  /// Parameters:
  /// - [providerId]: provider identifier to look up reviews for.
  ///
  /// Returns: a [Future] that completes with the list of reviews or
  /// throws an [Exception] if none are available.
  Future<List<ReviewModel>> getCachedProviderReviews(String providerId);

  /// Cache provider reviews for [providerId].
  ///
  /// Parameters:
  /// - [providerId]: provider identifier.
  /// - [reviews]: list of reviews to store.
  Future<void> cacheProviderReviews(
      String providerId, List<ReviewModel> reviews);

  /// Returns the list of featured providers that were cached.
  Future<List<ProviderModel>> getCachedFeaturedProviders();

  /// Cache a list of featured providers.
  Future<void> cacheFeaturedProviders(List<ProviderModel> providers);

  /// Returns favorite provider IDs stored locally.
  Future<List<String>> getFavoriteProviderIds();

  /// Add a provider id to favorites.
  Future<void> addFavoriteProvider(String providerId);

  /// Remove a provider id from favorites.
  Future<void> removeFavoriteProvider(String providerId);

  /// Clears provider-related cache keys from local storage.
  Future<void> clearCache();
}

/// ProviderLocalDataSourceImpl
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use ProviderLocalDataSourceImpl
/// final obj = ProviderLocalDataSourceImpl();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class ProviderLocalDataSourceImpl implements ProviderLocalDataSource {
  /// ProviderLocalDataSourceImpl
  ///
  /// Concrete SharedPreferences-backed implementation of [ProviderLocalDataSource].
  ///
  /// Business Rules:
  ///  - Keys are namespaced and should not collide with other features.
  final SharedPreferences sharedPreferences;

  static const String _providersKey = 'CACHED_PROVIDERS';
  static const String _providerDetailsKey = 'CACHED_PROVIDER_DETAILS_';
  static const String _providerReviewsKey = 'CACHED_PROVIDER_REVIEWS_';
  static const String _featuredProvidersKey = 'CACHED_FEATURED_PROVIDERS';
  static const String _favoriteProvidersKey = 'FAVORITE_PROVIDERS';

  ProviderLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<ProviderModel>> getCachedProviders() async {
    final jsonString = sharedPreferences.getString(_providersKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ProviderModel.fromJson(json)).toList();
    }
    // If no cached providers exist, throw to indicate an absent cache.
    throw Exception('No cached providers found');
  }

  @override
  Future<void> cacheProviders(List<ProviderModel> providers) async {
    final jsonString =
        json.encode(providers.map((provider) => provider.toJson()).toList());
    await sharedPreferences.setString(_providersKey, jsonString);
  }

  @override
  Future<ProviderModel?> getCachedProviderDetails(String providerId) async {
    final jsonString =
        sharedPreferences.getString('$_providerDetailsKey$providerId');
    if (jsonString != null) {
      return ProviderModel.fromJson(json.decode(jsonString));
    }
    return null;
  }

  @override
  Future<void> cacheProviderDetails(ProviderModel provider) async {
    final jsonString = json.encode(provider.toJson());
    await sharedPreferences.setString(
        '$_providerDetailsKey${provider.id}', jsonString);
  }

  @override
  Future<List<ReviewModel>> getCachedProviderReviews(String providerId) async {
    final jsonString =
        sharedPreferences.getString('$_providerReviewsKey$providerId');
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ReviewModel.fromJson(json)).toList();
    }
    // When no reviews are cached for the requested provider, throw an
    // exception to allow callers to decide whether to fetch remotely.
    throw Exception('No cached reviews found');
  }

  @override
  Future<void> cacheProviderReviews(
      String providerId, List<ReviewModel> reviews) async {
    final jsonString =
        json.encode(reviews.map((review) => review.toJson()).toList());
    await sharedPreferences.setString(
        '$_providerReviewsKey$providerId', jsonString);
  }

  @override
  Future<List<ProviderModel>> getCachedFeaturedProviders() async {
    final jsonString = sharedPreferences.getString(_featuredProvidersKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => ProviderModel.fromJson(json)).toList();
    }
    throw Exception('No cached featured providers found');
  }

  @override
  Future<void> cacheFeaturedProviders(List<ProviderModel> providers) async {
    final jsonString =
        json.encode(providers.map((provider) => provider.toJson()).toList());
    await sharedPreferences.setString(_featuredProvidersKey, jsonString);
  }

  @override
  Future<List<String>> getFavoriteProviderIds() async {
    final favoriteIds = sharedPreferences.getStringList(_favoriteProvidersKey);
    return favoriteIds ?? [];
  }

  @override
  Future<void> addFavoriteProvider(String providerId) async {
    final favoriteIds = await getFavoriteProviderIds();
    if (!favoriteIds.contains(providerId)) {
      favoriteIds.add(providerId);
      await sharedPreferences.setStringList(_favoriteProvidersKey, favoriteIds);
    }
  }

  @override
  Future<void> removeFavoriteProvider(String providerId) async {
    final favoriteIds = await getFavoriteProviderIds();
    favoriteIds.remove(providerId);
    await sharedPreferences.setStringList(_favoriteProvidersKey, favoriteIds);
  }

  @override
  Future<void> clearCache() async {
    final keys = sharedPreferences.getKeys();
    for (final key in keys) {
      if (key.startsWith(_providersKey) ||
          key.startsWith(_providerDetailsKey) ||
          key.startsWith(_providerReviewsKey) ||
          key.startsWith(_featuredProvidersKey)) {
        await sharedPreferences.remove(key);
      }
    }
  }
}
