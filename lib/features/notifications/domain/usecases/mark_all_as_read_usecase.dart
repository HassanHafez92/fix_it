import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

class MarkAllAsReadUseCase implements UseCase<void, String> {
  final NotificationRepository repository;

  MarkAllAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String userId) async {
    return await repository.markAllAsRead(userId);
  }
}
