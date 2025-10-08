import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_u/app/common/widgets/VideoPlayer.dart';
import 'package:only_u/app/data/constants.dart';
import 'package:only_u/app/data/models/post_comment.dart';
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
    comments.clear();
    setState(() {
      loadingComments = true;
    });
    final response = await PostsService().getPostComments(
      postID: widget.post.id,
    );
    if (response.Status == 'success') {
      comments.addAll(response.Data['comments']);
    }
    setState(() {
      loadingComments = false;
    });
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
    // await Get.bottomSheet(
    //   CommentBottomSheet(post: widget.post, secondaryColor: secondaryColor),
    //   isScrollControlled: true,
    // );
    // setState(() {
    //   commentsCount += 1;
    // });
    await Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        width: Get.width,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          border: Border(top: BorderSide(width: 1, color: Colors.white12)),
          color: Colors.black,
        ),
        child: Column(
          children: [
            Text(
              'Comments',
              style: GoogleFonts.rubik(
                textStyle: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            SizedBox(height: 10),

            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) => PostCommentView(
                  postComment: PostComment.fromJson(comments[index]),
                  postId: widget.post.id,
                ),
                separatorBuilder: (context, index) {
                  return SizedBox(height: 5);
                },
                itemCount: comments.length,
              ),
            ),
            SizedBox(height: 10),
            _buildCommentInputField(),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildCommentInputField() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        decoration: ShapeDecoration(
          color: Color(0xFF122C58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Add a comment',
            hintStyle: TextStyle(
              color: Color(0x66FFF7FA),
              fontFamily: 'Rubik',
              fontSize: 14,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8),

            // 👈 Leading widget
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 8, right: 4),
              child: Container(
                width: 32,
                height: 32,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://picsum.photos/32/32"),
                    fit: BoxFit.fill,
                  ),
                  shape: OvalBorder(
                    side: BorderSide(width: 1, color: Colors.white),
                  ),
                ),
              ),
            ),

            // 👈 Trailing widget
            suffixIcon: IconButton(
              onPressed: () {
                // TODO: handle send comment
              },
              icon: Icon(Icons.send, color: Colors.white),
            ),
          ),
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Rubik',
            fontSize: 14,
          ),
        ),
      ),
    );
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

class PostCommentView extends StatefulWidget {
  const PostCommentView({
    super.key,
    required this.postComment,
    required this.postId,
  });
  final PostComment postComment;
  final String postId;

  @override
  State<PostCommentView> createState() => _PostCommentViewState();
}

class _PostCommentViewState extends State<PostCommentView> {
  var likeCount = 0;
  var isLoading = false;

  void loadData() {
    likeCount = widget.postComment.likesCount;
  }

Future<void> likeComment() async {
  setState(() {
    isLoading = true;
  });

  final response = await PostsService().likePostComment(
    postId: widget.postId,
    commentId: widget.postComment.id,
  );

  if (response.Status == 'success') {
    setState(() {
      if (response.Data['liked'] == true) {
        likeCount += 1;
      } else {
        likeCount -= 1;
      }
    });
  }

  setState(() {
    isLoading = false;
  });
}


  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.all(2),
      child: Row(
        children: [
          //Avator
          SizedBox(
            width: Get.width * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: Image.asset('assets/imgs/avator.png'),
                ),
              ],
            ),
          ),
          SizedBox(width: 5),
          // title and description
          SizedBox(
            width: Get.width * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Text(
                  'Brooklyn Simmons',
                  style: TextStyle(
                    color: Color(0xFFFFF7FA),
                    fontSize: 18,
                    fontFamily: 'Rubik',
                  ),
                ),

                Text(
                  widget.postComment.text,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontFamily: 'Rubik',
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis, // better visual fallback
                ),
              ],
            ),
          ),

          // Likes Part
          SizedBox(
            width: Get.width * 0.15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 16,
                  width: 16,
                  child: isLoading
                      ? CircularProgressIndicator(color: secondaryColor)
                      : GestureDetector(
                          onTap: likeComment,
                          child: SvgPicture.asset('assets/imgs/heart_red.svg'),
                        ),
                ),
                Text(
                  likeCount.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Rubik',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
