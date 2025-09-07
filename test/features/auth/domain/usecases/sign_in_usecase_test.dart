
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fix_it/features/auth/domain/entities/user_entity.dart';
import 'package:fix_it/features/auth/domain/repositories/auth_repository.dart';
import 'package:fix_it/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:fix_it/core/error/failures.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SignInUseCase signInUseCase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    signInUseCase = SignInUseCase(mockAuthRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tUser = UserEntity(
    id: 'testId',
    email: tEmail,
    fullName: 'Test User',
    phoneNumber: null,
    userType: 'client',
    profession: null,
    profilePictureUrl: null,
    token: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  group('SignInUseCase', () {
    test(
      'should return UserEntity when the call to repository is successful',
      () async {
        // arrange
        when(() => mockAuthRepository.signIn(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => Right(tUser));

        // act
        final result = await signInUseCase(const SignInParams(
          email: tEmail,
          password: tPassword,
        ));

        // assert
        expect(result, Right(tUser));
        verify(() => mockAuthRepository.signIn(email: tEmail, password: tPassword));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return Failure when the call to repository is unsuccessful',
      () async {
        // arrange
        final tFailure = AuthenticationFailure('Sign in failed');
        when(() => mockAuthRepository.signIn(email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => Left(tFailure));

        // act
        final result = await signInUseCase(const SignInParams(
          email: tEmail,
          password: tPassword,
        ));

        // assert
        expect(result, Left(tFailure));
        verify(() => mockAuthRepository.signIn(email: tEmail, password: tPassword));
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );
  });
}
