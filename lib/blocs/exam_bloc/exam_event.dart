part of 'exam_bloc.dart';

@immutable
sealed class ExamEvent {}

class ExamRetreveEvent extends ExamEvent {
  final int examId;
  final String token;

  ExamRetreveEvent(this.examId, this.token);
}

final class ExamStartEvent extends ExamEvent {
  final String nextQuestion;

  final Exam exam;
  ExamStartEvent(this.nextQuestion, this.exam);
}

final class ExamNextQuestionEvent extends ExamEvent {
  final String token;
  final int idtestRequest;
  final Answer answer;
  final Exam exam;
  ExamNextQuestionEvent(this.token, this.answer, this.exam, this.idtestRequest);
}

final class ExamResetEvent extends ExamEvent {}
