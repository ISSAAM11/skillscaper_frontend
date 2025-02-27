import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillscaper_app/blocs/exam_bloc/exam_bloc.dart';
import 'package:skillscaper_app/blocs/test_request_bloc/test_request_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_event.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_state.dart';
import 'package:skillscaper_app/items/exam_items/instruction_item.dart';
import 'package:skillscaper_app/items/exam_items/question_item.dart';
import 'package:skillscaper_app/items/exam_items/result_item.dart';
import 'package:skillscaper_app/utils/notification_utils.dart';

class ExamMainElement extends StatefulWidget {
  final int idExam;
  final int idtestRequest;
  const ExamMainElement(
      {super.key, required this.idExam, required this.idtestRequest});

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
    final testRequestBloc = BlocProvider.of<TestRequestBloc>(context);

    return BlocConsumer<ExamBloc, ExamState>(
      listener: (context, state) {
        if (state is ExamFinishedstate) {
          successNotification(context,
              "You have completed ${state.testRequest.exam.testName} exam");
        }
      },
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
        if (state is ExamLoadingState) {
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
            idtestRequest: widget.idtestRequest,
          );
        }
        if (state is ExamFinishedstate) {
          testRequestBloc.add(TestRequestResetevent());
          return ResultItem(testRequest: state.testRequest, examFinished: true);
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
