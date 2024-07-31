import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int correctAnswers;
  final VoidCallback onRetry;
  final VoidCallback onAnalyse;

  const ResultScreen({
    Key? key,
    required this.correctAnswers,
    required this.onRetry,
    required this.onAnalyse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Correct Answers: $correctAnswers',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: onRetry,
              child: Text('Retry'),
            ),
            ElevatedButton(
              onPressed: onAnalyse,
              child: Text('Analyse'),
            ),
          ],
        ),
      ),
    );
  }
}
