import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/user_profile_repository.dart';

class UpdateUserProfileUseCase implements UseCase<UserProfileEntity, UserProfileEntity> {
  final UserProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfileEntity>> call(UserProfileEntity profile) async {
    return await repository.updateProfile(profile);
  }
}