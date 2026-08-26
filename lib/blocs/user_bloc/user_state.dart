part of 'user_bloc.dart';

enum GetUserProfileStatus { init, loading, failure, success }

enum UpdateProfilePhotoStatus { init, loading, failure, success }

enum UpdateUserStatus { init, loading, failure, success }

class UserState {
  final GetUserProfileStatus getUserProfileStatus;
  final UpdateProfilePhotoStatus updateProfilePhotoStatus;
  final UpdateUserStatus updateUserStatus;

  final String errorMessage;

  final UserProfileModel? userProfile;

  UserState({
    this.getUserProfileStatus = GetUserProfileStatus.init,
    this.updateProfilePhotoStatus = UpdateProfilePhotoStatus.init,
    this.updateUserStatus = UpdateUserStatus.init,
    this.errorMessage = '',
    this.userProfile,
  });

  UserState copyWith({
    GetUserProfileStatus? getUserProfileStatus,
    UpdateProfilePhotoStatus? updateProfilePhotoStatus,
    UpdateUserStatus? updateUserStatus,
    String? errorMessage,
    UserProfileModel? userProfile,
  }) {
    return UserState(
      getUserProfileStatus: getUserProfileStatus ?? this.getUserProfileStatus,
      updateProfilePhotoStatus:
          updateProfilePhotoStatus ?? this.updateProfilePhotoStatus,
      updateUserStatus: updateUserStatus ?? this.updateUserStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      userProfile: userProfile ?? this.userProfile,
    );
  }
}
