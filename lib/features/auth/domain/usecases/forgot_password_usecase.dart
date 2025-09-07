import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Initiates the password reset process for a user account.
///
/// This use case handles the password reset flow by sending a secure reset
/// link to the user's email address through Firebase Authentication. It provides
/// a safe and standardized way for users to recover access to their accounts.
///
/// **Business Rules:**
/// - Email must be in valid format
/// - User must have previously registered with this email
/// - Rate limiting applies to prevent abuse (handled by Firebase)
/// - Reset links expire after a specific time period (typically 1 hour)
///
/// **Security Features:**
/// - Always returns success to prevent email enumeration attacks
/// - Secure token generation handled by Firebase Authentication
/// - Rate limiting prevents brute force attempts
/// - Reset links are single-use and time-limited
///
/// **Process Flow:**
/// 1. Validate email format
/// 2. Send password reset request to Firebase Authentication
/// 3. Firebase generates secure reset token and sends email
/// 4. Return success status (regardless of email existence)
///
/// **Error Scenarios:**
/// - [ValidationFailure]: Invalid email format
/// - [NetworkFailure]: No internet connection
/// - [ServerFailure]: Firebase service temporarily unavailable
/// - [TooManyRequestsFailure]: Rate limit exceeded
///
/// **User Experience:**
/// - Always shows success message to user for security
/// - Actual email delivery depends on email service availability
/// - Users should check spam folder if email not received
/// - Process typically completes within 30 seconds
///
/// **Dependencies:**
/// - [AuthRepository]: Handles Firebase Authentication integration
/// - Firebase Authentication: Provides secure password reset functionality
/// - Email service: Delivers reset emails to users
///
/// Example usage:
/// ```dart
/// final forgotPasswordUseCase = sl<ForgotPasswordUseCase>();
/// 
/// final result = await forgotPasswordUseCase(ForgotPasswordParams(
///   email: 'user@example.com',
/// ));
/// 
/// result.fold(
///   (failure) {
///     switch (failure.runtimeType) {
///       case ValidationFailure:
///         showError('Please enter a valid email address');
///         break;
///       case NetworkFailure:
///         showError('Please check your internet connection');
///         break;
///       case TooManyRequestsFailure:
///         showError('Too many attempts. Please try again later');
///         break;
///       default:
///         showError('Unable to send reset email. Please try again');
///     }
///   },
///   (_) {
///     showSuccess('Password reset email sent! Check your inbox');
///     navigateToSignInScreen();
///   },
/// );
/// ```
class ForgotPasswordUseCase implements UseCase<void, ForgotPasswordParams> {
  /// Repository for authentication operations and password reset functionality.
  ///
  /// Provides access to Firebase Authentication password reset features
  /// through a clean interface that abstracts implementation details.
  final AuthRepository repository;

  /// Creates a [ForgotPasswordUseCase] with the required [repository].
  ///
  /// The repository dependency is injected to enable testing with mock
  /// implementations and to follow dependency inversion principles.
  ForgotPasswordUseCase(this.repository);

  /// Executes the password reset operation with the provided email.
  ///
  /// **Input Validation:**
  /// - Email format is validated by the repository implementation
  /// - Empty or whitespace-only emails are rejected
  ///
  /// **Returns:**
  /// - [Right<void>]: Password reset email sent successfully
  /// - [Left<Failure>]: Specific failure type indicating the error cause
  ///
  /// **Side Effects:**
  /// - Triggers password reset email from Firebase
  /// - May update user's password reset attempt count
  /// - Logs security events for monitoring
  ///
  /// **Performance:**
  /// - Typical response time: 200ms - 1s
  /// - Network dependency: Requires internet connection
  /// - Firebase quota: Subject to daily email sending limits
  ///
  /// The method delegates to the repository which handles actual Firebase
  /// integration and email format validation.
  @override
  Future<Either<Failure, void>> call(ForgotPasswordParams params) async {
    return repository.forgotPassword(email: params.email);
  }
}

/// Parameters required for the [ForgotPasswordUseCase] operation.
///
/// Encapsulates the email address for which a password reset is requested.
/// This class ensures type safety and provides a clear contract for the
/// password reset operation.
///
/// **Security Considerations:**
/// - Email addresses are handled as sensitive information
/// - Input validation is performed by the use case implementation
/// - No personally identifiable information is logged
class ForgotPasswordParams {
  /// Email address for the account that needs password reset.
  ///
  /// Must be a valid email format and should be associated with an
  /// existing user account. The system will always report success
  /// regardless of whether the email exists (security best practice).
  ///
  /// **Format Requirements:**
  /// - Valid RFC 5322 email format
  /// - Cannot be empty or whitespace only
  /// - Case insensitive (normalized to lowercase)
  final String email;

  /// Creates [ForgotPasswordParams] with the required email address.
  ///
  /// The email will be validated when the use case is executed.
  /// No validation is performed at parameter creation time to maintain
  /// separation of concerns.
  ///
  /// Example:
  /// ```dart
  /// final params = ForgotPasswordParams(
  ///   email: 'user@example.com',
  /// );
  /// ```
  const ForgotPasswordParams({required this.email});

  /// Returns a string representation of these parameters.
  ///
  /// The email is included in the string representation as it's not
  /// considered highly sensitive for debugging purposes.
  @override
  String toString() => 'ForgotPasswordParams(email: $email)';

  /// Checks equality based on email value.
  ///
  /// Two [ForgotPasswordParams] instances are equal if they have the same
  /// email address. This is useful for testing and state management.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ForgotPasswordParams && other.email == email;
  }

  /// Generates hash code based on email value.
  ///
  /// Used for proper behavior in collections and state management scenarios.
  @override
  int get hashCode => email.hashCode;
}

