import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:only_u/app/data/constants.dart';
import 'package:only_u/app/modules/profile/controllers/profile_controller.dart';
import 'package:shimmer/shimmer.dart';

import '../../../services/one_to_one_chat_service.dart';
import '../../chat/one_to_one_chat_page.dart';
import '../controllers/other_user_profile_controller.dart';

class OtherUserProfileView extends GetView<OtherUserProfileController> {
  OtherUserProfileView({super.key});
  final String userId = Get.arguments['userId'];
  final OneToOneChatService _chatService = OneToOneChatService();
  final ProfileController profileController = Get.find<ProfileController>();

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
              _buildPostsGridView(context),
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
      title: Obx(
        () => Text(
          controller.userName.value,
          style: normalBodyStyle.copyWith(fontSize: 20),
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
              _buildAvatorPart(),
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
                      style: normalBodyStyle,
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        controller.postsCount.value.toString(),
                        textAlign: TextAlign.center,
                        style: normalBodyStyle.copyWith(fontSize: 18),
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
                      style: normalBodyStyle,
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => Text(
                        controller.followers.value.toString(),
                        textAlign: TextAlign.center,
                        style: normalBodyStyle.copyWith(
                          fontSize: 18,
                          color: Color(0xFFFF3081),
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
                    style: normalBodyStyle,
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      controller.following.value.toString(),
                      textAlign: TextAlign.center,
                      style: normalBodyStyle.copyWith(
                        fontSize: 18,
                        color: Color(0xFFFF3081),
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

  Widget _buildAvatorPart() {
    return StatusAvatar(
      size: 60,
      imageUrl: controller.otherUserAvator.value,
      isOnline: true,
      borderColor: Colors.white,
    );
  }

  Widget _buildUserNameTv() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Obx(
        () => Text(
          '@${controller.email.value}',
          style: normalBodyStyle.copyWith(color: secondaryColor),
        ),
      ),
    );
  }

  Widget _buildBio() {
    return SizedBox(
      width: 343,
      height: 60,
      child: Obx(
        () => Text(controller.description.value, style: normalBodyStyle),
      ),
    );
  }

  Widget _buildButtonsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            debugPrint('On Messages Tapped');
            //Todo
            startChat(userId, controller.userName.value);
          },
          child: SizedBox(
            height: 42,
            child: SvgPicture.asset('assets/imgs/message.svg'),
          ),
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

  Future<void> startChat(String contactId, String contactName) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) return;

    try {
      final chatId = await _chatService.createChatIfNotExists(
        userId1: currentUserId,
        userId2: contactId,
        avatorUser1: profileController.avator.value,
        currentUserName: profileController.nameController.text,
        oppositeUserName: contactName,
      );
      if (chatId != null) {
        Get.to(() => OneToOneChatPage(chatID: chatId, chatName: contactName));
      }
    } catch (e) {
      debugPrint("Error starting chat: $e");
      Get.snackbar('Error', 'Failed to start chat: ${e.toString()}');
    }
  }

  Widget _buildPostsGridView(BuildContext context) {
    final double itemSize = MediaQuery.of(context).size.width / 3;
    return Expanded(
      child: Obx(
        () => GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1, // width = height
          ),
          itemCount: controller.postsImages.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: itemSize,
              width: itemSize,
              child: CachedNetworkImage(
                imageUrl: controller.postsImages[index],
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade100,
                  child: Container(
                    width: double.infinity,
                    height: 240,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
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
            Text('Following', style: normalBodyStyle.copyWith(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class StatusAvatar extends StatelessWidget {
  final double size;
  final String? imageUrl;
  final bool isOnline;
  final Color onlineColor;
  final Color offlineColor;
  final Color borderColor;

  const StatusAvatar({
    super.key,
    this.size = 56,
    this.imageUrl,
    required this.isOnline,
    this.onlineColor = Colors.green,
    this.offlineColor = Colors.grey,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Circular avatar
          ClipOval(
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl!,
                    width: size,
                    height: size,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: size,
                    height: size,
                    color: Colors.blueGrey.shade200,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person,
                      size: size * 0.55,
                      color: Colors.white,
                    ),
                  ),
          ),

          // Status dot (top-right)
          Positioned(
            right: -1,
            top: -1,
            child: Container(
              width: size * 0.2,
              height: size * 0.2,
              decoration: BoxDecoration(
                color: isOnline ? onlineColor : offlineColor,
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: size * 0.01),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
