import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillscaper_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:skillscaper_app/blocs/auth_bloc/auth_state.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_event.dart';
import 'package:skillscaper_app/items/login_items/login_main_element.dart';
import 'package:skillscaper_app/utils/notification_utils.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    final tokenBloc = BlocProvider.of<TokenBloc>(context);

    return BlocConsumer(
      bloc: authBloc,
      listener: (context, authState) {
        if (authState is AuthFailed) {
          errorNotification(context, authState.errorMessage);
        }
      },
      builder: (context, state) {
        if (authBloc.state is AuthSuccess) {
          tokenBloc.add(TokenFetch());
          WidgetsBinding.instance.addPostFrameCallback((_) {
            GoRouter.of(context).go('/home');
          });
        }
        return Scaffold(
          appBar: AppBar(title: Text('Login page')),
          body: SizedBox(height: double.infinity, child: LoginMainElement()),
        );
      },
    );
  }
}
