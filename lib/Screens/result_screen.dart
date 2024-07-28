import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int correctAnswers;
  final Function onRetry;
  final Function onAnalyse;

  const ResultScreen({
    Key? key,
    required this.correctAnswers,
    required this.onRetry,
    required this.onAnalyse,
  }) : super(key: key);

  String getBandScore(int correctAnswers) {
    if (correctAnswers >= 39) return '9';
    if (correctAnswers >= 37) return '8.5';
    if (correctAnswers >= 35) return '8';
    if (correctAnswers >= 33) return '7.5';
    if (correctAnswers >= 30) return '7';
    if (correctAnswers >= 27) return '6.5';
    if (correctAnswers >= 23) return '6';
    if (correctAnswers >= 19) return '5.5';
    if (correctAnswers >= 15) return '5';
    if (correctAnswers >= 13) return '4.5';
    if (correctAnswers >= 10) return '4';
    return '3.5 or below';
  }

  @override
  Widget build(BuildContext context) {
    final bandScore = getBandScore(correctAnswers);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Correct Answers: $correctAnswers',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Band Score: $bandScore',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => onAnalyse(),
              child: const Text('Analyse'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => onRetry(),
              child: const Text('Retry Test'),
            ),
          ],
        ),
      ),
    );
  }
}
