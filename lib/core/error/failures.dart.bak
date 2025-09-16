import 'package:equatable/equatable.dart';

/// Base class for all failure types in the Fix It application.
/// 
/// This abstract class provides a common interface for representing different
/// types of errors that can occur throughout the application. Following the
/// Clean Architecture pattern, failures are used to communicate errors between
/// layers without exposing implementation details.
/// 
/// All failures extend [Equatable] to enable value comparison, which is useful
/// for testing and state management in BLoC pattern.
/// 
/// **Usage Pattern:**
/// ```dart
/// // In Repository Implementation
/// Future<Either<Failure, UserEntity>> signIn(String email, String password) async {
///   try {
///     final result = await dataSource.signIn(email, password);
///     return Right(result);
///   } on SocketException {
///     return Left(NetworkFailure('No internet connection'));
///   } on HttpException {
///     return Left(ServerFailure('Server error occurred'));
///   } catch (e) {
///     return Left(UnknownFailure('An unexpected error occurred'));
///   }
/// }
/// 
/// // In BLoC
/// result.fold(
///   (failure) => emit(AuthError(failure.message)),
///   (user) => emit(AuthSuccess(user)),
/// );
/// ```
abstract class Failure extends Equatable {
  /// Creates a new [Failure] instance.
  const Failure();

  /// Human-readable error message describing what went wrong.
  /// 
  /// This message can be displayed to users or used for logging purposes.
  /// It should be descriptive enough to help users understand the issue
  /// and potentially take corrective action.
  String get message;

  /// Returns an empty list by default for [Equatable] comparison.
  /// 
  /// Concrete failure classes should override this to include their
  /// specific properties for proper equality comparison.
  @override
  List<Object> get props => [];
}

/// Represents failures that occur on the server side.
/// 
/// This failure type is used when the server returns an error response
/// (typically HTTP 5xx status codes) or when there are issues with
/// server-side processing.
/// 
/// **Common Scenarios:**
/// - HTTP 500 (Internal Server Error)
/// - HTTP 502 (Bad Gateway)
/// - HTTP 503 (Service Unavailable)
/// - Database connection errors on server
/// - Server-side validation failures
/// 
/// **Example Usage:**
/// ```dart
/// // In data source
/// if (response.statusCode >= 500) {
///   throw ServerFailure('Server is temporarily unavailable');
/// }
/// 
/// // In repository
/// on ServerException catch (e) {
///   return Left(ServerFailure(e.message));
/// }
/// ```
class ServerFailure extends Failure {
  /// The error message describing the server failure.
  @override
  final String message;

  /// Creates a new [ServerFailure] with the specified error message.
  /// 
  /// [message] should describe the server error in user-friendly terms.
  const ServerFailure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents failures related to local data caching.
/// 
/// This failure type is used when operations involving local data storage
/// fail, such as reading from or writing to local databases, shared preferences,
/// or file system operations.
/// 
/// **Common Scenarios:**
/// - SQLite database errors
/// - File system permission issues
/// - Disk space insufficient
/// - Corrupted local data
/// - SharedPreferences read/write failures
/// 
/// **Example Usage:**
/// ```dart
/// // In local data source
/// try {
///   final userData = await database.getUser(userId);
///   return userData;
/// } on DatabaseException {
///   throw CacheFailure('Failed to retrieve user data from local storage');
/// }
/// 
/// // In repository
/// on CacheException catch (e) {
///   return Left(CacheFailure(e.message));
/// }
/// ```
class CacheFailure extends Failure {
  /// The error message describing the cache failure.
  @override
  final String message;

  /// Creates a new [CacheFailure] with the specified error message.
  /// 
  /// [message] should describe the caching error in user-friendly terms.
  const CacheFailure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents failures related to network connectivity.
/// 
/// This failure type is used when network-related issues prevent the
/// application from communicating with external services, such as REST APIs,
/// Firebase, or other remote data sources.
/// 
/// **Common Scenarios:**
/// - No internet connection
/// - Connection timeout
/// - DNS resolution failures
/// - Firewall blocking connections
/// - Network unreachable
/// - Connection refused by server
/// 
/// **Example Usage:**
/// ```dart
/// // In API client
/// try {
///   final response = await dio.get(endpoint);
///   return response.data;
/// } on SocketException {
///   throw NetworkFailure('No internet connection available');
/// } on TimeoutException {
///   throw NetworkFailure('Connection timeout - please try again');
/// }
/// 
/// // In repository
/// on NetworkException catch (e) {
///   return Left(NetworkFailure(e.message));
/// }
/// ```
class NetworkFailure extends Failure {
  /// The error message describing the network failure.
  @override
  final String message;

