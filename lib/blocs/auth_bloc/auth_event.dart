part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

/// POST Auth/Register
class RegisterEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final String phoneNumber;
  final String gender; // enGender: Male | Female
  final DateTime birthDate;
  final String password;

  RegisterEvent({
    required this.firstName,
    required this.lastName,
    required this.userName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    required this.birthDate,
    required this.password,
  });
}

/// POST Auth/Login
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({required this.email, required this.password});
}

/// POST Auth/ConfirmEmail
class ConfirmEmailEvent extends AuthEvent {
  final String email;
  final String code;

  ConfirmEmailEvent({required this.email, required this.code});
}

/// POST Auth/ResendOtpCode
class ResendOtpCodeEvent extends AuthEvent {
  final String email;

  ResendOtpCodeEvent({required this.email});
}

/// POST Auth/RefreshToken (manual trigger - normally handled automatically
/// by the ApiService interceptor on a 401 response).
class RefreshTokenEvent extends AuthEvent {}

/// POST Auth/logout
class LogoutEvent extends AuthEvent {}

/// POST Auth/ForgotPassword
class ForgotPasswordEvent extends AuthEvent {
  final String email;

  ForgotPasswordEvent({required this.email});
}

/// POST Auth/ResetPassword
class ResetPasswordEvent extends AuthEvent {
  final String email;
  final String code;
  final String newPassword;

  ResetPasswordEvent({
    required this.email,
    required this.code,
    required this.newPassword,
  });
}

/// Hydrates the bloc's in-memory auth state (roles / login flag) from
/// what's already persisted in SharedPreferences. Does not call the API.
/// Use on app start to decide whether to show the login screen.
class LoadStoredAuthEvent extends AuthEvent {}

/// Wipes this bloc back to its initial state.
///
/// Dispatched for every bloc on sign-out: the blocs live at the app
/// root and outlive any single session, so without this the next
/// account would open onto the previous one's cart, orders, wallet and
/// profile until each screen happened to refetch.
class ClearAuthEvent extends AuthEvent {}
