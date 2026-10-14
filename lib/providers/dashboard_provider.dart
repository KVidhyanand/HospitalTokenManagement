import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospital_token/services/api_service.dart';

import '../models/dashboard_model.dart';
import '../repository/dashboard_repository.dart';

final apiProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final repositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(ref.read(apiProvider));
});

/// Provider (TOP LEVEL)
final dashboardProvider =
    AsyncNotifierProvider<DashboardNotifier, DashboardModel>(
      DashboardNotifier.new,
    );

class DashboardNotifier extends AsyncNotifier<DashboardModel> {
  Timer? _timer;

  @override
  Future<DashboardModel> build() async {
    // Initial API call
    final data = await _loadDashboard();

    // Start auto refresh
    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => refreshDashboard(),
    );

    // Dispose timer automatically
    ref.onDispose(() {
      _timer?.cancel();
    });

    return data;
  }

  Future<DashboardModel> _loadDashboard() async {
    return ref.read(repositoryProvider).fetchDashboard();
  }

  bool _isRefreshing = false;

  DateTime? _lastRefresh;

  Future<void> refreshDashboard() async {
    if (_isRefreshing) return;

    _isRefreshing = true;

    try {
      final data = await _loadDashboard();

      _lastRefresh = DateTime.now();

      state = AsyncData(data);
    } catch (e, st) {
      state = AsyncError(e, st);
    } finally {
      _isRefreshing = false;
    }
  }
}
