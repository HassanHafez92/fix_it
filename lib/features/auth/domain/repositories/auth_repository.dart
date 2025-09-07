import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

import '../entities/user_entity.dart';

/// Abstract repository interface for user authentication and account management.
///
/// This repository defines the contract for all authentication-related operations
/// in the Fix It application. It follows the Repository pattern from Clean Architecture,
/// providing a clean separation between the domain layer and data implementation details.
///
/// **Design Principles:**
/// - Interface Segregation: Focused solely on authentication operations
/// - Dependency Inversion: Domain layer depends on abstraction, not implementation
/// - Single Responsibility: Handles only authentication and user account operations
/// - Error Handling: Uses [Either] type for explicit error handling
///
/// **Implementation Requirements:**
/// - Must handle both online and offline scenarios
/// - Should provide consistent error mapping from data sources
/// - Must ensure thread safety for concurrent operations
/// - Should implement proper timeout handling
/// - Must handle authentication state persistence
///
/// **Data Sources:**
/// - Remote: Firebase Authentication and Cloud Firestore
/// - Local: Secure storage for authentication tokens and cached user data
/// - Cache: In-memory user session management
///
/// **Security Considerations:**
/// - All authentication tokens must be handled securely
/// - User credentials should never be stored locally
/// - Authentication state must be validated on app resume
/// - Failed authentication attempts should be logged for security monitoring
///
/// **Error Handling Strategy:**
/// All methods return [Either<Failure, T>] where:
/// - [Left] contains specific failure types for proper error handling
/// - [Right] contains the successful operation result
/// - Network errors are mapped to [NetworkFailure]
/// - Authentication errors are mapped to [AuthenticationFailure]
/// - Validation errors are mapped to [ValidationFailure]
///
/// **Common Implementations:**
/// - [AuthRepositoryImpl]: Production implementation using Firebase
/// - [MockAuthRepository]: Testing implementation with fake data
/// - [OfflineAuthRepository]: Offline-capable implementation
///
/// Example usage:
/// ```dart
/// class AuthService {
///   final AuthRepository _repository;
///   
///   AuthService(this._repository);
///   
///   Future<void> authenticateUser(String email, String password) async {
///     final result = await _repository.signIn(
///       email: email,
///       password: password,
///     );
///     
///     result.fold(
///       (failure) => handleAuthenticationError(failure),
///       (user) => onAuthenticationSuccess(user),
///     );
///   }
/// }
/// ```
abstract class AuthRepository {
  /// Authenticates a user with email and password credentials.
  ///
  /// Performs complete authentication flow including credential verification,
  /// user data retrieval, and session establishment. This method handles both
  /// Firebase Authentication and Firestore user profile data fetching.
  ///
  /// **Process Flow:**
  /// 1. Validate input parameters
  /// 2. Attempt Firebase Authentication
  /// 3. Retrieve user profile from Firestore
  /// 4. Merge authentication and profile data
  /// 5. Establish local session
  ///
  /// **Parameters:**
  /// - [email]: User's email address (validated format required)
  /// - [password]: User's password (minimum 6 characters)
  ///
  /// **Returns:**
  /// - [Right<UserEntity>]: Complete user data on successful authentication
  /// - [Left<Failure>]: Specific failure indicating the error cause
  ///
  /// **Possible Failures:**
  /// - [InvalidCredentialsFailure]: Wrong email/password combination
  /// - [NetworkFailure]: No internet connection or Firebase unavailable
  /// - [ServerFailure]: Firebase service temporarily unavailable
  /// - [UserNotFoundFailure]: Authentication succeeded but no profile data
  /// - [AccountDisabledFailure]: User account has been disabled
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.signIn(
  ///   email: 'user@example.com',
  ///   password: 'securePassword',
  /// );
  /// ```
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  /// Authenticates a user using Google Sign-In.
  ///
  /// Provides OAuth authentication through Google services, offering users
  /// a convenient and secure way to sign in without creating a separate password.
  /// This method handles the complete OAuth flow and user data synchronization.
  ///
  /// **Process Flow:**
  /// 1. Initialize Google Sign-In flow
  /// 2. Present Google authentication UI
  /// 3. Handle OAuth callback and token exchange
  /// 4. Create or retrieve user profile from Firestore
  /// 5. Establish authenticated session
  ///
  /// **Returns:**
  /// - [Right<UserEntity>]: Complete user data on successful authentication
  /// - [Left<Failure>]: Specific failure indicating the error cause
  ///
  /// **Possible Failures:**
  /// - [GoogleSignInCancelledFailure]: User cancelled the sign-in process
  /// - [GoogleSignInFailure]: Google authentication service error
  /// - [NetworkFailure]: No internet connection
  /// - [ServerFailure]: Firebase or Google service unavailable
  ///
  /// **Features:**
  /// - Automatic account creation for new Google users
  /// - Profile picture and email auto-population
  /// - Secure token management handled by Google
  /// - Cross-platform consistent experience
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.signInWithGoogle();
  /// result.fold(
  ///   (failure) => handleGoogleSignInError(failure),
  ///   (user) => onSuccessfulGoogleSignIn(user),
  /// );
  /// ```
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Creates a new user account with the provided information.
  ///
  /// Handles complete user registration including Firebase Authentication
  /// account creation and Firestore profile data storage. This method
  /// ensures data consistency between authentication and profile systems.
  ///
  /// **Process Flow:**
  /// 1. Validate all input parameters
  /// 2. Create Firebase Authentication account
  /// 3. Create Firestore user profile document
  /// 4. Link authentication and profile data
  /// 5. Send email verification (if required)
  ///
  /// **Parameters:**
  /// - [email]: Unique email address for the account
  /// - [password]: Secure password meeting requirements
  /// - [fullName]: User's complete name for profile
  /// - [phoneNumber]: Contact number for communication
  /// - [userType]: Either 'client' or 'provider'
  ///
  /// **Returns:**
  /// - [Right<UserEntity>]: Complete user data on successful registration
  /// - [Left<Failure>]: Specific failure indicating the error cause
  ///
  /// **Possible Failures:**
  /// - [EmailAlreadyInUseFailure]: Email is already registered
  /// - [WeakPasswordFailure]: Password doesn't meet security requirements
  /// - [ValidationFailure]: Invalid input parameters
  /// - [NetworkFailure]: No internet connection
  /// - [ServerFailure]: Firebase service unavailable
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.signUp(
  ///   email: 'newuser@example.com',
  ///   password: 'securePassword123',
  ///   fullName: 'John Doe',
  ///   phoneNumber: '+1234567890',
  ///   userType: 'client',
  /// );
  /// ```
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String userType,
  });

