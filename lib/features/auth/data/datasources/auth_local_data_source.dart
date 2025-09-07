import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUserData(UserModel user);
  Future<UserModel?> getCachedUserData();
  Future<void> clearUserData();
  Future<void> cacheAuthToken(String token);
  Future<String?> getCachedAuthToken();
  Future<void> clearAuthToken();
  Future<bool> isUserLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheUserData(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await sharedPreferences.setString(AppConstants.userDataKey, userJson);
    } catch (e) {
      throw Exception('Failed to cache user data: $e');
    }
  }

  @override
  Future<UserModel?> getCachedUserData() async {
    try {
      final userJson = sharedPreferences.getString(AppConstants.userDataKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get cached user data: $e');
    }
  }

  @override
  Future<void> clearUserData() async {
    try {
      await sharedPreferences.remove(AppConstants.userDataKey);
    } catch (e) {
      throw Exception('Failed to clear user data: $e');
    }
  }

  @override
  Future<void> cacheAuthToken(String token) async {
    try {
      await secureStorage.write(key: AppConstants.authTokenKey, value: token);
    } catch (e) {
      throw Exception('Failed to cache auth token: $e');
    }
  }

  @override
  Future<String?> getCachedAuthToken() async {
    try {
      return await secureStorage.read(key: AppConstants.authTokenKey);
    } catch (e) {
      throw Exception('Failed to get cached auth token: $e');
    }
  }

  @override
  Future<void> clearAuthToken() async {
    try {
      await secureStorage.delete(key: AppConstants.authTokenKey);
    } catch (e) {
      throw Exception('Failed to clear auth token: $e');
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      final token = await getCachedAuthToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
}
