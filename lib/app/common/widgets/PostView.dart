import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:only_u/app/common/widgets/CommentsBottomSheet.dart';
import 'package:only_u/app/common/widgets/LoadingView.dart';
import 'package:only_u/app/common/widgets/VideoPlayer.dart';
import 'package:only_u/app/data/constants.dart';
import 'package:only_u/app/data/models/post_model.dart';
import 'package:only_u/app/services/auth_service.dart';
import 'package:only_u/app/services/posts_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';

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
  var comments = [];
  var loadingComments = false;

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

  void onCommentButtonPressed() async {
    Get.bottomSheet(
      CommentsBottomSheet(postId: widget.post.id),
      isScrollControlled: true,
    );
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
              ? _buildVideoThumbnailView()
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
              child: Text('Brooklyn Simmons', style: normalBodyStyle),
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
      child: CachedNetworkImage(
        imageUrl: widget.post.media.first.url,
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
            width: double.infinity,
            height: 240,
            color: Colors.white,
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildVideoThumbnailView() {
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: widget.post.media.first.thumbnailUrl ?? '',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 240,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: double.infinity,
                height: 240,
                color: Colors.white,
              ),
            ),
            errorWidget: (context, url, error) => Icon(Icons.error),
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
        style: normalBodyStyle.copyWith(color: secondaryColor),
      ),
    );
  }

  Widget _buildDescriptionTv() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        widget.post.description,
        style: normalBodyStyle,
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
          Text("$likesCount", style: normalBodyStyle.copyWith(fontSize: 12)),
          SizedBox(width: 15),
          loadingComments
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(color: secondaryColor),
                )
              : GestureDetector(
                  onTap: onCommentButtonPressed,
                  child: SvgPicture.asset('assets/imgs/comment_white.svg'),
                ),
          SizedBox(width: 5),
          Text(
            "$commentsCount",
            style:normalBodyStyle.copyWith(fontSize: 12)),
          Spacer(),
          GestureDetector(
            onTap: onShareButtonPressed,
            child: SvgPicture.asset('assets/imgs/send_white.svg'),
          ),
        ],
      ),
    );
  }
}
