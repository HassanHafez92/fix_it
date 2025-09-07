import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationAsReadUseCase implements UseCase<void, String> {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String notificationId) async {
    return await repository.markAsRead(notificationId);
  }
}