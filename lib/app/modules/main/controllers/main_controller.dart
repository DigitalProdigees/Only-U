import 'package:get/get.dart';
import 'package:only_u/app/services/auth_service.dart';

class MainController extends GetxController {
  var isLoading = false.obs;
  final AuthService authService = AuthService();
  var tabIndex = 0.obs;
  var caroselIndex = 0.obs;
  final List<String> caroselImages = [
    'https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg',
    'https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg',
    'https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg',
  ];

  Future<void> signOut() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    await authService.logout();
    isLoading.value = false;
    Get.offAllNamed('/splash');
  }
}
