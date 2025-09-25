import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:only_u/app/common/widgets/CustomButton.dart';
import 'package:only_u/app/data/constants.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  void redirectToRegister() {
    //Todo
  }

  void redirectToLogin() {
    // Get.toNamed("/login");
    //Todo
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,

          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF1E1E1E), Color(0xFF1E1E1E)], // sample bg
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildBackGroundWidget(),
                _buildWelcomeTextView(),

                const SizedBox(height: 10),
                _buildSignUpToContinueTV(),
                const SizedBox(height: 16),
                _buildLoginWithGoogleBtn(),
                const SizedBox(height: 10),
                _buildDivider(),
                const SizedBox(height: 10),
                _buildRegisterButton(),
                const SizedBox(height: 10),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackGroundWidget() {
    return Image.asset(
      "assets/imgs/onboardBGImg.png",
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }

  Widget _buildWelcomeTextView() {
    return Container(
      alignment: Alignment.topLeft,
      margin: EdgeInsets.only(left: 20),
      child: Text(
        "Welcome to OnlyU",
        style: redHeadingStyle,
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: Divider(color: Color(0xFF8B87D2), thickness: 1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            "Or",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(
          width: 80,
          child: Divider(color: Color(0xFF8B87D2), thickness: 1),
        ),
      ],
    );
  }

  Widget _buildSignUpToContinueTV() {
    return Container(
      margin: EdgeInsets.only(left: 20),
      alignment: Alignment.topLeft,
      child: Text(
        "Signup to continue",
        style: whiteSubHeadingStyle,
      ),
    );
  }

  Widget _buildRegisterButton() {
    return CustomButton(
      title: 'Login With Email',
      icon: "assets/imgs/mail.png",
      onPressed: () {},
    );
  }

  Widget _buildLoginWithGoogleBtn() {
    return CustomButton(
      title: 'Google',
      icon: "assets/imgs/google.png",
      onPressed: () {},
    );
  }

  Widget _buildLoginLink() {
    return // Login link
    GestureDetector(
      onTap: redirectToLogin,
      child: const Text.rich(
        TextSpan(
          text: "Already got an account? ",
          style: TextStyle(fontSize: 16, color: Colors.white),
          children: [
            TextSpan(
              text: "Login here",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
