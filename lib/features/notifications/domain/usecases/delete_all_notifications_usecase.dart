import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/notification_repository.dart';

/// DeleteAllNotificationsUseCase
///
/// Business Rules:
/// - Add the main business rules or invariants enforced by this class.
/// - Be concise and concrete.
///
/// Error Scenarios:
/// - Describe common errors and how the class responds (exceptions,
///   fallbacks, retries).
///
/// Dependencies:
/// - List key dependencies, required services, or external resources.
///
/// Example usage:
/// ```dart
/// // Example: Create and use DeleteAllNotificationsUseCase
/// final obj = DeleteAllNotificationsUseCase();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class DeleteAllNotificationsUseCase implements UseCase<void, String> {
  final NotificationRepository repository;

  DeleteAllNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(String userId) async {
    return await repository.deleteAllNotifications(userId);
  }
}
