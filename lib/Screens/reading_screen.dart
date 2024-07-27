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
    try {
      String jsonString = await rootBundle.loadString('assets/data/reading/Reading1.json');
      print('JSON String: $jsonString'); // Debugging line
      final jsonResponse = json.decode(jsonString);
      print('JSON Response: $jsonResponse'); // Debugging line
      return ReadingTest.fromJson(jsonResponse);
    } catch (e) {
      print('Error loading JSON: $e'); // Debugging line
      throw e;
    }
  }

  void checkAnswers(ReadingTest test) {
    int correctAnswers = 0;
    for (var section in test.sections) {
      for (var question in section.questions) {
        if (selectedAnswers[question.question] == question.answer) {
          correctAnswers++;
        }
      }
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Results'),
        content: Text('You got $correctAnswers out of 40 correct!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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
              print('Data Loaded: ${snapshot.data}'); // Debugging line
              return buildContent(snapshot.data!);
            }
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FutureBuilder<ReadingTest>(
        future: readingContent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
            return FloatingActionButton(
              onPressed: () => checkAnswers(snapshot.data!),
              child: const Icon(Icons.check),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget buildContent(ReadingTest data) {
    print('Building Content'); // Debugging line
    return ListView(
      padding: const EdgeInsets.all(16),
      children: data.sections.map<Widget>((section) => buildSection(section)).toList(),
    );
  }

  Widget buildSection(Section section) {
    print('Building Section: ${section.title}'); // Debugging line
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Text(section.passage, style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 20),
        ...section.questions.map<Widget>((question) => buildQuestion(question)).toList(),
      ],
    );
  }

  Widget buildQuestion(Question question) {
    print('Building Question: ${question.question}'); // Debugging line
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
