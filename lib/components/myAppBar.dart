import 'package:flutter/material.dart';

import '../gpt/gpt_service.dart';
import '../gpt/models/chat_history_manager.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar(
      {super.key,
      required this.useLightMode,
      required this.handleBrightnessChange,
      required this.showExtraIcons});

  final bool useLightMode;
  final Function(bool useLightMode) handleBrightnessChange;
  final bool showExtraIcons;

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MyAppBarState extends State<MyAppBar> {
  // Use singleton instances
  final GptService _gptService = GptService();
  final ChatHistoryManager _chatHistoryManager = ChatHistoryManager();

  void _stopResponse() {
    _gptService.cancelGptResponse();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(title: const Text(' '), centerTitle: false, actions: [
      if (widget.showExtraIcons) ...[
        IconButton(
          onPressed: _stopResponse,
          icon: const Icon(Icons.pause),
          tooltip: 'stop response',
        ),
        // save chat icon button
        IconButton(
          onPressed: () {
            // save chat
            _chatHistoryManager.saveChat(
                _gptService.messages[0].text, _gptService.messages);
          },
          icon: const Icon(Icons.save),
          tooltip: 'save chat',
        ),
      ],
      IconButton(
        icon: widget.useLightMode
            ? Icon(Icons.wb_sunny_outlined,
            color: Theme.of(context).colorScheme.onSurface)
            : Icon(Icons.wb_sunny,
            color: Theme.of(context).colorScheme.onSurface),
        onPressed: () {
          widget.handleBrightnessChange(!widget.useLightMode);
        },
        tooltip: "Toggle brightness",
      ),
    ]);
  }
}
