part of 'test_request_bloc.dart';

@immutable
sealed class TestRequestEvent {}

class ExamRetreveEvent extends TestRequestEvent {
  final int userId;
  final String token;

  ExamRetreveEvent(this.userId, this.token);
}
