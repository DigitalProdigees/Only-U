import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:only_u/app/common/widgets/LoadingView.dart';

import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MainView'), centerTitle: true),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Main Landing Page - OnlyU', style: TextStyle(fontSize: 20)),
            SizedBox(height: 20),
            Obx(
              () => controller.isLoading.value
                  ? LoadingView()
                  : TextButton(
                      onPressed: () {
                        controller.signOut();
                      },
                      child: Text('Logout'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
