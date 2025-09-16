import 'package:fix_it/core/error/exceptions.dart';
import 'package:fix_it/features/profile/domain/entities/app_settings_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppSettingsLocalDataSource {
  Future<void> cacheAppSettings(AppSettingsEntity settings);
  Future<AppSettingsEntity> getLastAppSettings();
}

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
