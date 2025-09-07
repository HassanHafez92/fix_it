import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/user_profile_repository.dart';
import '../datasources/profile_local_data_source.dart';
import '../datasources/profile_remote_data_source.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;

  UserProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile(
      String userId) async {
    try {
      final remote = await remoteDataSource.fetchUserProfile(userId);
      await localDataSource.cacheUserProfile(remote);
      return Right(remote);
    } catch (e) {
      final cached = await localDataSource.getCachedProfile(userId);
      if (cached != null) return Right(cached);
      return Left(ServerFailure('Server error while fetching profile'));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateProfile(
      UserProfileEntity profile) async {
    try {
      final updated = await remoteDataSource.updateUserProfile(profile);
      await localDataSource.cacheUserProfile(updated);
      return Right(updated);
    } catch (e) {
      return Left(ServerFailure('Server error while updating profile'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword(
      String oldPassword, String newPassword) async {
    try {
      // Not implemented against remote; return success for now
      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Server error while changing password'));
    }
  }

  @override
  Future<Either<Failure, String>> uploadProfilePicture(String filePath) async {
    try {
      final url = await remoteDataSource.uploadProfilePicture(filePath);
      return Right(url);
    } catch (e) {
      return Left(
          ServerFailure('Server error while uploading profile picture'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteProfilePicture() async {
    try {
      await remoteDataSource.deleteProfilePicture();
      return Right(null);
    } catch (e) {
      return Left(ServerFailure('Server error while deleting profile picture'));
    }
  }
}
