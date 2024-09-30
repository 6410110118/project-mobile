abstract class ChangePasswordEvent {}

class OldPasswordChanged extends ChangePasswordEvent {
  final String oldPassword;
  OldPasswordChanged(this.oldPassword);
}

class NewPasswordChanged extends ChangePasswordEvent {
  final String newPassword;
  NewPasswordChanged(this.newPassword);
}

class ConfirmPasswordChange extends ChangePasswordEvent {
  final String confirmPassword;
  ConfirmPasswordChange(this.confirmPassword);
}

class ToggleOldPasswordVisibility extends ChangePasswordEvent {}

class ToggleNewPasswordVisibility extends ChangePasswordEvent {}

class ToggleConfirmPasswordChangeVisibility extends ChangePasswordEvent {}

class ChangePasswordSubmitted extends ChangePasswordEvent {}
