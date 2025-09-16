import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

/// Signs out the current user and performs complete session cleanup.
///
/// This use case handles the complete logout process including Firebase
/// Authentication sign-out, local session data clearing, cache invalidation,
/// and security cleanup. It ensures that all user-specific data is properly
/// cleared from the device when the user logs out.
///
/// **Business Rules:**
/// - Must clear all authentication tokens and user data
/// - Should work even if network is unavailable (local cleanup)
/// - Must invalidate all cached user information
/// - Should reset app state to unauthenticated
/// - Must stop all user-specific background processes
///
/// **Security Requirements:**
/// - Complete removal of authentication tokens
/// - Clearing of any cached sensitive data
/// - Invalidation of active sessions
/// - Reset of any biometric authentication states
/// - Clearing of any stored user preferences that contain PII
///
/// **Process Flow:**
/// 1. Sign out from Firebase Authentication
/// 2. Clear local authentication tokens and session data
/// 3. Clear all cached user data (profile, preferences, etc.)
/// 4. Reset app authentication state to unauthenticated
/// 5. Notify all authentication state listeners
/// 6. Stop any user-specific background services
/// 7. Navigate to welcome/login screen
///
/// **Cleanup Operations:**
/// - Firebase Authentication session termination
/// - Local secure storage cleanup (tokens, user data)
/// - In-memory cache invalidation
/// - Shared preferences cleanup (user-specific data)
/// - Database cleanup (local user data)
/// - File system cleanup (cached images, documents)
///
/// **Error Scenarios:**
/// - [NetworkFailure]: Unable to notify server (local cleanup still succeeds)
/// - [ServerFailure]: Firebase service unavailable (local cleanup still succeeds)
/// - Note: Sign-out always succeeds locally for security reasons
///
/// **Performance Characteristics:**
/// - Typical completion time: 100ms - 500ms
/// - Network dependency: Optional (local cleanup always works)
/// - Memory impact: Reduces memory usage by clearing caches
/// - Storage impact: Frees up local storage space
///
/// **User Experience:**
/// - Should provide immediate visual feedback (loading indicator)
/// - Always completes successfully from user perspective
/// - Redirects to appropriate screen after completion
/// - Maintains app stability during transition
///
/// **Dependencies:**
/// - [AuthRepository]: Handles Firebase and local storage operations
/// - Firebase Authentication: Manages remote session termination
/// - Local storage systems: Secure storage, shared preferences, etc.
/// - App state management: Notifies listeners of authentication changes
///
/// Example usage:
/// ```dart
/// final signOutUseCase = sl<SignOutUseCase>();
/// 
/// // Standard sign-out flow
/// void handleSignOut() async {
///   // Show loading indicator
///   showLoadingDialog();
///   
///   final result = await signOutUseCase(NoParams());
///   
///   // Hide loading indicator
///   hideLoadingDialog();
///   
///   result.fold(
///     (failure) {
///       // Log warning but don't show error to user
///       // Local cleanup still succeeded
///       logWarning('Sign-out network error: $failure');
///       navigateToWelcomeScreen();
///     },
///     (_) {
///       // Sign-out completed successfully
///       showMessage('Signed out successfully');
///       navigateToWelcomeScreen();
///     },
///   );
/// }
/// 
/// // Emergency sign-out (e.g., security breach detected)
/// void emergencySignOut() async {
///   await signOutUseCase(NoParams());
///   // Always navigate away immediately for security
///   navigateToWelcomeScreen();
///   showSecurityAlert('Session terminated for security reasons');
/// }
/// 
/// // Sign-out with confirmation dialog
/// void signOutWithConfirmation() {
///   showConfirmationDialog(
///     title: 'Sign Out',
///     message: 'Are you sure you want to sign out?',
///     onConfirm: () => handleSignOut(),
///   );
/// }
/// ```
class SignOutUseCase implements UseCase<void, NoParams> {
  /// Repository for authentication operations and session management.
  ///
  /// Provides access to Firebase Authentication sign-out functionality
  /// and local storage cleanup operations through a unified interface
  /// that ensures complete and secure session termination.
  final AuthRepository repository;

  /// Creates a [SignOutUseCase] with the required [repository].
  ///
  /// The repository dependency is injected to enable testing with mock
  /// implementations and to follow dependency inversion principles.
  SignOutUseCase(this.repository);

  /// Executes the complete sign-out process for the current user.
  ///
  /// **Input Parameters:**
  /// - [params]: [NoParams] instance (no additional input required)
  ///
  /// **Returns:**
  /// - [Right<void>]: Sign-out completed successfully
  /// - [Left<Failure>]: Network error during remote sign-out (local cleanup still succeeded)
  ///
  /// **Success Guarantee:**
  /// This operation is designed to always succeed from a security perspective.
  /// Even if network operations fail, local cleanup is performed to ensure
  /// the user is signed out of the device. Network failures are reported
  /// but do not prevent the sign-out from completing.
  ///
  /// **Side Effects:**
  /// - Clears all authentication tokens and user session data
  /// - Invalidates all cached user information
  /// - Resets app authentication state to unauthenticated
  /// - Triggers navigation to welcome/login screen
  /// - Stops all user-specific background processes
  /// - Notifies all authentication state listeners
  ///
  /// **Security Considerations:**
  /// - Local cleanup always completes regardless of network status
  /// - All sensitive data is securely cleared from the device
  /// - Authentication state is immediately reset
  /// - Any active sessions are invalidated
  ///
  /// **Performance Notes:**
  /// - Fast operation with minimal network dependency
  /// - Cleanup operations are optimized for quick completion
  /// - Safe to call multiple times (idempotent operation)
  /// - Does not block UI thread during execution
  ///
  /// The method delegates to the repository which handles the complex
  /// coordination of Firebase sign-out and local cleanup operations.
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}

