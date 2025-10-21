import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomBottomNavBar extends StatelessWidget {
  final List<String> _icons = [
    'assets/imgs/home_active.svg',
    'assets/imgs/content_active.svg',
    'assets/imgs/profile_active.svg',
  ];

  final CustomNavBarController controller = Get.find<CustomNavBarController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 7, 20, 41),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            final isActive = controller.selectedIndex.value == index;
            return GestureDetector(
              onTap: () => controller.selectTab(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isActive)
                    Container(
                      height: 3,
                      width: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF3181),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    )
                  else
                    const SizedBox(height: 3),
                  const SizedBox(height: 4),
                  SvgPicture.asset(
                    _icons[index],
                    width: 80,
                    height: 80,
                    colorFilter: ColorFilter.mode(
                      isActive ? const Color(0xFFFF3181) : Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class CustomNavBarController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void selectTab(int index) {
    selectedIndex.value = index;
  }
}
