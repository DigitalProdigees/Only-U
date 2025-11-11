import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class MediaUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadMedia(
    File file,
    String folder,
    bool isVideoType,
  ) async {
    try {
      String fileName = basename(file.path);
      Reference ref = _storage.ref().child('$folder/$fileName');
      final metadata = SettableMetadata(
        contentType: isVideoType ? 'video/mp4' : 'image/jpeg',
      );
      UploadTask uploadTask = ref.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      debugPrint('Upload failed: $e');
      return null;
    }
  }

  /// Upload an image file to Firebase Storage
  Future<String?> uploadImage() async {
    try {
      String? userId = FirebaseAuth.instance.currentUser?.uid;
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image == null) return null;

      Reference ref = _storage.ref().child(
        "user_uploads/$userId/${DateTime.now().millisecondsSinceEpoch}.jpg",
      );
      UploadTask uploadTask = ref.putFile(File(image.path));

      await uploadTask.whenComplete(() => null);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return null;
    }
  }
}
