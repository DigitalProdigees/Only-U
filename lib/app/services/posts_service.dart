import 'package:flutter/material.dart';
import 'package:only_u/app/common/repository/http_client.dart';
import 'package:only_u/app/data/models/api_response_model.dart';

class PostsService {
  Future<ApiResponse> getPosts({
    required int page,
    required int limit,
    required String userId,
  }) async {
    try {
      final resp = await HttpRider().mainGetRoute(
        "/posts/category/F8v8wV5ZeiVgIM2Hqjbh?limit=$limit&page=$page&userId=$userId",
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
}
