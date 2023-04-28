import 'package:flutter/material.dart';

import '../gpt/models/gpt_service.dart';

class SettingsWidget extends StatefulWidget {
  const SettingsWidget({
    super.key,
    required this.useLightMode,
    required this.handleBrightnessChange,
    required this.gptService,
  });

  final bool useLightMode;
  final Function handleBrightnessChange;
  final GptService gptService;

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final TextEditingController _apiKeyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load the current settings (API key, theme mode, etc.) from persistent storage here
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            title: const Text('API Key'),
            subtitle: TextField(
              controller: _apiKeyController,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your API key',
              ),
            ),
          ),
          // TODO: Add more settings here
          ElevatedButton(
            onPressed: () {
              // Update the API key in the GptService singleton
              GptService().updateApiKey(_apiKeyController.text);
              // Save the updated settings (API key, theme mode, etc.) to persistent storage here
              // Also update the app state to apply the new settings
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
