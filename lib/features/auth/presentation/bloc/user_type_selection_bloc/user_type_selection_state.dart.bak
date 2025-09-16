part of 'user_type_selection_bloc.dart';

abstract class UserTypeSelectionState extends Equatable {
  const UserTypeSelectionState();

  @override
  List<Object> get props => [];
}

class UserTypeSelectionInitial extends UserTypeSelectionState {}

class UserTypeSelectionLoading extends UserTypeSelectionState {}

class UserTypeSelectedState extends UserTypeSelectionState {
  final String userType;

  const UserTypeSelectedState({required this.userType});

  @override
  List<Object> get props => [userType];
}
