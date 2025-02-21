import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skillscaper_app/exceptions/exceptions.dart';
import 'package:skillscaper_app/models/exam/answer.dart';
import 'package:skillscaper_app/models/exam/exam.dart';
import 'package:skillscaper_app/models/exam/question.dart';
import 'package:skillscaper_app/models/test_requiest.dart';
import 'package:skillscaper_app/services/exam_service.dart';
import 'package:skillscaper_app/services/test_request_service.dart';

part 'exam_event.dart';
part 'exam_state.dart';

class ExamBloc extends Bloc<ExamEvent, ExamState> {
  int totalScore = 0;

  ExamService examService = ExamService();
  TestRequestService testRequestService = TestRequestService();

  ExamBloc() : super(ExamInitial()) {
    on<ExamRetreveEvent>((event, emit) async {
      try {
        emit(ExamLoadingState());
        final Exam exam =
            await examService.retrieveOneExamRequest(event.examId, event.token);

        emit(ExamRetreved(exam));
      } on TokenExpiredException catch (_) {
        emit(ExamTokenExpired());
      } catch (e) {
        emit(ExamDataFailed(e.toString()));
      }
    });
    on<ExamStartEvent>((event, emit) {
      try {
        Question initialQuesition = event.exam.question
            .firstWhere((item) => item.questionLevel == event.nextQuestion);

        emit(ExamInProcessRetreved(event.exam, initialQuesition));
      } on TokenExpiredException catch (_) {
        emit(ExamTokenExpired());
      } catch (e) {
        emit(ExamDataFailed(e.toString()));
      }
    });

    on<ExamNextQuestionEvent>((event, emit) async {
      try {
        totalScore += event.answer.score;

        if (event.answer.nextQuestionId != null) {
          Question nextQuesition = event.exam.question
              .firstWhere((item) => item.id == event.answer.nextQuestionId);

          emit(ExamInProcessRetreved(event.exam, nextQuesition));
        } else {
          final Map testRequestMap = {
            'id': event.idtestRequest,
            'is_completed': true,
            'total_score': totalScore,
          };
          final TestRequest testRequest = await testRequestService
              .updateTestRequest(testRequestMap, event.token);
          emit(ExamFinishedstate(testRequest, totalScore));
        }
      } catch (e) {
        emit(ExamDataFailed(e.toString()));
      }
    });

    on<ExamResetEvent>((event, emit) {
      totalScore = 0;
      emit(ExamInitial());
    });
  }
}
