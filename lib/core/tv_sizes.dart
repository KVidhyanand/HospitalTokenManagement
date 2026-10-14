import 'package:flutter/material.dart';

class TvSizes {
  TvSizes._();

  static bool is4K(BuildContext context) =>
      MediaQuery.of(context).size.width >= 3000;

  static double scale(BuildContext context) {
    return is4K(context) ? 2.0 : 1.0;
  }

  static double headerHeight(BuildContext context) => is4K(context) ? 150 : 70;

  static double footerHeight(BuildContext context) => is4K(context) ? 70 : 45;

  static double departmentTitle(BuildContext context) =>
      is4K(context) ? 40 : 24;

  static double doctorName(BuildContext context) => is4K(context) ? 34 : 20;

  static double clinicTitle(BuildContext context) => is4K(context) ? 32 : 18;

  static double tokenNumber(BuildContext context) => is4K(context) ? 64 : 22;

  //static double tokenNumber(BuildContext context) => is4K(context) ? 64 : 32;

  static double tokenLabel(BuildContext context) => is4K(context) ? 26 : 16;

  static double footerText(BuildContext context) => is4K(context) ? 24 : 14;
}
