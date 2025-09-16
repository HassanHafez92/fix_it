import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_settings_entity.dart';
import '../repositories/app_settings_repository.dart';

class GetAppSettingsUseCase implements UseCase<AppSettingsEntity, NoParams> {
  final AppSettingsRepository repository;

  GetAppSettingsUseCase(this.repository);

  @override
  Future<Either<Failure, AppSettingsEntity>> call(NoParams params) async {
    return await repository.getAppSettings();
  }
}