import 'package:flutter/material.dart';
import 'writing_screen.dart';

class StartWritingTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Writing Test'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WritingScreen()),
            );
          },
          child: Text('Start Test'),
        ),
      ),
    );
  }
}
