class Question {
  final String type;
  final String question;
  final List<String>? options;
  final String answer;
  final List<String>? headings;
  final List<ParagraphInfo>? paragraphs;

  Question({
    required this.type,
    required this.question,
    this.options,
    required this.answer,
    this.headings,
    this.paragraphs,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      type: json['type'] ?? 'unknown',
      question: json['question'] ?? 'No Question',
      options: json['options'] != null ? List<String>.from(json['options']) : null,
      answer: json['answer'] ?? 'No Answer',
      headings: json['headings'] != null ? List<String>.from(json['headings']) : null,
      paragraphs: json['paragraphs'] != null
          ? List<ParagraphInfo>.from(json['paragraphs'].map((i) => ParagraphInfo.fromJson(i)))
          : null,
    );
  }
}

class ParagraphInfo {
  final int paragraph;
  final String heading;

  ParagraphInfo({required this.paragraph, required this.heading});

  factory ParagraphInfo.fromJson(Map<String, dynamic> json) {
    return ParagraphInfo(
      paragraph: json['paragraph'] ?? 0,
      heading: json['heading'] ?? 'No Heading',
    );
  }
}
