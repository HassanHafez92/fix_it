import 'package:fix_it/features/chat/data/models/chat_model.dart';
import 'package:fix_it/features/chat/data/models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatModel>> getChatList();
  Future<List<ChatModel>> searchChatList(String query);
  Future<List<MessageModel>> getChatMessages(String chatId);
  Future<bool> sendMessage({
    required String chatId,
    required String message,
    String? attachmentUrl,
    String? attachmentType,
  });
  Future<String> createChat({
    required String otherUserId,
  });
  Future<bool> markMessagesAsRead({
    required String chatId,
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  // This would normally use an API client
  // For now, we'll implement mock data

  @override
  Future<List<ChatModel>> getChatList() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return mock data
    return [
      ChatModel(
        id: 'chat1',
        userId: 'user1',
        otherUserId: 'provider1',
        otherUserName: 'John Doe',
        otherUserProfileImage:
            'https://ui-avatars.com/api/?name=John+Doe&background=007bff&color=fff',
        lastMessage: 'Hi, I need help with my plumbing issue',
        lastMessageTime: DateTime.now().subtract(const Duration(minutes: 30)),
        unreadCount: 2,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ChatModel(
        id: 'chat2',
        userId: 'user1',
        otherUserId: 'provider2',
        otherUserName: 'Jane Smith',
        otherUserProfileImage:
            'https://ui-avatars.com/api/?name=Jane+Smith&background=28a745&color=fff',
        lastMessage: 'When can you come to fix the electricity?',
        lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
        unreadCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      ChatModel(
        id: 'chat3',
        userId: 'user1',
        otherUserId: 'provider3',
        otherUserName: 'Mike Johnson',
        otherUserProfileImage: null,
        lastMessage: 'Thanks for your help!',
        lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
        unreadCount: 0,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];
  }

  @override
  Future<List<MessageModel>> getChatMessages(String chatId) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return mock data based on chat ID
    if (chatId == 'chat1') {
      return [
        MessageModel(
          id: 'msg1',
          chatId: 'chat1',
          senderId: 'provider1',
          receiverId: 'user1',
          content:
              'Hello, I can help you with your plumbing issue. When are you available?',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          isRead: true,
        ),
        MessageModel(
          id: 'msg2',
          chatId: 'chat1',
          senderId: 'user1',
          receiverId: 'provider1',
          content: 'Hi, I need help with my plumbing issue',
          timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
          isRead: false,
        ),
      ];
    } else if (chatId == 'chat2') {
      return [
        MessageModel(
          id: 'msg3',
          chatId: 'chat2',
          senderId: 'user1',
          receiverId: 'provider2',
          content: 'When can you come to fix the electricity?',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isRead: true,
        ),
        MessageModel(
          id: 'msg4',
          chatId: 'chat2',
          senderId: 'provider2',
          receiverId: 'user1',
          content: 'I can come tomorrow at 10 AM',
          timestamp:
              DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
          isRead: true,
        ),
      ];
    } else {
      return [
        MessageModel(
          id: 'msg5',
          chatId: 'chat3',
          senderId: 'user1',
          receiverId: 'provider3',
          content: 'Thanks for your help!',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: true,
        ),
        MessageModel(
          id: 'msg6',
          chatId: 'chat3',
          senderId: 'provider3',
          receiverId: 'user1',
          content: 'You\'re welcome! Let me know if you need anything else.',
          timestamp:
              DateTime.now().subtract(const Duration(days: 1, minutes: 5)),
          isRead: true,
        ),
      ];
    }
  }

  @override
  Future<List<ChatModel>> searchChatList(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final list = await getChatList();
    final lower = query.toLowerCase();
    return list.where((c) {
      final name = c.otherUserName.toLowerCase();
      final last = (c.lastMessage ?? '').toLowerCase();
      return name.contains(lower) || last.contains(lower);
    }).toList();
  }

  @override
  Future<bool> sendMessage({
    required String chatId,
    required String message,
    String? attachmentUrl,
    String? attachmentType,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return success
    return true;
  }

  @override
  Future<String> createChat({
    required String otherUserId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Return mock chat id
    return 'chat_${otherUserId}_${DateTime.now().millisecondsSinceEpoch}';
  }

  @override
  Future<bool> markMessagesAsRead({
    required String chatId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Return success
    return true;
  }
}
