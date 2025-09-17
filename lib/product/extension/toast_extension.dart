import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/product/constant/color_constant.dart';

extension ToastExtension on String {
  static void showToast({
    required String message,
    required Color backgroundColor,
    required BuildContext context,
  }) {
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: ColorConstant.primary,
      fontSize: context.general.textTheme.bodyMedium?.fontSize,
    );
  }
}
