import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:only_u/app/data/constants.dart';
import 'package:only_u/app/services/user_service.dart';

class OtherUserProfileController extends GetxController {
  var isFollowing = false.obs;
  var followers = 0.obs;
  var postsCount = 0.obs;
  var following = 0.obs;
  var otherUserId = "";
  var userName = "".obs;
  var description = "".obs;
  var email = "".obs;
  var otherUserAvator = defaultAvatorUrl.obs;
  var loadingOtherUserProfile = false.obs;
  var postsImages = [].obs;
  var loadingChat = false.obs;


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

  Future<void> getOtherUserStats(String userID) async {
    loadingOtherUserProfile.value = true;
    final response = await UserService().getOtherUserStats(userId: userID);
    if (response.Status == "success") {
      // Handle success (e.g., update UI, show a message)
      debugPrint("Successfully fetched other user stats.");
      followers.value = response.Data['followersCount'] ?? 0;
      following.value = response.Data['followingCount'] ?? 0;
      postsCount.value = response.Data['postsCount'] ?? 0;
      otherUserAvator.value = response.Data['avator'] ?? defaultAvatorUrl;
      userName.value = response.Data['userName'];
      email.value = response.Data['email'] ?? "";
      description.value = response.Data['description'] ?? "";
      final postsMedia = response.Data['postsMedia'] as List;
      postsImages.value = postsMedia
          .map((postMedea) => extractPostImage(postMedea))
          .toList();
    } else {
      // Handle error (e.g., show an error message)
      debugPrint("Error fetching other user stats: ${response.Message}");
    }
    loadingOtherUserProfile.value = false;
  }

  String extractPostImage(Map postMedia) {
    if (postMedia['type'] == 'image') {
      return postMedia['url'];
    } else {
      return postMedia['thumbnailURL'];
    }
  }
}
