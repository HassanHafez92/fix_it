import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications(String userId);
  Future<Either<Failure, void>> markAsRead(String notificationId);
  Future<Either<Failure, void>> markAllAsRead(String userId);
  Future<Either<Failure, void>> deleteNotification(String notificationId);
  Future<Either<Failure, void>> deleteAllNotifications(String userId);
  Future<Either<Failure, int>> getUnreadCount(String userId);
  Future<Either<Failure, void>> sendNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? targetData,
    String? imageUrl,
  });
}