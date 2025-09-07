import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_user_profile_usecase.dart';
import '../../../../core/services/file_upload_service.dart';
import '../../../../core/di/injection_container.dart';
import 'user_profile_event.dart';
import 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetUserProfileUseCase getUserProfile;
  final UpdateUserProfileUseCase updateUserProfile;

  UserProfileBloc({
    required this.getUserProfile,
    required this.updateUserProfile,
  }) : super(UserProfileInitial()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UploadProfilePicture>(_onUploadProfilePicture);
    on<DeleteProfilePicture>(_onDeleteProfilePicture);
  }

  void _onLoadUserProfile(
    LoadUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());

    try {
      // For now, we'll use a hardcoded user ID
      // In a real app, this would come from the authenticated user
      const userId = 'current_user_id';

      final result = await getUserProfile(userId);

      result.fold(
        (failure) => emit(UserProfileError('فشل في تحميل البيانات الشخصية')),
        (profile) => emit(UserProfileLoaded(profile)),
      );
    } catch (e) {
      emit(UserProfileError('حدث خطأ غير متوقع: ${e.toString()}'));
    }
  }

  void _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<UserProfileState> emit,
  ) async {
    if (state is UserProfileLoaded) {
      emit(UserProfileUpdating(event.profile));

      try {
        final result = await updateUserProfile(event.profile);

        result.fold(
          (failure) => emit(UserProfileError('فشل في تحديث البيانات الشخصية')),
          (updatedProfile) => emit(UserProfileUpdated(updatedProfile)),
        );
      } catch (e) {
        emit(UserProfileError('حدث خطأ غير متوقع: ${e.toString()}'));
      }
    }
  }

  void _onUploadProfilePicture(
    UploadProfilePicture event,
    Emitter<UserProfileState> emit,
  ) async {
    if (state is UserProfileLoaded) {
      final currentProfile = (state as UserProfileLoaded).profile;
      emit(ProfilePictureUploading(currentProfile));

      try {
        // Use the FileUploadService to pick and upload an image, then update profile
        final fileUpload = sl<FileUploadService>();

        // Choose source based on the event payload: 'camera' -> camera, otherwise gallery
        final source = event.imagePath;

        // For gallery, request storage permission first
        if (source != 'camera') {
          final granted = await fileUpload.requestStoragePermission();
          if (!granted) {
            emit(UserProfileError('الصلاحية للوصول إلى المعرض مرفوضة'));
            return;
          }
        }

        final picked = source == 'camera'
            ? await fileUpload.pickImageFromCamera()
            : await fileUpload.pickImageFromGallery();

        if (picked == null) {
          // If picking failed after permission was granted, treat as cancellation
          // For camera, permission denial also causes null — show specific message
          if (source == 'camera') {
            emit(UserProfileError('تعذر الوصول إلى الكاميرا أو تم الإلغاء'));
            return;
          }
          // Gallery pick cancelled
          emit(UserProfileLoaded(currentProfile));
          return;
        }

        final uploadedUrl = await fileUpload.uploadFile(picked);
        if (uploadedUrl == null) {
          emit(UserProfileError('فشل في رفع الصورة الشخصية'));
          return;
        }

        // Update profile with new picture URL via usecase
        final updatedModel =
            currentProfile.copyWith(profilePictureUrl: uploadedUrl);
        final result = await updateUserProfile(updatedModel);

        result.fold(
          (failure) =>
              emit(UserProfileError('فشل في تحديث الملف الشخصي بعد الرفع')),
          (updatedProfile) => emit(UserProfileLoaded(updatedProfile)),
        );
      } catch (e) {
        emit(UserProfileError('فشل في رفع الصورة الشخصية'));
      }
    }
  }

  void _onDeleteProfilePicture(
    DeleteProfilePicture event,
    Emitter<UserProfileState> emit,
  ) async {
    if (state is UserProfileLoaded) {
      final currentProfile = (state as UserProfileLoaded).profile;

      try {
        final updatedProfile = currentProfile.copyWith(
          profilePictureUrl: null,
        );

        emit(UserProfileLoaded(updatedProfile));
      } catch (e) {
        emit(UserProfileError('فشل في حذف الصورة الشخصية'));
      }
    }
  }
}
