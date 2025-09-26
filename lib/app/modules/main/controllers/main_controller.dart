import 'package:get/get.dart';
import 'package:only_u/app/services/auth_service.dart';

class MainController extends GetxController {
  var isLoading = false.obs;
  final AuthService authService = AuthService();

  Future<void> signOut() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    await authService.logout();
    isLoading.value = false;
    Get.offAllNamed('/splash');
  }
}
