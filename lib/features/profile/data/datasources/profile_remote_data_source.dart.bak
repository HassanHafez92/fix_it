import '../../domain/entities/user_profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileEntity> fetchUserProfile(String userId);
  Future<UserProfileEntity> updateUserProfile(UserProfileEntity profile);
  Future<String> uploadProfilePicture(String filePath);
  Future<void> deleteProfilePicture();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl();

  @override
  Future<UserProfileEntity> fetchUserProfile(String userId) async {
    return UserProfileEntity(
      id: userId,
      fullName: 'John Doe',
      email: 'john.doe@example.com',
      phoneNumber: '+1 (555) 123-4567',
      profilePictureUrl: '',
      bio: 'Professional service provider.',
      createdAt: DateTime(2020, 1, 1),
      updatedAt: DateTime.now(),
    );
  }

  @override
  Future<UserProfileEntity> updateUserProfile(UserProfileEntity profile) async {
    return profile.copyWith(updatedAt: DateTime.now());
  }

  @override
  Future<String> uploadProfilePicture(String filePath) async {
    return 'https://example.com/profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg';
  }

  @override
  Future<void> deleteProfilePicture() async {
    return;
  }
}
