import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/feature/feed/view/feed_view.dart';
import 'package:moodify/feature/profile/view/profile_view.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/enum/icon_constant.dart';

mixin NavBarMixin<T extends StatefulWidget> on State<T> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    FeedView(),
    ProfileView(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget getNavBarIcon(IconConstant iconConstant, {required bool isSelected}) {
    return SvgPicture.asset(
      isSelected ? iconConstant.toSelectedSvg : iconConstant.toSvg,
      colorFilter: ColorFilter.mode(
        isSelected ? ColorConstant.secondary : ColorConstant.turquoise,
        BlendMode.srcIn,
      ),
      width: context.sized.mediumValue,
      height: context.sized.mediumValue,
    );
  }
}
