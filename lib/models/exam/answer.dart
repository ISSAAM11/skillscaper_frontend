class Answer {
  final int id;
  final String answerText;
  final int score;
  final int? nextQuestionId;
  final int? viderTiming;

  Answer({
    required this.id,
    required this.answerText,
    required this.score,
    this.nextQuestionId,
    this.viderTiming,
  });

  // Method to create an Answer object from a JSON map
  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      answerText: json['answer_text'],
      score: json['score'],
      nextQuestionId: json['next_question'],
      viderTiming: json['video_timing'],
    );
  }

  // Method to convert an Answer object to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'answer_text': answerText,
      'score': score,
      'next_question': nextQuestionId,
      'video_timing': viderTiming,
    };
  }
}
