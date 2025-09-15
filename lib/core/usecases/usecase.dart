import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../error/failures.dart';

/// Base interface for all use cases in the Fix It application.
/// 
/// This abstract class defines the contract for implementing business logic
/// operations following the Clean Architecture pattern. Each use case represents
/// a single business operation and encapsulates specific application logic.
/// 
/// **Type Parameters:**
/// - [Type]: The return type of the use case operation
/// - [Params]: The parameters required for the operation
/// 
/// **Return Value:**
/// All use cases return `Either<Failure, Type>` which represents:
/// - `Left(Failure)`: Operation failed with specific error information
/// - `Right(Type)`: Operation succeeded with the expected result
/// 
/// **Example Implementation:**
/// ```dart
////// SignInUseCase
///
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
class SignInUseCase implements UseCase<UserEntity, SignInParams> {
///   final AuthRepository repository;
///   
///   SignInUseCase(this.repository);
///   
///   @override
///   Future<Either<Failure, UserEntity>> call(SignInParams params) async {
///     return await repository.signIn(
///       email: params.email,
///       password: params.password,
///     );
///   }
/// }
/// 
////// SignInParams
///
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
class SignInParams extends Equatable {
///   final String email;
///   final String password;
///   
///   const SignInParams({required this.email, required this.password});
///   
///   @override
///   List<Object> get props => [email, password];
/// }
/// ```
/// 
/// **Usage in BLoC:**
/// ```dart
////// AuthBloc
///
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
class AuthBloc extends Bloc<AuthEvent, AuthState> {
///   final SignInUseCase signInUseCase;
///   
///   Future<void> _onSignInRequested(SignInRequested event, Emitter<AuthState> emit) async {
///     emit(AuthLoading());
///     
///     final result = await signInUseCase(SignInParams(
///       email: event.email,
///       password: event.password,
///     ));
///     
///     result.fold(
///       (failure) => emit(AuthFailure(failure.message)),
///       (user) => emit(AuthSuccess(user)),
///     );
///   }
/// }
/// ```
abstract/// UseCase
///
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
class UseCase<Type, Params> {
  /// Executes the use case with the provided parameters.
  /// 
  /// This method contains the core business logic for the specific operation.
  /// It should be implemented by concrete use case classes to perform their
  /// specific business operations.
  /// 
  /// **Parameters:**
  /// - [params]: The input parameters required for the operation
  /// 
  /// **Returns:**
  /// A [Future] that resolves to an [Either] containing:
  /// - [Failure] if the operation fails
  /// - [Type] if the operation succeeds
  /// 
  /// **Error Handling:**
  /// - Network errors should be wrapped in [NetworkFailure]
  /// - Server errors should be wrapped in [ServerFailure]
  /// - Authentication errors should be wrapped in [AuthFailure]
  /// - Validation errors should be wrapped in [ValidationFailure]
  Future<Either<Failure, Type>> call(Params params);
}

/// Base class for use cases that don't require input parameters.
/// 
/// This abstract class extends [Equatable] to provide value equality
/// comparison for parameter objects. Use this when your use case doesn't
/// need any input parameters.
/// 
/// **Example Usage:**
/// ```dart
////// GetCurrentUserUseCase
///
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
class GetCurrentUserUseCase implements UseCase<UserEntity, NoParams> {
///   final AuthRepository repository;
///   
///   GetCurrentUserUseCase(this.repository);
///   
///   @override
///   Future<Either<Failure, UserEntity>> call(NoParams params) async {
///     return await repository.getCurrentUser();
///   }
/// }
/// 
/// // Usage
/// final result = await getCurrentUserUseCase(const NoParamsImpl());
/// ```
abstract/// NoParams
///
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
///
class NoParams extends Equatable {
  /// Creates a new instance of [NoParams].
  const NoParams();

  /// Returns an empty list since no parameters are needed.
  /// 
  /// This satisfies the [Equatable] contract for value comparison.
  @override
  List<Object> get props => [];
}

/// Concrete implementation of [NoParams] for use cases without parameters.
/// **Business Rules:**
/// - Add the main business rules or invariants enforced by this class.
/// 
/// Use this class when calling use cases that don't require any input parameters.
/// The class is designed as a singleton-like pattern where you can use the same
/// instance across multiple calls.
/// 
/// **Usage Examples:**
/// ```dart
/// // Get current user
/// final userResult = await getCurrentUserUseCase(const NoParamsImpl());
/// 
/// // Sign out user
/// final signOutResult = await signOutUseCase(const NoParamsImpl());
/// 
/// // Get app settings
/// final settingsResult = await getAppSettingsUseCase(const NoParamsImpl());
/// ```
/// 
/// **Note:** You can reuse the same [NoParamsImpl] instance since it contains
/// no state and implements value equality through [Equatable].
class NoParamsImpl extends NoParams {
  /// Creates a new instance of [NoParamsImpl].
  /// 
  /// This constructor is const, allowing for compile-time constant instances
  /// that can be reused throughout the application.
  const NoParamsImpl();
}
