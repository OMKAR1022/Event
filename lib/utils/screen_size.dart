import 'package:flutter/material.dart';

class ScreenSize {
  static double height(BuildContext context, [double dividedBy = 1]) =>
      MediaQuery.of(context).size.height / dividedBy;

  static double width(BuildContext context, [double dividedBy = 1]) =>
      MediaQuery.of(context).size.width / dividedBy;
}
