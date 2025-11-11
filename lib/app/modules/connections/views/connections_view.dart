import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:only_u/app/common/widgets/VerticalMargin.dart';
import 'package:only_u/app/data/constants.dart';

import '../controllers/connections_controller.dart';

class ConnectionsView extends GetView<ConnectionsController> {
  ConnectionsView({super.key});

  final controller = Get.put(ConnectionsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Connections', style: normalBodyStyle),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [SizedBox(child: SvgPicture.asset('assets/imgs/search.svg'))],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            VerticalMargin(),
            _buildTabView(),
            VerticalMargin(),
            Obx(
              () => controller.tabIndex.value == 0
                  ? _buildFollowersListView()
                  : _buildFollowingListView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabView() {
    return Obx(
      () => Column(
        children: [
          Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: ShapeDecoration(
              color: Color(0xFF040E1E),
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
                  child: GestureDetector(
                    onTap: () {
                      controller.tabIndex.value = 0;
                      debugPrint("Followers tapped");
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
                            'Followers',
                            style: normalBodyStyle.copyWith(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.tabIndex.value = 1;
                      debugPrint("Following tapped");
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
                            'Following',
                            style: normalBodyStyle.copyWith(fontSize: 16),
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
      ),
    );
  }

  Widget _buildConnectionView() {
    return Container(
      // height: 50,
      width: Get.width,
      padding: EdgeInsets.all(5),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            //todo
            backgroundImage: NetworkImage(
              'https://firebasestorage.googleapis.com/v0/b/only-u-48058.firebasestorage.app/o/user_uploads%2Fs0dcGccCYIQ8JyZ3kEIvJzR28ag2%2F1762880150085.jpg?alt=media&token=cfd1f4d9-86fe-48d5-a585-f389cf489c88',
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Luna Cruz',
                style: normalBodyStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '@Cluna_86',
                style: normalBodyStyle.copyWith(
                  fontSize: 14,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFollowersListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return _buildConnectionView();
        },
      ),
    );
  }

  Widget _buildFollowingListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return _buildConnectionView();
        },
      ),
    );
  }
}
