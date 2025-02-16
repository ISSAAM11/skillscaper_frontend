import 'package:flutter/material.dart';
import 'package:skillscaper_app/models/exam/exam.dart';
import 'package:skillscaper_app/models/test_requiest.dart';

class ResultItem extends StatelessWidget {
  final TestRequest testRequest;
  final int totalScore;

  const ResultItem(
      {super.key, required this.testRequest, required this.totalScore});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: 800,
          child: SingleChildScrollView(
            child: Column(children: [
              Text(
                "You completed your ${testRequest.id} test!!",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
              ),
              SizedBox(height: 30),
              Text("This is your result: ${totalScore}"),
            ]),
          ),
        ),
      ),
    );
  }
}
