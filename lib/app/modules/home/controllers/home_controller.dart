import 'package:get/get.dart';
import 'package:only_u/app/services/google_sign_in_service.dart';

class HomeController extends GetxController {
  final GoogleSignInService googleSignInService = GoogleSignInService();

  void googleSignIn() async {
    final user = await googleSignInService.signInWithGoogle();
    if (user != null) {
      Get.snackbar('Success', 'Signed in as ${user.displayName}');
      Get.offAllNamed('/main');
      // Navigate to the next screen or update UI accordingly
    } else {
      Get.snackbar('Error', 'Google sign-in failed or was canceled');
    }
  }
}
