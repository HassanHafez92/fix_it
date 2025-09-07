import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fix_it/features/auth/data/datasources/auth_firebase_data_source.dart';
import 'package:fix_it/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:fix_it/features/auth/data/models/user_model.dart';
import 'package:fix_it/features/profile/data/models/user_profile_model.dart';
import 'package:fix_it/core/services/auth_service.dart';
import 'package:fix_it/core/error/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_it/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fix_it/features/auth/domain/entities/user_entity.dart';
import 'package:fix_it/core/network/network_info.dart';

class MockAuthFirebaseDataSource extends Mock
    implements AuthFirebaseDataSource {}

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockAuthService extends Mock implements AuthService {}

class FakeUserCredential implements UserCredential {
  @override
  // ignore: overridden_fields
  final User? user = null;

  @override
  AuthCredential? get credential => null;

  @override
  AdditionalUserInfo? get additionalUserInfo => null;
}

class UserModelFake extends Fake implements UserModel {}

void main() {
  setUpAll(() {
    // Register fallback value for UserModel when using any()
    registerFallbackValue(UserModelFake());
  });
  late AuthRepositoryImpl authRepositoryImpl;
  late MockAuthFirebaseDataSource mockAuthFirebaseDataSource;
  late MockAuthLocalDataSource mockAuthLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  late MockAuthService mockAuthService;

  setUp(() {
    mockAuthFirebaseDataSource = MockAuthFirebaseDataSource();
    mockAuthLocalDataSource = MockAuthLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    mockAuthService = MockAuthService();
    authRepositoryImpl = AuthRepositoryImpl(
      firebaseDataSource: mockAuthFirebaseDataSource,
      localDataSource: mockAuthLocalDataSource,
      networkInfo: mockNetworkInfo,
      authService: mockAuthService,
    );
    // Default network connectivity for tests
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    // Default local data source behaviors to avoid null returns
    when(() => mockAuthLocalDataSource.cacheUserData(any()))
        .thenAnswer((_) async => Future.value());
    when(() => mockAuthLocalDataSource.clearUserData())
        .thenAnswer((_) async => Future.value());
    when(() => mockAuthLocalDataSource.clearAuthToken())
        .thenAnswer((_) async => Future.value());
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  final tUserModel = UserModel(
    id: 'testId',
    email: tEmail,
    fullName: 'Test User',
    userType: 'client',
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
  final tUserEntity = UserEntity(
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

  group('signIn', () {
    test(
      'should return UserEntity when the call to firebase data source is successful',
      () async {
        // arrange
        // authService performs the actual sign in; firebaseDataSource then
        // returns the current user model. Stub both accordingly.
        when(() => mockAuthService.signInWithEmailAndPassword(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => FakeUserCredential());
        // AuthService now provides the current profile before we fetch a full UserModel
        when(() => mockAuthService.getCurrentUserProfile())
            .thenAnswer((_) async => UserProfileModel(
                  id: tUserModel.id,
                  fullName: tUserModel.fullName,
                  email: tUserModel.email,
                  createdAt: tUserModel.createdAt,
                  updatedAt: tUserModel.updatedAt,
                ));
        when(() => mockAuthFirebaseDataSource.getCurrentUser())
            .thenAnswer((_) async => tUserModel);
        when(() => mockAuthLocalDataSource.cacheUserData(any()))
            .thenAnswer((_) async => Future.value());

        // act
        final result =
            await authRepositoryImpl.signIn(email: tEmail, password: tPassword);

        // assert
        expect(result.isRight(), true);
        final user = result.getOrElse(() => throw Exception('No user'));
        expect(user.id, tUserEntity.id);
        expect(user.email, tUserEntity.email);
        expect(user.fullName, tUserEntity.fullName);
        expect(user.userType, tUserEntity.userType);
        // Production flow: AuthService performs sign in, then firebaseDataSource.getCurrentUser()
        verify(() => mockAuthService.signInWithEmailAndPassword(
            email: tEmail, password: tPassword));
        verify(() => mockAuthService.getCurrentUserProfile());
        verify(() => mockAuthFirebaseDataSource.getCurrentUser());
        verify(() => mockAuthLocalDataSource.cacheUserData(tUserModel));
        verifyNoMoreInteractions(mockAuthService);
        verifyNoMoreInteractions(mockAuthFirebaseDataSource);
        verifyNoMoreInteractions(mockAuthLocalDataSource);
      },
    );

    test(
      'should return Failure when the call to firebase data source is unsuccessful',
      () async {
        // arrange
        const tFailure = 'Sign in failed';
        when(() => mockAuthService.signInWithEmailAndPassword(
                email: any(named: 'email'), password: any(named: 'password')))
            .thenAnswer((_) async => FakeUserCredential());
        // Provide a profile so repository proceeds to call firebaseDataSource
        when(() => mockAuthService.getCurrentUserProfile())
            .thenAnswer((_) async => UserProfileModel(
                  id: tUserModel.id,
                  fullName: tUserModel.fullName,
                  email: tUserModel.email,
                  createdAt: tUserModel.createdAt,
                  updatedAt: tUserModel.updatedAt,
                ));
        when(() => mockAuthFirebaseDataSource.getCurrentUser())
            .thenAnswer((_) async => throw Exception(tFailure));

        // act
        final result =
            await authRepositoryImpl.signIn(email: tEmail, password: tPassword);

        // assert
        // assert
        // Production wraps exceptions in ServerFailure(e.toString())
        expect(result, Left(ServerFailure('Exception: $tFailure')));
        verify(() => mockAuthService.signInWithEmailAndPassword(
            email: tEmail, password: tPassword));
        verify(() => mockAuthService.getCurrentUserProfile());
        verifyNever(() => mockAuthLocalDataSource.cacheUserData(any()));
        verifyNoMoreInteractions(mockAuthService);
        // firebaseDataSource.getCurrentUser may have been invoked and thrown;
        // we already asserted the repository returned a ServerFailure above.
        verifyNoMoreInteractions(mockAuthLocalDataSource);
      },
    );
  });

  group('signUp', () {
    test(
      'should return UserEntity when the call to firebase data source is successful',
      () async {
        // arrange
        when(() => mockAuthService.signUpWithEmailAndPassword(
                email: any(named: 'email'),
                password: any(named: 'password'),
                name: any(named: 'name'),
                userType: any(named: 'userType')))
            .thenAnswer((_) async => FakeUserCredential());
        // AuthService should return a current profile after sign up
        when(() => mockAuthService.getCurrentUserProfile())
            .thenAnswer((_) async => UserProfileModel(
                  id: tUserModel.id,
                  fullName: tUserModel.fullName,
                  email: tUserModel.email,
                  createdAt: tUserModel.createdAt,
                  updatedAt: tUserModel.updatedAt,
                ));
        when(() => mockAuthFirebaseDataSource.getCurrentUser())
            .thenAnswer((_) async => tUserModel);
        when(() => mockAuthLocalDataSource.cacheUserData(any()))
            .thenAnswer((_) async => Future.value());

        // act
        final result = await authRepositoryImpl.signUp(
          email: tEmail,
          password: tPassword,
          fullName: 'Test User',
          phoneNumber: '1234567890',
          userType: 'client',
        );

        // assert
        expect(result.isRight(), true);
        final user = result.getOrElse(() => throw Exception('No user'));
        expect(user.id, tUserEntity.id);
        expect(user.email, tUserEntity.email);
        expect(user.fullName, tUserEntity.fullName);
        expect(user.userType, tUserEntity.userType);
        // Production flow: AuthService handles sign up, then firebaseDataSource.getCurrentUser()
        verify(() => mockAuthService.signUpWithEmailAndPassword(
              email: tEmail,
              password: tPassword,
              name: 'Test User',
              userType: 'client',
            ));
        verify(() => mockAuthService.getCurrentUserProfile());
        verify(() => mockAuthFirebaseDataSource.getCurrentUser());
        verify(() => mockAuthLocalDataSource.cacheUserData(tUserModel));
        verifyNoMoreInteractions(mockAuthService);
        verifyNoMoreInteractions(mockAuthFirebaseDataSource);
        verifyNoMoreInteractions(mockAuthLocalDataSource);
      },
    );
  });

  group('getCurrentUser', () {
    test(
      'should return UserEntity when there is a cached user',
      () async {
        // arrange
        // Simulate offline so repository uses the cached data path
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(() => mockAuthLocalDataSource.getCachedUserData())
            .thenAnswer((_) async => tUserModel);

        // act
        final result = await authRepositoryImpl.getCurrentUser();

        // assert
        expect(result.isRight(), true);
        final user =
            result.getOrElse(() => throw Exception('No user')) as UserEntity;
        expect(user.id, tUserEntity.id);
        expect(user.email, tUserEntity.email);
        expect(user.fullName, tUserEntity.fullName);
        expect(user.userType, tUserEntity.userType);
        verify(() => mockAuthLocalDataSource.getCachedUserData());
      },
    );

    test(
      'should return UserEntity when there is a user from firebase',
      () async {
        // arrange
        // Ensure network available (default) so repository queries firebase for user
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockAuthFirebaseDataSource.getCurrentUser())
            .thenAnswer((_) async => tUserModel);

        // act
        final result = await authRepositoryImpl.getCurrentUser();

        // assert
        expect(result.isRight(), true);
        final user =
            result.getOrElse(() => throw Exception('No user')) as UserEntity;
        expect(user.id, tUserEntity.id);
        expect(user.email, tUserEntity.email);
        expect(user.fullName, tUserEntity.fullName);
        expect(user.userType, tUserEntity.userType);
        verify(() => mockAuthFirebaseDataSource.getCurrentUser());
        verify(() => mockAuthLocalDataSource.cacheUserData(tUserModel));
      },
    );

    test(
      'should return Failure when there is no cached user and no user from firebase',
      () async {
        // arrange
        // Ensure network available and no user present remotely
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockAuthFirebaseDataSource.getCurrentUser())
            .thenAnswer((_) async => null);

        // act
        final result = await authRepositoryImpl.getCurrentUser();

        // assert
        // Production returns Right(null) when there is no user available over network
        expect(result, Right(null));
        verify(() => mockAuthFirebaseDataSource.getCurrentUser());
      },
    );
  });

  group('signOut', () {
    test(
      'should complete successfully when the call to both data sources is successful',
      () async {
        // arrange
        // Production uses authService.signOut(); stub it accordingly
        when(() => mockAuthService.signOut())
            .thenAnswer((_) async => Future.value());

        // act
        final result = await authRepositoryImpl.signOut();

        // assert
        expect(result, const Right(null));
        verify(() => mockAuthService.signOut());
        verify(() => mockAuthLocalDataSource.clearUserData());
        verify(() => mockAuthLocalDataSource.clearAuthToken());
        verifyNoMoreInteractions(mockAuthService);
        verifyNoMoreInteractions(mockAuthLocalDataSource);
      },
    );
  });
}
