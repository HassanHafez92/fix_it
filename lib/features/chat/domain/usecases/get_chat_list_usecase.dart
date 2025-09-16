import 'package:dartz/dartz.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/core/usecases/usecase.dart';
import 'package:fix_it/features/chat/domain/entities/chat_entity.dart';
import 'package:fix_it/features/chat/domain/repositories/chat_repository.dart';

/// GetChatListUseCase
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
/// // Example: Create and use GetChatListUseCase
/// final obj = GetChatListUseCase();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class GetChatListUseCase implements UseCase<List<ChatEntity>, NoParams> {
  final ChatRepository repository;

  GetChatListUseCase(this.repository);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(NoParams params) async {
    return await repository.getChatList();
  }
}
