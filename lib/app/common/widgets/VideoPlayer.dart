import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:only_u/app/common/widgets/LoadingView.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({
    super.key,
    this.videoUrl = '',
    this.aspectRatio = 0.5,
    this.description = 'This is the Post Description'
  });

  final String videoUrl;
  final double aspectRatio;
  final String description ;

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Center(
              child: VideoPost(
                videoUrl: widget.videoUrl,
                aspectRatio: widget.aspectRatio,
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 30,

              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  widget.description,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPost extends StatefulWidget {
  final String videoUrl;
  final double aspectRatio;

  const VideoPost({
    super.key,
    required this.videoUrl,
    this.aspectRatio = 0.5,
  });

  @override
  State<VideoPost> createState() => _VideoPostState();
}

class _VideoPostState extends State<VideoPost> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {}); // Refresh when ready
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
            aspectRatio: widget.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(_controller),
                IconButton(
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 50,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                ),
              ],
            ),
          )
        : const LoadingView();
  }
}
