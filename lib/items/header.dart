import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillscaper_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:skillscaper_app/blocs/auth_bloc/auth_event.dart';
import 'package:skillscaper_app/utils/color_theme.dart';

class HeaderItem extends StatelessWidget {
  const HeaderItem({super.key});

  @override
  Widget build(BuildContext context) {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    return Container(
      width: double.infinity,
      height: 50,
      color: ColorTheme.primary,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            "Skillscaper App",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          ElevatedButton(
            onPressed: () {
              authBloc.add(LogoutRequest());
            },
            child: Text('Logout'),
          )
        ]),
      ),
    );
  }
}
