import 'package:bloc/bloc.dart';
import './auth_event.dart';
import './auth_state.dart';
import '../../services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthService authService = AuthService();

  AuthBloc() : super(AuthInitial()) {
    on<AuthenticateRequest>((event, emit) async {
      emit(AuthLoading());
      try {
        await authService.loginUser(event.email, event.password);
        emit(AuthSuccess());
      } catch (error) {
        emit(AuthFailed(error.toString()));
      }
    });
    on<LogoutRequest>((event, emit) async {
      await authService.logoutUser();
      emit(AuthLogout());
    });

    on<AutoAuthenticateRequest>((event, emit) async {
      final user = await authService.tryAutoLogin();
      if (user == null) {
        emit(AuthLogout());
      } else {
        emit(AuthSuccess());
      }
    });
  }
}
