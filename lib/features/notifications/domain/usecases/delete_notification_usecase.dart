import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

class DeleteNotificationUseCase implements UseCase<void, String> {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String notificationId) async {
    return await repository.deleteNotification(notificationId);
  }
}
