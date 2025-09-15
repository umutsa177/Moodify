import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/product/constant/color_constant.dart';

extension ProjectDecoration on OutlineInputBorder {
  // Button border for login and register view
  static OutlineInputBorder authBorder(BuildContext context) =>
      OutlineInputBorder(
        borderRadius: context.border.lowBorderRadius,
        borderSide: const BorderSide(
          color: ColorConstant.primary,
        ),
      );
}
