import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillscaper_app/blocs/exam_bloc/exam_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_bloc.dart';
import 'package:skillscaper_app/models/exam/exam.dart';

class InstructionItem extends StatelessWidget {
  final Exam exam;
  const InstructionItem({required this.exam, super.key});

  @override
  Widget build(BuildContext context) {
    final examBloc = BlocProvider.of<ExamBloc>(context);
    final tokenBloc = BlocProvider.of<TokenBloc>(context);

    final initial_question = "1_a";
    return Expanded(
        child: Center(
            child: SizedBox(
      width: 800,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello Mentee to the ${exam.testName} Test!",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              "In this test there is  ${exam.question.length} possible Questions",
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 10),
            Text(
              "in each question you have ${exam.timerQuestion} second to answer the question",
              style: TextStyle(fontSize: 13),
            ),
            SizedBox(height: 30),
            Text(
              " Instructions:",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 20),
            Text(
                "1️. This test consists of multiple dialog-based scenarios where you will interact with virtual characters."),
            Text(
                "2. Each dialog will have multiple questions, and you must choose the most appropriate response."),
            Text(
                "3. Your answers will determine the flow of the conversation and your final score."),
            Text(
                "4. You will have a limited time to select an answer for each question. If no answer is chosen, the test will continue automatically."),
            Text(
                "5. Be sure to select the best possible answer based on context and accuracy."),
            Text(
                "6. Once the test is completed, you will receive your final score."),
            SizedBox(height: 15),
            Text(
              '✅ Click "Start Test" to begin. Good luck!',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () {
                examBloc.add(ExamStartEvent("1_a", exam));
              },
              child: Text('Start your test'),
            )
          ],
        ),
      ),
    )));
  }
}
