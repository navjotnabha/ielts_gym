// white rectangular  dividers
import 'package:flutter/material.dart';

class Section extends StatelessWidget {
  final String title;
  final List<Widget> items;

  const Section({super.key, required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(  // main white rectangular section
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items,
          ),
        ],
      ),
    );
  }
}