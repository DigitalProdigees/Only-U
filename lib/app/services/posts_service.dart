import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:only_u/app/common/repository/http_client.dart';
import 'package:only_u/app/data/models/api_response_model.dart';

class PostsService {
  Future<ApiResponse> getPosts({
    required int page,
    required int limit,
    required String userId,
    String? categoryId = "F8v8wV5ZeiVgIM2Hqjbh",
  }) async {
    try {
      final resp = await HttpRider().mainGetRoute(
        "/posts/category/$categoryId?limit=$limit&page=$page&userId=$userId",
        // "/posts?page=$page&limit=$limit&userId=$userId",
      );

      if (resp == null || resp.isEmpty) {
        return ApiResponse(
          Status: "error",
          Code: 500,
          Message: "No data received from server",
        );
      }
      debugPrint("PostsService Response: $resp");

      return ApiResponse.fromJson(resp);
    } catch (e) {
      return ApiResponse(
        Status: "error",
        Code: 500,
        Message: "Error fetching posts: ${e.toString()}",
      );
    }
  }

  Future<ApiResponse> likePost({
    required String postId,
    required String userId,
  }) async {
    try {
      final resp = await HttpRider().mainPostRoute("/posts/like", {
        "postId": postId,
        "userId": userId,
      });

      if (resp == null || resp.isEmpty) {
        return ApiResponse(
          Status: "error",
          Code: 500,
          Message: "No data received from server",
        );
      }
      debugPrint("Like Post Response: $resp");

      return ApiResponse.fromJson(resp);
    } catch (e) {
      debugPrint("likePost error: $e");
      return ApiResponse(
        Status: "error",
        Code: 500,
        Message: "Error liking post: ${e.toString()}",
      );
    }
  }

  Future<ApiResponse> addCommentPost({
    required String postId,
    required String userId,
    required String comment,
  }) async {
    try {
      final resp = await HttpRider().mainPostRoute("/posts/comment/add", {
        "postId": postId,
        "userId": userId,
        "text": comment,
      });

      if (resp == null || resp.isEmpty) {
        return ApiResponse(
          Status: "error",
          Code: 500,
          Message: "No data received from server",
        );
      }
      debugPrint("Commenting Post Response: $resp");

      return ApiResponse.fromJson(resp);
    } catch (e) {
      debugPrint("Commenting Post Response:  error: $e");
      return ApiResponse(
        Status: "error",
        Code: 500,
        Message: "Commenting Post Response: ${e.toString()}",
      );
    }
  }

  Future<ApiResponse> getPostComments({
    int limit = 100,
    required String postID,
  }) async {
    try {
      final resp = await HttpRider().mainGetRoute(
        "/posts/$postID/comments?limit=$limit",
      );

      if (resp == null || resp.isEmpty) {
        return ApiResponse(
          Status: "error",
          Code: 500,
          Message: "No data received from server",
        );
      }
      debugPrint("Post Comments Response: $resp");

      return ApiResponse.fromJson(resp);
    } catch (e) {
      return ApiResponse(
        Status: "error",
        Code: 500,
        Message: "Error fetching posts comments: ${e.toString()}",
      );
    }
  }

  Future<ApiResponse> likePostComment({
    required String postId,
    required String commentId,
  }) async {
    try {
      final resp = await HttpRider().mainPostRoute("/posts/likeComment", {
        "postId": postId,
        "commentId": commentId,
        "userId": FirebaseAuth.instance.currentUser?.uid,
      });

      if (resp == null || resp.isEmpty) {
        return ApiResponse(
          Status: "error",
          Code: 500,
          Message: "No data received from server",
        );
      }
      debugPrint("Like Post Comment Response: $resp");

      return ApiResponse.fromJson(resp);
    } catch (e) {
      debugPrint("Like Comment Post Response:  error: $e");
      return ApiResponse(
        Status: "error",
        Code: 500,
        Message: "Like Comment Post: ${e.toString()}",
      );
    }
  }
}
