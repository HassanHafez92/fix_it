import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_settings_entity.dart';

abstract class AppSettingsRepository {
  Future<Either<Failure, AppSettingsEntity>> getAppSettings();
  Future<Either<Failure, void>> updateAppSettings(AppSettingsEntity settings);
  Future<Either<Failure, void>> resetToDefaults();
}