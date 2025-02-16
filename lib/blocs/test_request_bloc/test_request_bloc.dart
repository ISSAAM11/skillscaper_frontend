import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:skillscaper_app/exceptions/exceptions.dart';
import 'package:skillscaper_app/models/test_requiest.dart';
import 'package:skillscaper_app/services/test_request_service.dart';

import '../../models/test_requiest.dart';

part 'test_request_event.dart';
part 'test_request_state.dart';

class TestRequestBloc extends Bloc<TestRequestEvent, TestRequestState> {
  TestRequestService testRequestService = TestRequestService();
  TestRequestBloc() : super(TestRequestInitial()) {
    on<ExamRetreveEvent>((event, emit) async {
      emit(TestRequestLoadingData());
      try {
        final List<TestRequest> testRequest = await testRequestService
            .retrieveTestRequest(event.userId, event.token);

        emit(TestRequestRetreved(testRequest));

        //else if (DateTime.now().isBefore(testRequest.timeLimit)) {
        //   emit(TestRequestNotYet(testRequest));
        // } else {
        //   emit(TestRequestEmpty(testRequest));
        // }
      } on TokenExpiredException catch (_) {
        emit(TestRequestTokenExpired());
      } catch (e) {
        emit(TestRequestDataFailed(e.toString()));
      }
    });
  }
}
