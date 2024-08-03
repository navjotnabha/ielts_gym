import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

class FirebaseService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<Map<String, dynamic>> fetchSectionData(String testFolder, String sectionFolder) async {
    try {
      final Reference dataRef = _storage.ref().child('$testFolder/$sectionFolder/data.json');
      final String dataUrl = await dataRef.getDownloadURL();
      final response = await http.get(Uri.parse(dataUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // Add the image URL if imagePath exists
        if (data['imagePath'] != null) {
          final Reference imageRef = _storage.ref().child('$testFolder/$sectionFolder/${data['imagePath']}');
          data['imageUrl'] = await imageRef.getDownloadURL();
        }

        // Add the audio URL if audioPath exists
        if (data['audioPath'] != null) {
          final Reference audioRef = _storage.ref().child('$testFolder/$sectionFolder/${data['audioPath']}');
          data['audioUrl'] = await audioRef.getDownloadURL();
        }

        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}
