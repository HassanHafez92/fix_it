part of 'client_sign_up_bloc.dart';

abstract class ClientSignUpEvent extends Equatable {
  const ClientSignUpEvent();

  @override
  List<Object?> get props => [];
}

class ClientSignUpSubmitted extends ClientSignUpEvent {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;

  const ClientSignUpSubmitted({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  @override
  List<Object?> get props => [fullName, email, password, phoneNumber];
}
