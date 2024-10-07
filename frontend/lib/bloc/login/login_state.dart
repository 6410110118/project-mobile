abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String token;

  LoginSuccess(this.token);
}
class ChangePasswordLoading extends LoginState {}

class ChangePasswordSuccess extends LoginState {}

class ChangePasswordFailure extends LoginState {
  final String error;

  ChangePasswordFailure(this.error);
}
class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}