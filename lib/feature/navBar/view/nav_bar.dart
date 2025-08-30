import 'package:flutter/material.dart';
import 'package:moodify/feature/navBar/mixin/nav_bar_mixin.dart';
import 'package:moodify/product/constant/string_constant.dart';
import 'package:moodify/product/enum/icon_constant.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with NavBarMixin<NavBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: getNavBarIcon(
              IconConstant.feed,
              isSelected: selectedIndex == 0,
            ),
            label: StringConstant.feed,
          ),
          BottomNavigationBarItem(
            icon: getNavBarIcon(
              IconConstant.profile,
              isSelected: selectedIndex == 1,
            ),
            label: StringConstant.profile,
          ),
        ],
      ),
    );
  }
}
