abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;

  LoginSuccess(this.token);
}
class ResetPasswordInitial extends LoginState {}

class ResetPasswordLoading extends LoginState {}

class ResetPasswordSuccess extends LoginState {}

class ResetPasswordFailure extends LoginState {
  final String error;

  ResetPasswordFailure({required this.error});
}
class LoginFailure extends LoginState {
  final String message;

  LoginFailure(this.message);
}
class LogoutSuccess extends LoginState {}
class LogoutFailure extends LoginState {
  final String error;
  LogoutFailure(this.error);
}