import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillscaper_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:skillscaper_app/blocs/auth_bloc/auth_event.dart';
import 'package:skillscaper_app/blocs/auth_bloc/auth_state.dart';
import 'package:skillscaper_app/screens/home_screen.dart';
import 'package:skillscaper_app/screens/exam_screen.dart';
import 'package:skillscaper_app/screens/login_screen.dart';
import 'package:skillscaper_app/utils/color_theme.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final authBloc = context.read<AuthBloc>();
        if (authBloc.state is AuthInitial) {
          authBloc.add(AutoAuthenticateRequest());
        }
      });
      _isInitialized = true;
    }
  }

  final GoRouter _router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/Exam/:idRequest/:idExam',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final idtestRequest = state.pathParameters["idExam"]!;
          final idExam = state.pathParameters["idRequest"]!;

          return NoTransitionPage(child: ExamScreen(idtestRequest, idExam));
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SkillScaper test',
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: ColorTheme.secondary,
          onError: ColorTheme.onError,
        ),
      ),
    );
  }
}
