abstract class RegisterEvent {}

class FirstNameChanged extends RegisterEvent {
  final String firstName;
  FirstNameChanged(this.firstName);
}

class LastNameChanged extends RegisterEvent {
  final String lastName;
  LastNameChanged(this.lastName);
}

class EmailChanged extends RegisterEvent {
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends RegisterEvent {
  final String password;
  PasswordChanged(this.password);
}

class ConfirmPasswordChanged extends RegisterEvent {
  final String confirmPassword;
  ConfirmPasswordChanged(this.confirmPassword);
}

class TogglePasswordVisibility extends RegisterEvent {}

class ToggleConfirmPasswordVisibility extends RegisterEvent {}

class RoleChanged extends RegisterEvent {
  final String role;
  RoleChanged(this.role);
}

class FormSubmitted extends RegisterEvent {}