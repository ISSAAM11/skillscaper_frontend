import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skillscaper_app/blocs/exam_bloc/exam_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_state.dart';
import 'package:skillscaper_app/models/exam/exam.dart';
import 'package:skillscaper_app/models/exam/question.dart';
import 'package:video_player/video_player.dart';

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
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _seconds = widget.exam.timerQuestion;
    _controller = VideoPlayerController.network(widget.exam.videoLink)
      ..initialize().then((_) {
        setState(() {});
        _controller.seekTo(Duration(seconds: 1));
        _controller.play();
      });

    _startTimer();
  }

  late Future<void> _initializeVideoPlayerFuture;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();

    super.dispose();
  }

  void _startTimer() {
    final examBloc = BlocProvider.of<ExamBloc>(context);
    final tokenBloc = BlocProvider.of<TokenBloc>(context);

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_seconds > 0) {
          _seconds--;
        } else {
          if (widget.question.answers[0].viderTiming != null) {
            _controller.seekTo(
                Duration(seconds: widget.question.answers[0].viderTiming!));
          }
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
  Widget build(BuildContext context) {
    final examBloc = BlocProvider.of<ExamBloc>(context);
    final tokenBloc = BlocProvider.of<TokenBloc>(context);

    return Expanded(
        child: Center(
      child: Container(
        alignment: Alignment.topCenter,
        width: 1200,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 500,
                      width: 600,
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
                                if (thisAnswer.viderTiming != null) {
                                  _controller.seekTo(Duration(
                                      seconds: thisAnswer.viderTiming!));
                                }
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
                    ),
                    SizedBox(width: 10),
                    Container(
                      width: 310,
                      height: 200,
                      child: _controller?.value.isInitialized ?? false
                          ? ClipRect(
                              child: OverflowBox(
                                alignment: Alignment.center,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: _controller!.value.size.width,
                                    height: _controller!.value.size.height,
                                    child: VideoPlayer(_controller!),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ),
                  ],
                )
              ]),
        ),
      ),
    ));
  }
}
