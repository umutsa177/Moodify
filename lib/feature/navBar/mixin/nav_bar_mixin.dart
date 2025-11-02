import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/feature/feed/view/feed_view.dart';
import 'package:moodify/feature/navBar/view/nav_bar.dart';
import 'package:moodify/feature/profile/view/profile_view.dart';
import 'package:moodify/product/constant/color_constant.dart';
import 'package:moodify/product/constant/double_constant.dart';
import 'package:moodify/product/enum/icon_constant.dart';

mixin NavBarMixin on State<NavBar> {
  int selectedIndex = 0;
  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      FeedView(mood: widget.mood),
      const ProfileView(),
    ];
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget getNavBarIcon({
    required IconConstant icon,
    required bool isSelected,
  }) {
    return isSelected ? _selectedIcon(icon) : _unselectedIcon(icon);
  }

  Widget _selectedIcon(IconConstant icon) {
    return Container(
      padding:
          context.padding.horizontalNormal +
          context.padding.horizontalLow +
          context.padding.verticalLow,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: ColorConstant.navBarButtonColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: context.border.highBorderRadius,
        boxShadow: [
          BoxShadow(
            color: ColorConstant.navBarButtonShadowColor,
            blurRadius: DoubleConstant.twelve,
            offset: const Offset(DoubleConstant.zero, DoubleConstant.four),
          ),
        ],
      ),
      child: SvgPicture.asset(
        icon.toSelectedSvg,
        colorFilter: const ColorFilter.mode(
          ColorConstant.primary,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _unselectedIcon(IconConstant icon) {
    return SvgPicture.asset(
      icon.toSvg,
      colorFilter: const ColorFilter.mode(
        ColorConstant.turquoise,
        BlendMode.srcIn,
      ),
    );
  }
}
