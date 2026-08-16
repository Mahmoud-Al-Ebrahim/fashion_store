part of 'user_bloc.dart';

enum GetUserProfileStatus { init, loading, failure, success }

enum UpdateProfilePhotoStatus { init, loading, failure, success }

class UserState {
  final GetUserProfileStatus getUserProfileStatus;
  final UpdateProfilePhotoStatus updateProfilePhotoStatus;

  final String errorMessage;

  final UserProfileModel? userProfile;

  UserState({
    this.getUserProfileStatus = GetUserProfileStatus.init,
    this.updateProfilePhotoStatus = UpdateProfilePhotoStatus.init,
    this.errorMessage = '',
    this.userProfile,
  });

  UserState copyWith({
    GetUserProfileStatus? getUserProfileStatus,
    UpdateProfilePhotoStatus? updateProfilePhotoStatus,
    String? errorMessage,
    UserProfileModel? userProfile,
  }) {
    return UserState(
      getUserProfileStatus: getUserProfileStatus ?? this.getUserProfileStatus,
      updateProfilePhotoStatus:
          updateProfilePhotoStatus ?? this.updateProfilePhotoStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      userProfile: userProfile ?? this.userProfile,
    );
  }
}
