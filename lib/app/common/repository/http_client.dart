import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:only_u/app/data/constants.dart';

class HttpRider {
  var dio = Dio(
    BaseOptions(
      followRedirects: true,
      validateStatus: (status) => status! < 500,
    ),
  );

  Future<dynamic> mainGetRoute(String route) async {
    debugPrint(baseURl + route);
    var resp = await dio.get(baseURl + route);
    debugPrint(resp.data.toString());
    return resp.data;
  }

  Future<Map<String, dynamic>> mainPostRoute(String route, dynamic data) async {
    debugPrint("📤 Request URL: $baseURl$route");
    debugPrint("📤 Request Body: $data");

    try {
      final resp = await dio.post(baseURl + route, data: data);

      debugPrint("📥 Status Code: ${resp.statusCode}");
      debugPrint("📥 Response: ${resp.data}");

      if (resp.data is Map<String, dynamic>) {
        return resp.data;
      } else {
        // if backend returns a list/string, wrap it in a map
        return {"data": resp.data};
      }
    } catch (e) {
      debugPrint("mainPostRoute error: $e");
      return {
        "Status": "error",
        "Message": "Request failed",
        "Error": e.toString(),
      };
    }
  }
}
