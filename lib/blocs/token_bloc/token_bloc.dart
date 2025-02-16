import 'package:flutter_bloc/flutter_bloc.dart';
import './token_event.dart';
import './token_state.dart';
import '../../services/token_service.dart';

class TokenBloc extends Bloc<TokenEvent, TokenState> {
  TokenService authService = TokenService();

  TokenBloc() : super(TokenInitial()) {
    on<TokenFetch>(
      (event, emit) async {
        final (token, userName) = await authService.retrieveToken();
        if (token != null && userName != null) {
          emit(TokenRetrieved(token, userName));
        } else {
          emit(TokenNotFound());
        }
      },
    );

    on<TokenRefresh>(
      (event, emit) async {
        emit(TokenExpired());
        try {
          final (token, userName) = await authService.refreshToken();
          emit(TokenRetrieved(token, userName));
        } catch (_) {
          emit(TokenNotFound());
        }
      },
    );

    on<TokenDelete>(
      (event, emit) {
        emit(TokenInitial());
      },
    );
  }
}
