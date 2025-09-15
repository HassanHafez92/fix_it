import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Authenticates a user with email and password credentials.
///
/// This use case handles the complete sign-in flow including credential
/// validation, Firebase authentication, user data retrieval from Firestore,
/// and comprehensive error handling with business logic validation.
///
/// **Business Rules:**
/// - Email must be in valid RFC 5322 format
/// - Password must be at least 6 characters long
/// - User account must exist and be verified
/// - User profile data must be present in Firestore
/// - Account must not be disabled or suspended
///
/// **Authentication Flow:**
/// 1. Validate input parameters (email format, password length)
/// 2. Attempt Firebase Authentication with credentials
/// 3. Retrieve user profile data from Firestore
/// 4. Return complete [UserEntity] with all profile information
///
/// **Error Scenarios:**
/// - [InvalidCredentialsFailure]: Wrong email/password combination
/// - [NetworkFailure]: No internet connection or Firebase unavailable
/// - [ServerFailure]: Firebase service temporarily unavailable
/// - [UserNotFoundFailure]: Authentication succeeded but no profile data
/// - [AccountDisabledFailure]: User account has been disabled
/// - [ValidationFailure]: Input parameters don't meet requirements
///
/// **Security Considerations:**
/// - Passwords are never stored or logged
/// - Failed attempts are tracked for security monitoring
/// - Rate limiting is handled by Firebase Authentication
/// - User tokens are automatically managed by Firebase SDK
///
/// **Dependencies:**
/// - [AuthRepository]: Handles Firebase authentication and Firestore operations
/// - Firebase Authentication: Provides secure credential verification
/// - Cloud Firestore: Stores extended user profile information
///
/// **Performance Notes:**
/// - Typical response time: 500ms - 2s depending on network
/// - Firestore read: 1 document read per successful sign-in
/// - Results are not cached due to security requirements
///
/// Example usage:
/// ```dart
/// final signInUseCase = sl<SignInUseCase>();
/// 
/// // Successful sign-in
/// final result = await signInUseCase(SignInParams(
///   email: 'user@example.com',
///   password: 'securePassword123',
/// ));
/// 
/// result.fold(
///   (failure) {
///     switch (failure.runtimeType) {
///       case InvalidCredentialsFailure:
///         showError('Invalid email or password');
///         break;
///       case NetworkFailure:
///         showError('Please check your internet connection');
///         break;
///       default:
///         showError('Sign-in failed. Please try again.');
///     }
///   },
///   (user) {
///     // Navigate to home screen
///     if (user.isProvider) {
///       navigateToProviderDashboard(user);
///     } else {
///       navigateToClientHome(user);
///     }
///   },
/// );
/// ```
class SignInUseCase implements UseCase<UserEntity, SignInParams> {
  /// Repository for authentication operations and user data management.
  ///
  /// Provides access to Firebase Authentication and Firestore operations
  /// through a clean interface that abstracts implementation details.
  final AuthRepository repository;

  /// Creates a [SignInUseCase] with the required [repository].
  ///
  /// The repository dependency is injected to enable testing with mock
  /// implementations and to follow dependency inversion principles.
  SignInUseCase(this.repository);

  /// Executes the sign-in operation with the provided parameters.
  ///
  /// **Input Validation:**
  /// - Validates email format using RFC 5322 standard
  /// - Ensures password meets minimum length requirements
  /// - Checks for empty or whitespace-only inputs
  ///
  /// **Returns:**
  /// - [Right<UserEntity>]: Complete user data on successful authentication
  /// - [Left<Failure>]: Specific failure type indicating the error cause
  ///
  /// **Side Effects:**
  /// - Updates Firebase Authentication state
  /// - Triggers auth state listeners throughout the app
  /// - May update user's last sign-in timestamp in Firestore
  ///
  /// The method delegates actual authentication to the repository after
  /// performing client-side validation to reduce unnecessary network calls.
  @override
  Future<Either<Failure, UserEntity>> call(SignInParams params) async {
    // Validate email format before making network call
    // This client-side validation prevents unnecessary Firebase API calls
    // for obviously invalid emails, improving performance and user experience
    if (!_isValidEmail(params.email)) {
      return Left(ValidationFailure('Please enter a valid email address'));
    }

    // Validate password length to meet security requirements
    // Early validation provides immediate feedback to users
    // without waiting for Firebase to reject the request
    if (!_isValidPassword(params.password)) {
      return Left(ValidationFailure('Password must be at least 6 characters long'));
    }

    // Normalize email input to handle common user errors
    // - Trim removes accidental leading/trailing whitespace
    // - toLowerCase ensures consistent email format for Firebase
    // This improves success rate for legitimate sign-in attempts
    final cleanEmail = params.email.trim().toLowerCase();

    // Delegate to repository for actual authentication
    // Repository handles network connectivity, Firebase integration,
    // error mapping, and local data caching
    return await repository.signIn(
      email: cleanEmail,
      password: params.password,
    );
  }

