part of 'exam_bloc.dart';

@immutable
sealed class ExamState {}

final class ExamInitial extends ExamState {}

final class ExamRetreved extends ExamState {
  final Exam exam;
  ExamRetreved(this.exam);
}

final class ExamInProcessRetreved extends ExamState {
  final Exam exam;
  final Question question;
  ExamInProcessRetreved(this.exam, this.question);
}

final class ExamFinishedstate extends ExamState {
  final TestRequest testRequest;
  final int totalScore;

  ExamFinishedstate(this.testRequest, this.totalScore);
}

final class ExamTokenExpired extends ExamState {}

final class ExamDataFailed extends ExamState {
  final String error;

  ExamDataFailed(this.error);
}
