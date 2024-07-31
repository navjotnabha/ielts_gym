import 'package:flutter/material.dart';
import 'reading_screen.dart';

class StartReadingTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Reading Test'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ReadingScreen()),
            );
          },
          child: Text('Start Test'),
        ),
      ),
    );
  }
}