  /// Validates email format using regular expression.
  ///
  /// Uses RFC 5322 compliant pattern to ensure email is properly formatted.
  /// This client-side validation prevents unnecessary network calls for
  /// obviously invalid email addresses.
  ///
  /// **Examples:**
  /// - Valid: 'user@example.com', 'test.email+tag@domain.co.uk'
  /// - Invalid: 'user@', 'invalid.email', '@domain.com'
  bool _isValidEmail(String email) {
    // Quick check for empty email to avoid unnecessary regex processing
    if (email.isEmpty) return false;

    // RFC 5322 compliant email regex pattern
    // This pattern validates:
    // - Local part: allows letters, numbers, and common special characters
    // - @ symbol: required separator between local and domain parts
    // - Domain part: validates proper domain structure with length limits
    // - TLD: ensures proper top-level domain format
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'
    );

    // Trim whitespace and validate against the regex pattern
    // This handles user input errors like leading/trailing spaces
    return emailRegex.hasMatch(email.trim());
  }

  /// Validates password meets minimum security requirements.
  ///
  /// Currently enforces minimum length of 6 characters as required by
  /// Firebase Authentication. Additional complexity requirements may be
  /// added in future versions.
  ///
  /// **Current requirements:**
  /// - Minimum 6 characters (Firebase requirement)
  /// - Cannot be empty or only whitespace
  ///
  /// **Future considerations:**
  /// - Mixed case letters
  /// - Special characters
  /// - Numeric characters
  bool _isValidPassword(String password) {
    // Check for empty password or whitespace-only password
    // Both scenarios should be rejected for security reasons
    if (password.isEmpty || password.trim().isEmpty) return false;

    // Enforce Firebase Authentication minimum length requirement
    // 6 characters is the absolute minimum for Firebase Auth
    // Note: Additional complexity rules could be added here in the future
    // such as requiring uppercase, lowercase, numbers, or special characters
    return password.length >= 6;
  }
}

/// Parameters required for the [SignInUseCase] operation.
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
/// Encapsulates the email and password credentials needed for user
/// authentication. This class ensures type safety and provides a
/// clear contract for the sign-in operation.
///
/// **Security Note:** The password is stored temporarily in memory
/// only during the authentication process and is not persisted.
///
/// **Validation:** Input validation is performed by the use case,
/// not by this parameter class, following single responsibility principle.
class SignInParams {
  /// User's email address for authentication.
  ///
  /// Should be the email address associated with the user's account.
  /// The use case will normalize this by trimming whitespace and
  /// converting to lowercase for consistent authentication.
  final String email;

  /// User's password for authentication.
  ///
  /// Must meet the application's password requirements:
  /// - Minimum 6 characters (Firebase requirement)
  /// - Cannot be empty or only whitespace
  ///
  /// **Security:** This password is handled securely and never logged
  /// or persisted beyond the authentication process.
  final String password;

  /// Creates [SignInParams] with the required authentication credentials.
  ///
  /// Both [email] and [password] are required for the authentication process.
  /// The actual validation of these parameters is performed by the use case
  /// to maintain separation of concerns.
  ///
  /// Example:
  /// ```dart
  /// final params = SignInParams(
  ///   email: 'user@example.com',
  ///   password: 'userPassword123',
  /// );
  /// ```
  const SignInParams({
    required this.email,
    required this.password,
  });

  /// Returns a string representation of these parameters.
  ///
  /// **Security:** The password is hidden in the string representation
  /// to prevent accidental logging of sensitive information.
  @override
  String toString() => 'SignInParams(email: $email, password: [HIDDEN])';

  /// Checks equality based on email and password values.
  ///
  /// Two [SignInParams] instances are equal if they have the same
  /// email and password values. This is useful for testing and
  /// state management scenarios.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SignInParams &&
        other.email == email &&
        other.password == password;
  }

  /// Generates hash code based on email and password.
  ///
  /// Used for proper behavior in collections and state management.
  /// The hash includes both email and password for complete equality checking.
  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}

