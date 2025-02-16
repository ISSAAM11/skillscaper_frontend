import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillscaper_app/blocs/exam_bloc/exam_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_event.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_state.dart';
import 'package:skillscaper_app/items/exam_items/instruction_item.dart';
import 'package:skillscaper_app/items/exam_items/question_item.dart';
import 'package:skillscaper_app/items/exam_items/result_item.dart';

class ExamMainElement extends StatefulWidget {
  final int idExam;

  const ExamMainElement({super.key, required this.idExam});

  @override
  State<ExamMainElement> createState() => _ExamMainElementState();
}

class _ExamMainElementState extends State<ExamMainElement> {
  ExamBloc? examBloc;
  bool isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      examBloc = BlocProvider.of<ExamBloc>(context);
      isInitialized = true;
    }
  }

  @override
  void dispose() {
    examBloc!.add(ExamResetEvent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examBloc = BlocProvider.of<ExamBloc>(context);
    final tokenBloc = BlocProvider.of<TokenBloc>(context);

    return BlocBuilder<ExamBloc, ExamState>(
      builder: (context, state) {
        if (state is ExamInitial) {
          examBloc.add(ExamRetreveEvent(
            widget.idExam,
            (tokenBloc.state as TokenRetrieved).token,
          ));
          return Expanded(
              child: Center(
            child: CircularProgressIndicator(),
          ));
        }
        if (state is ExamRetreved) {
          return InstructionItem(exam: state.exam);
        }
        if (state is ExamInProcessRetreved) {
          return QuestionItem(
            exam: state.exam,
            question: state.question,
            idtestRequest: widget.idExam,
          );
        }
        if (state is ExamFinishedstate) {
          return ResultItem(
              testRequest: state.testRequest, totalScore: state.totalScore);
        }

        if (state is ExamTokenExpired) {
          tokenBloc.add(TokenRefresh());
          examBloc.add(ExamResetEvent());
          return const Expanded(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is ExamDataFailed) {
          return Expanded(child: Center(child: Text(state.error)));
        }
        return Expanded(
            child: Center(
          child: CircularProgressIndicator(),
        ));
      },
    );
  }
}
