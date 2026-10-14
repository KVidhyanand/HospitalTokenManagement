import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static bool isWide(BuildContext context) {
    return MediaQuery.of(context).size.width > 1600;
  }

  static int departmentColumns(BuildContext context) {
    return isWide(context) ? 2 : 1;
  }

  static int clinicColumns(BuildContext context) {
    return isWide(context) ? 2 : 1;
  }

  static EdgeInsets screenPadding(BuildContext context) {
    return const EdgeInsets.all(16);
  }
}