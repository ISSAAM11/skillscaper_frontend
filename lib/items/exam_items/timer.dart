import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skillscaper_app/blocs/exam_bloc/exam_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_state.dart';
import 'package:skillscaper_app/models/exam/answer.dart';
import 'package:skillscaper_app/models/exam/exam.dart';

class TimerItem extends StatefulWidget {
  final int initialSeconds;
  final Exam exam;
  final Answer answers;
  final int idtestRequest;

  TimerItem({
    this.initialSeconds = 30,
    required this.exam,
    required this.answers,
    required this.idtestRequest,
  });

  @override
  _TimerItemState createState() => _TimerItemState();
}

class _TimerItemState extends State<TimerItem> {
  late int _seconds;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _seconds = widget.initialSeconds;
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
            widget.answers,
            widget.exam,
            widget.idtestRequest,
          ));
          _seconds = widget.initialSeconds;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_seconds',
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
