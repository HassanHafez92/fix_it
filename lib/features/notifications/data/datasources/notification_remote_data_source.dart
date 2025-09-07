import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationEntity>> getNotifications(String userId);
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead(String userId);
  Future<void> deleteNotification(String notificationId);
  Future<void> deleteAllNotifications(String userId);
  Future<int> getUnreadCount(String userId);
  Future<void> sendNotification({
    required String userId,
    required String title,
    required String body,
    required NotificationType type,
    Map<String, dynamic>? targetData,
    String? imageUrl,
  });
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> _userNotifications(String userId) =>
      firestore.collection('users').doc(userId).collection('notifications');

  @override
  Future<void> deleteAllNotifications(String userId) async {
    final coll = _userNotifications(userId);
    final batch = firestore.batch();
    final snap = await coll.get();
    for (final doc in snap.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    final query = await firestore
        .collectionGroup('notifications')
        .where('id', isEqualTo: notificationId)
        .get();
    for (final doc in query.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<List<NotificationEntity>> getNotifications(String userId) async {
    final snap = await _userNotifications(userId)
        .orderBy('timestamp', descending: true)
        .get();
    return snap.docs.map((d) {
      final data = d.data();
      return NotificationEntity(
        id: data['id'] as String? ?? d.id,
        userId: userId,
        title: data['title'] as String? ?? '',
        body: data['body'] as String? ?? '',
        type: NotificationType.values.firstWhere(
            (e) => e.toString() == data['type'],
            orElse: () => NotificationType.general),
        timestamp:
            (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
        isRead: data['isRead'] as bool? ?? false,
        targetData: (data['targetData'] as Map?)?.cast<String, dynamic>(),
        imageUrl: data['imageUrl'] as String?,
      );
    }).toList();
  }

  @override
  Future<void> markAllAsRead(String userId) async {
    final coll = _userNotifications(userId);
    final snap = await coll.where('isRead', isEqualTo: false).get();
    final batch = firestore.batch();
    for (final doc in snap.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  @override
  Future<void> markAsRead(String notificationId) async {
    final query = await firestore
        .collectionGroup('notifications')
        .where('id', isEqualTo: notificationId)
        .get();
    for (final doc in query.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  @override
  Future<void> sendNotification(
      {required String userId,
      required String title,
      required String body,
      required NotificationType type,
      Map<String, dynamic>? targetData,
      String? imageUrl}) async {
    final coll = _userNotifications(userId);
    final doc = coll.doc();
    await doc.set({
      'id': doc.id,
      'title': title,
      'body': body,
      'type': type.toString(),
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'targetData': targetData,
      'imageUrl': imageUrl,
    });
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    final snap = await _userNotifications(userId)
        .where('isRead', isEqualTo: false)
        .get();
    return snap.size;
  }
}
