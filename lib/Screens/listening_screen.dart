import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../Services/firebase_storage_service.dart';

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  @override
  _ListeningScreenState createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final FirebaseStorageService _storageService = FirebaseStorageService();

  Future<void> _playAudio(String url) async {
    await _audioPlayer.setSourceUrl(url);
    _audioPlayer.resume();
  }

  Future<void> _loadAndPlay(String gsUrl) async {
    final url = await _storageService.getAudioUrl(gsUrl);
    _playAudio(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listening Practice'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => _loadAndPlay('gs://ielts-gym-edbdf.appspot.com/audios/Test1/Section 1.mp3'),
            child: Text('Play Section 1'),
          ),
          ElevatedButton(
            onPressed: () => _loadAndPlay('gs://ielts-gym-edbdf.appspot.com/audios/Test1/Section 2.mp3'),
            child: Text('Play Section 2'),
          ),
        ],
      ),
    );
  }
}