  /// Signs out the current user and clears all session data.
  ///
  /// Performs complete logout including Firebase Authentication sign-out,
  /// local session clearing, and cache invalidation. This ensures complete
  /// security cleanup when the user logs out.
  ///
  /// **Process Flow:**
  /// 1. Sign out from Firebase Authentication
  /// 2. Clear local authentication tokens
  /// 3. Clear cached user data
  /// 4. Reset app authentication state
  /// 5. Notify authentication state listeners
  ///
  /// **Returns:**
  /// - [Right<void>]: Successful logout
  /// - [Left<Failure>]: Error during logout process
  ///
  /// **Side Effects:**
  /// - Clears all local user data and tokens
  /// - Resets authentication state to unauthenticated
  /// - Triggers navigation to login screen
  /// - Stops all user-specific background processes
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.signOut();
  /// result.fold(
  ///   (failure) => logWarning('Logout warning: $failure'),
  ///   (_) => navigateToWelcomeScreen(),
  /// );
  /// ```
  Future<Either<Failure, void>> signOut();

  /// Retrieves the currently authenticated user's information.
  ///
  /// Returns the complete user profile for the currently authenticated user,
  /// including both Firebase Authentication data and Firestore profile
  /// information. This method is used for session validation and profile display.
  ///
  /// **Process Flow:**
  /// 1. Check Firebase Authentication state
  /// 2. Validate authentication token
  /// 3. Retrieve current user profile from Firestore
  /// 4. Merge authentication and profile data
  /// 5. Return complete user entity
  ///
  /// **Returns:**
  /// - [Right<UserEntity?>]: Current user's profile data or null if not authenticated
  /// - [Left<Failure>]: Error during user data retrieval
  ///
  /// **Possible Failures:**
  /// - [TokenExpiredFailure]: Authentication token has expired
  /// - [UserNotFoundFailure]: User data not found in Firestore
  /// - [NetworkFailure]: Unable to fetch updated profile data
  /// - [ServerFailure]: Firebase service temporarily unavailable
  ///
  /// **Caching Strategy:**
  /// - Returns cached data if available and recent (< 5 minutes)
  /// - Fetches fresh data if cache is stale or empty
  /// - Updates cache after successful fetch
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.getCurrentUser();
  /// result.fold(
  ///   (failure) => handleUserDataError(failure),
  ///   (user) => user != null ? initializeUserSession(user) : redirectToLogin(),
  /// );
  /// ```
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Sends a password reset email to the specified email address.
  ///
  /// Initiates the password reset flow through Firebase Authentication,
  /// which sends a secure password reset link to the user's email address.
  /// The user can then follow the link to create a new password.
  ///
  /// **Process Flow:**
  /// 1. Validate email format
  /// 2. Send password reset email via Firebase
  /// 3. Return success confirmation
  ///
  /// **Parameters:**
  /// - [email]: Email address to send the reset link to
  ///
  /// **Returns:**
  /// - [Right<void>]: Password reset email sent successfully
  /// - [Left<Failure>]: Error during reset process
  ///
  /// **Possible Failures:**
  /// - [ValidationFailure]: Invalid email format
  /// - [NetworkFailure]: No internet connection
  /// - [ServerFailure]: Firebase service temporarily unavailable
  /// - [TooManyRequestsFailure]: Rate limit exceeded for password resets
  ///
  /// **Security Features:**
  /// - Rate limiting to prevent abuse
  /// - Secure token generation by Firebase
  /// - Time-limited reset links (typically 1 hour)
  /// - Always returns success to user (even if email doesn't exist)
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.forgotPassword(
  ///   email: 'user@example.com',
  /// );
  /// ```
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  });

  /// Updates the current user's profile information.
  ///
  /// Allows users to modify their profile data including display name,
  /// contact information, and profile picture. This method updates both
  /// Firebase Authentication profile and Firestore user document.
  ///
  /// **Process Flow:**
  /// 1. Validate input parameters
  /// 2. Update Firebase Authentication profile
  /// 3. Update Firestore user document
  /// 4. Sync changes across data sources
  /// 5. Return updated user entity
  ///
  /// **Parameters:**
  /// - [fullName]: Updated display name for the user
  /// - [phoneNumber]: Updated contact phone number (optional)
  /// - [profilePictureUrl]: URL to updated profile picture (optional)
  ///
  /// **Returns:**
  /// - [Right<UserEntity>]: Updated user data
  /// - [Left<Failure>]: Error during profile update
  ///
  /// **Possible Failures:**
  /// - [NotAuthenticatedFailure]: No user is currently signed in
  /// - [ValidationFailure]: Invalid input parameters
  /// - [NetworkFailure]: No internet connection
  /// - [ServerFailure]: Firebase service temporarily unavailable
  ///
  /// **Validation Rules:**
  /// - Full Name: 2-50 characters, no special characters
  /// - Phone: E.164 format if provided
  /// - Profile Picture URL: Valid HTTPS URL if provided
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.updateProfile(
  ///   fullName: 'John Smith',
  ///   phoneNumber: '+1987654321',
  ///   profilePictureUrl: 'https://example.com/profile.jpg',
  /// );
  /// ```
  Future<Either<Failure, UserEntity>> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? profilePictureUrl,
  });

  /// Changes the current user's password.
  ///
  /// Updates the user's authentication password in Firebase Authentication.
  /// This operation requires the user to be currently authenticated and
  /// may require recent authentication for security purposes.
  ///
  /// **Process Flow:**
  /// 1. Validate new password requirements
  /// 2. Check user authentication status
  /// 3. Update password in Firebase Authentication
  /// 4. Optionally send confirmation email
  ///
  /// **Parameters:**
  /// - [newPassword]: New password meeting security requirements
  ///
  /// **Returns:**
  /// - [Right<void>]: Password changed successfully
  /// - [Left<Failure>]: Error during password change
  ///
  /// **Possible Failures:**
  /// - [NotAuthenticatedFailure]: No user is currently signed in
  /// - [WeakPasswordFailure]: New password doesn't meet requirements
  /// - [RecentAuthenticationRequiredFailure]: User needs to re-authenticate
  /// - [NetworkFailure]: No internet connection
  /// - [ServerFailure]: Firebase service temporarily unavailable
  ///
  /// **Security Requirements:**
  /// - Password must be at least 6 characters
  /// - May require recent authentication (within last 5 minutes)
  /// - Old password is automatically invalidated
  ///
  /// Example:
  /// ```dart
  /// final result = await repository.changePassword(
  ///   newPassword: 'newSecurePassword123',
  /// );
  /// ```
  Future<Either<Failure, void>> changePassword({
    required String newPassword,
  });

  /// Checks if a user is currently authenticated.
  ///
  /// Provides a quick way to determine authentication status without
  /// fetching complete user data. This method checks local authentication
  /// state and is typically used for navigation decisions and UI state.
  ///
  /// **Returns:**
  /// - [true]: User is currently authenticated
  /// - [false]: No authenticated user session
  ///
  /// **Performance:**
  /// - Synchronous operation using cached authentication state
  /// - No network calls required
  /// - Instant response time
  ///
  /// **Use Cases:**
  /// - App startup navigation decisions
  /// - Route guards for protected screens
  /// - UI state management (show/hide authenticated features)
  /// - Background task authorization
  ///
  /// **Note:** This method only checks local authentication state.
  /// For complete user data, use [getCurrentUser] instead.
  ///
  /// Example:
  /// ```dart
  /// if (await repository.isUserLoggedIn()) {
  ///   navigateToHomeScreen();
  /// } else {
  ///   navigateToLoginScreen();
  /// }
  /// ```
  Future<bool> isUserLoggedIn();
}

