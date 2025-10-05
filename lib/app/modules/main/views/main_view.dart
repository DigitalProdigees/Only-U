import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_u/app/common/widgets/PostView.dart';
import 'package:only_u/app/data/constants.dart';
import 'package:only_u/app/data/models/post_model.dart';
import 'package:only_u/app/modules/otherUserProfile/controllers/other_user_profile_controller.dart';
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  MainView({super.key});

  final otherUSerProfileController = Get.put(OtherUserProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,

        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildAppBar(),
                SizedBox(height: 20),
                _buildSearchButton(),
                SizedBox(height: 20),
                _buildCategoryHorizontListView(),
                SizedBox(height: 20),
                Obx(() => _buildTabView()),
                SizedBox(height: 20),
                SizedBox(height: 10),
                _buildCaroselView(),
                SizedBox(height: 20),
                _buildHighlightView(),
                SizedBox(height: 10),
                _buildPostsListView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello ,',
              style: GoogleFonts.oleoScript(
                textStyle: TextStyle(color: Color(0xFFFF3080), fontSize: 24),
              ),
            ),
            Obx(
              () => Text(
                "${controller.currentUserProfile['name'].toString().split(' ').first ?? "Name"}",
                style: GoogleFonts.rubik(
                  textStyle: TextStyle(
                    color: Color(0xFFE7F6FF),
                    fontSize: 18,
                    fontFamily: 'Rubik',
                    height: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 42,
              height: 42,
              child: Image.asset('assets/imgs/notification.png'),
            ),
            SizedBox(
              width: 42,
              height: 42,
              child: Image.asset('assets/imgs/heart.png'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchButton() {
    return SvgPicture.asset(
      'assets/imgs/search_view.svg',
      width: double.infinity,
      height: 48,
    );
  }

  Widget _buildCategoryHorizontListView() {
    return SizedBox(
      width: Get.size.width,
      height: 42, // Set a fixed height for the horizontal ListView
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SvgPicture.asset(
              'assets/imgs/category_menu.svg',
              height: 40,
            );
          }

          return _buildCategoryIndividualView(categories[index - 1]);
        },
        separatorBuilder: (context, index) => Container(width: 5),
        itemCount: categories.length + 1, // +1 for the menu icon
      ),
    );
  }

  Widget _buildCategoryIndividualView(dynamic category) {
    return InkWell(
      onTap: () {
        controller.currentPostsPage = 1;
        controller.posts.clear();
        controller.currentCategoryId = category['id'] as String;
        controller.loadPosts();
      },
      child: Container(
        width: 85,
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              strokeAlign: BorderSide.strokeAlignOutside,
              color: Colors.white.withOpacity(0.10000000149011612),
            ),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              category['name'] as String,
              style: TextStyle(
                color: Color(0xFFE7F6FF),
                fontSize: 14,
                fontFamily: 'Rubik',
                height: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView() {
    return Column(
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          decoration: ShapeDecoration(
            color: Color(0x7F122C58),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    debugPrint("My Feed tapped");
                    controller.tabIndex.value = 0;
                  },
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                    decoration: controller.tabIndex.value == 0
                        ? ShapeDecoration(
                            color: Color(0x3FAC2458),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.50,
                                color: Color(0xFFFF3080),
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          )
                        : ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'My feed',
                          style: TextStyle(
                            color: Color(0xFFFFF7FA),
                            fontSize: 16,
                            fontFamily: 'Rubik',
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    debugPrint("All tapped");
                    controller.tabIndex.value = 1;
                  },
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: controller.tabIndex.value == 1
                        ? ShapeDecoration(
                            color: Color(0x3FAC2458),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1.50,
                                color: Color(0xFFFF3080),
                              ),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          )
                        : ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'All',
                          style: TextStyle(
                            color: Color(0xFFE7F6FF),
                            fontSize: 16,
                            fontFamily: 'Rubik',
                            height: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCaroselItem(String imagePath) {
    return Stack(
      children: [
        Container(
          width: 300,
          height: 180,
          decoration: ShapeDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.00, -1.00),
              end: Alignment(0, 1),
              colors: [Colors.black.withOpacity(0), Colors.black],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
        ),
        Positioned(
          top: 10,
          right: 20,
          child: SizedBox(
            height: 28,
            width: 28,
            child: Image.asset('assets/imgs/heart_white.png'),
          ),
        ),
      ],
    );
  }

  Widget _buildCaroselView() {
    return Obx(
      () => Column(
        children: [
          CarouselSlider(
            items: [
              _buildCaroselItem('assets/imgs/caurosel1.png'),
              _buildCaroselItem('assets/imgs/caurosel2.png'),
              _buildCaroselItem('assets/imgs/caurosel1.png'),
            ],

            // imageList.map((url) {
            //   return Image.network(
            //     url,
            //     fit: BoxFit.cover,
            //     width: double.infinity,
            //   );
            // }).toList(),
            options: CarouselOptions(
              height: 180,
              autoPlay: true,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                controller.caroselIndex.value = index;
              },
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: controller.caroselImages.asMap().entries.map((entry) {
              return Container(
                width: 10.0,
                height: 10.0,
                margin: EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: controller.caroselIndex.value == entry.key
                      ? Color(0xFFFF3181)
                      : Color(0xFFFF3181).withOpacity(0.3),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightView() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Highlights',
        style: GoogleFonts.oleoScript(
          textStyle: TextStyle(color: Color(0xFFFFF7FA), fontSize: 32),
        ),
      ),
    );
  }

  Widget _buildPostsListView() {
    return Obx(() {
      if (controller.posts.isEmpty) {
        return Center(
          child: Text(
            'No posts available',
            style: TextStyle(color: Colors.white),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final post = PostModel.fromJson(controller.posts[index]);
          if (index == controller.posts.length - 1) {
            // Load more posts when reaching the end of the list
            // controller.currentPostsPage += 1;
            // controller.loadPosts();
          }
          return PostView(
            post: post,
            onUserNameTap: () {
              // Navigate to user profile page
              otherUSerProfileController.otherUserId = post.userId;
              otherUSerProfileController.checkFollowingStatus();
              Get.toNamed(
                '/other-user-profile',
                arguments: {'userId': post.userId},
              );
            },
          );
        },
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: controller.posts.length,
      );
    });
  }
}
