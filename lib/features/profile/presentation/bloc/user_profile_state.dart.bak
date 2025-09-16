import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile_entity.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object> get props => [];
}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoading extends UserProfileState {}

class UserProfileLoaded extends UserProfileState {
  final UserProfileEntity profile;

  const UserProfileLoaded(this.profile);

  @override
  List<Object> get props => [profile];
}

class UserProfileUpdating extends UserProfileState {
  final UserProfileEntity profile;

  const UserProfileUpdating(this.profile);

  @override
  List<Object> get props => [profile];
}

class UserProfileUpdated extends UserProfileState {
  final UserProfileEntity profile;

  const UserProfileUpdated(this.profile);

  @override
  List<Object> get props => [profile];
}

class UserProfileError extends UserProfileState {
  final String message;

  const UserProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class ProfilePictureUploading extends UserProfileState {
  final UserProfileEntity profile;

  const ProfilePictureUploading(this.profile);

  @override
  List<Object> get props => [profile];
}