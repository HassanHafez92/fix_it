import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

/// Retrieves the currently authenticated user's profile information.
///
/// This use case is responsible for fetching the complete user profile
/// of the currently authenticated user, including both Firebase Authentication
/// data and extended profile information stored in Firestore.
///
/// **Business Rules:**
/// - User must be currently authenticated
/// - Authentication token must be valid and not expired
/// - User profile data must exist in Firestore
/// - Returns null if no user is currently authenticated
///
/// **Use Cases:**
/// - App startup authentication check
/// - Profile screen data loading
/// - Session validation before sensitive operations
/// - User context retrieval for business logic
/// - Navigation guard for authenticated routes
///
/// **Process Flow:**
/// 1. Check Firebase Authentication state
/// 2. Validate current authentication token
/// 3. Retrieve user profile from Firestore (if authenticated)
/// 4. Merge authentication and profile data
/// 5. Return complete user entity or null
///
/// **Caching Strategy:**
/// - Returns cached data if available and recent (< 5 minutes)
/// - Fetches fresh data if cache is stale or empty
/// - Updates cache after successful data retrieval
/// - Cache is invalidated on sign-out or authentication errors
///
/// **Error Scenarios:**
/// - [TokenExpiredFailure]: Authentication token has expired
/// - [UserNotFoundFailure]: User data not found in Firestore
/// - [NetworkFailure]: Unable to fetch updated profile data
/// - [ServerFailure]: Firebase service temporarily unavailable
/// - Returns null: No user is currently authenticated (not an error)
///
/// **Performance Considerations:**
/// - Typical response time: 100ms - 500ms (cached) or 500ms - 2s (network)
/// - Firestore read: 0-1 document reads depending on cache status
/// - Memory usage: Minimal, user data is lightweight
/// - Background refresh: Can be called periodically to keep data fresh
///
/// **Security Features:**
/// - Automatically validates authentication state
/// - Ensures user can only access their own data
/// - Token expiration is handled gracefully
/// - No sensitive data is cached beyond session
///
/// **Dependencies:**
/// - [AuthRepository]: Provides access to authentication and user data
/// - Firebase Authentication: Manages authentication state
/// - Cloud Firestore: Stores extended user profile information
/// - Local cache: Improves performance for frequent calls
///
/// Example usage:
/// ```dart
/// final getCurrentUserUseCase = sl<GetCurrentUserUseCase>();
/// 
/// // Check authentication status at app startup
/// final result = await getCurrentUserUseCase(NoParams());
/// 
/// result.fold(
///   (failure) {
///     switch (failure.runtimeType) {
///       case TokenExpiredFailure:
///         // Redirect to login with message
///         showMessage('Session expired. Please sign in again');
///         navigateToSignIn();
///         break;
///       case NetworkFailure:
///         // Show offline mode or retry option
///         showOfflineMessage();
///         break;
///       case UserNotFoundFailure:
///         // Data integrity issue - sign out and restart
///         signOutAndRestart();
///         break;
///       default:
///         // Generic error handling
///         showError('Unable to load user data');
///     }
///   },
///   (user) {
///     if (user != null) {
///       // User is authenticated, proceed with app flow
///       initializeUserSession(user);
///       if (user.isProvider) {
///         navigateToProviderDashboard();
///       } else {
///         navigateToClientHome();
///       }
///     } else {
///       // No user authenticated, show welcome/login screen
///       navigateToWelcomeScreen();
///     }
///   },
/// );
/// 
/// // Periodic refresh to keep data current
/// Timer.periodic(Duration(minutes: 5), (_) async {
///   await getCurrentUserUseCase(NoParams());
/// });
/// ```
class GetCurrentUserUseCase implements UseCase<UserEntity?, NoParams> {
  /// Repository for authentication operations and user data management.
  ///
  /// Provides access to Firebase Authentication state and Firestore user
  /// profile data through a clean interface that handles caching and
  /// error mapping consistently.
  final AuthRepository repository;

  /// Creates a [GetCurrentUserUseCase] with the required [repository].
  ///
  /// The repository dependency is injected to enable testing with mock
  /// implementations and to follow dependency inversion principles.
  GetCurrentUserUseCase(this.repository);

  /// Retrieves the current user's complete profile information.
  ///
  /// **Input Parameters:**
  /// - [params]: [NoParams] instance (no additional input required)
  ///
  /// **Returns:**
  /// - [Right<UserEntity?>]: Complete user profile or null if not authenticated
  /// - [Left<Failure>]: Specific failure type indicating the error cause
  ///
  /// **Null Return Semantics:**
  /// - `null` indicates no user is currently authenticated (normal state)
  /// - This is not considered an error condition
  /// - Calling code should handle null as "unauthenticated" state
  ///
  /// **Side Effects:**
  /// - May update local user data cache
  /// - Triggers authentication state validation
  /// - May refresh authentication token if needed
  /// - Updates last activity timestamp for session management
  ///
  /// **Error Handling:**
  /// - Network errors are mapped to specific failure types
  /// - Authentication errors trigger appropriate responses
  /// - Data integrity issues are reported as failures
  /// - Transient errors can be retried safely
  ///
  /// **Performance Notes:**
  /// - First call may take longer due to network fetch
  /// - Subsequent calls are typically served from cache
  /// - Cache is automatically invalidated when appropriate
  /// - Method is safe to call frequently
  ///
  /// The method delegates to the repository which handles the complex
  /// authentication state checking and data merging logic.
  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) async {
    return await repository.getCurrentUser();
  }
}