  /// Creates a new [NetworkFailure] with the specified error message.
  /// 
  /// [message] should describe the network error in user-friendly terms.
  const NetworkFailure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents failures related to user authentication and authorization.
/// 
/// This failure type is used when authentication or authorization operations
/// fail, such as invalid credentials, expired tokens, insufficient permissions,
/// or account-related issues.
/// 
/// **Common Scenarios:**
/// - Invalid email/password combination
/// - Expired authentication tokens
/// - Account not verified
/// - Account suspended or disabled
/// - Insufficient permissions
/// - OAuth authentication failures
/// - Firebase Auth errors
/// 
/// **Example Usage:**
/// ```dart
/// // In Firebase auth data source
/// try {
///   final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
///     email: email,
///     password: password,
///   );
///   return userCredential.user;
/// } on FirebaseAuthException catch (e) {
///   switch (e.code) {
///     case 'user-not-found':
///       throw AuthenticationFailure('No user found with this email');
///     case 'wrong-password':
///       throw AuthenticationFailure('Invalid password');
///     case 'user-disabled':
///       throw AuthenticationFailure('Account has been disabled');
///     default:
///       throw AuthenticationFailure('Authentication failed');
///   }
/// }
/// 
/// // In repository
/// on AuthenticationException catch (e) {
///   return Left(AuthenticationFailure(e.message));
/// }
/// ```
class AuthenticationFailure extends Failure {
  /// The error message describing the authentication failure.
  @override
  final String message;

  /// Creates a new [AuthenticationFailure] with the specified error message.
  /// 
  /// [message] should describe the authentication error in user-friendly terms.
  const AuthenticationFailure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents failures related to input validation.
/// 
/// This failure type is used when user input or data validation fails,
/// such as invalid email formats, weak passwords, missing required fields,
/// or business rule violations.
/// 
/// **Common Scenarios:**
/// - Invalid email format
/// - Password too weak
/// - Required fields missing
/// - Phone number format invalid
/// - Age restrictions not met
/// - Business rule violations
/// - Form validation errors
/// 
/// **Example Usage:**
/// ```dart
/// // In validation service
/// class EmailValidator {
///   static Either<ValidationFailure, String> validate(String email) {
///     if (email.isEmpty) {
///       return Left(ValidationFailure('Email is required'));
///     }
///     if (!RegExp(AppConstants.emailPattern).hasMatch(email)) {
///       return Left(ValidationFailure('Please enter a valid email address'));
///     }
///     return Right(email);
///   }
/// }
/// 
/// // In use case
/// final emailValidation = EmailValidator.validate(params.email);
/// if (emailValidation.isLeft()) {
///   return emailValidation.fold(
///     (failure) => Left(failure),
///     (_) => Right(null), // This won't be reached
///   );
/// }
/// ```
class ValidationFailure extends Failure {
  /// The error message describing the validation failure.
  @override
  final String message;

  /// Creates a new [ValidationFailure] with the specified error message.
  /// 
  /// [message] should describe the validation error in user-friendly terms.
  const ValidationFailure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents unexpected or unhandled failures.
/// 
/// This failure type is used as a fallback when an unexpected error occurs
/// that doesn't fit into other specific failure categories. It should be used
/// sparingly and typically indicates a need to add more specific failure types.
/// 
/// **Common Scenarios:**
/// - Unhandled exceptions
/// - Unexpected API responses
/// - Third-party library errors
/// - Platform-specific errors
/// - Unknown error states
/// 
/// **Example Usage:**
/// ```dart
/// // In repository as a catch-all
/// try {
///   // Some operation
///   return Right(result);
/// } on ServerException catch (e) {
///   return Left(ServerFailure(e.message));
/// } on NetworkException catch (e) {
///   return Left(NetworkFailure(e.message));
/// } catch (e) {
///   // Unexpected error - log for debugging
///   debugPrint('Unexpected error: $e');
///   return Left(UnknownFailure('An unexpected error occurred'));
/// }
/// 
/// // In BLoC for error handling
/// result.fold(
///   (failure) {
///     if (failure is UnknownFailure) {
///       // Log to crash analytics
///       crashlytics.recordError(failure.message, null);
///     }
///     emit(ErrorState(failure.message));
///   },
///   (data) => emit(SuccessState(data)),
/// );
/// ```
class UnknownFailure extends Failure {
  /// The error message describing the unknown failure.
  @override
  final String message;

  /// Creates a new [UnknownFailure] with the specified error message.
  /// 
  /// [message] should provide as much context as possible about the
  /// unexpected error for debugging purposes.
  const UnknownFailure(this.message);

  @override
  List<Object> get props => [message];
}

/// Represents failures related to business logic rules.
///
/// This failure type is used when business rules are violated or
/// business logic constraints are not met.
///
/// **Common Scenarios:**
/// - Attempting to delete the only payment method
/// - Insufficient funds for a transaction
/// - Business hours restrictions
/// - User permissions or role restrictions
/// - Order status transition violations
///
/// **Example Usage:**
/// ```dart
/// // In use case
/// if (paymentMethods.length == 1 && !params.forceDelete) {
///   return Left(BusinessLogicFailure(
///     'Cannot delete the only payment method. Please add another payment method first.',
///   ));
/// }
/// ```
class BusinessLogicFailure extends Failure {
  /// The error message describing the business logic failure.
  @override
  final String message;

  /// Creates a new [BusinessLogicFailure] with the specified error message.
  ///
  /// [message] should describe the business rule violation in user-friendly terms.
  const BusinessLogicFailure(this.message);

  @override
  List<Object> get props => [message];
}
