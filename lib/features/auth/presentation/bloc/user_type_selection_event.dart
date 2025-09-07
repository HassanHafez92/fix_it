import 'package:equatable/equatable.dart';

abstract class UserTypeSelectionEvent extends Equatable {
  const UserTypeSelectionEvent();

  @override
  List<Object> get props => [];
}

class UserTypeSelected extends UserTypeSelectionEvent {
  final String userType;

  const UserTypeSelected(this.userType);

  @override
  List<Object> get props => [userType];
}

class UserTypeSelectionReset extends UserTypeSelectionEvent {}