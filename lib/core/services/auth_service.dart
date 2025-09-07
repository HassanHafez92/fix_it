import 'package:firebase_auth/firebase_auth.dart';
import '../../features/profile/data/models/user_profile_model.dart';

abstract class AuthService {
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String userType,
  });

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> resetPassword({required String email});
  Future<void> changePassword({required String newPassword});

  Stream<User?> get authStateChanges;

  Future<UserProfileModel?> getCurrentUserProfile();

  Future<void> updateUserProfile(UserProfileModel profile);

  Future<bool> isFirstSignIn(String userId);

  Future<UserCredential?> signInWithGoogle();
}
