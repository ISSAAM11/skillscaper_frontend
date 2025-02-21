import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillscaper_app/blocs/auth_bloc/auth_bloc.dart';
import 'package:skillscaper_app/blocs/auth_bloc/auth_event.dart';
import 'package:skillscaper_app/utils/color_theme.dart';

class LoginMainElement extends StatelessWidget {
  const LoginMainElement({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controllerEmail = TextEditingController();
    final TextEditingController _controllerPassword = TextEditingController();
    final authBloc = BlocProvider.of<AuthBloc>(context);

    final _formKey = GlobalKey<FormState>();
    void submit() {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        authBloc.add(AuthenticateRequest(
            email: _controllerEmail.text, password: _controllerPassword.text));
      }
    }

    return Center(
        child: Form(
      key: _formKey,
      child: Container(
        width: 500,
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Login screen",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _controllerEmail,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Username is required";
                }
                // if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                //   return 'Please enter a valid email';
                // }
                return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            TextFormField(
              obscureText: true,
              controller: _controllerPassword,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Password is required";
                }

                return null;
              },
            ),
            SizedBox(
              height: 15,
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorTheme.primary,
                ),
                onPressed: () {
                  submit();
                },
                child: Text(
                  'Login',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
