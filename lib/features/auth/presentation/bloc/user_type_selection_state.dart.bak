import 'package:equatable/equatable.dart';

abstract class UserTypeSelectionState extends Equatable {
  const UserTypeSelectionState();

  @override
  List<Object> get props => [];
}

class UserTypeSelectionInitial extends UserTypeSelectionState {}

class UserTypeSelectionLoading extends UserTypeSelectionState {}

class UserTypeSelectionSelected extends UserTypeSelectionState {
  final String userType;

  const UserTypeSelectionSelected(this.userType);

  @override
  List<Object> get props => [userType];
}

class UserTypeSelectionError extends UserTypeSelectionState {
  final String message;

  const UserTypeSelectionError(this.message);

  @override
  List<Object> get props => [message];
}