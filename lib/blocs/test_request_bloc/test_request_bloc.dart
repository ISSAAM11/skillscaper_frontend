import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skillscaper_app/exceptions/exceptions.dart';
import 'package:skillscaper_app/models/test_requiest.dart';
import 'package:skillscaper_app/services/test_request_service.dart';

part 'test_request_event.dart';
part 'test_request_state.dart';

class TestRequestBloc extends Bloc<TestRequestEvent, TestRequestState> {
  TestRequestService testRequestService = TestRequestService();
  TestRequestBloc() : super(TestRequestInitial()) {
    on<TestRequestRetreveEvent>((event, emit) async {
      emit(TestRequestLoadingData());
      try {
        final prefs = await SharedPreferences.getInstance();
        final userData = json.decode(prefs.getString('userData')!) as Map;

        final List<TestRequest> testRequest = await testRequestService
            .retrieveTestRequest(userData["id"], event.token);

        emit(TestRequestRetreved(testRequest));
      } on TokenExpiredException catch (_) {
        emit(TestRequestTokenExpired());
      } catch (e) {
        emit(TestRequestDataFailed(e.toString()));
      }
    });

    on<TestRequestDetailsEvent>((event, emit) async {
      emit(TestRequestLoadingData());
      try {
        emit(TestRequestResult(event.testRequest));
      } catch (e) {
        emit(TestRequestDataFailed(e.toString()));
      }
    });

    on<TestRequestResetevent>((event, emit) async {
      emit(TestRequestInitial());
    });
  }
}
