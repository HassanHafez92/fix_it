import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/notification_entity.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUseCase implements UseCase<List<NotificationEntity>, String> {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(String userId) async {
    return await repository.getNotifications(userId);
  }
}