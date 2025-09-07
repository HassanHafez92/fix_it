part of 'user_profile_bloc.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final Map<String, dynamic> userProfile;

  const UserProfileLoaded({required this.userProfile});

  @override
  List<Object> get props => [userProfile];
}

class UserProfileUpdating extends UserProfileState {}

class UserProfileUpdated extends UserProfileState {}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError({required this.message});

  @override
  List<Object> get props => [message];
}
