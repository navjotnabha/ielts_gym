import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProgressSectionItem extends StatelessWidget {
  final double score;
  final String footer;
  const ProgressSectionItem({super.key, required this.score, required this.footer});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircularPercentIndicator(
          radius: 35.0,
          lineWidth: 7.0,
          percent: score / 9,
          center: Text(
            "$score/9",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          progressColor: Colors.blue,
        ),
        const SizedBox(height: 8),
        Text(footer),
      ],
    );
  }
}