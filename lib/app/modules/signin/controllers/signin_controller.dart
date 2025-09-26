import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:only_u/app/services/auth_service.dart';

class SigninController extends GetxController {
  var termsAndConditionsChecked = false.obs;
  var isLoading = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService authService = AuthService();

  void updateTermsAndConditionsValue(bool v) {
    termsAndConditionsChecked.value = v;
  }

  void signIn() async {
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

    var user = await authService.login(email, password);
    if (user != null) {
      Get.snackbar("Success", "Logged in successfully");
      // Navigate to home or dashboard
      Get.offAllNamed('/main');
    } else {
      Get.snackbar("Error", "Login failed. Please check your credentials.");
    }
    isLoading.value = false;
  }
}
