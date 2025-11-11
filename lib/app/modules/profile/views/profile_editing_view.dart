import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:only_u/app/common/widgets/LoadingView.dart';
import 'package:only_u/app/common/widgets/VerticalMargin.dart';
import 'package:only_u/app/data/constants.dart';

import '../../../common/widgets/CustomButton.dart';
import '../controllers/profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  EditProfilePage({super.key});

  final profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: normalBodyStyle),
        backgroundColor: Colors.black,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          color: Colors.black,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAvatorPart(),
                _buildLabel("Name"),
                VerticalMargin(),
                _buildInputField(controller: profileController.nameController),
                VerticalMargin(),
                _buildLabel("Description"),
                VerticalMargin(),
                _buildDescriptionInputField(
                  profileController.descriptionController,
                ),
                VerticalMargin(),
                _buildLabel("Mobile"),
                VerticalMargin(),
                _buildInputField(
                  controller: profileController.phoneController,
                  keyboardType: TextInputType.phone,
                ),
                VerticalMargin(),
                _buildLabel("Email"),
                VerticalMargin(),
                _buildInputField(
                  controller: profileController.emailController,
                  readOnly: true,
                ),
                VerticalMargin(),
                _buildLabel("Gender"),
                VerticalMargin(),
                _buildInputField(
                  controller: profileController.genderController,
                ),
                VerticalMargin(),
                _buildLabel("Skills"),
                VerticalMargin(),
                _buildInputField(
                  controller: profileController.skillsController,
                ),
                VerticalMargin(),
                _buildUpdateButton(),
              ],
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

  Widget _buildDescriptionInputField(TextEditingController controller) {
    return Container(
      width: Get.width,
      height: 150,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: TextField(
        maxLines: null,
        expands: true,
        controller: controller,
        style: normalBodyStyle,
        // controller: controller.descriptionController,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      width: Get.width,
      height: 50,
      padding: const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: TextField(
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: null,
        expands: true,
        controller: controller,
        style: normalBodyStyle,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildAvatorPart() {
    return Align(
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            height: 100,
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
              () => profileController.avatorUploading.value
                  ? SizedBox(
                      width: 100,
                      height: 147,
                      child: Center(
                        child: LoadingView()
                      ),
                    )
                  : Container(
                      width: 100,
                      height: 147,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(profileController.avator.value),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(height: 5),
          GestureDetector(
            onTap: profileController.updateAvator,
            child: Text(
              'Update ',
              textAlign: TextAlign.center,
              style: normalBodyStyle.copyWith(
                color: Color(0xFFFFF7FA),
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateButton() {
    return Obx(
      () => profileController.loading.value
          ? LoadingView()
          : CustomButton(
              title: 'Save',
              onPressed: profileController.onUpdateTapped,
            ),
    );
  }
}
