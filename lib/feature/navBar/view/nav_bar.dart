import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';
import 'package:moodify/feature/navBar/mixin/nav_bar_mixin.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/icon_constant.dart';
import 'package:moodify/product/enum/moods.dart';

class NavBar extends StatefulWidget {
  const NavBar({required this.mood, super.key});

  final Moods mood;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with NavBarMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[selectedIndex],
      extendBody: true,
      bottomNavigationBar: ClipRRect(
        borderRadius: context.border.normalBorderRadius,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: getNavBarIcon(
                icon: IconConstant.feed,
                isSelected: selectedIndex == 0,
              ),
              label: StringConstant.feed,
            ),
            BottomNavigationBarItem(
              icon: getNavBarIcon(
                icon: IconConstant.profile,
                isSelected: selectedIndex == 1,
              ),
              label: StringConstant.profile,
            ),
          ],
        ),
      ),
    );
  }
}
