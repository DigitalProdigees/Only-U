import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:only_u/app/common/repository/http_client.dart';
import 'package:only_u/app/data/models/api_response_model.dart';

class UserService {
  Future<ApiResponse> followOtherUser({required String followingId}) async {
    try {
      final data = {
        "followerId": FirebaseAuth.instance.currentUser?.uid,
        "followingId": followingId,
      };
      final resp = await HttpRider().mainPostRoute("/users/follow", data);

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
      debugPrint("Follow User error: $e");
      return ApiResponse(
        Status: "error",
        Code: 500,
        Message: "Error Following a user: ${e.toString()}",
      );
    }
  }
}
