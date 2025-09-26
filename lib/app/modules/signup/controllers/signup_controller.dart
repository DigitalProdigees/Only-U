import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:only_u/app/services/auth_service.dart';

class SignupController extends GetxController {
  var termsAndConditionsChecked = false.obs;
  var isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

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

  void updateTermsAndConditionsValue(bool v) {
    termsAndConditionsChecked.value = v;
  }

  void signUp() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Email and Password cannot be empty");
      return;
    }

    if (!termsAndConditionsChecked.value) {
      Get.snackbar("Error", "You must accept the terms and conditions");
      return;
    }
    isLoading.value = true;

    var user = await authService.signUp(email, password);
    if (user != null) {
      Get.snackbar("Success", "Account created successfully");
      // Navigate to home or dashboard
      Get.offAllNamed('/home'); // Adjust route as necessary
    } else {
      Get.snackbar("Error", "Sign Up failed. Please try again.");
    }
    isLoading.value = false;
  }
}
