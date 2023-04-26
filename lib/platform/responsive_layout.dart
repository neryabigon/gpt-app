import 'package:flutter/material.dart';

/*
 * This class is used to build the responsive layout for the app.
 * Since it does the fitting based on the screen size, it fit well for the web too out of the box (desktop and mobile browsers).
 */

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;
  final Widget desktopBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.tabletBody,
    required this.desktopBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 500) {
          return mobileBody;
        } else if (constraints.maxWidth < 1100) {
          return tabletBody;
        } else {
          return desktopBody; // also fit well for the web
        }
      },
    );
  }
}
