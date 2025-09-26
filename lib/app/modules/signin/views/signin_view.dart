import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:only_u/app/common/widgets/CustomButton.dart';
import 'package:only_u/app/common/widgets/CustomInputField.dart';
import 'package:only_u/app/common/widgets/LoadingView.dart';
import 'package:only_u/app/common/widgets/TermsCheckBox.dart';
import 'package:only_u/app/common/widgets/welcome_widget.dart';
import 'package:only_u/app/data/constants.dart';

import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildBackGroundWidget(),
                SizedBox(height: 5),
                WelcomWidget(),
                SizedBox(height: 10),
                _buildSignInWithEmailTV(),
                SizedBox(height: 10),
                _buildLabel('Email'),
                SizedBox(height: 10),
                _buildEmailField(),
                SizedBox(height: 20),
                _buildLabel('Password'),
                SizedBox(height: 10),
                _buildPasswordField(),
                SizedBox(height: 10),
                _buildTersWidget(),
                SizedBox(height: 20),
                _buildRegisterBtn(),
                SizedBox(height: 50),
                _buildAlreadyGotAnAccountWidget(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackGroundWidget() {
    return Image.asset(
      "assets/imgs/signin_bg.png",
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildSignInWithEmailTV() {
    return Container(
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.topLeft,
      child: Text("Sign in with Email", style: whiteSubHeadingStyle),
    );
  }

  Widget _buildLabel(String label) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      alignment: Alignment.topLeft,
      child: Text(
        label,
        style: TextStyle(
          color: Color(0xFFFFF7FA),
          fontSize: 14,
          fontFamily: 'Rubik',
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Custominputfield(
      hintText: 'e.g john@gmail.com',
      controller: controller.emailController,
    );
  }

  Widget _buildPasswordField() {
    return Custominputfield(
      hintText: "e.g john@123",
      controller: controller.passwordController,
      obscureText: true,
    );
  }

  Widget _buildTersWidget() {
    return TermsCheckbox(
      initialValue: controller.termsAndConditionsChecked.value,
      onChanged: controller.updateTermsAndConditionsValue,
      checkboxActiveColor: secondaryColor,
    );
  }

  Widget _buildRegisterBtn() {
    return Obx(
      () => controller.isLoading.value
          ? LoadingView()
          : CustomButton(
              title: 'Login',
              onPressed: () {
                controller.signIn();
              },
            ),
    );
  }

  Widget _buildAlreadyGotAnAccountWidget() {
    return InkWell(
      onTap: () => Get.toNamed('/signup'),
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
              text: "Don’t have an account? ",
              style: TextStyle(
                color: Color(0xFFFFF7FA),
                fontSize: 14,
                fontFamily: 'Rubik',
              ),
            ),
            TextSpan(
              text: "Signup Here",
              style: TextStyle(
                color: Color(0xFFFF3080),
                fontSize: 14,
                fontFamily: 'Rubik',
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
