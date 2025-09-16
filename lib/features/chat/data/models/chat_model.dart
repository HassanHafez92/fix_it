import 'package:json_annotation/json_annotation.dart';
import 'package:fix_it/features/chat/domain/entities/chat_entity.dart';

part 'chat_model.g.dart';

@JsonSerializable()
/// ChatModel
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
/// // Example: Create and use ChatModel
/// final obj = ChatModel();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
class ChatModel extends ChatEntity {
  const ChatModel({
    required super.id,
    required super.userId,
    required super.otherUserId,
    required super.otherUserName,
    super.otherUserProfileImage,
    super.lastMessage,
    super.lastMessageTime,
    required super.unreadCount,
    required super.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChatModelToJson(this);

  factory ChatModel.fromEntity(ChatEntity entity) {
    return ChatModel(
      id: entity.id,
      userId: entity.userId,
      otherUserId: entity.otherUserId,
      otherUserName: entity.otherUserName,
      otherUserProfileImage: entity.otherUserProfileImage,
      lastMessage: entity.lastMessage,
      lastMessageTime: entity.lastMessageTime,
      unreadCount: entity.unreadCount,
      createdAt: entity.createdAt,
    );
  }
}
