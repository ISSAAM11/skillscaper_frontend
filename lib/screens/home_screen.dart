import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillscaper_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:skillscaper_app/blocs/auth_bloc/auth_event.dart';
import 'package:skillscaper_app/blocs/auth_bloc/auth_state.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_event.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_state.dart';
import 'package:skillscaper_app/items/header.dart';
import 'package:skillscaper_app/items/home_items/home_main_element.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final tokenBloc = BlocProvider.of<TokenBloc>(context);
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
      if (authState is AuthLogout) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => GoRouter.of(context).go('/login'),
        );
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      return BlocBuilder<TokenBloc, TokenState>(builder: (context, tokenState) {
        if (tokenState is TokenExpired) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (tokenState is TokenInitial) {
          tokenBloc.add(TokenFetch());
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (tokenState is TokenNotFound) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) => authBloc.add(LogoutRequest()),
          );
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          body: SizedBox(
            height: double.infinity,
            child: Column(children: [HeaderItem(), HomeMainElement()]),
          ),
        );
      });
    });
  }
}
