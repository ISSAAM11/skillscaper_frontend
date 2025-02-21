import 'package:skillscaper_app/models/exam/answer.dart';

class Question {
  final int id;
  final String questionLevel;
  final int examId;
  final String questionText;
  final List<Answer> answers;
  final int? viderTiming; // Represents the ForeignKey to the next Question

  Question({
    required this.id,
    required this.questionLevel,
    required this.examId,
    required this.questionText,
    required this.answers,
    this.viderTiming,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      questionLevel: json['question_level'],
      examId: json['exam_id'],
      questionText: json['question_text'],
      answers: (json['answers'] as List)
          .map((questionJson) => Answer.fromJson(questionJson))
          .toList(),
      viderTiming: json['video_timing'],
    );
  }

  // Method to convert a Question object to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question_level': questionLevel,
      'exam_id': examId,
      'question_text': questionText,
      "answers": answers,
      'video_timing': viderTiming,
    };
  }
}
