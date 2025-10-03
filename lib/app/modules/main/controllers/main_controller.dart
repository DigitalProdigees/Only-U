import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:only_u/app/data/constants.dart';
import 'package:only_u/app/services/auth_service.dart';
import 'package:only_u/app/services/posts_service.dart';

class MainController extends GetxController {
  var isLoading = false.obs;
  final AuthService authService = AuthService();
  var tabIndex = 0.obs;
  var caroselIndex = 0.obs;
  var posts = [].obs;
  var currentPostsPage = 1;
  var currentCategoryId = categories[0]['id']!.toString();
  final List<String> caroselImages = [
    'https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg',
    'https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg',
    'https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg',
  ];

  void onInit() {
    loadPosts();
    super.onInit();
  }

  Future<void> loadPosts() async {
    final resp = await PostsService().getPosts(
      page: currentPostsPage,
      limit: 10,
      // userId: authService.currentUser?.uid ?? '',
      userId: 'user1235',
      categoryId: currentCategoryId,
    );
    if (resp.Status == "success") {
      debugPrint("Posts loaded successfully: ${resp.Data}");
      posts.addAll(resp.Data);
    } else {
      debugPrint("Error loading posts: ${resp.Message}");
    }
  }

  Future<void> signOut() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 2));
    await authService.logout();
    isLoading.value = false;
    Get.offAllNamed('/splash');
  }
}
