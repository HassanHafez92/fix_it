import 'package:json_annotation/json_annotation.dart';
import 'package:fix_it/features/chat/domain/entities/chat_entity.dart';

part 'chat_model.g.dart';

@JsonSerializable()
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
