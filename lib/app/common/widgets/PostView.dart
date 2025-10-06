import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:only_u/app/common/widgets/VideoPlayer.dart';
import 'package:only_u/app/data/constants.dart';
import 'package:only_u/app/data/models/post_model.dart';
import 'package:only_u/app/modules/main/controllers/main_controller.dart';
import 'package:only_u/app/services/auth_service.dart';
import 'package:only_u/app/services/posts_service.dart';
import 'package:share_plus/share_plus.dart';

class PostView extends StatefulWidget {
  PostView({super.key, required this.post, this.onUserNameTap});

  PostModel post;
  final VoidCallback? onUserNameTap;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
  final AuthService authService = AuthService();
  var isLiked = false;
  var likesCount = 0;
  var commentsCount = 0;

  void checkStatus() {
    setState(() {
      isLiked = widget.post.isLiked;
      likesCount = widget.post.likesCount;
      commentsCount = widget.post.commentsCount;
    });
  }

  Future<void> onLikeButtonPressed() async {
    try {
      setState(() {
        if (isLiked) {
          isLiked = false;
          likesCount -= 1;
        } else {
          isLiked = true;
          likesCount += 1;
        }
      });

      // Call the likePost API here and handle the response if needed
      final response = await PostsService().likePost(
        postId: widget.post.id,
        userId: authService.currentUser!.uid,
      );
      if (response.Status != "success") {
        // If the API call fails, revert the like status and count
        setState(() {
          if (isLiked) {
            isLiked = false;
          } else {
            isLiked = true;
          }
          likesCount = widget.post.likesCount;
        });
      } else {
        setState(() {
          likesCount = response.Data['likesCount'] ?? likesCount;
        });
      }
    } catch (e) {
      setState(() {
        isLiked = false;
        likesCount = widget.post.likesCount;
      });
    }
  }

  void onShareButtonPressed() {
    SharePlus.instance.share(
      ShareParams(
        text:
            'Check out this post: ${widget.post.description} download the app at https://example.com',
      ),
    );
  }

  void onCommentButtonPressed() {
    showCommentBottomSheet(context);
  }

  @override
  void initState() {
    checkStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      height: 430,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF).withOpacity(0.1),

        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUpperRow(),
          widget.post.media.first.type == 'video'
              ? _buildVideoThumbnainlView()
              // ? VideoPost(
              //     videoUrl: widget.post.media.first.url,
              //     aspectRatio: widget.post.media.first.aspectRatio ?? 16 / 9,
              //   )
              : _buildImageView(),
          _buildUserNameTv(),
          SizedBox(height: 5),
          _buildDescriptionTv(),
          SizedBox(height: 20),
          _buildDivider(),
          SizedBox(height: 20),
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildUpperRow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: Image.asset('assets/imgs/avator.png'),
          ),
          SizedBox(
            // width: double.infinity,
            child: GestureDetector(
              onTap: widget.onUserNameTap,
              child: Text(
                'Brooklyn Simmons',
                style: TextStyle(
                  color: Color(0xFFFFF7FA),
                  fontSize: 16,
                  fontFamily: 'Rubik',
                ),
              ),
            ),
          ),
          Spacer(),
          SizedBox(
            height: 30,
            width: 30,
            child: Image.asset('assets/imgs/heart_white.png'),
          ),
          // SizedBox(width: 20),
        ],
      ),
    );
  }

  Widget _buildImageView() {
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Image.network(widget.post.media.first.url, fit: BoxFit.cover),
    );
  }

  Widget _buildVideoThumbnainlView() {
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Stack(
        children: [
          Image.network(
            widget.post.media.first.thumbnailUrl ?? '',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 240,
          ),
          Center(
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  // Handle play button press
                  Get.to(
                    () => VideoPlayerPage(
                      videoUrl: widget.post.media.first.url,
                      aspectRatio: widget.post.media.first.aspectRatio!,
                      description: widget.post.description,
                    ),
                  );
                },
                icon: Icon(Icons.play_arrow, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserNameTv() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        '@simmlove',
        style: TextStyle(
          color: secondaryColor,
          fontSize: 14,
          fontFamily: 'Rubik',
        ),
      ),
    );
  }

  Widget _buildDescriptionTv() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        widget.post.description,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Rubik',
        ),
        overflow: TextOverflow.clip,
        maxLines: 1,
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      height: 1,
      decoration: ShapeDecoration(
        color: Colors.white.withOpacity(0.10000000149011612),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      ),
    );
  }

  Widget _buildBottomRow() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: onLikeButtonPressed,
            child: SvgPicture.asset(
              isLiked
                  ? 'assets/imgs/like_white_dense.svg'
                  : 'assets/imgs/like_white.svg',
            ),
          ),
          SizedBox(width: 5),
          Text(
            "$likesCount",
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Rubik',
              color: Colors.white,
            ),
          ),
          SizedBox(width: 15),
          GestureDetector(
            onTap: onCommentButtonPressed,
            child: SvgPicture.asset('assets/imgs/comment_white.svg'),
          ),
          SizedBox(width: 5),
          Text(
            "$commentsCount",
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Rubik',
              color: Colors.white,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: onShareButtonPressed,
            child: SvgPicture.asset('assets/imgs/send_white.svg'),
          ),
        ],
      ),
    );
  }

  void showCommentBottomSheet(BuildContext context) async {
    await Get.bottomSheet(
      CommentBottomSheet(post: widget.post, secondaryColor: secondaryColor),
      isScrollControlled: true,
    );
    setState(() {
      commentsCount += 1;
    });
    Get.snackbar('Success', 'Your Comment Added');
  }
}

class CommentBottomSheet extends StatefulWidget {
  final Color secondaryColor;

  final PostModel post;
  const CommentBottomSheet({
    required this.secondaryColor,
    super.key,
    required this.post,
  });

  @override
  _CommentBottomSheetState createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  bool isLoading = false;
  final TextEditingController commentController = TextEditingController();
  final MainController mainController = Get.find<MainController>();
  void submitComment() async {
    setState(() => isLoading = true);
    final AuthService authService = AuthService();
    final response = await PostsService().addCommentPost(
      postId: widget.post.id,
      userId: authService.currentUser!.uid,
      comment: commentController.text,
    );
    debugPrint("Add Comment Response: $response");
    // if (response.Status == "success") {
    //   mainController.posts.where((p) => p['id'] == widget.post.id).forEach((p) {
    //     p['commentsCount'] += 1;
    //   });
    //   mainController.update();
    // }

    setState(() => isLoading = false);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Write a Comment',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Rubik',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          TextField(
            maxLines: 5,
            style: TextStyle(color: Colors.white),
            controller: commentController,
            decoration: InputDecoration(
              hintText: 'Type your comment here...',
              hintStyle: TextStyle(color: Colors.white54),
              filled: true,
              fillColor: Colors.white12,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          SizedBox(height: 20),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: widget.secondaryColor,
                  ),
                )
              : Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: submitComment,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.secondaryColor,
                      padding: EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Rubik',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
