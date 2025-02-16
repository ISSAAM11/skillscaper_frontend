import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillscaper_app/blocs/exam_bloc/exam_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_state.dart';
import 'package:skillscaper_app/models/exam/exam.dart';
import 'package:skillscaper_app/models/exam/question.dart';

class QuestionItem extends StatelessWidget {
  final Exam exam;
  final Question question;
  final int idtestRequest;

  const QuestionItem(
      {required this.exam,
      required this.question,
      required this.idtestRequest,
      super.key});

  @override
  Widget build(BuildContext context) {
    final examBloc = BlocProvider.of<ExamBloc>(context);
    final tokenBloc = BlocProvider.of<TokenBloc>(context);

    return Expanded(
        child: Center(
      child: SizedBox(
        width: 800,
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Question : ${question.questionText}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: question.answers.length,
                    itemBuilder: (context, index) {
                      var thisAnswer = question.answers[index];
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(thisAnswer.answerText),
                          leading: CircleAvatar(
                            child: Text((index + 1).toString()),
                          ),
                          onTap: () {
                            examBloc.add(ExamNextQuestionEvent(
                              (tokenBloc.state as TokenRetrieved).token,
                              thisAnswer,
                              exam,
                              idtestRequest,
                            ));
                          },
                        ),
                      );
                    },
                  ),
                )
              ]),
        ),
      ),
    ));
  }
}
