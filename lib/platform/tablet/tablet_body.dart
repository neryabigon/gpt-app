import 'package:flutter/material.dart';
import 'package:gpt/gpt/chat_widget.dart';
import 'package:gpt/gpt/gpt_service.dart';
import '../../components/myAppBar.dart';
import '../../components/my_drawer.dart';
import '../../gpt/models/chat_history_manager.dart';

class TabletScaffold extends StatefulWidget {
  const TabletScaffold({
    super.key,
    required this.useLightMode,
    required this.handleBrightnessChange,
  });

  final bool useLightMode;
  final Function(bool useLightMode) handleBrightnessChange;

  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  // Use singleton instances
  final GptService _gptService = GptService();
  final ChatHistoryManager _chatHistoryManager = ChatHistoryManager();
  final ValueNotifier<bool> refreshNotifier = ValueNotifier<bool>(false);

  void refresh() {
    setState(() {
      refreshNotifier.value = !refreshNotifier.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: MyAppBar(
        useLightMode: widget.useLightMode,
        handleBrightnessChange: widget.handleBrightnessChange,
        showExtraIcons: false,
        onRefreshChatHistory: refresh,
      ),
      drawer: MyDrawer(
        useLightMode: widget.useLightMode,
        handleBrightnessChange: widget.handleBrightnessChange,
        gptService: _gptService,
        chatHistoryManager: _chatHistoryManager,
        onLoadChat: (messages) {
          setState(() {
            _gptService.messages = messages;
          });
        },
        refreshNotifier: refreshNotifier,
      ),
      body: ChatWidget(
        useLightMode: widget.useLightMode,
        handleBrightnessChange: widget.handleBrightnessChange,
        gptService: _gptService,
        chatHistoryManager: _chatHistoryManager,
        showExtraIcons: true,
        onRefreshChatHistory: refresh,
      ),
    );
  }
}
