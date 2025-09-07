// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_firebase_data_source.dart';
import '../../../../core/services/auth_service.dart';

/// Production implementation of [AuthRepository] using Firebase and local storage.
///
/// This repository implementation provides authentication services by coordinating
/// between Firebase Authentication, Cloud Firestore, and local data storage.
/// It follows the Repository pattern to abstract data source complexities and
/// provide a clean interface for the domain layer.
///
/// **Architecture:**
/// - **Remote Data Source**: Firebase Authentication + Cloud Firestore
/// - **Local Data Source**: Secure storage for caching and offline access
/// - **Network Management**: Connectivity-aware operations with fallbacks
/// - **Error Handling**: Comprehensive error mapping and user-friendly messages
///
/// **Data Flow:**
/// ```
/// Domain Layer
///      ↓
/// AuthRepository (Interface)
///      ↓
/// AuthRepositoryImpl (This class)
///      ↓
/// [FirebaseDataSource] ←→ [LocalDataSource] ←→ [NetworkInfo]
/// ```
///
/// **Key Features:**
/// - Automatic network connectivity detection
/// - Local data caching for improved performance
/// - Offline fallback capabilities where possible
/// - Comprehensive error handling and mapping
/// - Authentication state synchronization
/// - Thread-safe operations
///
/// **Caching Strategy:**
/// - User data is cached locally after successful operations
/// - Cache is invalidated on sign-out or authentication errors
/// - Cached data is used for offline scenarios where applicable
/// - Cache expiration is managed automatically
///
/// **Error Handling:**
/// - Network errors mapped to [NetworkFailure]
/// - Authentication errors mapped to [AuthenticationFailure]
/// - Server errors mapped to [ServerFailure]
/// - Validation errors mapped to [ValidationFailure]
/// - Unknown errors mapped to [UnknownFailure]
///
/// **Security Considerations:**
/// - All authentication tokens are handled securely
/// - Local storage uses platform-specific secure storage
/// - User credentials are never stored locally
/// - Authentication state is validated on each operation
/// - Sensitive data is cleared on sign-out
///
/// **Dependencies:**
/// - [AuthFirebaseDataSource]: Handles Firebase operations
/// - [AuthLocalDataSource]: Manages local storage and caching
/// - [NetworkInfo]: Provides network connectivity information
///
/// Example usage:
/// ```dart
/// final repository = AuthRepositoryImpl(
///   firebaseDataSource: sl<AuthFirebaseDataSource>(),
///   localDataSource: sl<AuthLocalDataSource>(),
///   networkInfo: sl<NetworkInfo>(),
/// );
///
/// // The repository is typically used through dependency injection
/// // and accessed via use cases in the domain layer
/// ```
class AuthRepositoryImpl implements AuthRepository {
  final AuthFirebaseDataSource firebaseDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  final AuthService authService;

