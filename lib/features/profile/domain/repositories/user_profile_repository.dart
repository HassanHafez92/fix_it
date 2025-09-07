import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile_entity.dart';

abstract class UserProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile(String userId);
  Future<Either<Failure, UserProfileEntity>> updateProfile(UserProfileEntity profile);
  Future<Either<Failure, void>> changePassword(String oldPassword, String newPassword);
  Future<Either<Failure, String>> uploadProfilePicture(String filePath);
  Future<Either<Failure, void>> deleteProfilePicture();
}