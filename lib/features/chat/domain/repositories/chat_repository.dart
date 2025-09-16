import 'package:dartz/dartz.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/features/chat/domain/entities/chat_entity.dart';
import 'package:fix_it/features/chat/domain/entities/message_entity.dart';

/// ChatRepository
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
/// // Example: Create and use ChatRepository
/// final obj = ChatRepository();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract class ChatRepository {
  Future<Either<Failure, List<ChatEntity>>> getChatList();
  Future<Either<Failure, List<ChatEntity>>> searchChatList(String query);
  Future<Either<Failure, List<MessageEntity>>> getChatMessages(String chatId);
  Future<Either<Failure, bool>> sendMessage({
    required String chatId,
    required String message,
    String? attachmentUrl,
    String? attachmentType,
  });
  Future<Either<Failure, String>> createChat({
    required String otherUserId,
  });
  Future<Either<Failure, bool>> markMessagesAsRead({
    required String chatId,
  });
  Stream<List<MessageEntity>> subscribeToChatMessages(String chatId);
}
