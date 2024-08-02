import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';

class ListeningScreen extends StatefulWidget {
  @override
  _ListeningScreenState createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  int _currentSection = 1;
  bool _isLoading = true;
  bool _isPlaying = false;
  bool _isAudioComplete = false;
  Map<String, dynamic> _questionsData = {}; // Initialize with an empty map

  @override
  void initState() {
    super.initState();
    _loadSection();
    _audioPlayer.onPlayerComplete.listen((_) {
      _onAudioComplete();
    });
  }

  Future<void> _loadSection() async {
    setState(() {
      _isLoading = true;
      _isAudioComplete = false;
    });

    final questionsUrl = "https://firebasestorage.googleapis.com/v0/b/ielts-gym-edbdf.appspot.com/o/listening_material%2Ftest_1%2Fsection$_currentSection%2Fquestions.json?alt=media&token=5360fb8b-f8b7-4b81-85d4-f846a3aa098f";
    final audioUrlMp3 = "https://firebasestorage.googleapis.com/v0/b/ielts-gym-edbdf.appspot.com/o/listening_material%2Ftest_1%2Fsection$_currentSection%2Faudio.mp3?alt=media&token=5360fb8b-f8b7-4b81-85d4-f846a3aa098f";

    try {
      final questionsResponse = await http.get(Uri.parse(questionsUrl));
      if (questionsResponse.statusCode == 200) {
        _questionsData = json.decode(questionsResponse.body);
        if (_questionsData['questions'] == null) {
          throw Exception('No questions found for section $_currentSection');
        }
        print('Loaded section $_currentSection');
        setState(() {
          _isLoading = false;
        });

        // Log constructed URL
        print('Attempting to play audio: MP3 URL: $audioUrlMp3');

        // Play MP3 audio
        await _playAudio(audioUrlMp3);
      } else {
        print('Error loading section $_currentSection: ${questionsResponse.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Exception: $e');
      setState(() {
        _isLoading = false;
        _questionsData = {}; // Clear the questions data to prevent further errors
      });
    }
  }

  Future<void> _playAudio(String audioUrlMp3) async {
    setState(() {
      _isPlaying = true;
      _isAudioComplete = false;
    });

    try {
      await _audioPlayer.play(UrlSource(audioUrlMp3));
      print('Playing audio from $audioUrlMp3');
    } catch (e) {
      print('Error playing audio from $audioUrlMp3: $e');
    }
  }

  void _onAudioComplete() {
    print('Audio completed');
    setState(() {
      _isPlaying = false;
      _isAudioComplete = true;
    });
  }

  void _nextSection() {
    print('Loading next section');
    setState(() {
      _currentSection++;
      _isAudioComplete = false;
      _isPlaying = false;
    });
    _loadSection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listening Test'),
      ),
      body: Stack(
        children: [
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : _questionsData.isEmpty
              ? Center(child: Text('No data found'))
              : ListView.builder(
            itemCount: _questionsData['questions'].length,
            itemBuilder: (context, index) {
              final question = _questionsData['questions'][index];
              return ListTile(
                title: Text(question['question']),
                subtitle: Text('Answer: ${question['answer']}'),
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: ElevatedButton(
              onPressed: _nextSection,
              child: Text('Next Section'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
