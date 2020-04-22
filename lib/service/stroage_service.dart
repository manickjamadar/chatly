import 'dart:io';

import 'package:chatly/helpers/failure.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  static Future<String> uploadImage(String filePath, File imageFile) async {
    try {
      StorageReference ref = FirebaseStorage.instance.ref().child(filePath);
      StorageUploadTask task = ref.putFile(imageFile);
      final snapshot = await task.onComplete;
      final String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (error) {
      throw Failure.public("Uploading image is failed");
    }
  }
}
