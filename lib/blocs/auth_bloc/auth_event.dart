sealed class AuthEvent {}

class AuthenticateRequest extends AuthEvent {
  final String email;
  final String password;

  AuthenticateRequest({required this.email, required this.password});
}

class AutoAuthenticateRequest extends AuthEvent {}

class LogoutRequest extends AuthEvent {}
