import 'package:flutter/material.dart';
import '../Screens/listening_screen.dart';
import '../Screens/reading_screen.dart';
import '../Screens/speaking_screen.dart';
import '../Screens/writing_screen.dart';


class SectionItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;

  const SectionItem({super.key, required this.name, required this.icon, required this.color});

  void _navigateToModule(BuildContext context) {
    Widget screen;
    switch (name) {
      case 'Reading':
        screen = const ReadingScreen();
        break;
      case 'Listening':
        screen = const ListeningScreen();
        break;
      case 'Writing':
        screen = const WritingScreen();
        break;
      case 'Speaking':
        screen = const SpeakingScreen();
        break;
      default:
        screen = const Scaffold(
          body: Center(child: Text('Unknown module')),
        );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateToModule(context),
      child: Column(
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            ),
            child: Center(
              child: CircleAvatar(
                backgroundColor: color,
                radius: 30,
                child: Icon(icon, size: 30, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(name),
        ],
      ),
    );
  }
}

