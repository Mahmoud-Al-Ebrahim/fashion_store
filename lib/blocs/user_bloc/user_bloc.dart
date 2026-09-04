import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:mime_type/mime_type.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../core/localization/translation_keys.dart';
import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../models/common/api_response_model.dart';
import '../../models/user/user_profile_model.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState()) {
    on<GetUserProfileEvent>(_onGetUserProfileEvent);
    on<UpdateProfilePhotoEvent>(_onUpdateProfilePhotoEvent);
    on<UpdateUserEvent>(_onUpdateUserEvent);
    on<ClearUserEvent>((event, emit) => emit(UserState()));
  }

  FutureOr<void> _onGetUserProfileEvent(
    GetUserProfileEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(getUserProfileStatus: GetUserProfileStatus.loading));
    await ApiService.getMethod(endPoint: 'User/GetUserProfile')
        .then((response) {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<UserProfileModel>.fromJson(
            response.data,
            (json) => UserProfileModel.fromJson(json),
          );
          emit(
            state.copyWith(
              getUserProfileStatus: GetUserProfileStatus.success,
              userProfile: apiResponse.data,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              getUserProfileStatus: GetUserProfileStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              getUserProfileStatus: GetUserProfileStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onUpdateProfilePhotoEvent(
    UpdateProfilePhotoEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(
      state.copyWith(
        updateProfilePhotoStatus: UpdateProfilePhotoStatus.loading,
      ),
    );
    final fileName = event.image.path.split('/').last;
    final mimeType = mime(fileName) ?? '';
    final mimeParts = mimeType.split('/');
    await ApiService.putMethod(
          endPoint: 'User/UpdateProfilePhoto',
          form: FormData.fromMap({
            "image": await MultipartFile.fromFile(
              event.image.path,
              filename: fileName,
              contentType: mimeParts.length == 2
                  ? MediaType(mimeParts[0], mimeParts[1])
                  : null,
            ),
          }),
        )
        .then((response) {
          log(response.data.toString());
          add(GetUserProfileEvent());
          emit(
            state.copyWith(
              updateProfilePhotoStatus: UpdateProfilePhotoStatus.success,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              updateProfilePhotoStatus: UpdateProfilePhotoStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              updateProfilePhotoStatus: UpdateProfilePhotoStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onUpdateUserEvent(
    UpdateUserEvent event,
    Emitter<UserState> emit,
  ) async {
    emit(
      state.copyWith(
        updateUserStatus: UpdateUserStatus.loading,
        errorMessage: '',
      ),
    );
    // Send only what the caller actually changed: the API reads a missing
    // key as "leave this field alone".
    final Map<String, dynamic> body = {};
    if (event.firstName != null) body['firstName'] = event.firstName;
    if (event.lastName != null) body['lastName'] = event.lastName;
    if (event.birthDate != null) {
      body['birthDate'] = event.birthDate!.toIso8601String();
    }
    if (event.gender != null) body['gender'] = event.gender;
    if (event.phoneNumber != null) body['phoneNumber'] = event.phoneNumber;

    await ApiService.putMethod(endPoint: 'User/UpdateUser', body: body)
        .then((response) {
          log(response.data.toString());
          emit(state.copyWith(updateUserStatus: UpdateUserStatus.success));
          // Re-read so the screen shows what the server actually stored.
          add(GetUserProfileEvent());
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              updateUserStatus: UpdateUserStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              updateUserStatus: UpdateUserStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }
}
