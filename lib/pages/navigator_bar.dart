// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travely/pages/map_page.dart';
import 'package:travely/pages/routes_page.dart';
import 'package:travely/pages/saved_page.dart';
import 'package:travely/pages/calendar_page.dart';
import 'package:travely/pages/profile_page.dart';

class NavigatorBar extends StatefulWidget {
  const NavigatorBar({super.key});

  @override
  State<NavigatorBar> createState() => _NavigatorBarState();
}

class _NavigatorBarState extends State<NavigatorBar> {
  final PageController _pageController = PageController();
<<<<<<< HEAD
  final List<Widget> _screens = [const MapPage(), const RoutesPage(), const SavedPage(), const CalendarPage(), const ProfilePage()];
    int _selectedIndex = 0;
=======
  final List<Widget> _screens = [
    const MapPage(),
    const RoutesPage(),
    const SavedPage(),
    const CalendarPage(),
    const ProfilePage()
  ];
  int _selectedIndex = 0;
>>>>>>> origin/Ivan_branch

  void _onPageChanged(int selectedIndex) {
    setState(() {
      _selectedIndex = selectedIndex;
    });
  }

  void _onItemTapped(int selectedIndex) {
    print("Selected index: $selectedIndex");
    _pageController.jumpToPage(selectedIndex);
  }
<<<<<<< HEAD
  Color selectColor(int index)=>_selectedIndex == index ? const Color.fromARGB(255, 191, 68, 68): Colors.grey;
=======
>>>>>>> origin/Ivan_branch

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: const Color(0xFFECEBE4),
          onTap: _onItemTapped,
          showUnselectedLabels: false,
          showSelectedLabels: false,
          items: [
            BotNavItem(_selectedIndex == 0
                ? "assets/images/selected/map_marker.svg"
                : "assets/images/unselected/map_marker.svg"),
            BotNavItem(_selectedIndex == 1
                ? "assets/images/selected/bookmark.svg"
                : "assets/images/unselected/bookmark.svg"),
            BotNavItem(_selectedIndex == 2
                ? "assets/images/selected/fire_flame_curved.svg"
                : "assets/images/unselected/fire_flame_curved.svg"),
            BotNavItem(_selectedIndex == 3
                ? "assets/images/selected/time_past.svg"
                : "assets/images/unselected/time_past.svg"),
            BotNavItem(_selectedIndex == 4
                ? "assets/images/selected/circle_user.svg"
                : "assets/images/unselected/circle_user.svg")
          ]),
    );
  }
}

class BotNavItem extends BottomNavigationBarItem {
  BotNavItem(String path, {Key? key})
      : super(
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xFFFAFAFF),
            ),
            child: SvgPicture.asset(
              path,
              height: 50,
            ),
          ),
          label: '', // Label text can be empty if needed
        );
}
