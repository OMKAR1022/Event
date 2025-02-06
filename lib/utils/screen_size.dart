import 'package:flutter/material.dart';

class ScreenSize {
  static double height(BuildContext context, [double dividedBy = 1]) =>
      MediaQuery.of(context).size.height / dividedBy;

  static double width(BuildContext context, [double dividedBy = 1]) =>
      MediaQuery.of(context).size.width / dividedBy;

  // Responsive Text Size
  static double textSize(BuildContext context, double size) {
    // Adjust the scale factor as needed
    return (MediaQuery.of(context).size.width * 0.0025) * size;
  }

  // Responsive Padding
  static EdgeInsets padding(BuildContext context, {double all = 8}) {
    return EdgeInsets.all(width(context) * (all / 100));
  }

  // Responsive Margin
  static EdgeInsets margin(BuildContext context, {double all = 8}) {
    return EdgeInsets.all(width(context) * (all / 100));
  }
}
