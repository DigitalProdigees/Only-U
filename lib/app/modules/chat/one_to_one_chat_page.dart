import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:only_u/app/common/utils/helper_methods.dart';
import 'package:only_u/app/data/constants.dart';

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
  final TextEditingController chatInputController = TextEditingController();

  final OneToOneChatService _oneToOneChatService = OneToOneChatService();

  final ChatController controller = Get.put(ChatController());

  String? currentUserID = FirebaseAuth.instance.currentUser?.uid;

  // final UploadService _uploadService = UploadService();

  bool showOtherButtons = true;

  onSendButtonTapped() {
    if (controller.recordedAudioPath.value.isNotEmpty) {
      // If there's a recorded audio, send it
      controller.sendRecordedAudio(groupId: widget.chatID, isGroupChat: false);
    } else if (chatInputController.text.isNotEmpty) {
      // Otherwise send text message if not empty
      _oneToOneChatService.sendMessage(
        chatID: widget.chatID,
        text: chatInputController.text,
      );

      chatInputController.clear();
    }
    scrollToTheEndOfChat();
  }

  onMediaButtonTapped() async {
    // final resultUrl = await _uploadService.uploadImage();
    // if (resultUrl != null) {
    //   _oneToOneChatService.sendMessage(
    //       chatID: widget.chatID, mediaLink: resultUrl, messageType: 'image');
    //   scrollToTheEndOfChat();
    //   debugPrint("Image URL: $resultUrl");
    // }
  }

  onMicButtonTapped() async {
    try {
      await controller.toggleRecording(widget.chatID);
      scrollToTheEndOfChat();
    } catch (e) {
      Get.snackbar('Error', 'Failed to record audio: ${e.toString()}');
    }
  }

  void scrollToTheEndOfChat() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.scrollController.hasClients) {
        controller.scrollController.animateTo(
          controller.scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    debugPrint('GroupId: ${widget.chatID}');
    // Future.delayed(Duration(seconds: 1)).then((_) {
    //   controller.scrollController.animateTo(
    //     controller.scrollController.position.maxScrollExtent,
    //     duration: Duration(milliseconds: 300),
    //     curve: Curves.easeOut,
    //   );
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
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
                children: [
                  Text(
                    widget.chatName,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Icon(Icons.call_outlined, color: Colors.black),
            SizedBox(width: 10.w),
            Icon(Icons.videocam_outlined, color: Colors.black),
            SizedBox(width: 10.w),
            IconButton(
              onPressed: () {
                showChatOptionsSheet(context);
              },
              icon: Icon(Icons.more_vert, color: Colors.black),
            ),
            SizedBox(width: 10.w),
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
          // Obx(() => controller.isRecording.value
          //     ? _buildRecordingIndicator(controller)
          //     : SizedBox.shrink()),
          // Obx(() => controller.recordedAudioPath.value.isNotEmpty
          //     ? _buildAudioPreview(controller, widget.chatID)
          //     : SizedBox.shrink()),
          // Chat Input
          Container(
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
                      showOtherButtons
                          ? IconButton(
                              onPressed: onMediaButtonTapped,
                              icon: Icon(Icons.attach_file_outlined),
                            )
                          : SizedBox(),
                      showOtherButtons
                          ? Obx(() {
                              if (controller.isRecording.value) {
                                return IconButton(
                                  onPressed: onMicButtonTapped,
                                  icon: Icon(Icons.stop, color: Colors.red),
                                );
                              } else {
                                return IconButton(
                                  onPressed: onMicButtonTapped,
                                  icon: Obx(
                                    () => Icon(
                                      controller.isRecording.value
                                          ? Icons.stop
                                          : Icons.mic,
                                      color: controller.isRecording.value
                                          ? Colors.red
                                          : Colors.indigo,
                                    ),
                                  ),
                                );
                              }
                            })
                          : SizedBox(),
                      IconButton(
                        onPressed: onSendButtonTapped,
                        icon: Icon(Icons.send),
                      ),
                    ],
                  ),
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
              color: Colors.indigo,
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

  Widget _buildRecordingIndicator(ChatController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      color: Colors.red[100],
      child: Row(
        children: [
          Icon(Icons.mic, color: Colors.red),
          SizedBox(width: 8.w),
          Obx(() => Text('Recording: ${controller.recordingTime.value}')),
          Spacer(),
          GestureDetector(
            onTap: () => controller.toggleRecording(widget.chatID),
            child: Icon(Icons.stop, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPreview(ChatController controller, String groupId) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: Obx(
                  () => Icon(
                    controller.isPlayingPreview.value
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.indigo,
                  ),
                ),
                onPressed: controller.togglePreviewPlayback,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Obx(
                  () => Slider(
                    value: controller.previewPosition.value.inSeconds
                        .toDouble(),
                    min: 0,
                    max: controller.previewDuration.value.inSeconds.toDouble(),
                    onChanged: (value) {
                      controller.seekPreviewAudio(
                        Duration(seconds: value.toInt()),
                      );
                    },
                    activeColor: Colors.indigo,
                    inactiveColor: Colors.grey,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Obx(
                () => Text(
                  _formatDuration(controller.previewPosition.value),
                  style: TextStyle(fontSize: 12.sp),
                ),
              ),
              SizedBox(width: 8.w),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: controller.cancelRecording,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioMessageBubble(
    BuildContext context,
    Map<String, dynamic> message,
  ) {
    final isSent = message['senderId'] == currentUserID;
    final audioUrl = message['mediaLink'];

    return Column(
      children: [
        Align(
          alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            padding: EdgeInsets.all(12.r),
            margin: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              color: isSent ? Colors.indigo : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
                bottomLeft: isSent ? Radius.circular(20.r) : Radius.zero,
                bottomRight: isSent ? Radius.zero : Radius.circular(20.r),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final isCurrentlyPlaying =
                      controller.currentlyPlayingUrl.value == audioUrl;
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          isCurrentlyPlaying && controller.isPlaying.value
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: isSent ? Colors.white : Colors.black,
                        ),
                        onPressed: () =>
                            controller.toggleAudioPlayback(audioUrl),
                      ),
                      SizedBox(width: 8.w),
                      Obx(() {
                        final duration =
                            controller.currentlyPlayingUrl.value == audioUrl
                            ? controller.playbackDuration.value
                            : Duration.zero;
                        final position =
                            controller.currentlyPlayingUrl.value == audioUrl
                            ? controller.playbackPosition.value
                            : Duration.zero;

                        return Text(
                          '${_formatDuration(position)} / ${_formatDuration(duration)}',
                          style: TextStyle(
                            color: isSent ? Colors.white : Colors.black,
                          ),
                        );
                      }),
                    ],
                  );
                }),
                Obx(() {
                  if (controller.currentlyPlayingUrl.value == audioUrl) {
                    return Slider(
                      value: controller.playbackPosition.value.inSeconds
                          .toDouble(),
                      min: 0,
                      max: controller.playbackDuration.value.inSeconds
                          .toDouble(),
                      onChanged: (value) {
                        controller.seekAudio(Duration(seconds: value.toInt()));
                      },
                      activeColor: isSent ? Colors.white : Colors.indigo,
                      inactiveColor: isSent ? Colors.white54 : Colors.grey,
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: isSent ? 0 : 8.w,
            right: isSent ? 8.w : 0,
          ),
          child: Align(
            alignment: isSent ? Alignment.centerRight : Alignment.centerLeft,
            child: Text(
              HelpersMethod.getFormattedTimeFromTimestamp(message['timestamp']),
              style: TextStyle(fontSize: 11.sp, color: Colors.grey),
            ),
          ),
        ),
      ],
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
