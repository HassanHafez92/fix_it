import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Service responsible for FCM token management and basic message handling.
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
class NotificationService {
  final FirebaseMessaging _messaging;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  NotificationService(
      {FirebaseMessaging? messaging,
      FirebaseAuth? auth,
      FirebaseFirestore? firestore})
      : _messaging = messaging ?? FirebaseMessaging.instance,
        _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /// Initializes FCM: requests permission on iOS, gets initial token and
  /// subscribes to token refresh events. Tokens are stored under
  /// `users/{uid}/push_tokens/{token}` to enable multi-device delivery.
  Future<void> init() async {
    try {
      await _messaging.requestPermission();

      // Get token and sync
      final token = await _messaging.getToken();
      if (token != null) {
        await _syncToken(token);
      }

      // Listen for token refresh
      _messaging.onTokenRefresh.listen((newToken) async {
        await _syncToken(newToken);
      });

      // Foreground message handler can be set by app via FirebaseMessaging.onMessage
    } catch (_) {
      // Non-fatal: continue without FCM
    }
  }

  Future<void> _syncToken(String token) async {
    final user = _auth.currentUser;
    if (user == null) return; // not signed in yet

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('push_tokens')
        .doc(token);
    await docRef.set({
      'token': token,
      'createdAt': FieldValue.serverTimestamp(),
      'platform': defaultTargetPlatform.toString(),
    });
  }
}
