import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:only_u/app/data/constants.dart';
import 'package:only_u/app/data/models/post_model.dart';

class PostView extends StatefulWidget {
  const PostView({super.key, required this.post});

  final PostModel post;

  @override
  State<PostView> createState() => _PostViewState();
}

class _PostViewState extends State<PostView> {
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
          SvgPicture.asset('assets/imgs/like_white.svg'),
          SizedBox(width: 5),
          Text(
            "${widget.post.likesCount}",
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
