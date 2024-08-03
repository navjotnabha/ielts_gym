import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<List<Map<String, dynamic>>> fetchSectionData(String testFolder, String sectionFolder) async {
    try {
      final Reference dataRef = _storage.ref().child('$testFolder/$sectionFolder/data.json');
      final String dataUrl = await dataRef.getDownloadURL();
      final response = await http.get(Uri.parse(dataUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }

  Future<String> fetchAudioUrl(String testFolder, String sectionFolder) async {
    try {
      final Reference audioRef = _storage.ref().child('$testFolder/$sectionFolder/audio.mp3');
      final String audioUrl = await audioRef.getDownloadURL();
      return audioUrl;
    } catch (e) {
      throw Exception('Failed to fetch audio URL: $e');
    }
  }

  Future<String?> fetchImageUrl(String testFolder, String sectionFolder) async {
    try {
      final Reference imageRef = _storage.ref().child('$testFolder/$sectionFolder/image.jpg');
      final String imageUrl = await imageRef.getDownloadURL();
      return imageUrl;
    } catch (e) {
      // If image not found, return null
      return null;
    }
  }
}
