abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({required this.username, required this.password});
}

class ChangePasswordEvent extends LoginEvent {
  final String currentPassword;
  final String newPassword;

  ChangePasswordEvent({
    required this.currentPassword,
    required this.newPassword,
  });
}
class LogoutRequested extends LoginEvent {}