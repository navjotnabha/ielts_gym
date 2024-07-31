import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> getAudioUrl(String gsUrl) async {
    // Extract the path from the gs:// URL
    String filePath = gsUrl.replaceFirst('gs://ielts-gym-edbdf.appspot.com/', '');
    return await _storage.ref(filePath).getDownloadURL();
  }
}
