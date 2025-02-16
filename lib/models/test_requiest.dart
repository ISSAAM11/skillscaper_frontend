import 'package:skillscaper_app/models/exam/exam.dart';
import 'package:skillscaper_app/models/user.dart';

class TestRequest {
  final int id;
  final User user;
  final Exam exam;
  final bool isCompleted;
  final DateTime timeLimit;
  final int totalScore;

  TestRequest({
    required this.id,
    required this.user,
    required this.exam,
    required this.isCompleted,
    required this.timeLimit,
    required this.totalScore,
  });

  factory TestRequest.fromJson(Map<String, dynamic> json) {
    return TestRequest(
      id: json['id'],
      isCompleted: json['is_completed'],
      timeLimit: DateTime.parse(json['time_limit']),
      totalScore: json['total_score'],
      user: User.fromJson(json['id_user']),
      exam: Exam.fromJsonDepth1(json['id_exam']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user': user.toMap(),
      'id_exam': exam.toMap(),
      'is_completed': isCompleted,
      'time_limit': timeLimit,
      'total_score': totalScore,
    };
  }
}
