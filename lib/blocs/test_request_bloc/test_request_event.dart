part of 'test_request_bloc.dart';

@immutable
sealed class TestRequestEvent {}

class TestRequestRetreveEvent extends TestRequestEvent {
  final String token;

  TestRequestRetreveEvent(this.token);
}

class TestRequestDetailsEvent extends TestRequestEvent {
  final TestRequest testRequest;
  TestRequestDetailsEvent(this.testRequest);
}

class TestRequestResetevent extends TestRequestEvent {}
