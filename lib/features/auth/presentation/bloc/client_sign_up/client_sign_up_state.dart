part of 'client_sign_up_bloc.dart';

abstract class ClientSignUpState extends Equatable {
  const ClientSignUpState();

  @override
  List<Object?> get props => [];
}

class ClientSignUpInitial extends ClientSignUpState {}

class ClientSignUpLoading extends ClientSignUpState {}

class ClientSignUpSuccess extends ClientSignUpState {
  final UserEntity user;

  const ClientSignUpSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class ClientSignUpError extends ClientSignUpState {
  final String message;

  const ClientSignUpError(this.message);

  @override
  List<Object?> get props => [message];
}
