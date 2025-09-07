import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../models/payment_method_model.dart';

/// Local data source for payment methods using SharedPreferences.
/// 
/// This class handles local caching of payment methods for offline access
/// and faster loading times.
abstract class PaymentMethodsLocalDataSource {
  /// Caches payment methods locally
  Future<void> cachePaymentMethods(String userId, List<PaymentMethodModel> paymentMethods);

  /// Retrieves cached payment methods
  Future<List<PaymentMethodModel>> getCachedPaymentMethods(String userId);

  /// Caches the default payment method
  Future<void> cacheDefaultPaymentMethod(String userId, PaymentMethodModel? paymentMethod);

  /// Retrieves the cached default payment method
  Future<PaymentMethodModel?> getCachedDefaultPaymentMethod(String userId);

  /// Clears all cached payment methods for a user
  Future<void> clearCachedPaymentMethods(String userId);

  /// Clears all cached data
  Future<void> clearAllCache();
}

/// Implementation of PaymentMethodsLocalDataSource using SharedPreferences
class PaymentMethodsLocalDataSourceImpl implements PaymentMethodsLocalDataSource {
  final SharedPreferences sharedPreferences;

  /// Key prefix for payment methods cache
  static const String paymentMethodsKey = 'CACHED_PAYMENT_METHODS_';

  /// Key prefix for default payment method cache
  static const String defaultPaymentMethodKey = 'CACHED_DEFAULT_PAYMENT_METHOD_';

  /// Key for cache timestamp
  static const String cacheTimestampKey = 'PAYMENT_METHODS_CACHE_TIMESTAMP_';

  /// Cache validity duration (24 hours)
  static const Duration cacheValidityDuration = Duration(hours: 24);

  PaymentMethodsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cachePaymentMethods(String userId, List<PaymentMethodModel> paymentMethods) async {
    try {
      final cacheKey = paymentMethodsKey + userId;
      final timestampKey = cacheTimestampKey + userId;

      // Convert payment methods to JSON
      final paymentMethodsJson = paymentMethods
          .map((method) => method.toJson())
          .toList();

      // Cache the data and timestamp
      await Future.wait([
        sharedPreferences.setString(cacheKey, json.encode(paymentMethodsJson)),
        sharedPreferences.setInt(timestampKey, DateTime.now().millisecondsSinceEpoch),
      ]);
    } catch (e) {
      throw CacheException(message: 'Failed to cache payment methods: $e');
    }
  }

  @override
  Future<List<PaymentMethodModel>> getCachedPaymentMethods(String userId) async {
    try {
      final cacheKey = paymentMethodsKey + userId;
      final timestampKey = cacheTimestampKey + userId;

      // Check if cache exists
      final cachedData = sharedPreferences.getString(cacheKey);
      final timestamp = sharedPreferences.getInt(timestampKey);

      if (cachedData == null || timestamp == null) {
        throw CacheException(message: 'No cached payment methods found');
      }

      // Check if cache is still valid
      final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      final now = DateTime.now();
      final cacheAge = now.difference(cacheTime);

      if (cacheAge > cacheValidityDuration) {
        // Cache is expired, clear it
        await clearCachedPaymentMethods(userId);
        throw CacheException(message: 'Cached payment methods expired');
      }

      // Parse and return cached data
      final List<dynamic> jsonList = json.decode(cachedData);
      return jsonList
          .map((jsonItem) => PaymentMethodModel.fromJson(jsonItem as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is CacheException) rethrow;
      throw CacheException(message: 'Failed to retrieve cached payment methods: $e');
    }
  }

  @override
  Future<void> cacheDefaultPaymentMethod(String userId, PaymentMethodModel? paymentMethod) async {
    try {
      final cacheKey = defaultPaymentMethodKey + userId;

      if (paymentMethod == null) {
        await sharedPreferences.remove(cacheKey);
      } else {
        final paymentMethodJson = json.encode(paymentMethod.toJson());
        await sharedPreferences.setString(cacheKey, paymentMethodJson);
      }
    } catch (e) {
      throw CacheException(message: 'Failed to cache default payment method: $e');
    }
  }

  @override
  Future<PaymentMethodModel?> getCachedDefaultPaymentMethod(String userId) async {
    try {
      final cacheKey = defaultPaymentMethodKey + userId;
      final cachedData = sharedPreferences.getString(cacheKey);

      if (cachedData == null) {
        return null;
      }

      final Map<String, dynamic> jsonData = json.decode(cachedData);
      return PaymentMethodModel.fromJson(jsonData);
    } catch (e) {
      throw CacheException(message: 'Failed to retrieve cached default payment method: $e');
    }
  }

  @override
  Future<void> clearCachedPaymentMethods(String userId) async {
    try {
      final cacheKey = paymentMethodsKey + userId;
      final timestampKey = cacheTimestampKey + userId;
      final defaultKey = defaultPaymentMethodKey + userId;

      await Future.wait([
        sharedPreferences.remove(cacheKey),
        sharedPreferences.remove(timestampKey),
        sharedPreferences.remove(defaultKey),
      ]);
    } catch (e) {
      throw CacheException(message: 'Failed to clear cached payment methods: $e');
    }
  }

  @override
  Future<void> clearAllCache() async {
    try {
      final keys = sharedPreferences.getKeys();
      final paymentMethodKeys = keys.where((key) => 
        key.startsWith(paymentMethodsKey) ||
        key.startsWith(defaultPaymentMethodKey) ||
        key.startsWith(cacheTimestampKey)
      ).toList();

      await Future.wait(
        paymentMethodKeys.map((key) => sharedPreferences.remove(key))
      );
    } catch (e) {
      throw CacheException(message: 'Failed to clear all payment methods cache: $e');
    }
  }

  /// Checks if cached data exists for a user
  bool hasCachedData(String userId) {
    final cacheKey = paymentMethodsKey + userId;
    return sharedPreferences.containsKey(cacheKey);
  }

  /// Gets the cache timestamp for a user
  DateTime? getCacheTimestamp(String userId) {
    final timestampKey = cacheTimestampKey + userId;
    final timestamp = sharedPreferences.getInt(timestampKey);

    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  /// Checks if cached data is still valid
  bool isCacheValid(String userId) {
    final timestamp = getCacheTimestamp(userId);
    if (timestamp == null) return false;

    final now = DateTime.now();
    final cacheAge = now.difference(timestamp);
    return cacheAge <= cacheValidityDuration;
  }
}
