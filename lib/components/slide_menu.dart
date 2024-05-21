import 'package:flutter/material.dart';
import 'package:travely/pages/calendar_page.dart';
import 'package:travely/pages/map_page.dart';
import 'package:travely/pages/profile_page.dart';
import 'package:travely/pages/routes_page.dart';

class SideMenu extends StatelessWidget {
  final Function(int) onItemTapped;

  SideMenu({required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Map'),
            onTap: () {
              Navigator.pop(context);
              onItemTapped(0);
            },
          ),
          ListTile(
            title: Text('RoutesPage'),
            onTap: () {
              Navigator.pop(context);
              onItemTapped(1);
            },
          ),
          ListTile(
            title: Text('CalendarPage'),
            onTap: () {
              Navigator.pop(context);
              onItemTapped(2);
            },
          ),
          ListTile(
            title: Text('ProfilePage'),
            onTap: () {
              Navigator.pop(context);
              onItemTapped(3);
            },
          ),
        ],
      ),
    );
  }
}
