import 'package:flutter/material.dart';

class QuestionWidget extends StatefulWidget {
  final Map<String, dynamic> question;
  final String questionType;

  const QuestionWidget({
    required this.question,
    required this.questionType,
    Key? key,
  }) : super(key: key);

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? selectedAnswer;

  @override
  Widget build(BuildContext context) {
    if (widget.questionType == "multipleChoice") {
      return _buildMultipleChoiceQuestion();
    } else if (widget.questionType == "fillMap") {
      return _buildImageQuestion();
    } else {
      return _buildFillBlanksQuestion();
    }
  }

  Widget _buildMultipleChoiceQuestion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.question['question']),
          ...widget.question['options'].map<Widget>((option) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAnswer = option;
                  });
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  elevation: 4,
                  color: selectedAnswer == option ? Colors.green : Colors.white,
                  child: ListTile(
                    leading: Radio<String>(
                      value: option,
                      groupValue: selectedAnswer,
                      onChanged: (String? value) {
                        setState(() {
                          selectedAnswer = value;
                        });
                      },
                    ),
                    title: Text(option),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildFillBlanksQuestion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.question['id']}.",
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(width: 8.0),
              Expanded(

                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.question['question'],
                      style: TextStyle(fontSize: 16.0),
                    ),
                    DropdownButton<String>(
                      value: selectedAnswer,
                      hint: Text("Select an answer", style: TextStyle(color: Colors.red)),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedAnswer = newValue;
                        });
                      },
                      items: widget.question['options']
                          .map<DropdownMenuItem<String>>((dynamic option) {
                        return DropdownMenuItem<String>(
                          value: option,
                          child: Text(option,style: TextStyle(color: Colors.green[800]),),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.0),

        ],
      ),
    );
  }


  Widget _buildImageQuestion() {
    String imageUrl = widget.question['imageUrl'] ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (imageUrl.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Image.network(imageUrl),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(widget.question['question']),
        ),
      ],
    );
  }
}
