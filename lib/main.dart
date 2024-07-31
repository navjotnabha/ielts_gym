import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Screens/listening_screen.dart';
import 'Screens/practice_screen.dart';
import 'Screens/reading_screen.dart';
import 'Screens/result_screen.dart';
import 'Screens/speaking_screen.dart';
import 'Screens/start_listening_test.dart';
import 'Screens/start_reading_test.dart';
import 'Screens/start_speaking_test.dart';
import 'Screens/start_writing_test.dart';
import 'Screens/writing_screen.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IELTS Gym',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PracticeScreen(),
      routes: {
        '/start_listening_test': (context) => StartListeningTest(),
        '/start_reading_test': (context) => StartReadingTest(),
        '/start_writing_test': (context) => StartWritingTest(),
        '/start_speaking_test': (context) => StartSpeakingTest(),
        '/listening': (context) => ListeningScreen(),
        '/reading': (context) => ReadingScreen(),
        '/writing': (context) => WritingScreen(),
        '/speaking': (context) => SpeakingScreen(),
        '/result': (context) => ResultScreen(correctAnswers: 0, onRetry: () {}, onAnalyse: () {}),
      },
    );
  }
}
