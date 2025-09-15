import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/services/auth_service.dart';
import '../../domain/entities/user_entity.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService authService;

  AuthBloc({
    required this.authService,
  }) : super(AuthInitial()) {
    try {
      on<AppStartedEvent>(_onAppStarted);
      on<SignInEvent>(_onSignIn);
      on<SignUpEvent>(_onSignUp);
      on<SignOutEvent>(_onSignOut);
      on<ForgotPasswordEvent>(_onForgotPassword);
      on<SignInWithGoogleEvent>(_onSignInWithGoogle);
      on<SignUpWithGoogleEvent>(_onSignUpWithGoogle);
    } catch (e) {
      // Fallback to basic authentication handling
      on<AppStartedEvent>((event, emit) async {
        emit(AuthUnauthenticated());
      });
    }
  }

  Future<void> _onAppStarted(
    AppStartedEvent event,
    Emitter<AuthState> emit,
  ) async {
    // Set initial state
    if (state is! AuthLoading) {
      emit(AuthLoading());
    }

    // Add a timeout to prevent the app from getting stuck
    try {
      // Set a timeout of 5 seconds
      await Future.any([
        _performAuthCheck(emit),
        Future.delayed(const Duration(seconds: 5),
            () => throw TimeoutException('Authentication check timed out'))
      ]);
    } catch (e) {
      if (e is TimeoutException) {
      } else {}

      emit(AuthUnauthenticated());
    }
  }

  Future<void> _performAuthCheck(Emitter<AuthState> emit) async {
    try {
      // Debug: trace auth check start
      // ignore: avoid_print
      print('AuthBloc: starting _performAuthCheck');
      // Add a timeout to prevent the app from getting stuck
      final userProfile = await Future.any([
        authService.getCurrentUserProfile(),
        Future.delayed(const Duration(seconds: 5),
            () => throw TimeoutException('Authentication check timed out'))
      ]);
      // Debug: report the result of the profile fetch
      // ignore: avoid_print
      print(
          'AuthBloc: _performAuthCheck result -> ${userProfile == null ? 'null' : 'profile found'}');

      if (userProfile != null) {
        final userEntity = UserEntity(
          id: userProfile.id,
          fullName: userProfile.fullName,
          email: userProfile.email,
          phoneNumber: userProfile.phoneNumber,
          profession: null, // Not available in UserProfileModel
          userType:
              'customer', // Default value since it's not in UserProfileModel
          profilePictureUrl: userProfile.profilePictureUrl,
          token: null, // Not available in UserProfileModel
          createdAt: userProfile.createdAt,
          updatedAt: userProfile.updatedAt,
        );
        emit(AuthAuthenticated(userEntity));
      } else {
        // Firestore profile was not available. This can happen when Firestore
        // rules prevent reads (permission-denied). In that case, check the
        // FirebaseAuth state: if a Firebase user is signed in, treat them as
        // authenticated (degraded mode) by building a minimal UserEntity from
        // the Firebase user. This avoids marking the user unauthenticated
        // simply because Firestore is inaccessible.
        try {
          // Debug: attempt to read Firebase auth state when profile missing
          // ignore: avoid_print
          print(
              'AuthBloc: profile null — checking Firebase authStateChanges...');
          // Attempt to read an authenticated Firebase user from the auth
          // state stream. If none is available quickly, fall back to null.
          final fb.User? fbUser = await authService.authStateChanges
              .firstWhere((u) => u != null, orElse: () => null);

          // Debug: report whether a Firebase user was found
          // ignore: avoid_print
          print(
              'AuthBloc: firebase auth state -> ${fbUser == null ? 'null' : 'user found'}');

          if (fbUser != null) {
            final userEntity = UserEntity(
              id: fbUser.uid,
              fullName: fbUser.displayName ?? 'User',
              email: fbUser.email ?? '',
              phoneNumber: fbUser.phoneNumber,
              profession: null,
              userType: 'customer',
              profilePictureUrl: fbUser.photoURL ?? '',
              token: null,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            emit(AuthAuthenticated(userEntity));
            return;
          }
        } catch (_) {
          // ignore and fall through to unauthenticated
        }

        emit(AuthUnauthenticated());
      }
    } catch (e) {
      if (e is TimeoutException) {
      } else {}

      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignIn(
    SignInEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Ensure the user is actually signed in with the provided credentials
      await authService.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final userProfile = await authService.getCurrentUserProfile();
      if (userProfile != null) {
        final userEntity = UserEntity(
          id: userProfile.id,
          fullName: userProfile.fullName,
          email: userProfile.email,
          phoneNumber: userProfile.phoneNumber,
          profession: null, // Not available in UserProfileModel
          userType:
              'customer', // Default value since it's not in UserProfileModel
          profilePictureUrl: userProfile.profilePictureUrl,
          token: null, // Not available in UserProfileModel
          createdAt: userProfile.createdAt,
          updatedAt: userProfile.updatedAt,
        );
        emit(AuthAuthenticated(userEntity));
      } else {
        emit(AuthError('User profile not found'));
      }
    } catch (e) {
      emit(AuthError('Sign in failed: ${e.toString()}'));
    }
  }

  Future<void> _onSignUp(
    SignUpEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      // Call the sign up method with the user's information
      await authService.signUpWithEmailAndPassword(
        email: event.email,
        password: event.password,
        name: event.name,
        userType: event.userType,
      );

      // After successful sign up, get the user profile
      final userProfile = await authService.getCurrentUserProfile();
      if (userProfile != null) {
        final userEntity = UserEntity(
          id: userProfile.id,
          fullName: userProfile.fullName,
          email: userProfile.email,
          phoneNumber: userProfile.phoneNumber,
          profession: null, // Not available in UserProfileModel
          userType: event.userType, // Use the userType from the event
          profilePictureUrl: userProfile.profilePictureUrl,
          token: null, // Not available in UserProfileModel
          createdAt: userProfile.createdAt,
          updatedAt: userProfile.updatedAt,
        );
        emit(AuthAuthenticated(userEntity));
      } else {
        emit(AuthError('User profile not found after sign up'));
      }
    } catch (e) {
      final msg = e.toString();
      if (msg.contains('email-already-in-use') ||
          msg.contains('already in use')) {
        emit(AuthEmailAlreadyInUse(event.email));
      } else {
        emit(AuthError('Sign up failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onSignOut(
    SignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authService.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError('Sign out failed: ${e.toString()}'));
    }
  }

  Future<void> _onForgotPassword(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await authService.resetPassword(email: event.email);
      emit(AuthPasswordResetSent());
    } catch (e) {
      emit(AuthError('Password reset failed: ${e.toString()}'));
    }
  }

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await authService.signInWithGoogle();
      if (userCredential != null) {
        final userProfile = await authService.getCurrentUserProfile();
        if (userProfile != null) {
          final userEntity = UserEntity(
            id: userProfile.id,
            fullName: userProfile.fullName,
            email: userProfile.email,
            phoneNumber: userProfile.phoneNumber,
            profession: null, // Not available in UserProfileModel
            userType:
                'customer', // Default value since it's not in UserProfileModel
            profilePictureUrl: userProfile.profilePictureUrl,
            token: null, // Not available in UserProfileModel
            createdAt: userProfile.createdAt,
            updatedAt: userProfile.updatedAt,
          );
          emit(AuthAuthenticated(userEntity));
        } else if (userCredential.user != null) {
          // Firestore profile missing (e.g. permission denied). Build a
          // minimal authenticated user from the Firebase user so the app can
          // continue and prompt for profile completion if needed.
          final fbUser = userCredential.user!;
          final userEntity = UserEntity(
            id: fbUser.uid,
            fullName: fbUser.displayName ?? 'User',
            email: fbUser.email ?? '',
            phoneNumber: fbUser.phoneNumber,
            profession: null,
            userType: 'customer',
            profilePictureUrl: fbUser.photoURL ?? '',
            token: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          emit(AuthAuthenticated(userEntity));
        } else {
          emit(AuthError('Google sign in failed'));
        }
      } else {
        emit(AuthError('Google sign in failed'));
      }
    } catch (e) {
      emit(AuthError('Google sign in failed: ${e.toString()}'));
    }
  }

  Future<void> _onSignUpWithGoogle(
    SignUpWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final userCredential = await authService.signInWithGoogle();
      if (userCredential != null) {
        final userProfile = await authService.getCurrentUserProfile();
        if (userProfile != null) {
          final userEntity = UserEntity(
            id: userProfile.id,
            fullName: userProfile.fullName,
            email: userProfile.email,
            phoneNumber: userProfile.phoneNumber,
            profession: null, // Not available in UserProfileModel
            userType:
                'customer', // Default value since it's not in UserProfileModel
            profilePictureUrl: userProfile.profilePictureUrl,
            token: null, // Not available in UserProfileModel
            createdAt: userProfile.createdAt,
            updatedAt: userProfile.updatedAt,
          );
          emit(AuthAuthenticated(userEntity));
        } else if (userCredential.user != null) {
          final fbUser = userCredential.user!;
          final userEntity = UserEntity(
            id: fbUser.uid,
            fullName: fbUser.displayName ?? 'User',
            email: fbUser.email ?? '',
            phoneNumber: fbUser.phoneNumber,
            profession: null,
            userType: 'customer',
            profilePictureUrl: fbUser.photoURL ?? '',
            token: null,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          emit(AuthAuthenticated(userEntity));
        } else {
          emit(AuthError('Google sign up failed'));
        }
      } else {
        emit(AuthError('Google sign up failed'));
      }
    } catch (e) {
      emit(AuthError('Google sign up failed: ${e.toString()}'));
    }
  }
}
