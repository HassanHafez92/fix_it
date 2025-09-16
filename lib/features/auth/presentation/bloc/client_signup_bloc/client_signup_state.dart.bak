part of 'client_signup_bloc.dart';

abstract class ClientSignUpState extends Equatable {
  const ClientSignUpState();

  @override
  List<Object> get props => [];
}

class ClientSignUpInitial extends ClientSignUpState {}

class ClientSignUpLoading extends ClientSignUpState {}

class ClientSignUpSuccess extends ClientSignUpState {}

class ClientSignUpFailure extends ClientSignUpState {
  final String message;

  const ClientSignUpFailure(this.message);

  @override
  List<Object> get props => [message];
}

class ClientSignUpEmailAlreadyInUse extends ClientSignUpState {
  final String email;
  const ClientSignUpEmailAlreadyInUse(this.email);

  @override
  List<Object> get props => [email];
}
