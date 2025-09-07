import '../../domain/entities/user_profile_entity.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileEntity?> getCachedProfile(String userId);
  Future<void> cacheUserProfile(UserProfileEntity profile);
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  ProfileLocalDataSourceImpl();

  final Map<String, UserProfileEntity> _cache = {};

  @override
  Future<UserProfileEntity?> getCachedProfile(String userId) async {
    return _cache[userId];
  }

  @override
  Future<void> cacheUserProfile(UserProfileEntity profile) async {
    _cache[profile.id] = profile;
  }
}
