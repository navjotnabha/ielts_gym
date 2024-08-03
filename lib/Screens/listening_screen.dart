import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ielts_gym/widgets/question_widget.dart';

class ListeningScreen extends StatefulWidget {
  @override
  _ListeningScreenState createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  late AudioPlayer _audioPlayer;
  String? _audioUrl;
  late Map<String, dynamic> _questionsData;
  bool _isLoading = true;
  bool _isAudioComplete = false;
  int _currentSection = 1;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadSection();
  }

  Future<void> _loadSection() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('https://firebasestorage.googleapis.com/v0/b/ielts-gym-edbdf.appspot.com/o/listening_material%2Ftest_1%2Fsection$_currentSection%2Fdata.json?alt=media'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _questionsData = data['questionData'];
          _audioUrl = 'https://firebasestorage.googleapis.com/v0/b/ielts-gym-edbdf.appspot.com/o/listening_material%2Ftest_1%2Fsection$_currentSection%2Faudio.mp3?alt=media';
          _isLoading = false;
        });
        _playAudio();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _playAudio() async {
    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isAudioComplete = true;
      });
    });
    await _audioPlayer.play(UrlSource(_audioUrl!));
  }

  void _nextSection() {
    _audioPlayer.stop();
    setState(() {
      _currentSection++;
      _isAudioComplete = false;
    });
    _loadSection();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listening Test'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _questionsData['questions'].length,
              itemBuilder: (context, index) {
                final question = _questionsData['questions'][index];
                final questionType = _questionsData['questionsType'];
                return QuestionWidget(
                  question: question,
                  questionType: questionType,
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: _nextSection,
            child: Text('Next Section'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
