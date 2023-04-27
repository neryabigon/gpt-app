import 'package:flutter/material.dart';

var drawerTextColor = TextStyle(
  color: Colors.grey[600],
);

var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);

// snackbar
void snack(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg,
          style:
          TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
      duration: const Duration(milliseconds: 800),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    ),
  );
}