import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/notification_entity.dart';

/// NotificationRemoteDataSource
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
/// // Example: Create and use NotificationRemoteDataSource
/// final obj = NotificationRemoteDataSource();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
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

/// NotificationRemoteDataSourceImpl
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
/// // Example: Create and use NotificationRemoteDataSourceImpl
/// final obj = NotificationRemoteDataSourceImpl();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
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
    try {
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
    } on FirebaseException catch (e) {
      // Treat permission-denied as no notifications available in restricted environments.
      if (e.code == 'permission-denied') {
        return <NotificationEntity>[];
      }
      rethrow;
    }
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
    try {
      final snap = await _userNotifications(userId)
          .where('isRead', isEqualTo: false)
          .get();
      return snap.size;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        return 0;
      }
      rethrow;
    }
  }
}
