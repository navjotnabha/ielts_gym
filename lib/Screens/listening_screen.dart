import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:ielts_gym/services/firebase_service.dart';
import 'package:ielts_gym/widgets/question_widget.dart';

class ListeningScreen extends StatefulWidget {
  @override
  _ListeningScreenState createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  late AudioPlayer _audioPlayer;
  String? _audioUrl;
  String? _imageUrl;
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
      final sectionData = await _firebaseService.fetchSectionData('listening_material/test_1', 'section$_currentSection');

      setState(() {
        _questionsData = sectionData['questionData'];
        _audioUrl = sectionData['audioUrl'];
        _imageUrl = sectionData['imageUrl'];
        _isLoading = false;
      });
      _playAudio();
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
          if (_imageUrl != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Image.network(_imageUrl!),
            ),
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
