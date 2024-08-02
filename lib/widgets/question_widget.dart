import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final Map<String, dynamic> question;
  final String questionType;

  QuestionWidget({required this.question, required this.questionType});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? _selectedAnswer;

  @override
  Widget build(BuildContext context) {
    return widget.questionType == 'multipleChoice'
        ? _buildMultipleChoiceQuestion()
        : _buildFillBlanksQuestion();
  }

  Widget _buildMultipleChoiceQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.question['question'], style: TextStyle(fontSize: 16.0)),
        ..._buildMultipleChoiceOptions(),
      ],
    );
  }

  List<Widget> _buildMultipleChoiceOptions() {
    return (widget.question['options'] as List<dynamic>)
        .map((dynamic option) {
      return ListTile(
        title: Text(option as String),
        leading: Radio<String>(
          value: option as String,
          groupValue: _selectedAnswer,
          onChanged: (String? value) {
            setState(() {
              _selectedAnswer = value;
            });
          },
          activeColor: Colors.green, // Set the active color to green
        ),
      );
    }).toList();
  }

  Widget _buildFillBlanksQuestion() {
    return ListTile(
      title: Text(widget.question['question']),
      trailing: DropdownButton<String>(
        value: _selectedAnswer,
        hint: Text('Choose an answer'),
        onChanged: (String? newValue) {
          setState(() {
            _selectedAnswer = newValue;
          });
        },
        items: (widget.question['options'] as List<dynamic>)
            .map<DropdownMenuItem<String>>((dynamic value) {
          return DropdownMenuItem<String>(
            value: value as String,
            child: Text(value as String),
          );
        }).toList(),
        style: TextStyle(color: Colors.green), // Set the font color to green
      ),
    );
  }
}
