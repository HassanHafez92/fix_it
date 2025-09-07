import 'package:fix_it/features/chat/data/models/chat_model.dart';
import 'package:fix_it/features/chat/data/models/message_model.dart';

abstract class ChatLocalDataSource {
  Future<List<ChatModel>> getCachedChatList();
  Future<void> cacheChatList(List<ChatModel> chats);

  Future<List<MessageModel>> getCachedChatMessages(String chatId);
  Future<void> cacheChatMessages(String chatId, List<MessageModel> messages);
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  // In a real app, this would use shared_preferences, hive, or another local storage solution
  final Map<String, dynamic> _cache = {};

  @override
  Future<List<ChatModel>> getCachedChatList() async {
    // In a real app, this would retrieve the chat list from local storage
    // For now, we'll return mock data if available in the cache
    if (_cache.containsKey('chat_list')) {
      return _cache['chat_list'];
    } else {
      // Return empty list if no cached data
      return [];
    }
  }

  @override
  Future<void> cacheChatList(List<ChatModel> chats) async {
    // In a real app, this would save the chat list to local storage
    // For now, we'll just store them in the in-memory cache
    _cache['chat_list'] = chats;
  }

  @override
  Future<List<MessageModel>> getCachedChatMessages(String chatId) async {
    // In a real app, this would retrieve the messages for a specific chat from local storage
    // For now, we'll return mock data if available in the cache
    final cacheKey = 'chat_messages_$chatId';
    if (_cache.containsKey(cacheKey)) {
      return _cache[cacheKey];
    } else {
      // Return empty list if no cached data
      return [];
    }
  }

  @override
  Future<void> cacheChatMessages(String chatId, List<MessageModel> messages) async {
    // In a real app, this would save the messages for a specific chat to local storage
    // For now, we'll just store them in the in-memory cache
    final cacheKey = 'chat_messages_$chatId';
    _cache[cacheKey] = messages;
  }
}
