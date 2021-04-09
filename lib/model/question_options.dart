class QuestionOptions {
  final String question;
  final String level;
  final List<Object> options;

  QuestionOptions({this.question, this.options, this.level});

  factory QuestionOptions.fromJson(Map<String, dynamic> jsonMap) {
    (jsonMap['options'] as List<Object>).shuffle();
    return QuestionOptions(
      question: jsonMap['question'] as String,
      options: jsonMap['options'] as List<Object>,
      level: jsonMap['level'] as String,
    );
  }
}
