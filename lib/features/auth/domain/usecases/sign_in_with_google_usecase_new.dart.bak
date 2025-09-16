import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

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
///
/// **User Experience Features:**
/// - Single-tap authentication (no password required)
/// - Automatic account detection on device
/// - Seamless switching between Google accounts
/// - Profile picture and email auto-population
/// - Consistent cross-platform experience
/// - Remember user choice for future sign-ins
///
/// **Performance Characteristics:**
/// - Typical completion time: 2-10 seconds (includes user interaction)
/// - Network calls: Multiple (OAuth flow, token exchange, profile fetch)
/// - User interaction: Required (account selection and consent)
/// - Caching: Google credentials cached by platform SDK
///
/// **Dependencies:**
/// - [AuthRepository]: Handles Firebase integration and user data
/// - Google Sign-In SDK: Platform-specific OAuth implementation
/// - Firebase Authentication: Validates Google tokens
/// - Cloud Firestore: Stores extended user profile information
/// - Platform services: Google Play Services (Android), Safari (iOS)
///
/// Example usage:
/// ```dart
/// final signInWithGoogleUseCase = sl<SignInWithGoogleUseCase>();
/// 
/// // Standard Google Sign-In flow
/// void handleGoogleSignIn() async {
///   // Show loading state
///   showGoogleSignInLoading();
///   
///   final result = await signInWithGoogleUseCase(NoParams());
///   
///   hideGoogleSignInLoading();
///   
///   result.fold(
///     (failure) {
///       switch (failure.runtimeType) {
///         case GoogleSignInCancelledFailure:
///           // User cancelled - no error message needed
///           break;
///         case NetworkFailure:
///           showError('Please check your internet connection and try again');
///           break;
///         case GoogleSignInFailure:
///           showError('Google Sign-In is temporarily unavailable');
///           break;
///         case PermissionDeniedFailure:
///           showError('Please grant necessary permissions to continue');
///           break;
///         default:
///           showError('Sign-in failed. Please try again');
///       }
///     },
///     (user) {
///       // Successful authentication
///       showWelcomeMessage('Welcome, \${user.displayName}!');
///       
///       if (user.isProvider) {
///         navigateToProviderDashboard(user);
///       } else {
///         navigateToClientHome(user);
///       }
///     },
///   );
/// }
/// ```
class SignInWithGoogleUseCase implements UseCase<UserEntity, NoParams> {
  /// Repository for authentication operations and Google Sign-In integration.
  ///
  /// Provides access to Firebase Authentication with Google provider
  /// and handles the coordination between Google OAuth tokens and
  /// Firebase user session management.
  final AuthRepository repository;

  /// Creates a [SignInWithGoogleUseCase] with the required [repository].
  ///
  /// The repository dependency is injected to enable testing with mock
  /// implementations and to follow dependency inversion principles.
  SignInWithGoogleUseCase({required this.repository});

  /// Executes the Google Sign-In authentication flow.
  ///
  /// **Input Parameters:**
  /// - [params]: [NoParams] instance (no additional input required)
  ///
  /// **Returns:**
  /// - [Right<UserEntity>]: Complete user data on successful authentication
  /// - [Left<Failure>]: Specific failure type indicating the error cause
  ///
  /// **User Interaction Flow:**
  /// 1. Google Sign-In UI is presented to the user
  /// 2. User selects their Google account (or signs in if needed)
  /// 3. User grants permissions for the app to access their Google profile
  /// 4. OAuth tokens are exchanged and validated
  /// 5. User profile is created/updated in Firestore
  /// 6. Authenticated session is established
  ///
  /// **Side Effects:**
  /// - Updates Firebase Authentication state
  /// - Creates or updates user profile in Firestore
  /// - Establishes authenticated session
  /// - Triggers authentication state listeners
  /// - Caches Google credentials on device
  /// - May prompt for additional permissions
  ///
  /// **Error Handling:**
  /// - User cancellation is handled gracefully (not an error to user)
  /// - Network errors provide appropriate retry suggestions
  /// - Permission issues are clearly communicated
  /// - Service unavailability is handled with fallback options
  ///
  /// The method delegates to the repository which handles the complex
  /// OAuth flow coordination and Firebase integration.
  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}
