import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/question_model.dart';
import '../models/reading_test.dart';
import 'result_screen.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({Key? key}) : super(key: key);

  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  late Future<ReadingTest> readingContent;
  Map<String, String?> selectedAnswers = {};
  int _currentSectionIndex = 0;
  bool _isAnalyseMode = false;

  @override
  void initState() {
    super.initState();
    readingContent = loadReadingContent();
  }

  Future<ReadingTest> loadReadingContent() async {
    try {
      String jsonString = await rootBundle.loadString('assets/data/reading/Reading1.json');
      final jsonResponse = json.decode(jsonString);
      return ReadingTest.fromJson(jsonResponse);
    } catch (e) {
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
    showResults(correctAnswers);
  }

  void showResults(int correctAnswers) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          correctAnswers: correctAnswers,
          onRetry: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ReadingScreen()));
          },
          onAnalyse: () {
            Navigator.of(context).pop();
            setState(() {
              _isAnalyseMode = true;
            });
          },
        ),
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
    bool isCorrect = selectedAnswers[question.question] == question.answer;

    if (question.type == 'multiple_choice') {
      return buildMultipleChoiceQuestion(index, question, isCorrect);
    } else if (question.type == 'true_false_not_given') {
      return buildTrueFalseNotGivenQuestion(index, question, isCorrect);
    } else if (question.type == 'matching_headings') {
      return buildMatchingHeadingsQuestion(index, question, isCorrect);
    } else if (question.type == 'short_answer') {
      return buildShortAnswerQuestion(index, question, isCorrect);
    }
    return Container();
  }

  Widget buildMultipleChoiceQuestion(int index, Question question, bool isCorrect) {
    bool isAnswered = selectedAnswers.containsKey(question.question);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isAnalyseMode && !isAnswered)
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Not answered',
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ),
        Text('$index. ${question.question}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...question.options!.map<Widget>((option) {
          Color color = Colors.black;
          IconData? icon;
          if (_isAnalyseMode) {
            if (selectedAnswers[question.question] == option) {
              if (option == question.answer) {
                color = Colors.green;
                icon = Icons.check;
              } else {
                color = Colors.red;
                icon = Icons.close;
              }
            } else if (option == question.answer) {
              color = Colors.green;
              icon = Icons.check;
            }
          }
          return _isAnalyseMode
              ? ListTile(
            title: Row(
              children: [
                Flexible(child: Text(option, style: TextStyle(color: color))),
                if (icon != null) ...[
                  const SizedBox(width: 10),
                  Icon(icon, color: color),
                ]
              ],
            ),
          )
              : RadioListTile<String>(
            title: Flexible(child: Text(option)),
            value: option,
            groupValue: selectedAnswers[question.question],
            onChanged: (value) {
              setState(() {
                selectedAnswers[question.question] = value;
              });
            },
          );
        }).toList(),
        const Divider(color: Colors.grey),
      ],
    );
  }

  Widget buildTrueFalseNotGivenQuestion(int index, Question question, bool isCorrect) {
    bool isAnswered = selectedAnswers.containsKey(question.question);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_isAnalyseMode && !isAnswered)
          const Padding(
            padding: EdgeInsets.only(left: 16.0),
            child: Text(
              'Not answered',
              style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ),
        Text('$index. ${question.question}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...['True', 'False', 'Not Given'].map<Widget>((option) {
          Color color = Colors.black;
          IconData? icon;
          if (_isAnalyseMode && isAnswered) {
            if (selectedAnswers[question.question] == option) {
              color = isCorrect ? Colors.green : Colors.red;
              icon = isCorrect ? Icons.check : Icons.close;
            }
            else if (option == question.answer) {
              color = Colors.green;
            }
          }
          return _isAnalyseMode
              ? ListTile(
            title: Row(
              children: [
                Flexible(child: Text(option, style: TextStyle(color: color))),
                if (icon != null) ...[
                  const SizedBox(width: 10),
                  Icon(icon, color: color),
                ]
              ],
            ),
          )
              : RadioListTile<String>(
            title: Flexible(child: Text(option)),
            value: option,
            groupValue: selectedAnswers[question.question],
            onChanged: (value) {
              setState(() {
                selectedAnswers[question.question] = value;
              });
            },
          );
        }).toList(),
        const Divider(color: Colors.grey),
      ],
    );
  }

  Widget buildMatchingHeadingsQuestion(int index, Question question, bool isCorrect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$index. ${question.question}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ...question.headings!.map<Widget>((heading) {
          return Text(heading, style: const TextStyle(fontSize: 16));
        }).toList(),
        const Divider(color: Colors.grey),
      ],
    );
  }

  Widget buildShortAnswerQuestion(int index, Question question, bool isCorrect) {
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
        const Divider(color: Colors.grey),
      ],
    );
  }
}
