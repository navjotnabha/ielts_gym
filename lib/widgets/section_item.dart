import 'package:flutter/material.dart';

class SectionItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final String route;

  const SectionItem({
    Key? key,
    required this.name,
    required this.icon,
    required this.color,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 4.0,  // Adding shadow
      borderRadius: BorderRadius.circular(8),
      shadowColor: Colors.black.withOpacity(0.2),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, route);
        },
        borderRadius: BorderRadius.circular(8), // To match the Material borderRadius
        splashColor: color.withOpacity(0.2),  // Adding splash color effect
        highlightColor: color.withOpacity(0.1), // Adding highlight color effect
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
