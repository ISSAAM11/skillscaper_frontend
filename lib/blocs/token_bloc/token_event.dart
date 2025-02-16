sealed class TokenEvent {}

class TokenFetch extends TokenEvent {}

class TokenRefresh extends TokenEvent {
  TokenRefresh();
}

class TokenDelete extends TokenEvent {}
