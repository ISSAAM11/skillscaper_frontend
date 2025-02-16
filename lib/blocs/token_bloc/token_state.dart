sealed class TokenState {}

class TokenRetrieved extends TokenState {
  final String token;
  final String userName;

  TokenRetrieved(this.token, this.userName);
}

class TokenExpired extends TokenState {}

class TokenNotFound extends TokenState {}

class TokenInitial extends TokenState {}
