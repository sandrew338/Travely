import 'package:flutter/material.dart';
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
  final List<Widget> _screens = [const MapPage(), const RoutesPage(), const SavedPage(), const CalendarPage(), const ProfilePage()];
    int _selectedIndex = 0;

  void _onPageChanged(int selectedIndex) {
     setState(() {
      _selectedIndex = selectedIndex;
     });
  }
  void _onItemTapped(int selectedIndex) {
    print("Selected index: $selectedIndex");
    _pageController.jumpToPage(selectedIndex);
  }
  Color selectColor(int index)=>_selectedIndex == index ? const Color.fromARGB(255, 191, 68, 68): Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar:
    BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex:_selectedIndex,
          backgroundColor: Colors.green[100],
          onTap: _onItemTapped,
          selectedItemColor : Colors.redAccent,
          //fixedColor: Colors.grey,
          //selectedItemColor: Colors.grey,
          items: [
            //_selectedIndex == 0 ? Colors.red: Colors.grey
            BottomNavigationBarItem(icon: Icon(Icons.map, color: selectColor(0)),label: 'Map'),
            BottomNavigationBarItem(icon: Icon(Icons.route,color:  selectColor(1)), label: 'Routes'),
            BottomNavigationBarItem(icon: Icon(Icons.save,color:  selectColor(2)), label: 'Saved'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_month, color:  selectColor(3)), label: 'Calendar'),
            BottomNavigationBarItem(icon: Icon(Icons.man, color:  selectColor(4)), label: 'Profile'),
          ],
        
      ),);
}
}