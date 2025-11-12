import 'package:get/get.dart';
import 'package:only_u/app/services/user_service.dart';

class ConnectionsController extends GetxController {
  var tabIndex = 0.obs;
  var loading = false.obs;
  var connections = [].obs;

  Future<void> loadConnections() async {
    final connectionType = tabIndex.value == 0 ? 'followers' : 'following';
    loading.value = true;
    final response = await UserService().getFollowingOrFollowers(
      connectionType: connectionType,
    );
    connections.clear();
    connections.addAll(response.Data);
    loading.value = false;
  }

  @override
  void onInit() {
    // loadConnections();
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
