import 'package:flutter/material.dart';
import 'package:only_u/app/common/repository/http_client.dart';
import 'package:only_u/app/data/models/api_response_model.dart';

class CategoriesService {
  Future<ApiResponse> getCategories() async {
    try {
      final resp = await HttpRider().mainGetRoute("/categories/");

      if (resp == null || resp.isEmpty) {
        return ApiResponse(
          Status: "error",
          Code: 500,
          Message: "No data received from server",
        );
      }
      debugPrint("Get Categories Response: $resp");

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
