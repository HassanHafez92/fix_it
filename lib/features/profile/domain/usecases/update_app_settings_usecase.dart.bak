import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_settings_entity.dart';
import '../repositories/app_settings_repository.dart';

class UpdateAppSettingsUseCase implements UseCase<void, AppSettingsEntity> {
  final AppSettingsRepository repository;

  UpdateAppSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AppSettingsEntity settings) async {
    return await repository.updateAppSettings(settings);
  }
}