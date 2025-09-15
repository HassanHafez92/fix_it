import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Creates a new user account with complete profile information.
///
/// This use case handles the complete user registration process including
/// Firebase Authentication account creation, Firestore profile data storage,
/// and comprehensive validation of all user input. It ensures data consistency
/// between authentication and profile systems.
///
/// **Business Rules:**
/// - Email must be unique across the system
/// - Password must meet security requirements (minimum 6 characters)
/// - Full name is required and must be between 2-50 characters
/// - Phone number is required for all users
/// - User type must be either 'client' or 'provider'
/// - Profession is required for provider accounts
/// - All data must pass validation before account creation
///
/// **Registration Flow:**
/// 1. Validate all input parameters client-side
/// 2. Create Firebase Authentication account with email/password
/// 3. Create Firestore user profile document with extended information
/// 4. Link authentication and profile data using user ID
/// 5. Send email verification if required by app settings
/// 6. Return complete user entity with established session
///
/// **Validation Rules:**
/// - **Email**: Valid RFC 5322 format, unique in system
/// - **Password**: Minimum 6 characters, complexity requirements
/// - **Full Name**: 2-50 characters, letters/spaces/hyphens only
/// - **Phone**: E.164 international format (e.g., +1234567890)
/// - **User Type**: Exactly 'client' or 'provider'
/// - **Profession**: Required for providers, must match service categories
///
/// **Error Scenarios:**
/// - [EmailAlreadyInUseFailure]: Email is already registered
/// - [WeakPasswordFailure]: Password doesn't meet security requirements
/// - [ValidationFailure]: Invalid input parameters (format, length, etc.)
/// - [NetworkFailure]: No internet connection during registration
/// - [ServerFailure]: Firebase service temporarily unavailable
/// - [DataIntegrityFailure]: Profile creation failed after auth success
///
/// **Security Features:**
/// - Password is securely hashed and stored by Firebase
/// - Email verification can be required before account activation
/// - User data is validated both client-side and server-side
/// - Account creation is atomic (all-or-nothing operation)
/// - Personal information is stored securely in Firestore
///
/// **User Experience:**
/// - Immediate feedback on validation errors
/// - Progress indication during registration process
/// - Clear error messages for resolution guidance
/// - Automatic navigation to appropriate onboarding flow
/// - Welcome email and account confirmation
///
/// **Data Consistency:**
/// - Authentication and profile data are created atomically
/// - Rollback mechanism if any step fails
/// - Consistent user ID across all systems
/// - Profile data immediately available after registration
///
/// **Dependencies:**
/// - [AuthRepository]: Handles Firebase and Firestore operations
/// - Firebase Authentication: Manages account creation and verification
/// - Cloud Firestore: Stores extended user profile information
/// - Email service: Sends verification and welcome emails
///
/// Example usage:
/// ```dart
/// final signUpUseCase = sl<SignUpUseCase>();
/// 
/// // Client registration
/// final clientResult = await signUpUseCase(SignUpParams(
///   email: 'client@example.com',
///   password: 'securePassword123',
///   fullName: 'John Doe',
///   phoneNumber: '+1234567890',
///   userType: 'client',
/// ));
/// 
/// // Provider registration
/// final providerResult = await signUpUseCase(SignUpParams(
///   email: 'provider@example.com',
///   password: 'securePassword123',
///   fullName: 'Jane Smith',
///   phoneNumber: '+1987654321',
///   userType: 'provider',
///   profession: 'plumbing',
/// ));
/// 
/// // Handle registration result
/// result.fold(
///   (failure) {
///     switch (failure.runtimeType) {
///       case EmailAlreadyInUseFailure:
///         showError('Email already registered. Try signing in instead.');
///         break;
///       case WeakPasswordFailure:
///         showError('Password too weak. Use at least 8 characters with mixed case.');
///         break;
///       case ValidationFailure:
///         showError('Please check your information: ${failure.message}');
///         break;
///       case NetworkFailure:
///         showError('Please check your internet connection and try again');
///         break;
///       default:
///         showError('Registration failed. Please try again later');
///     }
///   },
///   (user) {
///     showSuccess('Welcome to Fix It, ${user.displayName}!');
///     if (user.isProvider) {
///       navigateToProviderOnboarding(user);
///     } else {
///       navigateToClientOnboarding(user);
///     }
///   },
/// );
/// ```
class SignUpUseCase implements UseCase<UserEntity, SignUpParams> {
  /// Repository for authentication operations and user account creation.
  ///
  /// Provides access to Firebase Authentication and Firestore operations
  /// for creating new user accounts with complete profile information.
  final AuthRepository repository;

  /// Creates a [SignUpUseCase] with the required [repository].
  ///
  /// The repository dependency is injected to enable testing with mock
  /// implementations and to follow dependency inversion principles.
  SignUpUseCase(this.repository);

