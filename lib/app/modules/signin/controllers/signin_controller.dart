import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SigninController extends GetxController {
  //TODO: Implement SigninController

  var termsAndConditionsChecked = false.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
}
