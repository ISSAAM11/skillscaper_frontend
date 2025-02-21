import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_state.dart';
import 'package:skillscaper_app/models/test_requiest.dart';

import '../../blocs/test_request_bloc/test_request_bloc.dart';

class ResultItem extends StatelessWidget {
  final TestRequest testRequest;
  final bool examFinished;
  const ResultItem(
      {super.key, required this.testRequest, required this.examFinished});

  @override
  Widget build(BuildContext context) {
    final testRequestBloc = BlocProvider.of<TestRequestBloc>(context);
    final tokenBloc = BlocProvider.of<TokenBloc>(context);

    return Expanded(
      child: Center(
        child: SizedBox(
          width: 800,
          child: SingleChildScrollView(
            child: Column(children: [
              Text(
                "You completed your ${testRequest.exam.testName} test !",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
              SizedBox(height: 30),
              Text("This is your result: ${testRequest.totalScore}"),
              SizedBox(height: 10),
              // Text(
              //     "There is ${testRequest.exam.question.length} possible question on this exam"),
              SizedBox(height: 30),
              ElevatedButton(
                  onPressed: () {
                    if (examFinished) {
                      GoRouter.of(context).go('/home');
                    } else {
                      testRequestBloc.add(TestRequestRetreveEvent(
                          (tokenBloc.state as TokenRetrieved).token));
                    }
                  },
                  child: Text("Go back"))
            ]),
          ),
        ),
      ),
    );
  }
}
