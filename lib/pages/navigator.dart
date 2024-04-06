// NavigationBar(
// backgroundColor: Colors.white,
// height: 80,
// //onDestinationSelected:()=>
// destinations: const[
//
// NavigationDestination(icon: Icon(Icons.map, color: Colors.red), label: ''),
// NavigationDestination(icon: Icon(Icons.route), label: ''),
// NavigationDestination(icon: Icon(Icons.save), label: ''),
// NavigationDestination(icon: Icon(Icons.calendar_month), label: ''),
// NavigationDestination(icon: Icon(Icons.man), label: ''),
// ]
// //child: bottomAppBarContents,
// ),
import 'package:flutter/material.dart';
class BottomNavigationBarExample extends StatefulWidget {
  const BottomNavigationBarExample({super.key});

  @override
  State<BottomNavigationBarExample> createState() =>
      _BottomNavigationBarExampleState();
}

class _BottomNavigationBarExampleState extends State<BottomNavigationBarExample> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
