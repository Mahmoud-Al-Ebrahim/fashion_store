part of 'auth_bloc.dart';

enum RegisterStatus { init, loading, failure, success }

enum LoginStatus { init, loading, failure, success }

enum ConfirmEmailStatus { init, loading, failure, success }

enum ResendOtpStatus { init, loading, failure, success }

enum RefreshTokenStatus { init, loading, failure, success }

enum LogoutStatus { init, loading, failure, success }

enum ForgotPasswordStatus { init, loading, failure, success }

enum ResetPasswordStatus { init, loading, failure, success }

class AuthState {
  final RegisterStatus registerStatus;
  final LoginStatus loginStatus;
  final ConfirmEmailStatus confirmEmailStatus;
  final ResendOtpStatus resendOtpStatus;
  final RefreshTokenStatus refreshTokenStatus;
  final LogoutStatus logoutStatus;
  final ForgotPasswordStatus forgotPasswordStatus;
  final ResetPasswordStatus resetPasswordStatus;

  final String errorMessage;

  /// Whether a valid access token is currently stored (populated after a
  /// successful login, a successful [LoadStoredAuthEvent], or cleared on logout).
  final bool isLoggedIn;
  final List<String> roles;
  final LoginResponseModel? loginResponse;

  AuthState({
    this.registerStatus = RegisterStatus.init,
    this.loginStatus = LoginStatus.init,
    this.confirmEmailStatus = ConfirmEmailStatus.init,
    this.resendOtpStatus = ResendOtpStatus.init,
    this.refreshTokenStatus = RefreshTokenStatus.init,
    this.logoutStatus = LogoutStatus.init,
    this.forgotPasswordStatus = ForgotPasswordStatus.init,
    this.resetPasswordStatus = ResetPasswordStatus.init,
    this.errorMessage = '',
    this.isLoggedIn = false,
    this.roles = const [],
    this.loginResponse,
  });

  bool get isStoreAdmin => roles.contains('Admin');

  bool get isSuperAdmin => roles.contains('SuperAdmin');

  AuthState copyWith({
    RegisterStatus? registerStatus,
    LoginStatus? loginStatus,
    ConfirmEmailStatus? confirmEmailStatus,
    ResendOtpStatus? resendOtpStatus,
    RefreshTokenStatus? refreshTokenStatus,
    LogoutStatus? logoutStatus,
    ForgotPasswordStatus? forgotPasswordStatus,
    ResetPasswordStatus? resetPasswordStatus,
    String? errorMessage,
    bool? isLoggedIn,
    List<String>? roles,
    LoginResponseModel? loginResponse,
  }) {
    return AuthState(
      registerStatus: registerStatus ?? this.registerStatus,
      loginStatus: loginStatus ?? this.loginStatus,
      confirmEmailStatus: confirmEmailStatus ?? this.confirmEmailStatus,
      resendOtpStatus: resendOtpStatus ?? this.resendOtpStatus,
      refreshTokenStatus: refreshTokenStatus ?? this.refreshTokenStatus,
      logoutStatus: logoutStatus ?? this.logoutStatus,
      forgotPasswordStatus: forgotPasswordStatus ?? this.forgotPasswordStatus,
      resetPasswordStatus: resetPasswordStatus ?? this.resetPasswordStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      roles: roles ?? this.roles,
      loginResponse: loginResponse ?? this.loginResponse,
    );
  }
}
