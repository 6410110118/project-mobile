abstract class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final String email;
  final String username;
  final String firstName;
  final String lastName;
  final String password;
  final String confirmPassword;
  final String role;

  RegisterButtonPressed({
    required this.email,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.password,
    required this.confirmPassword,
    required this.role,
  });
}