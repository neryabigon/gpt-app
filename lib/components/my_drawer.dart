import 'package:flutter/material.dart';
import '../gpt/widgets/chat_history_widget.dart';
import '../gpt/models/gpt_service.dart';
import '../gpt/models/chat_history_manager.dart';
import '../gpt/models/message.dart';
import '../gpt/widgets/model_setting_widget.dart';
import 'setting_widget.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer(
      {super.key,
      required this.useLightMode,
      required this.handleBrightnessChange,
      required this.gptService,
      required this.chatHistoryManager,
      required this.onLoadChat,
      required this.refreshNotifier});

  final bool useLightMode;
  final Function(bool useLightMode) handleBrightnessChange;
  final GptService gptService;
  final ChatHistoryManager chatHistoryManager;
  final Function(List<Message> messages) onLoadChat;
  final ValueNotifier<bool> refreshNotifier;

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.history,
              size: 40,
            ),
          ),
          Expanded(
            child: ChatHistoryWidget(
              useLightMode: widget.useLightMode,
              handleBrightnessChange: widget.handleBrightnessChange,
              chatHistoryManager: widget.chatHistoryManager,
              onLoadChat: widget.onLoadChat,
              refreshNotifier: widget.refreshNotifier,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Model Settings
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Model Settings'),
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          content: SizedBox(
                            height: MediaQuery.of(context).size.height *
                                0.6, // Change as per your requirement
                            width: MediaQuery.of(context).size.width *
                                0.3, // Adjust the width of the popup
                            child: ModelSettingsWidget(
                                handleBrightnessChange:
                                    widget.handleBrightnessChange,
                                useLightMode: widget.useLightMode,
                                gptService: widget.gptService),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.settings),
                ),
                // Settings
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Settings'),
                          content: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.3, // Adjust the width of the popup
                            child: SettingsWidget(
                                handleBrightnessChange:
                                    widget.handleBrightnessChange,
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
                  },
                  icon: const Icon(Icons.settings),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
