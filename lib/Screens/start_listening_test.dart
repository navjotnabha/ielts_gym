import 'package:flutter/material.dart';
import 'listening_screen.dart';

class StartListeningTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Start Listening Test'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ListeningScreen()),
            );
          },
          child: Text('Start Test'),
        ),
      ),
    );
  }
}
