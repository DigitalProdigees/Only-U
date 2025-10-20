import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:only_u/app/common/widgets/CustomButton.dart';
import 'package:only_u/app/common/widgets/CustomToggleButton.dart';
import 'package:only_u/app/common/widgets/LoadingView.dart';
import 'package:only_u/app/data/constants.dart';
import 'package:only_u/app/services/media_service.dart';
import '../controllers/createpost_controller.dart';

class CreatepostView extends GetView<CreatepostController> {
  const CreatepostView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              _buildTitle(),
              SizedBox(height: 10),
              _buildLabel('Write'),
              SizedBox(height: 10),
              _buildInputField(),
              SizedBox(height: 10),
              _buildLabel('Upload Media'),
              SizedBox(height: 10),
              _buildSelectMediaButton(context),
              SizedBox(height: 10),
              SizedBox(height: 10),
              _buildLabel('Upload Tags'),
              SizedBox(height: 10),
              _buildTagsView(),
              SizedBox(height: 10),
              _buildLabel('Privacy Settings'),
              SizedBox(height: 10),
              _buildPrivacySettingRow('Only follower can view profile'),
              SizedBox(height: 10),
              _buildPrivacySettingRow('All can chat with me'),
              SizedBox(height: 10),
              _buildPrivacySettingRow('Comment notification'),
              SizedBox(height: 10),
              _buildPrivacySettingRow('Promote your Profile'),
              SizedBox(height: 10),
              _buildUploadButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text('Add Content', style: normalBodyStyle.copyWith(fontSize: 20));
  }

  Widget _buildLabel(String label) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: normalBodyStyle.copyWith(fontSize: 16, color: secondaryColor),
    );
  }

  Widget _buildInputField() {
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
        style: normalBodyStyle,
        controller: controller.descriptionController,
        decoration: InputDecoration(
          hintText: 'e.g I am a modal.....',
          hintStyle: normalBodyStyle,
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildSelectMediaButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showMediaPickerDialog(context);
      },
      child: Container(
        width: Get.width,
        height: 49,
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: Colors.white.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Center(child: Text('Select Media', style: normalBodyStyle)),
      ),
    );
  }

  Widget _buildPrivacySettingRow(String statement) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(statement, textAlign: TextAlign.center, style: normalBodyStyle),
        CustomToggleButton(),
      ],
    );
  }

  Widget _buildUploadButton() {
    return Obx(
      () => controller.loading.value
          ? LoadingView()
          : CustomButton(title: 'Upload', onPressed: controller.onUploadTapped),
    );
  }

  Widget _buildTagsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 4,
            children: controller.tags
                .map(
                  (tag) => Chip(
                    label: Text(
                      tag,
                      style: normalBodyStyle.copyWith(color: Color(0xff2E93D0)),
                    ),
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    deleteIcon: Icon(Icons.close),
                    onDeleted: () => controller.removeTag(tag),
                  ),
                )
                .toList(),
          ),
        ),
        TextField(
          controller: controller.tagInputcontroller,
          decoration: InputDecoration(
            hintText: 'Enter a tag and press enter',
            hintStyle: normalBodyStyle,
          ),
          style: normalBodyStyle,

          onSubmitted: controller.addTag,
        ),
      ],
    );
  }

  void showMediaPickerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Center(
            child: Text(
              'Choose Media Source',
              style: normalBodyStyle.copyWith(fontSize: 14),
            ),
          ),
          content: Row(
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.photo, color: Colors.black),
                label: Text(
                  'Gallery',
                  style: normalBodyStyle.copyWith(color: secondaryColor),
                ),
                onPressed: () {
                  Get.back();
                  controller.pickMedia(ImageSource.gallery, true);
                },
              ),
              SizedBox(width: 5),
              ElevatedButton.icon(
                icon: Icon(Icons.camera_alt, color: Colors.black),
                label: Text(
                  'Camera',
                  style: normalBodyStyle.copyWith(color: secondaryColor),
                ),
                onPressed: () {
                  Get.back();
                  controller.pickMedia(ImageSource.camera, false);
                  // Handle camera selection
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final ImagePicker _picker = ImagePicker();
  final MediaUploadService _uploadService = MediaUploadService();

  Future<void> pickAndUploadMedia(ImageSource source, bool isVideo) async {
    final XFile? pickedFile = isVideo
        ? await _picker.pickVideo(source: source)
        : await _picker.pickImage(source: source);

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      String folder = isVideo ? 'videos' : 'images';
      String? url = await _uploadService.uploadMedia(file, folder);
      if (url != null || url!.isNotEmpty) {
        
      }
      debugPrint('Uploaded to: $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => pickAndUploadMedia(ImageSource.camera, false),
            child: Text('Upload Image'),
          ),
          ElevatedButton(
            onPressed: () => pickAndUploadMedia(ImageSource.gallery, true),
            child: Text('Upload Video'),
          ),
        ],
      ),
    );
  }
}
