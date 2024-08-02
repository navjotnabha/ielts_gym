import 'package:flutter/material.dart';
import '../widgets/progress_section_item.dart';
import '../widgets/section_item.dart';
import '../widgets/sections.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200], // Set the background color of the whole screen
      body: SingleChildScrollView(
        child: Column(
          children: [
            Section(
              title: 'Practice',
              items: [
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1.75,
                  mainAxisSpacing: 10,
                  padding: const EdgeInsets.all(16),
                  children: const [
                    SectionItem(
                      name: 'Reading',
                      icon: Icons.book,
                      color: Colors.red,
                      route: '/start_reading_test',
                    ),
                    SectionItem(
                      name: 'Listening',
                      icon: Icons.headset,
                      color: Colors.green,
                      route: '/start_listening_test',
                    ),
                    SectionItem(
                      name: 'Writing',
                      icon: Icons.edit,
                      color: Colors.blue,
                      route: '/start_writing_test',
                    ),
                    SectionItem(
                      name: 'Speaking',
                      icon: Icons.record_voice_over,
                      color: Colors.orange,
                      route: '/start_speaking_test',
                    ),
                  ],
                ),
              ],
            ),
            const Section(
              title: 'Best Achieved',
              items: [
                ProgressSectionItem(score: 4.5, footer: 'Reading'),
                ProgressSectionItem(score: 4.5, footer: 'Listening'),
                ProgressSectionItem(score: 4.5, footer: 'Writing'),
                ProgressSectionItem(score: 4.5, footer: 'Speaking'),
              ],
            ),
            const Section(
              title: 'Improve Skills',
              items: [
                SectionItem(
                  name: 'Grammar',
                  icon: Icons.spellcheck,
                  color: Colors.purple,
                  route: '/start_grammar_practice',
                ),
                SectionItem(
                  name: 'Vocabulary',
                  icon: Icons.language,
                  color: Colors.teal,
                  route: '/start_vocabulary_practice',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
