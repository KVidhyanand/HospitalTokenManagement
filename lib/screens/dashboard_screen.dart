import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospital_token/widgets/app_scaffold.dart';
import 'package:hospital_token/widgets/clinic_card.dart';
import 'package:hospital_token/widgets/department_panel.dart';
import 'package:hospital_token/widgets/footer_widget.dart';
import 'package:hospital_token/widgets/header_widget.dart';

import '../providers/dashboard_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(dashboardProvider);

    return AppScaffold(
      body: dashboard.when(
        loading: () {
          return const Center(child: CircularProgressIndicator());
        },

        error: (error, stackTrace) {
          return Center(
            child: Text(error.toString(), style: const TextStyle(fontSize: 25)),
          );
        },

        data: (dashboardData) {
          return Column(
            children: [
              HeaderWidget(isConnected: true),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),

                  child: Row(
                    children: [
                      Expanded(
                        child: DepartmentPanel(
                          department: dashboardData.departments[0],
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: DepartmentPanel(
                          department: dashboardData.departments[1],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //FooterWidget(isConnected: true, lastUpdated: DateTime.now()),
            ],
          );
        },
      ),
    );
  }
}
