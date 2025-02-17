import 'package:skillscaper_app/models/user.dart';

sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLogout extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}

class AuthFailed extends AuthState {
  final String errorMessage;

  AuthFailed(this.errorMessage);
}
