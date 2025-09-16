part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AppStartedEvent extends AuthEvent {}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  final String userType;
  final String? profession;

  const SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.userType,
    this.profession,
  });

  @override
  List<Object?> get props => [name, email, password, phone, userType, profession];
}

class SignOutEvent extends AuthEvent {}

class ForgotPasswordEvent extends AuthEvent {
  final String email;

  const ForgotPasswordEvent({required this.email});

  @override
  List<Object?> get props => [email];
}

class SignInWithGoogleEvent extends AuthEvent {}

class SignUpWithGoogleEvent extends AuthEvent {}
