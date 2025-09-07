import 'package:equatable/equatable.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class ClientSignUpUseCase extends UseCase<UserEntity, ClientSignUpParams> {
  final AuthRepository repository;

  ClientSignUpUseCase({required this.repository});

  @override
  Future<UserEntity> call(ClientSignUpParams params) async {
    try {
      final result = await repository.signUp(
        email: params.email,
        password: params.password,
        fullName: params.fullName,
        phoneNumber: params.phoneNumber,
        userType: 'client',
      );
      
      return result.fold(
        (failure) => throw Exception('Failed to sign up as client: ${failure.message}'),
        (userEntity) => userEntity,
      );
    } catch (e) {
      throw Exception('Failed to sign up as client: $e');
    }
  }
}

class ClientSignUpParams extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;

  const ClientSignUpParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [fullName, email, password, phoneNumber];
}
