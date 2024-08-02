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
  String? _imageUrl; // Make _imageUrl nullable
  Map<int, String> _draggedAnswers = {};

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
      _imageUrl = null;
      _draggedAnswers.clear();
    });

    final questionsUrl = "https://firebasestorage.googleapis.com/v0/b/ielts-gym-edbdf.appspot.com/o/listening_material%2Ftest_1%2Fsection$_currentSection%2Fquestions.json?alt=media&token=5360fb8b-f8b7-4b81-85d4-f846a3aa098f";
    final audioUrlMp3 = "https://firebasestorage.googleapis.com/v0/b/ielts-gym-edbdf.appspot.com/o/listening_material%2Ftest_1%2Fsection$_currentSection%2Faudio.mp3?alt=media&token=5360fb8b-f8b7-4b81-85d4-f846a3aa098f";
    final imageUrl = "https://firebasestorage.googleapis.com/v0/b/ielts-gym-edbdf.appspot.com/o/listening_material%2Ftest_1%2Fsection$_currentSection%2Fimage.jpg?alt=media&token=5360fb8b-f8b7-4b81-85d4-f846a3aa098f";

    try {
      final questionsResponse = await http.get(Uri.parse(questionsUrl));
      if (questionsResponse.statusCode == 200) {
        _questionsData = json.decode(questionsResponse.body);
        if (_questionsData['questions'] == null && _questionsData['questionType'] != 'fillMap') {
          throw Exception('No questions found for section $_currentSection');
        }
        print('Loaded section $_currentSection');

        if (_questionsData['questionType'] == 'fillMap') {
          _imageUrl = imageUrl;
        }

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

  void _nextSection() async {
    print('Stopping current audio');
    await _audioPlayer.stop();  // Stop any currently playing audio

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
              : Column(
            children: [
              if (_imageUrl != null)
                Expanded(
                  flex: 3,
                  child: Image.network(
                    _imageUrl!,
                    fit: BoxFit.cover,
                  ),
                ),
              if (_questionsData['questionType'] == 'fillMap')
                Expanded(
                  flex: 2,
                  child: _buildFillMapQuestions(),
                ),
              if (_questionsData['questionType'] != 'fillMap')
                Expanded(
                  flex: 5,
                  child: ListView.builder(
                    itemCount: _questionsData['questions']?.length ?? 0,
                    itemBuilder: (context, index) {
                      final question = _questionsData['questions'][index];
                      return ListTile(
                        title: Text(question['question']),
                        subtitle: Text('Answer: ${question['answer']}'),
                      );
                    },
                  ),
                ),
            ],
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

  Widget _buildFillMapQuestions() {
    final blanks = _questionsData['blanks'] as List<dynamic>;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: blanks.length,
            itemBuilder: (context, index) {
              final blank = blanks[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${blank['id']}. ${blank['correctAnswer']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(width: 10),
                    DragTarget<String>(
                      onAccept: (receivedItem) {
                        setState(() {
                          _draggedAnswers[blank['id']] = receivedItem;
                        });
                      },
                      builder: (context, acceptedItems, rejectedItems) {
                        return Container(
                          width: 100,
                          height: 40,
                          color: Colors.grey[200],
                          child: Center(
                            child: Text(
                              _draggedAnswers[blank['id']] ?? blank['placeholder'],
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: blanks.map((blank) {
            return Draggable<String>(
              data: blank['label'],
              feedback: Material(
                child: Container(
                  width: 50,
                  height: 40,
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      blank['label'],
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              childWhenDragging: Container(
                width: 50,
                height: 40,
                color: Colors.grey,
                child: Center(
                  child: Text(
                    blank['label'],
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
              child: Container(
                width: 50,
                height: 40,
                color: Colors.green,
                child: Center(
                  child: Text(
                    blank['label'],
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
