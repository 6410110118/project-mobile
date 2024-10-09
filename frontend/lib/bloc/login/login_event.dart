abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String username;
  final String password;

  LoginButtonPressed({required this.username, required this.password});
}

class ResetPasswordButtonPressed extends LoginEvent {
  final String email;
  final String newpassword;

  ResetPasswordButtonPressed({required this.email , required this.newpassword});  
}
class LogoutRequested extends LoginEvent {}