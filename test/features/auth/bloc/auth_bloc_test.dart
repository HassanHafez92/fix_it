import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_it/features/profile/data/models/user_profile_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fix_it/core/services/auth_service.dart';
import 'package:fix_it/features/auth/presentation/bloc/auth_bloc.dart';

// Mock classes
class MockAuthService extends Mock implements AuthService {}

class MockUserCredential extends Mock implements UserCredential {}

void main() {
  group('AuthBloc', () {
    late AuthBloc authBloc;
    late MockAuthService mockAuthService;

    setUp(() {
      mockAuthService = MockAuthService();
      authBloc = AuthBloc(
        authService: mockAuthService,
      );
    });

    tearDown(() {
      authBloc.close();
    });

    test('initial state is AuthInitial', () {
      expect(authBloc.state, AuthInitial());
    });

    group('AppStartedEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when user is logged in',
        build: () {
          when(() => mockAuthService.getCurrentUserProfile())
              .thenAnswer((_) async => UserProfileModel(
                    id: 'testId',
                    fullName: 'Test User',
                    email: 'test@example.com',
                    phoneNumber: '1234567890',
                    profilePictureUrl: 'https://example.com/profile.jpg',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ));
          return authBloc;
        },
        act: (bloc) => bloc.add(AppStartedEvent()),
        expect: () => <Object>[
          isA<AuthLoading>(),
          isA<AuthAuthenticated>(),
        ],
        verify: (bloc) {
          final last = bloc.state;
          expect(last, isA<AuthAuthenticated>());
          if (last is AuthAuthenticated) {
            expect(last.user.email, 'test@example.com');
            expect(last.user.fullName, 'Test User');
          }
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when user is not logged in',
        build: () {
          when(() => mockAuthService.getCurrentUserProfile())
              .thenAnswer((_) async => null);
          return authBloc;
        },
        act: (bloc) => bloc.add(AppStartedEvent()),
        expect: () => <AuthState>[
          AuthLoading(),
          AuthUnauthenticated(),
        ],
      );
    });

    group('SignInEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when sign in is successful',
        build: () {
          when(() => mockAuthService.getCurrentUserProfile())
              .thenAnswer((_) async => UserProfileModel(
                    id: 'testId',
                    fullName: 'Test User',
                    email: 'test@example.com',
                    phoneNumber: '1234567890',
                    profilePictureUrl: 'https://example.com/profile.jpg',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ));
          return authBloc;
        },
        act: (bloc) => bloc.add(const SignInEvent(
          email: 'test@example.com',
          password: 'password123',
        )),
        expect: () => <Object>[
          isA<AuthLoading>(),
          isA<AuthAuthenticated>(),
        ],
        verify: (bloc) {
          final last = bloc.state;
          expect(last, isA<AuthAuthenticated>());
          if (last is AuthAuthenticated) {
            expect(last.user.email, 'test@example.com');
            expect(last.user.fullName, 'Test User');
          }
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when sign in fails',
        build: () {
          when(() => mockAuthService.getCurrentUserProfile())
              .thenAnswer((_) async => null);
          return authBloc;
        },
        act: (bloc) => bloc.add(const SignInEvent(
          email: 'test@example.com',
          password: 'wrongpassword',
        )),
        expect: () => <AuthState>[
          AuthLoading(),
          AuthError('User profile not found'),
        ],
      );
    });

    group('SignUpEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when sign up is successful',
        build: () {
          when(() => mockAuthService.getCurrentUserProfile())
              .thenAnswer((_) async => UserProfileModel(
                    id: 'testId',
                    fullName: 'Test User',
                    email: 'test@example.com',
                    phoneNumber: '1234567890',
                    profilePictureUrl: 'https://example.com/profile.jpg',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ));
          return authBloc;
        },
        act: (bloc) => bloc.add(const SignUpEvent(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
          phone: '1234567890',
          userType: 'customer',
        )),
        expect: () => <Object>[
          isA<AuthLoading>(),
          isA<AuthAuthenticated>(),
        ],
        verify: (bloc) {
          final last = bloc.state;
          expect(last, isA<AuthAuthenticated>());
          if (last is AuthAuthenticated) {
            expect(last.user.email, 'test@example.com');
            expect(last.user.fullName, 'Test User');
          }
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when sign up fails',
        build: () {
          when(() => mockAuthService.getCurrentUserProfile())
              .thenAnswer((_) async => null);
          return authBloc;
        },
        act: (bloc) => bloc.add(const SignUpEvent(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
          phone: '1234567890',
          userType: 'customer',
        )),
        expect: () => <AuthState>[
          AuthLoading(),
          AuthError('User profile not found'),
        ],
      );
    });

    group('SignOutEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthUnauthenticated] when sign out is successful',
        build: () {
          when(() => mockAuthService.signOut())
              .thenAnswer((_) async => Future.value());
          return authBloc;
        },
        act: (bloc) => bloc.add(SignOutEvent()),
        expect: () => <AuthState>[
          AuthLoading(),
          AuthUnauthenticated(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when sign out fails',
        build: () {
          when(() => mockAuthService.signOut())
              .thenAnswer((_) async => throw Exception('Sign out failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(SignOutEvent()),
        expect: () => <AuthState>[
          AuthLoading(),
          AuthError('Sign out failed: Exception: Sign out failed'),
        ],
      );
    });

    group('ForgotPasswordEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthPasswordResetSent] when password reset is successful',
        build: () {
          when(() => mockAuthService.resetPassword(email: any(named: 'email')))
              .thenAnswer((_) async => Future.value());
          return authBloc;
        },
        act: (bloc) =>
            bloc.add(const ForgotPasswordEvent(email: 'test@example.com')),
        expect: () => <AuthState>[
          AuthLoading(),
          AuthPasswordResetSent(),
        ],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when password reset fails',
        build: () {
          when(() => mockAuthService.resetPassword(email: any(named: 'email')))
              .thenAnswer(
                  (_) async => throw Exception('Password reset failed'));
          return authBloc;
        },
        act: (bloc) => bloc.add(ForgotPasswordEvent(email: 'test@example.com')),
        expect: () => <AuthState>[
          AuthLoading(),
          AuthError('Password reset failed: Exception: Password reset failed'),
        ],
      );
    });

    group('SignInWithGoogleEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, Authenticated] when Google sign in is successful',
        build: () {
          when(() => mockAuthService.signInWithGoogle())
              .thenAnswer((_) async => MockUserCredential());
          when(() => mockAuthService.getCurrentUserProfile())
              .thenAnswer((_) async => UserProfileModel(
                    id: 'testId',
                    fullName: 'Test User',
                    email: 'test@example.com',
                    phoneNumber: '1234567890',
                    profilePictureUrl: 'https://example.com/profile.jpg',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ));
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInWithGoogleEvent()),
        expect: () => <Object>[
          isA<AuthLoading>(),
          isA<AuthAuthenticated>(),
        ],
        verify: (bloc) {
          final last = bloc.state;
          expect(last, isA<AuthAuthenticated>());
          if (last is AuthAuthenticated) {
            expect(last.user.email, 'test@example.com');
            expect(last.user.fullName, 'Test User');
          }
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthError] when Google sign in fails',
        build: () {
          when(() => mockAuthService.signInWithGoogle())
              .thenAnswer((_) async => null);
          return authBloc;
        },
        act: (bloc) => bloc.add(SignInWithGoogleEvent()),
        expect: () => <AuthState>[
          AuthLoading(),
          AuthError('Google sign in failed'),
        ],
      );
    });
  });
}
