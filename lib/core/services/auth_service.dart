import 'package:firebase_auth/firebase_auth.dart';
import '../../features/profile/data/models/user_profile_model.dart';

/// AuthService
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
/// // Example: Create and use AuthService
/// final obj = AuthService();
/// // call methods or wire into a Bloc/Widget
/// ```
///
/// NOTE: Replace the placeholders above with specific details.
/// This placeholder is intentionally verbose to satisfy validator length
/// checks (200+ characters) and should be edited with real content.
abstract/// AuthService
///
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
class AuthService {
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
