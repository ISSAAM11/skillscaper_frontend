import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skillscaper_app/blocs/test_request_bloc/test_request_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_bloc.dart';
import 'package:skillscaper_app/blocs/token_bloc/token_state.dart';
import 'package:skillscaper_app/items/exam_items/result_item.dart';

class HomeMainElement extends StatefulWidget {
  const HomeMainElement({super.key});

  @override
  State<HomeMainElement> createState() => _HomeMainElementState();
}

class _HomeMainElementState extends State<HomeMainElement> {
  TestRequestBloc? examBloc;
  bool isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      examBloc = BlocProvider.of<TestRequestBloc>(context);
      isInitialized = true;
    }
  }

  @override
  void dispose() {
    examBloc!.add(TestRequestResetevent());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokenBloc = BlocProvider.of<TokenBloc>(context);
    final testRequestBloc = BlocProvider.of<TestRequestBloc>(context);

    return BlocBuilder<TestRequestBloc, TestRequestState>(
        builder: (context, state) {
      if (state is TestRequestInitial) {
        testRequestBloc.add(
            TestRequestRetreveEvent((tokenBloc.state as TokenRetrieved).token));
      }
      if (state is TestRequestDataFailed) {
        return Center(child: Text(state.error));
      }

      if (state is TestRequestTokenExpired) {
        return Center(child: CircularProgressIndicator());
      }
      if (state is TestRequestRetreved) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: ListView.builder(
              itemCount: state.testRequest.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Text(
                    style: TextStyle(
                        height: 3, fontSize: 17, fontWeight: FontWeight.w600),
                    "this is your test list:",
                  );
                }

                final dateLimit = state.testRequest[index - 1].timeLimit;
                return ListTile(
                  onTap: () {
                    if (state.testRequest[index - 1].isCompleted) {
                      testRequestBloc.add(TestRequestDetailsEvent(
                          state.testRequest[index - 1]));
                    } else if (DateTime.now().isBefore(dateLimit)) {
                      GoRouter.of(context).go(
                          "/Exam/${state.testRequest[index - 1].id}/${state.testRequest[index - 1].exam.id}",
                          extra: {
                            "idRequest": state.testRequest[index - 1].id,
                            "idExam": state.testRequest[index - 1].exam.id
                          });
                    }
                  },
                  enabled: DateTime.now().isAfter(dateLimit) &&
                          !state.testRequest[index - 1].isCompleted
                      ? false
                      : true,
                  title: Text(state.testRequest[index - 1].exam.testName),
                  subtitle: RichText(
                    text: TextSpan(
                      text: 'Limit date : ',
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(
                          text:
                              "${dateLimit.year} / ${dateLimit.month} / ${dateLimit.day}",
                        ),
                        TextSpan(
                            text: DateTime.now().isAfter(dateLimit) &&
                                    !state.testRequest[index - 1].isCompleted
                                ? '  Outdated'
                                : "",
                            style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                  leading: Icon(Icons.list),
                  trailing: state.testRequest[index - 1].isCompleted
                      ? Text(
                          "Total score : ${state.testRequest[index - 1].totalScore}")
                      : DateTime.now().isAfter(dateLimit)
                          ? SizedBox()
                          : Text(
                              "Incompleted",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                );
              },
            ),
          ),
        );
      }
      if (state is TestRequestResult) {
        return ResultItem(testRequest: state.testRequest, examFinished: false);
      }
      return SizedBox();
    });
  }
}
