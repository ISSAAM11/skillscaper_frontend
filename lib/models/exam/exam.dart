import 'package:skillscaper_app/models/exam/question.dart';

class Exam {
  final int id;
  final String testName;
  final int timerQuestion;
  final List<Question> question;

  Exam({
    required this.id,
    required this.testName,
    required this.timerQuestion,
    required this.question,
  });

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      testName: json['test_name'],
      timerQuestion: json['timerQuestion'],
      question: (json['questions'] as List)
          .map((questionJson) => Question.fromJson(questionJson))
          .toList(),
    );
  }

  // Method to convert an Exam object to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'test_name': testName,
      'timer_question': timerQuestion,
      'question': question.map((q) => q.toMap()).toList(),
    };
  }

  factory Exam.fromJsonDepth1(Map<String, dynamic> json) {
    return Exam(
      id: json['id'],
      timerQuestion: json['timerQuestion'],
      testName: json['test_name'],
      question: [],
    );
  }
}
