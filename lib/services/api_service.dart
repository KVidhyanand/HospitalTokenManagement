import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  late final Dio _dio;

  //https://mpd4529156cc596006ca.free.beeceptor.com/data

  //https://dummyjson.com/c/c687-6c12-418a-b7ea

  ApiService() {
    _dio = Dio(
      BaseOptions(
        //baseUrl: "https://mocki.io/v1/d990bdb8-418d-4fba-bbcd-36dada2c0e7b",
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        headers: {"Content-Type": "application/json"},
      ),
    );
  }

  Future<Map<String, dynamic>> getDashboard() async {
    final response = await _dio.get(
      "https://mocki.io/v1/b98f53d5-0456-4b3f-bfe4-7fa61c9f404c",
    );
    //final response = await _dio.get("dashboard");
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString("dashboard", jsonEncode(response.data));
      return response.data;
    }

    throw Exception("Unable to fetch dashboard");
  }
}
