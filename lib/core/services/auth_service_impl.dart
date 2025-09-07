import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';
import '../../features/profile/data/models/user_profile_model.dart';
import 'google_auth_service.dart';

class AuthServiceImpl implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleAuthService _googleAuthService = GoogleAuthService();

  @override
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
    final User? user = _firebaseAuth.currentUser;
    if (user == null) {
      return null;
    }

    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        // Ensure userType is not null
        if (data['userType'] == null) {
          data['userType'] = 'customer'; // Default user type
        }
        return UserProfileModel.fromJson(data);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
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
        UserProfileModel? existingProfile = await getCurrentUserProfile();

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

          await _firestore
              .collection('users')
              .doc(userCredential.user!.uid)
              .set(userProfile.toJson());
        }
      }

      return userCredential;
    } catch (e) {
      throw Exception('Google sign in failed: $e');
    }
  }
}
