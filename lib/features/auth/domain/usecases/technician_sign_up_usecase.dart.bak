
import 'package:equatable/equatable.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class TechnicianSignUpUseCase extends UseCase<UserEntity, TechnicianSignUpParams> {
  final AuthRepository repository;

  TechnicianSignUpUseCase({required this.repository});

  @override
  Future<UserEntity> call(TechnicianSignUpParams params) async {
    try {
      final result = await repository.signUp(
        email: params.email,
        password: params.password,
        fullName: params.fullName,
        phoneNumber: params.phoneNumber,
        userType: 'technician',
      );
      
      return result.fold(
        (failure) => throw Exception('Failed to sign up as technician: ${failure.message}'),
        (userEntity) => userEntity,
      );
    } catch (e) {
      throw Exception('Failed to sign up as technician: $e');
    }
  }
}

class TechnicianSignUpParams extends Equatable {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String profession;

  const TechnicianSignUpParams({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.profession,
  });

  @override
  List<Object?> get props => [fullName, email, password, phoneNumber, profession];
}
