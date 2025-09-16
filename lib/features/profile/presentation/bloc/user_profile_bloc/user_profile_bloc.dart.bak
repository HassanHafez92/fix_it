// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fix_it/core/usecases/usecase.dart';
import 'package:fix_it/features/profile/domain/entities/user_profile_entity.dart';
import 'package:fix_it/features/profile/domain/usecases/get_user_profile_usecase.dart';
import 'package:fix_it/features/profile/domain/usecases/update_user_profile_usecase.dart';
import 'package:fix_it/features/profile/domain/usecases/change_password_usecase.dart';
import 'package:fix_it/features/auth/domain/usecases/get_current_user_usecase.dart';

part 'user_profile_event.dart';
part 'user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final GetCurrentUserUseCase getCurrentUser;
  final GetUserProfileUseCase getUserProfile;
  final UpdateUserProfileUseCase updateUserProfile;
  final ChangePasswordUseCase changePassword;

  UserProfileBloc({
    required this.getCurrentUser,
    required this.getUserProfile,
    required this.updateUserProfile,
    required this.changePassword,
  }) : super(UserProfileInitial()) {
    on<LoadUserProfileEvent>(_onLoadUserProfile);
    on<UpdateUserProfileEvent>(_onUpdateUserProfile);
    on<UpdateProfilePictureEvent>(_onUpdateProfilePicture);
  }

  Future<void> _onLoadUserProfile(
    LoadUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(UserProfileLoading());
    try {
      // Get current authenticated user
      final currentUserResult = await getCurrentUser.call(const NoParamsImpl());

      // Extract user entity synchronously from the Either
      var userEntity;
      currentUserResult.fold((failure) {
        emit(UserProfileError(message: failure.message));
      }, (u) {
        userEntity = u;
      });

      if (userEntity == null) {
        // Either there was a failure or no authenticated user
        // If a failure was emitted above, just return.
        if (state is! UserProfileLoaded) return;
        emit(UserProfileError(message: 'No authenticated user'));
        return;
      }

      // Fetch profile for the authenticated user
      final result = await getUserProfile.call(userEntity.id);

      var profile;
      result.fold((failure) {
        emit(UserProfileError(message: failure.message));
      }, (p) {
        profile = p;
      });

      if (profile == null) return;

      final userProfile = {
        'id': profile.id,
        'fullName': profile.fullName,
        'email': profile.email,
        'phoneNumber': profile.phoneNumber ?? '',
        'profilePictureUrl': profile.profilePictureUrl ?? '',
        'bio': profile.bio ?? '',
        'paymentMethods': profile.paymentMethods,
        'createdAt': profile.createdAt,
        'updatedAt': profile.updatedAt,
      };

      emit(UserProfileLoaded(userProfile: userProfile));
    } catch (e) {
      emit(UserProfileError(message: e.toString()));
    }
  }

  void _onUpdateUserProfile(
    UpdateUserProfileEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    if (state is UserProfileLoaded) {
      final currentState = state as UserProfileLoaded;

      emit(UserProfileUpdating());
      try {
        // Build a UserProfileEntity from current state and overrides
        final existing = currentState.userProfile;
        final entity = UserProfileEntity(
          id: existing['id'] as String,
          fullName: event.fullName ?? existing['fullName'] as String,
          email: event.email ?? existing['email'] as String,
          phoneNumber:
              event.phoneNumber ?? (existing['phoneNumber'] as String?),
          profilePictureUrl: existing['profilePictureUrl'] as String?,
          bio: event.bio ?? existing['bio'] as String?,
          paymentMethods: List<String>.from(existing['paymentMethods'] ?? []),
          createdAt: existing['createdAt'] as DateTime,
          updatedAt: DateTime.now(),
        );

        final result = await updateUserProfile.call(entity);

        result.fold((failure) {
          emit(UserProfileError(message: failure.message));
          emit(currentState);
        }, (updated) {
          add(LoadUserProfileEvent());
          emit(UserProfileUpdated());
        });
      } catch (e) {
        emit(UserProfileError(message: e.toString()));
        emit(currentState);
      }
    }
  }

  void _onUpdateProfilePicture(
    UpdateProfilePictureEvent event,
    Emitter<UserProfileState> emit,
  ) async {
    if (state is UserProfileLoaded) {
      final currentState = state as UserProfileLoaded;

      emit(UserProfileUpdating());
      try {
        final existing = currentState.userProfile;
        final entity = UserProfileEntity(
          id: existing['id'] as String,
          fullName: existing['fullName'] as String,
          email: existing['email'] as String,
          phoneNumber: existing['phoneNumber'] as String?,
          profilePictureUrl: event.profilePictureUrl,
          bio: existing['bio'] as String?,
          paymentMethods: List<String>.from(existing['paymentMethods'] ?? []),
          createdAt: existing['createdAt'] as DateTime,
          updatedAt: DateTime.now(),
        );

        final result = await updateUserProfile.call(entity);

        result.fold((failure) {
          emit(UserProfileError(message: failure.message));
          emit(currentState);
        }, (updated) {
          add(LoadUserProfileEvent());
          emit(UserProfileUpdated());
        });
      } catch (e) {
        emit(UserProfileError(message: e.toString()));
        emit(currentState);
      }
    }
  }
}
