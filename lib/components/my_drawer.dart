import 'package:flutter/material.dart';
import '../gpt/chat_history_widget.dart';
import '../gpt/gpt_service.dart';
import '../gpt/models/chat_history_manager.dart';
import '../gpt/models/message.dart';

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
        ],
      ),
    );
  }
}
