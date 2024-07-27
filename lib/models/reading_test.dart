import 'question_model.dart';

class ReadingTest {
  final String title;
  final String passage;
  final List<Question> questions;

  ReadingTest({required this.title, required this.passage, required this.questions});

  factory ReadingTest.fromJson(Map<String, dynamic> json) {
    var list = json['questions'] as List;
    List<Question> questionList = list.map((i) => Question.fromJson(i)).toList();

    return ReadingTest(
      title: json['title'] ?? 'No Title',
      passage: json['passage'] ?? 'No Passage',
      questions: questionList,
    );
  }
}
// i just made a change here i want see if chatgpt finds it