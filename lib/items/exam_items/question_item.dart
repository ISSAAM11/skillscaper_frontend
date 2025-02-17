import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillscaper_app/blocs/exam_bloc/exam_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_state.dart';
import 'package:skillscaper_app/items/exam_items/timer.dart';
import 'package:skillscaper_app/models/exam/exam.dart';
import 'package:skillscaper_app/models/exam/question.dart';

class QuestionItem extends StatefulWidget {
  final Exam exam;
  final Question question;
  final int idtestRequest;

  const QuestionItem(
      {required this.exam,
      required this.question,
      required this.idtestRequest,
      super.key});

  @override
  State<QuestionItem> createState() => _QuestionItemState();
}

class _QuestionItemState extends State<QuestionItem> {
  late int _seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _seconds = widget.exam.timerQuestion;
    _startTimer();
  }

  void _startTimer() {
    final examBloc = BlocProvider.of<ExamBloc>(context);
    final tokenBloc = BlocProvider.of<TokenBloc>(context);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          examBloc.add(ExamNextQuestionEvent(
            (tokenBloc.state as TokenRetrieved).token,
            widget.question.answers[0],
            widget.exam,
            widget.idtestRequest,
          ));
          _seconds = widget.exam.timerQuestion;
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _seconds = _seconds = widget.exam.timerQuestion;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

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
                  "Question : ${widget.question.questionText}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
                Text(
                  '$_seconds',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: widget.question.answers.length,
                    itemBuilder: (context, index) {
                      var thisAnswer = widget.question.answers[index];
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
                              widget.exam,
                              widget.idtestRequest,
                            ));
                            _resetTimer();
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