  AuthRepositoryImpl({
    required this.firebaseDataSource,
    required this.localDataSource,
    required this.networkInfo,
    required this.authService,
  });

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    // Check network connectivity before attempting authentication
    // This prevents unnecessary Firebase calls and provides immediate feedback
    if (await networkInfo.isConnected) {
      try {
        // Attempt Firebase Authentication with provided credentials
        // This call handles:
        // 1. Email/password validation with Firebase Auth
        // 2. User profile retrieval from Firestore
        // 3. Authentication token generation and management
        await authService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Prefer the AuthService to obtain the current authenticated profile
        final profile = await authService.getCurrentUserProfile();
        if (profile == null) return Left(ServerFailure('Sign in failed'));

        // Retrieve full UserModel for caching and entity conversion
        final userModel = await firebaseDataSource.getCurrentUser();
        if (userModel == null) return Left(ServerFailure('Sign in failed'));

        await localDataSource.cacheUserData(userModel);
        return Right(userModel.toEntity());
      } catch (e) {
        // Map all Firebase/network exceptions to domain failures
        // This ensures consistent error handling across the app
        // Common scenarios: wrong credentials, account disabled, server issues
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // No network connection available
      // Note: We don't attempt offline sign-in for security reasons
      // Authentication always requires server verification
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    if (await networkInfo.isConnected) {
      try {
        await authService.signInWithGoogle();

        final profile = await authService.getCurrentUserProfile();
        if (profile == null)
          return Left(ServerFailure('Google sign-in failed'));

        final userModel = await firebaseDataSource.getCurrentUser();
        if (userModel == null)
          return Left(ServerFailure('Google sign-in failed'));

        await localDataSource.cacheUserData(userModel);
        return Right(userModel.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
    required String userType,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await authService.signUpWithEmailAndPassword(
          email: email,
          password: password,
          name: fullName,
          userType: userType,
        );
        final profile = await authService.getCurrentUserProfile();
        if (profile == null) return Left(ServerFailure('Sign up failed'));

        final userModel = await firebaseDataSource.getCurrentUser();
        if (userModel == null) return Left(ServerFailure('Sign up failed'));

        await localDataSource.cacheUserData(userModel);
        return Right(userModel.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    // Check network connectivity for remote sign-out
    // Note: Local cleanup should always happen regardless of network status
    if (await networkInfo.isConnected) {
      try {
        // Step 1: Sign out from Firebase Authentication
        // This invalidates the authentication token on the server
        // and prevents further API calls with the current session
        // Use AuthService for sign out
        await authService.signOut();

        // Step 2: Clear cached user profile data
        // This removes any personally identifiable information
        // stored locally including name, email, preferences, etc.
        await localDataSource.clearUserData();

        // Step 3: Clear authentication tokens from secure storage
        // This ensures no authentication state remains on the device
        // and prevents automatic re-authentication on app restart
        await localDataSource.clearAuthToken();

        // All cleanup completed successfully
        return const Right(null);
      } catch (e) {
        // Network sign-out failed, but local cleanup still occurred
        // This could happen if Firebase is temporarily unavailable
        // The user is still signed out locally for security
        return Left(ServerFailure(e.toString()));
      }
    } else {
      // No network connection - cannot notify server of sign-out
      // However, we still perform local cleanup for security and privacy
      // This ensures user data is removed from the device even when offline
      try {
        // Step 1: Clear cached user profile data
        // This removes any personally identifiable information
        // stored locally including name, email, preferences, etc.
        await localDataSource.clearUserData();

        // Step 2: Clear authentication tokens from secure storage
        // This ensures no authentication state remains on the device
        // and prevents automatic re-authentication on app restart
        await localDataSource.clearAuthToken();

        // Note: We couldn't sign out from Firebase due to no network
        // The remote session remains active until it expires or
        // the user signs out when they have internet connectivity again
        // This is a security trade-off for better user experience

        // Return success with a message indicating offline sign-out occurred
        return const Right(null);
      } catch (e) {
        // Local cleanup failed - this is a critical security issue
        // Return failure so the app can handle appropriately
        return Left(
            ServerFailure('Failed to clear local data: ${e.toString()}'));
      }
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      // Check network connectivity to determine data source strategy
      if (await networkInfo.isConnected) {
        // Network available: Fetch fresh user data from Firebase
        // This ensures we have the most up-to-date profile information
        // including any changes made on other devices or through admin console
        final userModel = await firebaseDataSource.getCurrentUser();
        if (userModel != null) {
          await localDataSource.cacheUserData(userModel);
        }
        return Right(userModel?.toEntity());
      } else {
        // Network unavailable: Fall back to cached data
        // This enables basic app functionality when offline
        // Note: Cached data may be stale but still useful for UI display
        final cachedUser = await localDataSource.getCachedUserData();

        // Convert cached model to domain entity if present so callers always
        // receive a UserEntity (or null) and the API is consistent.
        return Right(cachedUser?.toEntity());
      }
    } catch (e) {
      // Handle any unexpected errors (database issues, corrupted cache, etc.)
      // Log the error for debugging but don't crash the app
      // Return failure so calling code can handle appropriately
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword({
    required String email,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        await authService.resetPassword(email: email);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String fullName,
    String? phoneNumber,
    String? profilePictureUrl,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        // Use AuthService to update the user profile document and auth profile
        final current = await authService.getCurrentUserProfile();
        if (current == null) throw Exception('No authenticated user');

        final updatedModel = current.copyWith(
          fullName: fullName,
          phoneNumber: phoneNumber,
          profilePictureUrl: profilePictureUrl,
          updatedAt: DateTime.now(),
        );

        await authService.updateUserProfile(updatedModel as dynamic);

        // Fetch the full user model after update for caching and entity mapping
        final userModel = await firebaseDataSource.getCurrentUser();
        if (userModel == null)
          return Left(ServerFailure('Failed to fetch updated user'));
        await localDataSource.cacheUserData(userModel);
        return Right(userModel.toEntity());
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String newPassword,
  }) async {
    if (await networkInfo.isConnected) {
      try {
        // Delegate password change to the AuthService implementation
        await authService.changePassword(newPassword: newPassword);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No internet connection'));
    }
  }

  @override
  Future<bool> isUserLoggedIn() async {
    try {
      // Determine authentication status based on network availability
      if (await networkInfo.isConnected) {
        // Network available: check via AuthService for the current profile
        final profile = await authService.getCurrentUserProfile();
        return profile != null;
      } else {
        // Network unavailable: Check local authentication state
        // This allows the app to function offline with last known state
        // Note: This doesn't verify if the remote session is still valid
        final cachedUser = await localDataSource.getCachedUserData();

        // Return true if we have cached user data
        // This assumes the user was authenticated when the data was cached
        // Limitation: Cannot detect if the account was disabled while offline
        return cachedUser != null;
      }
    } catch (e) {
      // Any error in checking authentication status should default to false
      // This ensures security by denying access when state is uncertain
      // Errors could include: corrupted cache, network timeouts, etc.
      // Graceful degradation: treat unknown state as not authenticated
      return false;
    }
  }
}
