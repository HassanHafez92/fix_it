part of 'technician_sign_up_bloc.dart';

abstract class TechnicianSignUpEvent extends Equatable {
  const TechnicianSignUpEvent();

  @override
  List<Object?> get props => [];
}

class TechnicianSignUpSubmitted extends TechnicianSignUpEvent {
  final String fullName;
  final String email;
  final String password;
  final String phoneNumber;
  final String profession;

  const TechnicianSignUpSubmitted({
    required this.fullName,
    required this.email,
    required this.password,
    required this.phoneNumber,
    required this.profession,
  });

  @override
  List<Object?> get props => [fullName, email, password, phoneNumber, profession];
}
