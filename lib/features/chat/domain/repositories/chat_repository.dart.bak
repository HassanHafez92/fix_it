import 'package:dartz/dartz.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:fix_it/features/chat/domain/entities/chat_entity.dart';
import 'package:fix_it/features/chat/domain/entities/message_entity.dart';

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
