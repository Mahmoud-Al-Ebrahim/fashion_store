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

/// PUT User/UpdateUser - edits the signed-in account's own details.
///
/// Every role has a personal profile, so this is not gated on any role.
/// Fields are optional: the API treats a null as "leave unchanged".
class UpdateUserEvent extends UserEvent {
  final String? firstName;
  final String? lastName;
  final DateTime? birthDate;
  final String? gender;
  final String? phoneNumber;

  UpdateUserEvent({
    this.firstName,
    this.lastName,
    this.birthDate,
    this.gender,
    this.phoneNumber,
  });
}

/// Wipes this bloc back to its initial state.
///
/// Dispatched for every bloc on sign-out: the blocs live at the app
/// root and outlive any single session, so without this the next
/// account would open onto the previous one's cart, orders, wallet and
/// profile until each screen happened to refetch.
class ClearUserEvent extends UserEvent {}
