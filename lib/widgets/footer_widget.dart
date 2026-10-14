import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/colors.dart';
import '../core/constants.dart';
import '../core/tv_sizes.dart';

class FooterWidget extends StatelessWidget {
  final bool isConnected;
  final DateTime? lastUpdated;

  const FooterWidget({super.key, required this.isConnected, this.lastUpdated});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: TvSizes.footerHeight(context),

      padding: const EdgeInsets.symmetric(horizontal: 20),

      decoration: const BoxDecoration(color: AppColors.footer),

      child: Row(
        children: [
          /// Connection Status
          Icon(
            Icons.circle,
            size: 12,
            color: isConnected ? AppColors.online : AppColors.offline,
          ),

          const SizedBox(width: 8),

          Text(
            isConnected ? "Connected" : "Offline",
            style: TextStyle(
              color: Colors.white,
              fontSize: TvSizes.footerText(context),
            ),
          ),

          const SizedBox(width: 30),

          /// Last Updated
          Text(
            "Last Updated : "
            "${lastUpdated == null ? '--' : DateFormat('dd-MMM-yyyy hh:mm:ss a').format(lastUpdated!)}",
            style: TextStyle(
              color: Colors.white,
              fontSize: TvSizes.footerText(context),
            ),
          ),

          const Spacer(),

          /// Refresh Interval
          Text(
            "Refresh : ${AppConstants.refreshSeconds}s",
            style: TextStyle(
              color: Colors.white,
              fontSize: TvSizes.footerText(context),
            ),
          ),

          const SizedBox(width: 30),

          /// Welcome Message
          Text(
            AppConstants.footerMessage,
            style: TextStyle(
              color: Colors.white,
              fontSize: TvSizes.footerText(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
