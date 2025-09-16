import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

/// Authenticates a user using Google Sign-In OAuth flow.
///
/// This use case handles the complete Google Sign-In authentication process,
/// including OAuth flow initiation, user consent, token exchange, and user
/// profile creation or retrieval. It provides a seamless and secure way for
/// users to authenticate using their existing Google accounts.
///
/// **Business Rules:**
/// - User must have a valid Google account
/// - Google Sign-In must be enabled in Firebase project
/// - User must grant necessary permissions during OAuth flow
/// - Automatic account creation for new Google users
/// - Profile information is auto-populated from Google profile
///
/// **OAuth Flow Process:**
/// 1. Initialize Google Sign-In SDK
/// 2. Present Google authentication UI to user
/// 3. User selects Google account and grants permissions
/// 4. Google returns authorization code and user info
/// 5. Exchange authorization code for access tokens
/// 6. Verify tokens with Firebase Authentication
/// 7. Create or retrieve user profile from Firestore
/// 8. Return complete user entity with session established
///
/// **Security Features:**
/// - OAuth 2.0 standard compliance for secure authentication
/// - No password handling required (managed by Google)
/// - Automatic token refresh handled by Google SDK
/// - Secure token storage managed by platform
/// - Cross-site request forgery (CSRF) protection
/// - Consent screen ensures user awareness of permissions
///
/// **Error Scenarios:**
/// - [GoogleSignInCancelledFailure]: User cancelled the sign-in process
/// - [GoogleSignInFailure]: Google authentication service error
/// - [NetworkFailure]: No internet connection during OAuth flow
/// - [ServerFailure]: Firebase or Google service temporarily unavailable
/// - [PermissionDeniedFailure]: User denied required permissions
/// - [AccountRestrictionFailure]: Google account restricted or disabled
class SignInWithGoogleUseCase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  SignInWithGoogleUseCase({required this.repository});

  @override
  Future<UserEntity> call(NoParams params) async {
    try {
      final result = await repository.signInWithGoogle();
      
      return result.fold(
        (failure) => throw Exception('Failed to sign in with Google: ${failure.message}'),
        (userEntity) => userEntity,
      );
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
  }
}
