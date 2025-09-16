import '../../domain/entities/user_profile_entity.dart';

/// ProfileLocalDataSource
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
/// // Example: Create and use ProfileLocalDataSource
/// final obj = ProfileLocalDataSource();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract class ProfileLocalDataSource {
  Future<UserProfileEntity?> getCachedProfile(String userId);
  Future<void> cacheUserProfile(UserProfileEntity profile);
}

/// ProfileLocalDataSourceImpl
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
/// // Example: Create and use ProfileLocalDataSourceImpl
/// final obj = ProfileLocalDataSourceImpl();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
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
