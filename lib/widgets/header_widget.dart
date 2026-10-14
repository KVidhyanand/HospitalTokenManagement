import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/colors.dart';
import '../core/constants.dart';
import '../core/tv_sizes.dart';

class HeaderWidget extends StatefulWidget {
  final bool isConnected;

  const HeaderWidget({super.key, required this.isConnected});

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final titleSize = TvSizes.is4K(context) ? 42.0 : 24.0;
    final subTitleSize = TvSizes.is4K(context) ? 22.0 : 14.0;
    final timeSize = TvSizes.is4K(context) ? 30.0 : 18.0;

    return Container(
      height: TvSizes.headerHeight(context),
      padding: const EdgeInsets.symmetric(horizontal: 20),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff1565C0), Color(0xff0D47A1)],
        ),
      ),

      child: Row(
        children: [
          /// Logo
          Image.asset(
            "assets/images/hospital_logo.png",
            height: TvSizes.is4K(context) ? 90 : 55,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.local_hospital, color: Colors.white, size: 50),
          ),

          const SizedBox(width: 20),

          /// Hospital Details
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.hospitalName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  "OPD Token Management System",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: subTitleSize,
                  ),
                ),
              ],
            ),
          ),

          /// Center Title
          Expanded(
            child: Center(
              child: Text(
                "TOKEN DISPLAY",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: titleSize,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),

          /// Right Section
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat("dd-MMM-yyyy").format(_now),
                style: TextStyle(color: Colors.white70, fontSize: subTitleSize),
              ),

              const SizedBox(height: 8),

              Text(
                DateFormat("hh:mm:ss a").format(_now),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: timeSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
