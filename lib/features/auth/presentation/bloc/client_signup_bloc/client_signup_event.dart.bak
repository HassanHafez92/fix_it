part of 'client_signup_bloc.dart';

abstract class ClientSignUpEvent extends Equatable {
  const ClientSignUpEvent();

  @override
  List<Object> get props => [];
}

class ClientSignUpRequested extends ClientSignUpEvent {
  final String name;
  final String email;
  final String phone;
  final String password;

  const ClientSignUpRequested({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, phone, password];
}
