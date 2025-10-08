import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:only_u/app/data/constants.dart';
import 'package:only_u/app/data/models/post_comment.dart';
import 'package:only_u/app/services/posts_service.dart';

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
