import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class MediaUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadMedia(File file, String folder) async {
    try {
      String fileName = basename(file.path);
      Reference ref = _storage.ref().child('$folder/$fileName');
      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Upload failed: $e');
      return null;
    }
  }
}
