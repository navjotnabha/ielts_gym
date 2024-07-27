import 'question_model.dart';

class ReadingTest {
  final List<Section> sections;

  ReadingTest({required this.sections});

  factory ReadingTest.fromJson(Map<String, dynamic> json) {
    var list = json['test']['sections'] as List<dynamic>?;
    List<Section> sectionsList = list != null ? list.map((i) => Section.fromJson(i)).toList() : [];
    return ReadingTest(sections: sectionsList);
  }
}

class Section {
  final String title;
  final String passage;
  final List<Question> questions;

  Section({required this.title, required this.passage, required this.questions});

  factory Section.fromJson(Map<String, dynamic> json) {
    var list = json['questions'] as List<dynamic>?;
    List<Question> questionList = list != null ? list.map((i) => Question.fromJson(i)).toList() : [];

    return Section(
      title: json['title'] ?? 'No Title',
      passage: json['passage'] ?? 'No Passage',
      questions: questionList,
    );
  }
}
