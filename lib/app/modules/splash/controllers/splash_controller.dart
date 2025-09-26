import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 3), () {
      navigateBasedOnAuth();
    });
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

  Future<void> navigateBasedOnAuth() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is already logged in
      Get.offAllNamed('/main');
    } else {
      // User not logged in
      Get.offAllNamed('/home');
    }
  }
}
