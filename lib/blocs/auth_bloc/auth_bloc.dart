import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:easy_localization/easy_localization.dart';

import '../../core/localization/translation_keys.dart';
import '../../core/utils/api_error_helper.dart';
import '../../core/utils/api_service.dart';
import '../../core/utils/jwt_helper.dart';
import '../../core/utils/my_shared_pref.dart';
import '../../models/auth/login_response_model.dart';
import '../../models/common/api_response_model.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState()) {
    on<RegisterEvent>(_onRegisterEvent);
    on<LoginEvent>(_onLoginEvent);
    on<ConfirmEmailEvent>(_onConfirmEmailEvent);
    on<ResendOtpCodeEvent>(_onResendOtpCodeEvent);
    on<RefreshTokenEvent>(_onRefreshTokenEvent);
    on<LogoutEvent>(_onLogoutEvent);
    on<ForgotPasswordEvent>(_onForgotPasswordEvent);
    on<ResetPasswordEvent>(_onResetPasswordEvent);
    on<LoadStoredAuthEvent>(_onLoadStoredAuthEvent);
    on<ClearAuthEvent>((event, emit) => emit(AuthState()));
  }

  FutureOr<void> _onRegisterEvent(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(registerStatus: RegisterStatus.loading));
    await ApiService.postMethod(
          endPoint: 'Auth/Register',
          body: {
            "firstName": event.firstName,
            "lastName": event.lastName,
            "userName": event.userName,
            "email": event.email,
            "phoneNumber": event.phoneNumber,
            "gender": event.gender,
            "birthDate": event.birthDate.toUtc().toIso8601String(),
            "password": event.password,
          },
        )
        .then((response) {
          log(response.data.toString());
          emit(state.copyWith(registerStatus: RegisterStatus.success));
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              registerStatus: RegisterStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              registerStatus: RegisterStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onLoginEvent(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(loginStatus: LoginStatus.loading));
    await ApiService.postMethod(
          endPoint: 'Auth/Login',
          body: {"email": event.email, "password": event.password},
        )
        .then((response) async {
          log(response.data.toString());
          final apiResponse = ApiResponseModel<LoginResponseModel>.fromJson(
            response.data,
            (json) => LoginResponseModel.fromJson(json),
          );
          final loginResponse = apiResponse.data!;

          await ApiService.setAuthToken(loginResponse.accessToken);
          await MySharedPref.saveRefreshToken(loginResponse.refreshTokenString);
          await MySharedPref.saveRoles(loginResponse.roles);
          await MySharedPref.saveEmail(event.email);
          final userId = JwtHelper.getUserId(loginResponse.accessToken);
          if (userId != null) {
            await MySharedPref.saveUserId(userId);
          }

          emit(
            state.copyWith(
              loginStatus: LoginStatus.success,
              loginResponse: loginResponse,
              isLoggedIn: true,
              roles: loginResponse.roles,
            ),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              loginStatus: LoginStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              loginStatus: LoginStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onConfirmEmailEvent(
    ConfirmEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(confirmEmailStatus: ConfirmEmailStatus.loading));
    await ApiService.postMethod(
          endPoint: 'Auth/ConfirmEmail',
          body: {"email": event.email, "code": event.code},
        )
        .then((response) {
          log(response.data.toString());
          emit(state.copyWith(confirmEmailStatus: ConfirmEmailStatus.success));
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              confirmEmailStatus: ConfirmEmailStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              confirmEmailStatus: ConfirmEmailStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onResendOtpCodeEvent(
    ResendOtpCodeEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(resendOtpStatus: ResendOtpStatus.loading));
    await ApiService.postMethod(
          endPoint: 'Auth/ResendOtpCode',
          body: {"email": event.email},
        )
        .then((response) {
          log(response.data.toString());
          emit(state.copyWith(resendOtpStatus: ResendOtpStatus.success));
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              resendOtpStatus: ResendOtpStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              resendOtpStatus: ResendOtpStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onRefreshTokenEvent(
    RefreshTokenEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(refreshTokenStatus: RefreshTokenStatus.loading));
    final refreshToken = MySharedPref.getRefreshToken();
    await ApiService.postMethod(
          endPoint: 'Auth/RefreshToken',
          body: {"accessToken": ApiService.token, "refreshToken": refreshToken},
        )
        .then((response) async {
          log(response.data.toString());
          final data = response.data['data'] as Map<String, dynamic>;
          await ApiService.setAuthToken(data['accessToken'].toString());
          await MySharedPref.saveRefreshToken(data['refreshToken'].toString());
          emit(state.copyWith(refreshTokenStatus: RefreshTokenStatus.success));
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              refreshTokenStatus: RefreshTokenStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              refreshTokenStatus: RefreshTokenStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onLogoutEvent(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(logoutStatus: LogoutStatus.loading));
    final refreshToken = MySharedPref.getRefreshToken();
    await ApiService.postMethod(
          endPoint: 'Auth/logout',
          body: {"refreshToken": refreshToken},
        )
        .then((response) async {
          log(response.data.toString());
          await ApiService.clearAuth();
          await MySharedPref.clearAuthData();
          emit(
            state.copyWith(
              logoutStatus: LogoutStatus.success,
              isLoggedIn: false,
              roles: [],
            ),
          );
        })
        .catchError((error) async {
          log(error.toString());
          // Clear local session regardless - an expired/invalid token on the
          // server side still means the user is effectively logged out locally.
          await ApiService.clearAuth();
          await MySharedPref.clearAuthData();
          emit(
            state.copyWith(
              logoutStatus: LogoutStatus.success,
              isLoggedIn: false,
              roles: [],
            ),
          );
        })
        .onError((error, stackTrace) async {
          log(error.toString());
          await ApiService.clearAuth();
          await MySharedPref.clearAuthData();
          emit(
            state.copyWith(
              logoutStatus: LogoutStatus.success,
              isLoggedIn: false,
              roles: [],
            ),
          );
        });
  }

  FutureOr<void> _onForgotPasswordEvent(
    ForgotPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.loading));
    await ApiService.postMethod(
          endPoint: 'Auth/ForgotPassword',
          body: {"email": event.email},
        )
        .then((response) {
          log(response.data.toString());
          emit(
            state.copyWith(forgotPasswordStatus: ForgotPasswordStatus.success),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              forgotPasswordStatus: ForgotPasswordStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              forgotPasswordStatus: ForgotPasswordStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onResetPasswordEvent(
    ResetPasswordEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(state.copyWith(resetPasswordStatus: ResetPasswordStatus.loading));
    await ApiService.postMethod(
          endPoint: 'Auth/ResetPassword',
          body: {
            "email": event.email,
            "code": event.code,
            "newPassword": event.newPassword,
          },
        )
        .then((response) {
          log(response.data.toString());
          emit(
            state.copyWith(resetPasswordStatus: ResetPasswordStatus.success),
          );
        })
        .catchError((error) {
          log(error.toString());
          emit(
            state.copyWith(
              resetPasswordStatus: ResetPasswordStatus.failure,
              errorMessage: apiErrorMessage(error),
            ),
          );
        })
        .onError((error, stackTrace) {
          log(error.toString());
          emit(
            state.copyWith(
              resetPasswordStatus: ResetPasswordStatus.failure,
              errorMessage: LK.commonErrorGeneric.tr(),
            ),
          );
        });
  }

  FutureOr<void> _onLoadStoredAuthEvent(
    LoadStoredAuthEvent event,
    Emitter<AuthState> emit,
  ) {
    final token = MySharedPref.getToken();
    final roles = MySharedPref.getRoles();
    emit(state.copyWith(isLoggedIn: token != null, roles: roles));
  }
}
