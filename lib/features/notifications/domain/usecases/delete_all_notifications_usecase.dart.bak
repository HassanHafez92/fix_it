import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

class DeleteAllNotificationsUseCase implements UseCase<void, String> {
  final NotificationRepository repository;

  DeleteAllNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String userId) async {
    return await repository.deleteAllNotifications(userId);
  }
}
