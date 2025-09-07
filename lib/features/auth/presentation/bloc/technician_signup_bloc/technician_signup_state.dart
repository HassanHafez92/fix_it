part of 'technician_signup_bloc.dart';

abstract class TechnicianSignUpState extends Equatable {
  const TechnicianSignUpState();

  @override
  List<Object> get props => [];
}

class TechnicianSignUpInitial extends TechnicianSignUpState {}

class TechnicianSignUpLoading extends TechnicianSignUpState {}

class TechnicianSignUpSuccess extends TechnicianSignUpState {}

class TechnicianSignUpFailure extends TechnicianSignUpState {
  final String message;

  const TechnicianSignUpFailure(this.message);

  @override
  List<Object> get props => [message];
}
