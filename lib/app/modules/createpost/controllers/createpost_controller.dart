import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:only_u/app/services/media_service.dart';
import 'package:only_u/app/services/posts_service.dart';
import 'package:video_compress/video_compress.dart';


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
      String? url;
      File selectedFile = File(pickedFilePath);
      String folder = isVideoType ? 'videos' : 'images';

      if (isVideoType) {
        final compressedMediaInfo = await compressVideo(pickedFilePath);
        url = await uploadService.uploadMedia(
          compressedMediaInfo!.file!,
          folder,
        );

        if (url != null || url!.isNotEmpty) {
          debugPrint('Video Uploaded : $url');
          mainMediaUrl = url;
          final thumbnail = await generateThumbnail();
          thumbnailUrl = await uploadService.uploadMedia(thumbnail!, 'images');
          debugPrint('Thunmnail Upload Url: $thumbnailUrl');
          await createPost(
            duration: compressedMediaInfo.duration!.toInt(),
            aspectRatio:
                (compressedMediaInfo.height! / compressedMediaInfo.width!),
          );
        }
      } else {
        url = await uploadService.uploadMedia(selectedFile, 'images');
        debugPrint('Image Uploaded Url: $thumbnailUrl');
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

  Future<void> createPost({int? duration, double? aspectRatio}) async {
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
          "duration": duration, // duration in seconds
          "aspectRatio": aspectRatio, // height/width
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
    final thumbnailFile = await VideoCompress.getFileThumbnail(
      pickedFilePath,
      quality: 50, // default(100)
      position: -1, // default(-1)
    );
    return thumbnailFile;
  }

  Future<MediaInfo?> compressVideo(String videoPath) async {
    try {
      // Optional: show compression progress
      // VideoCompress.compressProgress$.subscribe((progress) {
      //   debugPrint('Compression progress: $progress%');
      // });

      final MediaInfo? compressedVideo = await VideoCompress.compressVideo(
        videoPath,
        quality:
            VideoQuality.MediumQuality, // Options: Low, Medium, High, Default
        deleteOrigin:
            false, // Set to true to delete the original file after compression
      );
      return compressedVideo;
    } catch (e) {
      debugPrint('Video compression failed: $e');
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