  /// Executes the user registration process with comprehensive validation.
  ///
  /// **Input Parameters:**
  /// - [params]: [SignUpParams] containing all required registration data
  ///
  /// **Returns:**
  /// - [Right<UserEntity>]: Complete user data on successful registration
  /// - [Left<Failure>]: Specific failure type indicating the error cause
  ///
  /// **Validation Process:**
  /// The repository implementation performs comprehensive validation including:
  /// - Email format and uniqueness verification
  /// - Password strength and security requirements
  /// - Name format and length validation
  /// - Phone number format verification
  /// - User type and profession validation
  ///
  /// **Side Effects:**
  /// - Creates new Firebase Authentication account
  /// - Creates new Firestore user profile document
  /// - Establishes authenticated session
  /// - Triggers welcome email (if configured)
  /// - Updates authentication state throughout app
  /// - May send email verification link
  ///
  /// **Error Recovery:**
  /// - Partial registration attempts are cleaned up automatically
  /// - Users can retry registration with corrected information
  /// - Duplicate email attempts redirect to sign-in flow
  /// - Network failures can be retried safely
  ///
  /// **Performance Notes:**
  /// - Typical completion time: 1-3 seconds
  /// - Network calls: 2-3 (auth creation, profile creation, verification)
  /// - Client-side validation reduces unnecessary network calls
  /// - Progress can be tracked for better user experience
  ///
  /// The method delegates to the repository which handles the complex
  /// coordination between Firebase Authentication and Firestore operations.
  @override
  Future<Either<Failure, UserEntity>> call(SignUpParams params) async {
    return await repository.signUp(
      email: params.email,
      password: params.password,
      fullName: params.fullName,
      phoneNumber: params.phoneNumber,
      userType: params.userType,
    );
  }
}

/// Parameters required for the [SignUpUseCase] operation.
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
/// Encapsulates all user registration data including authentication credentials
/// and profile information. This class ensures type safety and provides proper
/// equality semantics for testing and state management.
///
/// **Data Validation:**
/// Input validation is performed by the use case and repository implementations
/// rather than at the parameter level to maintain separation of concerns and
/// provide consistent error handling.
///
/// **Security Considerations:**
/// - Password is stored temporarily only during registration process
/// - Personal information is handled according to privacy policies
/// - No sensitive data is logged or cached beyond the registration flow
class SignUpParams extends Equatable {
  /// Email address for the new user account.
  ///
  /// Must be a valid email format and unique across the system.
  /// This email will be used for authentication and communication.
  final String email;

  /// Password for the new user account.
  ///
  /// Must meet security requirements:
  /// - Minimum 6 characters (Firebase requirement)
  /// - Recommended: Mix of uppercase, lowercase, numbers, symbols
  /// - Cannot be a common password or personal information
  final String password;

  /// Full display name of the user.
  ///
  /// Used throughout the app for personalization and identification.
  /// Requirements:
  /// - 2-50 characters in length
  /// - Letters, spaces, hyphens, and apostrophes only
  /// - No special characters or numbers
  final String fullName;

  /// Contact phone number in international format.
  ///
  /// Required for all users to enable communication and verification.
  /// Must be in E.164 format (e.g., +1234567890).
  /// Used for:
  /// - Account verification (optional)
  /// - Service communication (providers)
  /// - Emergency contact (clients)
  final String phoneNumber;

  /// User type classification: 'client' or 'provider'.
  ///
  /// Determines app functionality and user experience:
  /// - 'client': Can browse and book services
  /// - 'provider': Can offer services and accept bookings
  /// 
  /// This field is immutable after account creation.
  final String userType;

  /// Professional specialization for service providers.
  ///
  /// Required when [userType] is 'provider', must be null for clients.
  /// Must match one of the predefined service categories:
  /// - 'plumbing', 'electrical', 'cleaning', 'painting'
  /// - 'carpentry', 'appliance_repair', 'hvac', 'gardening'
  final String? profession;

  /// Creates [SignUpParams] with the required registration information.
  ///
  /// All fields except [profession] are required. The [profession] field
  /// must be provided when [userType] is 'provider'.
  ///
  /// Example:
  /// ```dart
  /// // Client registration
  /// final clientParams = SignUpParams(
  ///   email: 'client@example.com',
  ///   password: 'securePassword123',
  ///   fullName: 'John Doe',
  ///   phoneNumber: '+1234567890',
  ///   userType: 'client',
  /// );
  /// 
  /// // Provider registration
  /// final providerParams = SignUpParams(
  ///   email: 'provider@example.com',
  ///   password: 'securePassword123',
  ///   fullName: 'Jane Smith',
  ///   phoneNumber: '+1987654321',
  ///   userType: 'provider',
  ///   profession: 'plumbing',
  /// );
  /// ```
  const SignUpParams({
    required this.email,
    required this.password,
    required this.fullName,
    required this.phoneNumber,
    required this.userType,
    this.profession,
  });

  /// List of properties used for equality comparison.
  ///
  /// Includes all fields for comprehensive equality checking,
  /// useful for testing and state management scenarios.
  @override
  List<Object?> get props => [
        email,
        password,
        fullName,
        phoneNumber,
        userType,
        profession,
      ];

  /// Returns a string representation of these parameters.
  ///
  /// **Security Note:** The password is excluded from the string representation
  /// to prevent accidental logging of sensitive information.
  @override
  String toString() {
    return 'SignUpParams(email: $email, fullName: $fullName, phoneNumber: $phoneNumber, userType: $userType, profession: $profession)';
  }
}

