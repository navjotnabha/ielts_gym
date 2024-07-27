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
  int _currentSectionIndex = 0;

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

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Are you sure you want to quit this test and go back to the Home Screen?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
      ),
    );
  }

  Widget buildContent(ReadingTest data) {
    print('Building Content'); // Debugging line
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [buildSection(data.sections[_currentSectionIndex])],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentSectionIndex > 0)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentSectionIndex--;
                    });
                  },
                  child: const Text('Previous Section'),
                ),
              ),
            if (_currentSectionIndex < data.sections.length - 1)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentSectionIndex++;
                    });
                  },
                  child: const Text('Next Section'),
                ),
              ),
            if (_currentSectionIndex == data.sections.length - 1)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    checkAnswers(data);
                  },
                  child: const Text('Submit'),
                ),
              ),
          ],
        ),
      ],
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
        ...section.questions.asMap().entries.map<Widget>((entry) {
          int index = entry.key + 1;
          Question question = entry.value;
          return buildQuestion(index, question);
        }).toList(),
      ],
    );
  }

  Widget buildQuestion(int index, Question question) {
    print('Building Question: ${question.question}'); // Debugging line
    if (question.type == 'multiple_choice') {
      return buildMultipleChoiceQuestion(index, question);
    } else if (question.type == 'true_false_not_given') {
      return buildTrueFalseNotGivenQuestion(index, question);
    } else if (question.type == 'matching_headings') {
      return buildMatchingHeadingsQuestion(index, question);
    } else if (question.type == 'short_answer') {
      return buildShortAnswerQuestion(index, question);
    }
    return Container();
  }

  Widget buildMultipleChoiceQuestion(int index, Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$index. ${question.question}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget buildTrueFalseNotGivenQuestion(int index, Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$index. ${question.question}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget buildMatchingHeadingsQuestion(int index, Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$index. ${question.question}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...question.headings!.map<Widget>((heading) {
          return Text(heading, style: const TextStyle(fontSize: 16));
        }).toList(),
      ],
    );
  }

  Widget buildShortAnswerQuestion(int index, Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$index. ${question.question}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
