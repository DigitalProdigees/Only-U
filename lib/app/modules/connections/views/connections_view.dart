import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:only_u/app/common/widgets/LoadingView.dart';
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
      appBar: _buildAppBar(),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            VerticalMargin(),
            _buildTabView(),
            VerticalMargin(),
            _buildConnectionsListView(),
            // Obx(
            //   () => controller.tabIndex.value == 0
            //       ? _buildFollowersListView()
            //       : _buildFollowingListView(),
            // ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Connections', style: normalBodyStyle),
      backgroundColor: Colors.black,
      iconTheme: IconThemeData(color: Colors.white),
      actions: [SizedBox(child: SvgPicture.asset('assets/imgs/search.svg'))],
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
                      debugPrint("Followers tapped");
                      controller.tabIndex.value = 0;
                      controller.loadConnections();
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
                      debugPrint("Following tapped");
                      controller.tabIndex.value = 1;
                      controller.loadConnections();
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

  Widget _buildConnectionsListView() {
    return Obx(
      () => controller.loading.value
          ? Align(alignment: Alignment.center, child: LoadingView())
          : controller.connections.isNotEmpty
          ? Expanded(
              child: ListView.builder(
                itemCount: controller.connections.length,
                itemBuilder: (context, index) {
                  return _buildConnectionView(index);
                },
              ),
            )
          : Center(
              child: Text(
                'No ${controller.tabIndex.value == 0 ? 'followers' : 'following'} yet!',
                style: normalBodyStyle,
              ),
            ),
    );
  }

  Widget _buildConnectionView(int index) {
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
              controller.connections[index]['avator'] ?? defaultAvatorUrl,
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.connections[index]['name'] ?? '',
                style: normalBodyStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                controller.connections[index]['email'] ?? '',
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
}
