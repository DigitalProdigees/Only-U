import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:only_u/app/data/constants.dart';
import 'package:only_u/app/services/media_service.dart';
import 'package:only_u/app/services/user_service.dart';

class ProfileController extends GetxController {
  var showMenu = false.obs;
  var currntUserProfile = {}.obs;
  var avator = defaultAvatorUrl.obs;
  var loading = false.obs;
  var avatorUploading = false.obs;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  void toggleMenu() {
    showMenu.value = !showMenu.value;
  }

  Future<void> loadCurrentUserProfile() async {
    final userProfile = await UserService().getCurrentUserProfile();
    if (userProfile != null) {
      currntUserProfile.value = userProfile;
      nameController.text = userProfile['name'] ?? '';
      descriptionController.text = userProfile['description'] ?? '';
      emailController.text = userProfile['email'] ?? '';
      phoneController.text = userProfile['mobile'] ?? '';
      genderController.text = userProfile['gender'] ?? '';
      skillsController.text = userProfile['skills'] ?? '';
      avator.value = userProfile['avator'] ?? '';
      update();
    }
  }

  Future<void> updateAvator() async {
    avatorUploading.value = true;
    update();
    final resultUrl = await MediaUploadService().uploadImage();
    if (resultUrl != null) {
      avator.value = resultUrl;
    }
    avatorUploading.value = false;
    update();
  }

  Future<void> onUpdateTapped() async {
    loading.value = true;

    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        phoneController.text.isEmpty ||
        emailController.text.isEmpty ||
        genderController.text.isEmpty ||
        skillsController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
      );
      loading.value = false;
      return;
    }

    await Future.delayed(Duration(seconds: 3));

    final updatedData = {
      "name": nameController.text,
      "description": descriptionController.text,
      "mobile": phoneController.text,
      "gender": genderController.text,
      "skills": skillsController.text,
      "avator": avator.value,
    };
    final success = await UserService().updateUserProfile(updatedData);
    if (success) {
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      await loadCurrentUserProfile();
    } else {
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    loading.value = false;
  }

  Future<void> onLogoutTapped() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/splash');
  }

  @override
  void onInit() {
    loadCurrentUserProfile();
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
}
