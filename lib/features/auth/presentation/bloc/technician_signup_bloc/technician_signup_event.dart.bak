part of 'technician_signup_bloc.dart';

abstract class TechnicianSignUpEvent extends Equatable {
  const TechnicianSignUpEvent();

  @override
  List<Object> get props => [];
}

class TechnicianSignUpRequested extends TechnicianSignUpEvent {
  final String name;
  final String email;
  final String phone;
  final String profession;
  final String password;

  const TechnicianSignUpRequested({
    required this.name,
    required this.email,
    required this.phone,
    required this.profession,
    required this.password,
  });

  @override
  List<Object> get props => [name, email, phone, profession, password];
}
