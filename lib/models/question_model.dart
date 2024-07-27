class Question {
  final String type;
  final String question;
  final List<String>? options;
  final String answer;
  final List<String>? headings;

  Question({required this.type, required this.question, this.options, required this.answer, this.headings});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: json['type'] ?? 'unknown',
      question: json['question'] ?? 'No Question',
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      answer: json['answer'] ?? 'No Answer',
      headings: json['headings'] != null ? List<String>.from(json['headings']) : null,
    );
  }
}
