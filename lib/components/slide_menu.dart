import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final Function(int) onItemTapped;

  const SideMenu({super.key, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Menu'),
          ),
          ListTile(
            title: const Text('Map'),
            onTap: () {
              Navigator.pop(context);
              onItemTapped(0);
            },
          ),
          ListTile(
            title: const Text('RoutesPage'),
            onTap: () {
              Navigator.pop(context);
              onItemTapped(1);
            },
          ),
          ListTile(
            title: const Text('CalendarPage'),
            onTap: () {
              Navigator.pop(context);
              onItemTapped(2);
            },
          ),
          ListTile(
            title: const Text('ProfilePage'),
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
