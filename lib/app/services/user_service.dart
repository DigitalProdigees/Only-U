import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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

  Future<ApiResponse> checkUserFollowinStatus({
    required String followingUserId,
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    try {
      final resp = await HttpRider().mainGetRoute(
        "/users/checkFollowStatus?followerId=$currentUserId&followingId=$followingUserId",
      );

      if (resp == null || resp.isEmpty) {
        return ApiResponse(
          Status: "error",
          Code: 500,
          Message: "No data received from server",
        );
      }
      debugPrint("Check User Follow Status Response: $resp");

      return ApiResponse.fromJson(resp);
    } catch (e) {
      return ApiResponse(
        Status: "error",
        Code: 500,
        Message: "Error checking user following status: ${e.toString()}",
      );
    }
  }

  Future<Map<String, dynamic>?> getCurrentUserProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint("No authenticated user.");
        return null;
      }

      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data();
      } else {
        debugPrint("User profile not found.");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      return null;
    }
  }

  Future<bool> updateUserProfile(Map<String, dynamic> updatedData) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint("No authenticated user.");
        return false;
      }

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      await userRef.update(updatedData);

      debugPrint("Profile updated successfully!");
      return true;
    } catch (e) {
      debugPrint("Error updating profile: $e");
      return false;
    }
  }

  Future<ApiResponse> getFollowingOrFollowers({
    required String connectionType, // followers or following
  }) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    try {
      final resp = await HttpRider().mainGetRoute(
        "/users/$currentUserId/$connectionType",
      );

      if (resp == null || resp.isEmpty) {
        return ApiResponse(
          Status: "error",
          Code: 500,
          Message: "No data received from server",
        );
      }
      debugPrint("Getting users connections: $resp");

      return ApiResponse.fromJson(resp);
    } catch (e) {
      return ApiResponse(
        Status: "error",
        Code: 500,
        Message: "Error Getting users connections: ${e.toString()}",
      );
    }
  }

  Future<ApiResponse> getOtherUserStats({required String userId}) async {
    try {
      final resp = await HttpRider().mainGetRoute("/users/$userId/stats");

      if (resp == null || resp.isEmpty) {
        return ApiResponse(
          Status: "error",
          Code: 500,
          Message: "No data received from server",
        );
      }
      debugPrint("getOtherUserStats Response: $resp");

      return ApiResponse.fromJson(resp);
    } catch (e) {
      return ApiResponse(
        Status: "error",
        Code: 500,
        Message: "Error Getting other user stats: ${e.toString()}",
      );
    }
  }

  Future<void> updateFcmToken() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint("No authenticated user.");
        return;
      }

      final fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken == null) {
        debugPrint("Failed to get FCM token.");
        return;
      }

      final userRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);

      await userRef.update({'fcmToken': fcmToken});

      debugPrint("FCM token updated successfully!");
    } catch (e) {
      debugPrint("Error updating FCM token: $e");
    }
  }
}
