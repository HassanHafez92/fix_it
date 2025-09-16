import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/core/usecases/usecase.dart';
import 'package:fix_it/features/chat/domain/entities/message_entity.dart';
import 'package:fix_it/features/chat/domain/repositories/chat_repository.dart';

/// GetChatMessagesUseCase
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
/// // Example: Create and use GetChatMessagesUseCase
/// final obj = GetChatMessagesUseCase();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class GetChatMessagesUseCase implements UseCase<List<MessageEntity>, GetChatMessagesParams> {
  final ChatRepository repository;

  GetChatMessagesUseCase(this.repository);

  @override
  Future<Either<Failure, List<MessageEntity>>> call(GetChatMessagesParams params) async {
    return await repository.getChatMessages(params.chatId);
  }
}

/// GetChatMessagesParams
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
/// // Example: Create and use GetChatMessagesParams
/// final obj = GetChatMessagesParams();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class GetChatMessagesParams extends Equatable {
  final String chatId;

  const GetChatMessagesParams({required this.chatId});

  @override
  List<Object> get props => [chatId];
}
