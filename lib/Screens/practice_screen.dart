import 'package:flutter/material.dart';

import '../widgets/progress_section_item.dart';
import '../widgets/section_item.dart';
import '../widgets/sections.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200], // Set the background color of the whole screen
      child: const SingleChildScrollView(
        child: Column(
          children: [
            Section(
              title: 'Practice',
              items: [
                SectionItem(
                    name: 'Reading', icon: Icons.book, color: Colors.red),
                SectionItem(
                    name: 'Listening',
                    icon: Icons.headset,
                    color: Colors.green),
                SectionItem(
                    name: 'Writing', icon: Icons.edit, color: Colors.blue),
                SectionItem(
                    name: 'Speaking',
                    icon: Icons.record_voice_over,
                    color: Colors.orange),
              ],
            ),
            Section(
              title: 'Best Achieved',
              items: [

                    ProgressSectionItem(score: 4.5, footer: 'Reading'),
                    ProgressSectionItem(score: 4.5, footer: 'Listening'),
                    ProgressSectionItem(score: 4.5, footer: 'Writing'),
                    ProgressSectionItem(score: 4.5, footer: 'Speaking'),
              ],
            ),
            Section(
              title: 'Improve Skills',
              items: [
                SectionItem(
                    name: 'Grammar',
                    icon: Icons.spellcheck,
                    color: Colors.purple),
                SectionItem(
                    name: 'Vocabulary',
                    icon: Icons.language,
                    color: Colors.teal),
                //SectionItem(name: 'Tips', icon: Icons.lightbulb, color: Colors.indigo),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
