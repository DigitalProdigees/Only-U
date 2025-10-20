import 'package:get/get.dart';

import '../controllers/createpost_controller.dart';

class CreatepostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreatepostController>(
      () => CreatepostController(),
    );
  }
}
