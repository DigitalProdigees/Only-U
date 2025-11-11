import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:only_u/app/data/constants.dart';
import '../../../common/widgets/VerticalMargin.dart';
import '../controllers/profile_controller.dart';
import 'profile_editing_view.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildAppBar(),

              Obx(
                () => controller.showMenu.value
                    ? _buildMenu()
                    : _buildProfileView(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatorPart(),
          _buildLabel('Name'),
          VerticalMargin(),
          _buildTextView('name'),
          VerticalMargin(),
          _buildLabel('Description'),
          VerticalMargin(),
          _buildTextView('description'),
          VerticalMargin(),
          _buildLabel('Mobile'),
          VerticalMargin(),
          _buildTextView('mobile'),
          VerticalMargin(),
          _buildLabel('Email'),
          VerticalMargin(),
          _buildTextView('email'),
          VerticalMargin(),
          _buildLabel('Gender'),
          VerticalMargin(),
          _buildTextView('gender'),
          VerticalMargin(),
          _buildLabel('Skills'),
          VerticalMargin(),
          _buildTextView('skills'),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        Obx(
          () => controller.showMenu.value
              ? IconButton(
                  onPressed: controller.toggleMenu,
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                )
              : SizedBox(),
        ),
        SizedBox(width: 10),
        Text(
          'Profile Details',
          style: normalBodyStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Spacer(),
        Obx(
          () => controller.showMenu.value
              ? SizedBox()
              : GestureDetector(
                  onTap: controller.toggleMenu,
                  child: SizedBox(
                    child: SvgPicture.asset('assets/imgs/profileMenu.svg'),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildAvatorPart() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: 98,
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(546.88),
          ),
          shadows: [
            BoxShadow(
              color: Color(0x3FFFFFFF),
              blurRadius: 17.50,
              offset: Offset(0, 0),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Obx(
          () => Container(
            width: 100,
            height: 147,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(controller.avator.value),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: normalBodyStyle.copyWith(fontSize: 16, color: secondaryColor),
    );
  }

  Widget _buildTextView(String keyName) {
    return Obx(
      () => Text(
        controller.currntUserProfile[keyName] ?? '',
        textAlign: TextAlign.start,
        style: normalBodyStyle.copyWith(fontSize: 16, color: Colors.white),
        maxLines: 3,
      ),
    );
  }

  Widget _buildMenu() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.to(() => EditProfilePage());
            controller.toggleMenu();
          },
          child: Row(
            children: [
              Text(
                'Edit Profile',
                style: normalBodyStyle.copyWith(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
            ],
          ),
        ),
        VerticalMargin(),
        Row(
          children: [
            Text(
              'Subscriptions',
              style: normalBodyStyle.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
        VerticalMargin(),
        Row(
          children: [
            Text(
              'Settings',
              style: normalBodyStyle.copyWith(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
          ],
        ),
      ],
    );
  }
}
