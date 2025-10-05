import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_u/app/data/constants.dart';

import '../controllers/other_user_profile_controller.dart';

class OtherUserProfileView extends GetView<OtherUserProfileController> {
  OtherUserProfileView({super.key});
  final String userId = Get.arguments['userId'];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: _buildAppBar(),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUpperRow(),
              _buildUserNameTv(),
              SizedBox(height: 10),
              _buildBio(),
              SizedBox(height: 20),
              _buildButtonsRow(),
              SizedBox(height: 10),
              _buildGridView(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Get.back();
        },
      ),
      title: Text(
        'Brooklyn Simmons',
        style: GoogleFonts.rubik(
          textStyle: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildUpperRow() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10),
          height: 98,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(546.88),
                  ),
                ),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset('assets/imgs/avator.png'),
                ),
              ),
              const SizedBox(width: 2),

              Container(
                // width: 66,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Posts',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        controller.postsCount.value.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFF3081),
                          fontSize: 18,
                          fontFamily: 'Rubik',
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                // width: 75.67,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Followers',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        controller.followers.value.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFFF3081),
                          fontSize: 18,
                          fontFamily: 'Rubik',
                          height: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Following',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.rubik(
                      textStyle: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      controller.following.value.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFF3081),
                        fontSize: 18,
                        fontFamily: 'Rubik',
                        height: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserNameTv() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '@simmlove',
        style: GoogleFonts.rubik(
          textStyle: TextStyle(color: secondaryColor, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildBio() {
    return SizedBox(
      width: 343,
      height: 60,
      child: Text(
        '🌟 Brooklyn Simmons 🌟\nModel | Dreamer | Wanderer\n📍 NYC | LA | ✈️ Everywhere',
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Rubik',
        ),
      ),
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 42,
          child: SvgPicture.asset('assets/imgs/message.svg'),
        ),
        Obx(
          () => FollowFollowingButton(
            isFollowing: controller.isFollowing.value,
            onTap: () {
              controller.followUser(followingId: userId);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildGridView() {
    return ThreeColumnGrid();
  }
}

class FollowFollowingButton extends StatelessWidget {
  FollowFollowingButton({super.key, this.isFollowing = false, this.onTap});

  void Function()? onTap;
  bool isFollowing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isFollowing
          ? DoneFollowing()
          : SizedBox(
              height: 50,
              width: Get.width * 0.4,
              child: SvgPicture.asset('assets/imgs/follow_red.svg'),
            ),
    );
  }
}

class DoneFollowing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.4,
      height: 42,
      decoration: ShapeDecoration(
        color: Color(0xFFFF3080),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(500)),
      ),
      child: Container(
        height: 50,
        // padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        decoration: ShapeDecoration(
          color: Color(0x3FAC2458),
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1.50, color: Color(0xFFFF3080)),
            borderRadius: BorderRadius.circular(50),
          ),
          shadows: [
            BoxShadow(
              color: Color(0xFFFF3181),
              blurRadius: 16,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Following',
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
    );
  }
}

class ThreeColumnGrid extends StatelessWidget {
  final List<String> imageUrls = [
    'https://images.pexels.com/photos/2065203/pexels-photo-2065203.jpeg',
    'https://images.pexels.com/photos/2065200/pexels-photo-2065200.jpeg',
    'https://images.pexels.com/photos/1468379/pexels-photo-1468379.jpeg',
    'https://images.pexels.com/photos/160599/beauty-leather-style-girl-160599.jpeg',
    'https://images.pexels.com/photos/1162983/pexels-photo-1162983.jpeg',
    'https://images.pexels.com/photos/2169434/pexels-photo-2169434.jpeg',
    'https://images.pexels.com/photos/2613260/pexels-photo-2613260.jpeg',
    'https://images.pexels.com/photos/2744193/pexels-photo-2744193.jpeg',
    'https://images.pexels.com/photos/732425/pexels-photo-732425.jpeg',
  ];

  @override
  Widget build(BuildContext context) {
    final double itemSize = MediaQuery.of(context).size.width / 3;

    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1, // width = height
        ),
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(3),
            width: itemSize,
            height: itemSize,
            child: Image.network(imageUrls[index], fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
