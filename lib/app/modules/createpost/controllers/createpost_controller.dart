import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:only_u/app/services/media_service.dart';
import 'package:only_u/app/services/posts_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class CreatepostController extends GetxController {
  final TextEditingController tagInputcontroller = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final ImagePicker picker = ImagePicker();
  final MediaUploadService uploadService = MediaUploadService();

  var tags = [].obs;
  var pickedFilePath = '';
  var loading = false.obs;
  var isVideoType = false;
  var mainMediaUrl = '';
  String? thumbnailUrl = '';

  Future<void> pickMedia(ImageSource source, bool isVideo) async {
    final XFile? pickedFile = isVideo
        ? await picker.pickVideo(source: source)
        : await picker.pickImage(source: source);

    if (pickedFile != null) {
      pickedFilePath = pickedFile.path;
      isVideoType = isVideo;
      debugPrint('Picked File Path: ${pickedFile.path}');
    }
  }

  Future<void> onUploadTapped() async {
    final validatinResult = validateForm();
    if (validatinResult) {
      loading.value = true;
      File file = File(pickedFilePath);
      String folder = isVideoType ? 'videos' : 'images';
      String? url = await uploadService.uploadMedia(file, folder);
      debugPrint('Main Media Uploaded : $url');
      if (url != null || url!.isNotEmpty) {
        mainMediaUrl = url;
        //if media type is video then generating and saving the thumbnail
        if (isVideoType) {
          final thumbnail = await generateThumbnail();
          thumbnailUrl = await uploadService.uploadMedia(thumbnail!, 'images');

          debugPrint('Thunmnail Upload Url: $thumbnailUrl');
        }

        await createPost();
      }

      loading.value = false;
    }
  }

  bool validateForm() {
    if (pickedFilePath.isEmpty) {
      Get.snackbar('Error', 'Please Select Media First');
      return false;
    } else if (descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Please Enter Description');
      return false;
    }
    return true;
  }

  Future<void> createPost() async {
    final requestBody = {
      "userId": FirebaseAuth.instance.currentUser!.uid,
      "categoryId": "JuqjwnzTRo6B3r3g1eeH",
      "description": descriptionController.text,
      "media": [
        {
          "type": isVideoType ? "video" : "image", //video or images
          "url": mainMediaUrl,
          "thumbnailURL": isVideoType ? thumbnailUrl : null,
          //todo real time paramters to be used
          "duration": 30, // duration in seconds
          "aspectRatio": 1.7777, // height/width
        },
      ],
      "tags": tags,
      "privacy": "public",
    };

    final response = await PostsService().createPost(requestBody: requestBody);
    if (response.Status == 'success') {
      Get.snackbar('Post Created', 'Your content is created and published');
      descriptionController.clear();
      tags.clear();
    } else {
      debugPrint('Error While Creating new post: ${response.Message}');
      Get.snackbar('Error', response.Message!);
    }
  }

  Future<File?> generateThumbnail() async {
    try {
      final String? filePath = await VideoThumbnail.thumbnailFile(
        video: pickedFilePath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 128,
        quality: 25,
        thumbnailPath: (await getTemporaryDirectory()).path,
      );

      if (filePath != null) {
        return File(filePath);
      } else {
        return null;
      }
    } catch (e) {
      debugPrint('Thumbnail generation failed: $e');
      return null;
    }
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void addTag(String tag) {
    if (tag.isNotEmpty && !tags.contains(tag)) {
      tags.add(tag);
      tagInputcontroller.clear();
    }
  }

  void removeTag(String tag) {
    tags.remove(tag);
  }
}
