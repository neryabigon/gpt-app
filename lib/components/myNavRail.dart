import 'package:flutter/material.dart';
import 'package:gpt/gpt/models/gpt_service.dart';
import 'setting_widget.dart';

class MyNavRail extends StatefulWidget {
  const MyNavRail({
    super.key,
    required this.useLightMode,
    required this.handleBrightnessChange, required this.gptService,
  });

  final bool useLightMode;
  final Function(bool useLightMode) handleBrightnessChange;
  final GptService gptService;

  @override
  State<MyNavRail> createState() => _MyNavRailState();
}

class _MyNavRailState extends State<MyNavRail> {
  bool extended = false;
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
        } else if (index == 1) {
          setState(() {
            _selectedIndex = index;
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Settings'),
                  content: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3, // Adjust the width of the popup
                    child: SettingsWidget(
                        handleBrightnessChange: widget.handleBrightnessChange,
                        useLightMode: widget.useLightMode,
                        gptService: widget.gptService),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          });
        } else if (index == 2) {
          setState(() {
            _selectedIndex = index;
          });
        }
      },
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          label: Text('Home'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.info),
          label: Text('About'),
        ),
      ],
      selectedIndex: _selectedIndex,
      extended: extended,
    );
  }
}
