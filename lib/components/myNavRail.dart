import 'package:flutter/material.dart';

class MyNavRail extends StatefulWidget {
  const MyNavRail({Key? key}) : super(key: key);

  @override
  State<MyNavRail> createState() => _MyNavRailState();
}

class _MyNavRailState extends State<MyNavRail> {
  bool extanded = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      leading: const Icon(Icons.menu),
      onDestinationSelected: (int index) {
        if (index == 0) {
          setState(() {
            _selectedIndex = index;
          });
          // Navigator.pushNamed(context, '/dashboard');
        } else if (index == 1) {
          setState(() {
            _selectedIndex = index;
          });
          // Navigator.pushNamed(context, '/settings');
        } else if (index == 2) {
          setState(() {
            _selectedIndex = index;
          });
          // Navigator.pushNamed(context, '/about');
        } else if (index == 3) {
          setState(() {
            _selectedIndex = index;
          });
          // Navigator.pushNamed(context, '/logout');
        } else if (index == 4) {
          setState(() {
            extanded = !extanded;
          });
        }
      },
      destinations: [
        const NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text('Dashboard'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.info),
          label: Text('About'),
        ),
        const NavigationRailDestination(
          icon: Icon(Icons.logout),
          label: Text('Logout'),
        ),
        NavigationRailDestination(
          icon: extanded
              ? const Icon(Icons.arrow_left)
              : const Icon(Icons.arrow_right),
          label: extanded ? const Text('collapse') : const Text('expand'),
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.5),
        ),
      ],
      selectedIndex: _selectedIndex,
      extended: extanded,
    );
  }
}
