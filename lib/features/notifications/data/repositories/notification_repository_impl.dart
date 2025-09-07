import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_local_data_source.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  final NotificationLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NotificationRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> deleteAllNotifications(String userId) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.deleteAllNotifications(userId);
      }
      await localDataSource.clearCachedNotifications(userId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(
      String notificationId) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.deleteNotification(notificationId);
      }
      // No local action for single delete (could refresh cache)
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications(
      String userId) async {
    try {
      if (await networkInfo.isConnected) {
        final notifications = await remoteDataSource.getNotifications(userId);
        await localDataSource.cacheNotifications(userId, notifications);
        return Right(notifications);
      } else {
        final cached = await localDataSource.getCachedNotifications(userId);
        return Right(cached);
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead(String userId) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.markAllAsRead(userId);
      }
      // Update local cache by clearing unread flag
      final cached = await localDataSource.getCachedNotifications(userId);
      final updated = cached.map((n) => n.copyWith(isRead: true)).toList();
      await localDataSource.cacheNotifications(userId, updated);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.markAsRead(notificationId);
      }
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getUnreadCount(String userId) async {
    try {
      if (await networkInfo.isConnected) {
        final count = await remoteDataSource.getUnreadCount(userId);
        return Right(count);
      } else {
        final cached = await localDataSource.getCachedNotifications(userId);
        final count = cached.where((n) => !n.isRead).length;
        return Right(count);
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendNotification(
      {required String userId,
      required String title,
      required String body,
      required NotificationType type,
      Map<String, dynamic>? targetData,
      String? imageUrl}) async {
    try {
      if (await networkInfo.isConnected) {
        await remoteDataSource.sendNotification(
          userId: userId,
          title: title,
          body: body,
          type: type,
          targetData: targetData,
          imageUrl: imageUrl,
        );
        return const Right(null);
      }
      return Left(ServerFailure('No network to send notification'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
