import 'package:equatable/equatable.dart';
import '../../domain/entities/user_profile_entity.dart';

abstract class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadUserProfile extends UserProfileEvent {
  const LoadUserProfile();
}

class UpdateUserProfile extends UserProfileEvent {
  final UserProfileEntity profile;

  const UpdateUserProfile(this.profile);

  @override
  List<Object> get props => [profile];
}

class UploadProfilePicture extends UserProfileEvent {
  final String imagePath;

  const UploadProfilePicture(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class DeleteProfilePicture extends UserProfileEvent {
  const DeleteProfilePicture();
}