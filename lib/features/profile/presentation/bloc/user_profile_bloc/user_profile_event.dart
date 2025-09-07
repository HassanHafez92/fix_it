part of 'user_profile_bloc.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfileEvent extends UserProfileEvent {
  const LoadUserProfileEvent();
}

class UpdateUserProfileEvent extends UserProfileEvent {
  final String? fullName;
  final String? email;
  final String? phoneNumber;
  final String? bio;
  final String? address;

  const UpdateUserProfileEvent({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.bio,
    this.address,
  });

  @override
  List<Object> get props => [fullName ?? '', email ?? '', phoneNumber ?? '', bio ?? '', address ?? ''];
}

class UpdateProfilePictureEvent extends UserProfileEvent {
  final String profilePictureUrl;

  const UpdateProfilePictureEvent({
    required this.profilePictureUrl,
  });

  @override
  List<Object> get props => [profilePictureUrl];
}
