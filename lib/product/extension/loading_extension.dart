import 'package:flutter/material.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';

extension LoadingExtension on CircularProgressIndicator {
  static Widget loadingBar(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: ColorConstant.primary,
        strokeWidth: DoubleConstant.two,
        strokeCap: StrokeCap.square,
      ),
    );
  }
}
