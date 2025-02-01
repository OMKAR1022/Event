import 'package:flutter/material.dart';

class ResponsiveSize {
  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double fontSize(BuildContext context, double baseFontSize) {
    double screenWidth = width(context);
    if (screenWidth > 600) {
      return baseFontSize * 1.2;
    } else if (screenWidth > 400) {
      return baseFontSize * 1.1;
    } else {
      return baseFontSize;
    }
  }

  static double padding(BuildContext context, double basePadding) {
    double screenWidth = width(context);
    if (screenWidth > 600) {
      return basePadding * 1.5;
    } else if (screenWidth > 400) {
      return basePadding * 1.2;
    } else {
      return basePadding;
    }
  }
}

