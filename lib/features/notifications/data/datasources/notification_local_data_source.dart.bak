import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationLocalDataSource {
  Future<List<NotificationEntity>> getCachedNotifications(String userId);
  Future<void> cacheNotifications(
      String userId, List<NotificationEntity> notifications);
  Future<void> clearCachedNotifications(String userId);
}

class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  final SharedPreferences sharedPreferences;

  NotificationLocalDataSourceImpl({required this.sharedPreferences});

  String _key(String userId) => 'notifications_cache_\$userId';

  @override
  Future<void> cacheNotifications(
      String userId, List<NotificationEntity> notifications) async {
    final jsonList = notifications
        .map((n) => {
              'id': n.id,
              'userId': n.userId,
              'title': n.title,
              'body': n.body,
              'type': n.type.toString(),
              'timestamp': n.timestamp.toIso8601String(),
              'isRead': n.isRead,
              'targetData': n.targetData,
              'imageUrl': n.imageUrl,
            })
        .toList();
    await sharedPreferences.setString(_key(userId), jsonEncode(jsonList));
  }

  @override
  Future<List<NotificationEntity>> getCachedNotifications(String userId) async {
    final raw = sharedPreferences.getString(_key(userId));
    if (raw == null) return [];
    final List decoded = jsonDecode(raw) as List;
    return decoded.map((e) {
      final Map<String, dynamic> map = Map<String, dynamic>.from(e as Map);
      return NotificationEntity(
        id: map['id'] as String? ?? '',
        userId: map['userId'] as String? ?? userId,
        title: map['title'] as String? ?? '',
        body: map['body'] as String? ?? '',
        type: NotificationType.values.firstWhere(
            (t) => t.toString() == map['type'],
            orElse: () => NotificationType.general),
        timestamp: DateTime.tryParse(map['timestamp'] as String? ?? '') ??
            DateTime.now(),
        isRead: map['isRead'] as bool? ?? false,
        targetData: (map['targetData'] as Map?)?.cast<String, dynamic>(),
        imageUrl: map['imageUrl'] as String?,
      );
    }).toList();
  }

  @override
  Future<void> clearCachedNotifications(String userId) async {
    await sharedPreferences.remove(_key(userId));
  }
}
