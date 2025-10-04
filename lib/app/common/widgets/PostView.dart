import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:only_u/app/data/constants.dart';
import 'package:only_u/app/data/models/post_model.dart';
import 'package:only_u/app/services/posts_service.dart';

class PostView extends StatefulWidget {
  PostView({super.key, required this.post});

  PostModel post;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
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
        userId: 'user1235',
      );
      if (response.Status != "success") {
        // If the API call fails, revert the like status and count
        setState(() {
          if (isLiked) {
            isLiked = false;
            likesCount -= 1;
          } else {
            isLiked = true;
            likesCount += 1;
          }
        });
      }
      setState(() {
        likesCount = response.Data['likesCount'] ?? likesCount;
      });
    } catch (e) {
      setState(() {
        if (isLiked) {
          isLiked = false;
          likesCount -= 1;
        } else {
          isLiked = true;
          likesCount += 1;
        }
      });
    }
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
          _buildImageView(),
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
            child: Text(
              'Brooklyn Simmons',
              style: TextStyle(
                color: Color(0xFFFFF7FA),
                fontSize: 16,
                fontFamily: 'Rubik',
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
          SvgPicture.asset('assets/imgs/comment_white.svg'),
          SizedBox(width: 5),
          Text(
            "${widget.post.commentsCount}",
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Rubik',
              color: Colors.white,
            ),
          ),
          Spacer(),
          SvgPicture.asset('assets/imgs/send_white.svg'),
        ],
      ),
    );
  }
}
