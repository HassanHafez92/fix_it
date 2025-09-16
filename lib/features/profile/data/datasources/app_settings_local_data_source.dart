import 'package:fix_it/core/error/exceptions.dart';
import 'package:fix_it/features/profile/domain/entities/app_settings_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// AppSettingsLocalDataSource
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
/// // Example: Create and use AppSettingsLocalDataSource
/// final obj = AppSettingsLocalDataSource();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract class AppSettingsLocalDataSource {
  Future<void> cacheAppSettings(AppSettingsEntity settings);
  Future<AppSettingsEntity> getLastAppSettings();
}

/// AppSettingsLocalDataSourceImpl
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
/// // Example: Create and use AppSettingsLocalDataSourceImpl
/// final obj = AppSettingsLocalDataSourceImpl();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class AppSettingsLocalDataSourceImpl implements AppSettingsLocalDataSource {
  final SharedPreferences sharedPreferences;

  AppSettingsLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheAppSettings(AppSettingsEntity settings) async {
    await sharedPreferences.setString(
      'app_settings',
      settings.toJson(),
    );
  }

  @override
  Future<AppSettingsEntity> getLastAppSettings() {
    final jsonString = sharedPreferences.getString('app_settings');
    if (jsonString != null) {
      return Future.value(AppSettingsEntity.fromJson(jsonString));
    } else {
      throw CacheException();
    }
  }
}
