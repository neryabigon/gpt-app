import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gpt/platform/desktop/desktop_body.dart';
import 'package:gpt/platform/tablet/tablet_body.dart';
import 'platform/mobile/mobile_body.dart';
import 'platform/responsive_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.system;

  bool get useLightMode {
    switch (themeMode) {
      case ThemeMode.system:
        return PlatformDispatcher.instance.platformBrightness ==
            Brightness.light;
      case ThemeMode.light:
        return true;
      case ThemeMode.dark:
        return false;
    }
  }

  void handleBrightnessChange(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: Colors.blueGrey,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.blueGrey,
        // visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: themeMode,
      home: ResponsiveLayout(
        mobileBody: MobileScaffold(
            useLightMode: useLightMode,
            handleBrightnessChange: handleBrightnessChange,),
        tabletBody: TabletScaffold(
            useLightMode: useLightMode,
            handleBrightnessChange: handleBrightnessChange,),
        desktopBody: DesktopScaffold(
            useLightMode: useLightMode,
            handleBrightnessChange: handleBrightnessChange,),
      ),
    );
  }
}
