part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

/// GET User/GetUserProfile
class GetUserProfileEvent extends UserEvent {}

/// PUT User/UpdateProfilePhoto (multipart/form-data, field: image)
class UpdateProfilePhotoEvent extends UserEvent {
  final File image;

  UpdateProfilePhotoEvent({required this.image});
}
