import 'package:flutter/material.dart';

var drawerTextColor = TextStyle(
  color: Colors.grey[600],
);

var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);



var myDrawer = Drawer(
  // backgroundColor: Colors.grey[300],
  elevation: 0,
  child: ListView(children: [
    Column(
      children: [
        const DrawerHeader(
          child: Icon(
            Icons.menu,
            size: 64,
          ),
        ),
        Padding(
          padding: tilePadding,
          child: ListTile(
            onTap: () {},
            leading: const Icon(Icons.home),
            title: const Text(
              'D A S H B O A R D',
            ),
          ),
        ),
        Padding(
          padding: tilePadding,
          child: ListTile(
            onTap: () {},
            leading: const Icon(Icons.settings),
            title: const Text(
              'S E T T I N G S',
            ),
          ),
        ),
        Padding(
          padding: tilePadding,
          child: ListTile(
            onTap: () {},
            leading: const Icon(Icons.info),
            title: const Text(
              'A B O U T',
            ),
          ),
        ),
        Padding(
          padding: tilePadding,
          child: ListTile(
            onTap: () {},
            leading: const Icon(Icons.logout),
            title: const Text(
              'L O G O U T',
            ),
          ),
        ),
      ],
    ),
  ]),
);
