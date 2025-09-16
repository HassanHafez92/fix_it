part of 'technician_sign_up_bloc.dart';

abstract class TechnicianSignUpState extends Equatable {
  const TechnicianSignUpState();

  @override
  List<Object?> get props => [];
}

class TechnicianSignUpInitial extends TechnicianSignUpState {}

class TechnicianSignUpLoading extends TechnicianSignUpState {}

class TechnicianSignUpSuccess extends TechnicianSignUpState {
  final UserEntity user;

  const TechnicianSignUpSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class TechnicianSignUpError extends TechnicianSignUpState {
  final String message;

  const TechnicianSignUpError(this.message);

  @override
  List<Object?> get props => [message];
}
