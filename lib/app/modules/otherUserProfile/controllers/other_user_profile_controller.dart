import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:only_u/app/services/user_service.dart';

class OtherUserProfileController extends GetxController {
  var isFollowing = false.obs;
  var followers = 0.obs;
  var postsCount = 13.obs;
  var following = 0.obs;
  var otherUserId = "";

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> followUser({required String followingId}) async {
    final response = await UserService().followOtherUser(
      followingId: followingId,
    );
    if (response.Status == "success") {
      // Handle success (e.g., update UI, show a message)
      debugPrint("Successfully followed the user.");
      isFollowing.value = response.Data['followed'] ?? true;
      followers.value = response.Data['followersCount'] ?? followers.value;
    } else {
      // Handle error (e.g., show an error message)
      debugPrint("Error following user: ${response.Message}");
    }
  }

  Future<void> checkFollowingStatus() async {
    final response = await UserService().checkUserFollowinStatus(
      followingUserId: otherUserId,
    );
    if (response.Status == "success") {
      // Handle success (e.g., update UI, show a message)
      debugPrint("Successfully fetched following status.");
      isFollowing.value = response.Data['isFollowing'] ?? false;
    } else {
      // Handle error (e.g., show an error message)
      debugPrint("Error fetching following status: ${response.Message}");
    }
  }
}
