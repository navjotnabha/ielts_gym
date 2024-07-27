import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/question_model.dart';
import '../models/reading_test.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({Key? key}) : super(key: key);

  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late Future<ReadingTest> readingContent;
  Map<String, String?> selectedAnswers = {};

  @override
  void initState() {
    super.initState();
    readingContent = loadReadingContent();
  }

  Future<ReadingTest> loadReadingContent() async {
    String jsonString = await rootBundle.loadString('assets/data/reading/reading1.json');
    final jsonResponse = json.decode(jsonString);
    print('JSON Response: $jsonResponse'); // Add this line
    return ReadingTest.fromJson(jsonResponse);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Practice'),
      ),
      body: FutureBuilder<ReadingTest>(
        future: readingContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return buildContent(snapshot.data!);
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget buildContent(ReadingTest data) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(data.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text(data.passage, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        ...data.questions.map<Widget>((question) => buildQuestion(question)).toList(),
      ],
    );
  }

  Widget buildQuestion(Question question) {
    if (question.type == 'multiple_choice') {
      return buildMultipleChoiceQuestion(question);
    } else if (question.type == 'true_false_not_given') {
      return buildTrueFalseNotGivenQuestion(question);
    } else if (question.type == 'matching_headings') {
      return buildMatchingHeadingsQuestion(question);
    } else if (question.type == 'short_answer') {
      return buildShortAnswerQuestion(question);
    }
    return Container();
  }

  Widget buildMultipleChoiceQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...question.options!.map<Widget>((option) {
          return RadioListTile<String>(
            title: Text(option),
            value: option,
            groupValue: selectedAnswers[question.question],
            onChanged: (value) {
              setState(() {
                selectedAnswers[question.question] = value;
              });
            },
          );
        }).toList(),
      ],
    );
  }

  Widget buildTrueFalseNotGivenQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        RadioListTile<String>(
          title: const Text('True'),
          value: 'True',
          groupValue: selectedAnswers[question.question],
          onChanged: (value) {
            setState(() {
              selectedAnswers[question.question] = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('False'),
          value: 'False',
          groupValue: selectedAnswers[question.question],
          onChanged: (value) {
            setState(() {
              selectedAnswers[question.question] = value;
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Not Given'),
          value: 'Not Given',
          groupValue: selectedAnswers[question.question],
          onChanged: (value) {
            setState(() {
              selectedAnswers[question.question] = value;
            });
          },
        ),
      ],
    );
  }

  Widget buildMatchingHeadingsQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...question.headings!.map<Widget>((heading) {
          return Text(heading, style: const TextStyle(fontSize: 16));
        }).toList(),
      ],
    );
  }

  Widget buildShortAnswerQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question.question, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextField(
          onChanged: (value) {
            setState(() {
              selectedAnswers[question.question] = value;
            });
          },
        ),
      ],
    );
  }
}
