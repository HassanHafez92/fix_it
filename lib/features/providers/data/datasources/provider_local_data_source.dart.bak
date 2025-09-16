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
  Future<List<ProviderModel>> getCachedProviders();
  Future<void> cacheProviders(List<ProviderModel> providers);
  Future<ProviderModel?> getCachedProviderDetails(String providerId);
  Future<void> cacheProviderDetails(ProviderModel provider);
  Future<List<ReviewModel>> getCachedProviderReviews(String providerId);
  Future<void> cacheProviderReviews(
      String providerId, List<ReviewModel> reviews);
  Future<List<ProviderModel>> getCachedFeaturedProviders();
  Future<void> cacheFeaturedProviders(List<ProviderModel> providers);
  Future<List<String>> getFavoriteProviderIds();
  Future<void> addFavoriteProvider(String providerId);
  Future<void> removeFavoriteProvider(String providerId);
  Future<void> clearCache();
}

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
