import 'package:flutter/material.dart';
import 'speaking_screen.dart';

class StartSpeakingTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Speaking Test'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SpeakingScreen()),
            );
          },
          child: Text('Start Test'),
        ),
      ),
    );
  }
}
