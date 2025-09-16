import 'package:equatable/equatable.dart';

class ChatEntity extends Equatable {
  final String id;
  final String userId;
  final String otherUserId;
  final String otherUserName;
  final String? otherUserProfileImage;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final DateTime createdAt;

  const ChatEntity({
    required this.id,
    required this.userId,
    required this.otherUserId,
    required this.otherUserName,
    this.otherUserProfileImage,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCount,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        otherUserId,
        otherUserName,
        otherUserProfileImage,
        lastMessage,
        lastMessageTime,
        unreadCount,
        createdAt,
      ];
}
