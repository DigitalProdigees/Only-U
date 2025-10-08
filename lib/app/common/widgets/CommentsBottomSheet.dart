import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:only_u/app/common/widgets/LoadingView.dart';
import 'package:only_u/app/common/widgets/PostCommentView.dart';
import 'package:only_u/app/data/models/post_comment.dart';
import 'package:only_u/app/services/auth_service.dart';
import 'package:only_u/app/services/posts_service.dart';

class CommentsBottomSheet extends StatefulWidget {
  CommentsBottomSheet({super.key, required this.postId});

  final String postId;

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final CommentController commentController = Get.put(CommentController());

  @override
  void initState() {
    commentController.loadComemnts(postId: widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Obx(
            () => commentController.loadingComments.value
                ? LoadingView()
                : Expanded(
                    child: ListView.separated(
                      controller: commentController.listViewScrollController,
                      itemBuilder: (context, index) => PostCommentView(
                        postComment: PostComment.fromJson(
                          commentController.comments[index],
                        ),
                        postId: widget.postId,
                      ),
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 5);
                      },
                      itemCount: commentController.comments.length,
                    ),
                  ),
          ),
          SizedBox(height: 10),
          Obx(
            () =>
                commentController.loadingComments.value ? Spacer() : SizedBox(),
          ),

          _buildCommentInputField(),
        ],
      ),
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
          controller: commentController.commentTextFieldController,
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
            suffixIcon: Obx(
              () => commentController.commentButtonLoading.value
                  ? SizedBox(height: 15, width: 15, child: LoadingView())
                  : IconButton(
                      onPressed: () {
                        commentController.onSendCommentButtonTapped(
                          postId: widget.postId,
                        );
                      },
                      icon: Icon(Icons.send, color: Colors.white),
                    ),
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

class CommentController extends GetxController {
  final TextEditingController commentTextFieldController =
      TextEditingController();

  final ScrollController listViewScrollController = ScrollController();
  var loadingComments = true.obs;
  var commentButtonLoading = false.obs;
  var comments = [].obs;

  void loadComemnts({required String postId}) async {
    comments.clear();
    loadingComments.value = true;
    final response = await PostsService().getPostComments(postID: postId);
    if (response.Status == 'success') {
      comments.addAll(response.Data['comments']);
    }
    loadingComments.value = false;
  }

  void onSendCommentButtonTapped({required String postId}) async {
    commentButtonLoading.value = true;
    final AuthService authService = AuthService();
    final response = await PostsService().addCommentPost(
      postId: postId,
      userId: authService.currentUser!.uid,
      comment: commentTextFieldController.text,
    );
    debugPrint("Add Comment Response: $response");
    if (response.Status == "success") {
      //Refreshing Comments
      final response = await PostsService().getPostComments(postID: postId);
      if (response.Status == 'success') {
        comments.clear();
        comments.addAll(response.Data['comments']);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        listViewScrollController.animateTo(
          listViewScrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
      commentTextFieldController.clear();
    }

    commentButtonLoading.value = false;
  }
}
