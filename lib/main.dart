import 'package:flutter/material.dart';
import 'Screens/home_screen.dart';

void main() {
  runApp(const IELTSGymApp());
}

class IELTSGymApp extends StatelessWidget {
  const IELTSGymApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IELTS GYM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}









