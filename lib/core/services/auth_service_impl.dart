// ignore_for_file: avoid_print, duplicate_ignore

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import '../../app_config.dart';
import '../../features/profile/data/models/user_profile_model.dart';
import 'google_auth_service.dart';

/// AuthServiceImpl
///
/// Business Rules:
///  - Provides the concrete implementation for authentication-related
///    operations using Firebase Auth and Firestore.
///  - Methods should be resilient: failures while reading Firestore return
///    `null` where appropriate to avoid blocking app startup.
///
/// Note: This class intentionally contains pragmatic error handling to make
/// the app tolerant of Firestore permission issues in development/test envs.
class AuthServiceImpl implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  @override

  /// Creates a new user account using email and password.
  ///
  /// Returns the Firebase [UserCredential] for the created account on
  /// success.
  ///
  /// Throws an [Exception] on failure (for example, when the email is
  /// already in use, the password is weak, or network errors occur).
  ///
  /// Business rules:
  /// - `email` must be a valid email address.
  /// - `password` must meet server-side requirements.
  /// - `name` and `userType` are stored in the Firestore `users` document
  ///   created for the new user.
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String userType,
  }) async {
    try {
      // Note: we intentionally do not perform a pre-check for existing sign-in
      // methods because the project's firebase_auth API version may not expose
      // a stable method for that. Rely on `createUserWithEmailAndPassword`
      // which will throw a FirebaseAuthException with code
      // 'email-already-in-use' if the email is already registered.
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile document
      UserProfileModel userProfile = UserProfileModel(
        id: userCredential.user!.uid,
        fullName: name,
        email: email,
        phoneNumber: '',
        profilePictureUrl: '',
        bio: '',
        paymentMethods: const [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Add userType to the profile data since it's not part of UserProfileModel
      Map<String, dynamic> profileData = userProfile.toJson();
      profileData['userType'] = userType;

      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(profileData);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Map common FirebaseAuthException codes to friendly messages
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception(
              'The email address is already in use by another account.');
        case 'weak-password':
          throw Exception(
              'The password is too weak. Please choose a stronger password.');
        case 'invalid-email':
          throw Exception('The email address is invalid.');
        case 'operation-not-allowed':
          throw Exception('Email/password accounts are not enabled.');
        case 'network-request-failed':
          throw Exception('Network error. Please check your connection.');
        default:
          throw Exception('Sign up failed: ${e.message ?? e.code}');
      }
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  @override
  Future<void> changePassword({required String newPassword}) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No user is currently signed in');
      await user.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Change password failed: $e');
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges();
  }

  @override
  Future<UserProfileModel?> getCurrentUserProfile() async {
    /// Returns the current user's profile read from Firestore.
    ///
    /// Returns:
    ///  - `UserProfileModel` when a profile document exists and is readable.
    ///  - `null` when no Firebase user is signed in, the document does not
    ///    exist, the Firestore read times out, or permissions prevent access.
    ///
    /// This method intentionally returns `null` instead of throwing for many
    /// error cases so that UI startup flows can continue and fallback UI
    /// behavior can handle missing profile data.
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      // ignore: avoid_print
      print('AuthService: no Firebase user currently signed in');
      return null;
    }

    // Detailed debug & timing to help diagnose startup auth flows
    final start = DateTime.now();
    // ignore: avoid_print
    print('AuthService: getCurrentUserProfile() started for uid=${user.uid}');

    try {
      // Protect against long-running Firestore calls by adding a timeout.
      // ignore: avoid_print
      print('AuthService: About to call Firestore get()');
      final futureDoc = _firestore.collection('users').doc(user.uid).get();
      DocumentSnapshot doc = await futureDoc
          .timeout(Duration(seconds: AppConfig.authProfileTimeoutSeconds));

      final tookMs = DateTime.now().difference(start).inMilliseconds;
      // ignore: avoid_print
      print(
          'AuthService: Firestore get() completed in ${tookMs}ms; exists=${doc.exists}');

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        // Ensure userType is not null
        if (data['userType'] == null) {
          data['userType'] = 'customer'; // Default user type
        }
        return UserProfileModel.fromJson(data);
      }

      return null;
    } on TimeoutException catch (e, s) {
      // Timeout when fetching profile; return null so auth flow can fall back
      // to the Firebase auth state check and the UI can continue.
      // ignore: avoid_print
      print(
          'AuthService: getCurrentUserProfile() timed out after ${AppConfig.authProfileTimeoutSeconds}s');
      print('AuthService: TimeoutException: $e');
      print('AuthService: Stacktrace: $s');
      return null;
    } catch (e) {
      // If Firestore permission denied, treat as missing profile instead of
      // failing the whole auth flow. This makes sign-in flows resilient in
      // test or restricted environments where Firestore rules prevent reads.
      if (e is FirebaseException && e.code == 'permission-denied') {
        // ignore: avoid_print
        print(
            'Firestore permission denied while fetching user profile: ${e.message}');
        return null;
      }
      // For other errors, log and return null to avoid blocking app startup.
      // This keeps the auth flow resilient while still surfacing the error in logs.
      // ignore: avoid_print
      print('AuthService: Failed to get user profile: $e');
      return null;
    }
  }

  @override
  Future<void> updateUserProfile(UserProfileModel profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.id)
          .update(profile.toJson());
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  @override
  Future<bool> isFirstSignIn(String userId) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(userId).get();

      // If document doesn't exist or has no createdAt field, it's the first sign in
      return !doc.exists || !doc.data().toString().contains('createdAt');
    } catch (e) {
      throw Exception('Failed to check first sign in: $e');
    }
  }

  @override
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final UserCredential? userCredential =
          await _googleAuthService.signInWithGoogle();

      if (userCredential != null && userCredential.user != null) {
        // Check if user profile exists
        UserProfileModel? existingProfile;
        try {
          existingProfile = await getCurrentUserProfile();
        } catch (e) {
          // If profile lookup fails due to permissions, treat as missing and
          // continue; creating a new profile will likely fail too, so guard below.
          existingProfile = null;
        }

        // If profile doesn't exist, create a new one
        if (existingProfile == null) {
          final userProfile = UserProfileModel(
            id: userCredential.user!.uid,
            fullName: userCredential.user!.displayName ?? '',
            email: userCredential.user!.email ?? '',
            phoneNumber: '',
            profilePictureUrl: userCredential.user!.photoURL ?? '',
            bio: '',
            paymentMethods: const [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );

          try {
            await _firestore
                .collection('users')
                .doc(userCredential.user!.uid)
                .set(userProfile.toJson());
          } catch (e) {
            // If creation fails due to permissions, log and continue — the
            // app should still be able to operate in a degraded mode.
            if (e is FirebaseException && e.code == 'permission-denied') {
              // ignore: avoid_print
              print(
                  'Firestore permission denied while creating user profile: ${e.message}');
            } else {
              rethrow;
            }
          }
        }
      }

      return userCredential;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }
}
