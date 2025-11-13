import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:only_u/app/common/utils/helper_methods.dart';
import 'package:only_u/app/data/constants.dart';
import 'package:only_u/app/services/media_service.dart';

import '../../common/widgets/LoadingView.dart';
import '../../services/one_to_one_chat_service.dart';
import 'chat_controller.dart';

class OneToOneChatPage extends StatefulWidget {
  OneToOneChatPage({
    super.key,
    required this.chatID,
    this.chatName = "",
    this.chatImage,
  });
  final String chatID;
  final String chatName;
  final String? chatImage;

  @override
  State<OneToOneChatPage> createState() => _OneToOneChatPageState();
}

class _OneToOneChatPageState extends State<OneToOneChatPage> {
  final ChatController controller = Get.put(ChatController());
  final TextEditingController chatInputController = TextEditingController();

  final OneToOneChatService _oneToOneChatService = OneToOneChatService();

  String? currentUserID = FirebaseAuth.instance.currentUser?.uid;

  bool showOtherButtons = true;
  bool mediaUploading = false;

  Future<void> onSendButtonTapped() async {
    if (chatInputController.text.isNotEmpty) {
      _oneToOneChatService.sendMessage(
        chatID: widget.chatID,
        text: chatInputController.text,
      );

      chatInputController.clear();
    }
    scrollToTheEndOfChat();
  }

  Future<void> onMediaButtonTapped() async {
    setState(() {
      mediaUploading = true;
    });
    final resultUrl = await MediaUploadService().uploadImage();
    if (resultUrl != null) {
      _oneToOneChatService.sendMessage(
        chatID: widget.chatID,
        mediaLink: resultUrl,
        messageType: 'image',
      );
      scrollToTheEndOfChat();
      debugPrint("Image URL: $resultUrl");
    }
    setState(() {
      mediaUploading = false;
    });
  }

  void scrollToTheEndOfChat() {
    try {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.scrollController.hasClients) {
          controller.scrollController.animateTo(
            controller.scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      print('Error while scrolling to end of chat: $e');
    }
  }

  @override
  void initState() {
    scrollToTheEndOfChat();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black,
          elevation: 0,
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(
                  widget.chatImage ?? defaultAvatorUrl,
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text(widget.chatName, style: normalBodyStyle)],
              ),
            ],
          ),
          actions: [
            // Icon(Icons.call_outlined, color: Colors.black),
            // SizedBox(width: 10.w),
            // Icon(Icons.videocam_outlined, color: Colors.black),
            // SizedBox(width: 10.w),
            // IconButton(
            //   onPressed: () {
            //     showChatOptionsSheet(context);
            //   },
            //   icon: Icon(Icons.more_vert, color: Colors.black),
            // ),
            // SizedBox(width: 10.w),
          ],
        ),
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: _oneToOneChatService.getChatMessages(chatID: widget.chatID),
            builder:
                (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (!snapshot.hasData) return LoadingView();

                  return Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: ListView.builder(
                        controller: controller.scrollController,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var message = snapshot.data![index];
                          debugPrint('Message:$message');
                          return message['senderId'] == currentUserID
                              ? _buildSentMessage(context, message)
                              : _buildReceivedMessage(context, message);
                        },
                      ),
                    ),
                  );
                },
          ),
          // Chat Input
          _buildInputUI(),
        ],
      ),
    );
  }

  Widget _buildInputUI() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.grey),
              ),
              child: Focus(
                onFocusChange: (hasFocus) {
                  showOtherButtons = !hasFocus;
                },
                child: TextField(
                  controller: chatInputController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.emoji_emotions_outlined),
                    suffixIcon: SizedBox(),
                    hintText: "Type a Message...",
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          SizedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                mediaUploading
                    ? Center(child: CupertinoActivityIndicator())
                    : IconButton(
                        onPressed: onMediaButtonTapped,
                        icon: Icon(Icons.attach_file_outlined),
                      ),
                IconButton(
                  onPressed: onSendButtonTapped,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSentMessage(BuildContext context, Map<String, dynamic> message) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            padding: EdgeInsets.all(12.r),
            margin: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              color: secondaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r),
              ),
            ),
            child: message['type'] == 'text'
                ? Text(
                    message['text'] ?? '',
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Image.network(
                      message['mediaLink'] ?? '',
                      width: 200.w,
                      height: 120.h,
                      fit: BoxFit.cover,
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              HelpersMethod.getFormattedTimeFromTimestamp(message['timestamp']),
              style: TextStyle(fontSize: 11.sp, color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceivedMessage(
    BuildContext context,
    Map<String, dynamic> message,
  ) {
    return GestureDetector(
      onLongPressStart: (details) {
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(
            details.globalPosition.dx,
            details.globalPosition.dy,
            details.globalPosition.dx,
            details.globalPosition.dy,
          ),
          items: [
            PopupMenuItem(
              value: 'forward',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Forward', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 8),
                  Icon(Icons.share, size: 18),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'report',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Report', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 8),
                  Icon(Icons.report, size: 18),
                ],
              ),
            ),
          ],
        ).then((selected) {
          if (selected != null) {
            if (selected == 'forward') {
              Get.snackbar('Forward', 'Message forwarded');
            } else if (selected == 'report') {}
          }
        });
      },
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              padding: EdgeInsets.all(12.r),
              margin: EdgeInsets.symmetric(vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                ),
              ),
              child: message['type'] == 'text'
                  ? Text(
                      message['text'],
                      style: TextStyle(color: Colors.black, fontSize: 14.sp),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.network(
                        message['mediaLink'] ?? '',
                        width: 200.w,
                        height: 120.h,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                HelpersMethod.getFormattedTimeFromTimestamp(
                  message['timestamp'],
                ),
                style: TextStyle(fontSize: 11.sp, color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showChatOptionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                trailing: Icon(Icons.info_outline, color: Colors.blueAccent),
                title: Text('Block User'),
                onTap: () {
                  Navigator.pop(context);
                  // Todo: Implement block user functionality here
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
