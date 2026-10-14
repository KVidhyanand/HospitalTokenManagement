import 'dart:convert';

import '../models/dashboard_model.dart';

import '../services/api_service.dart';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardRepository {
  final ApiService apiService;

  DashboardRepository(this.apiService);

  Future<DashboardModel> fetchDashboard() async {
    print("@@@@@@@@Fetching dashboard data...");
    try {
      final json = await apiService.getDashboard();

      final prefs = await SharedPreferences.getInstance();
      final cache = prefs.getString("dashboard");

      if (cache != null) {
        return DashboardModel.fromJson(jsonDecode(cache));
      }

      return DashboardModel.fromJson(json);
    } catch (e) {
      throw Exception("Unable to fetch dashboard");
    }
  }
}
