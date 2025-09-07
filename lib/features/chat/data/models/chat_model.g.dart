// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(Map<String, dynamic> json) => ChatModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      otherUserId: json['otherUserId'] as String,
      otherUserName: json['otherUserName'] as String,
      otherUserProfileImage: json['otherUserProfileImage'] as String?,
      lastMessage: json['lastMessage'] as String?,
      lastMessageTime: json['lastMessageTime'] == null
          ? null
          : DateTime.parse(json['lastMessageTime'] as String),
      unreadCount: (json['unreadCount'] as num).toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ChatModelToJson(ChatModel instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'otherUserId': instance.otherUserId,
      'otherUserName': instance.otherUserName,
      'otherUserProfileImage': instance.otherUserProfileImage,
      'lastMessage': instance.lastMessage,
      'lastMessageTime': instance.lastMessageTime?.toIso8601String(),
      'unreadCount': instance.unreadCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };
