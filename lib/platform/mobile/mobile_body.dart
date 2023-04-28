import 'package:flutter/material.dart';
import 'package:gpt/gpt/widgets/chat_widget.dart';
import 'package:gpt/gpt/models/gpt_service.dart';
import '../../components/myAppBar.dart';
import '../../components/my_drawer.dart';
import '../../gpt/models/chat_history_manager.dart';

class MobileScaffold extends StatefulWidget {
  const MobileScaffold({
    super.key,
    required this.useLightMode,
    required this.handleBrightnessChange,
  });

  final bool useLightMode;
  final Function(bool useLightMode) handleBrightnessChange;

  @override
  State<MobileScaffold> createState() => _MobileScaffoldState();
}

class _MobileScaffoldState extends State<MobileScaffold> {
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
        showExtraIcons: true,
        onRefreshChatHistory: refresh,
      ),
      drawer: MyDrawer(
        useLightMode: widget.useLightMode,
        handleBrightnessChange: widget.handleBrightnessChange,
        gptService: _gptService,
        chatHistoryManager: _chatHistoryManager,
        onLoadChat: (messages) {
          setState(() {
            _gptService.chat.messages = messages;
          });
        },
        refreshNotifier: refreshNotifier,
      ),
      body: ChatWidget(
        useLightMode: widget.useLightMode,
        handleBrightnessChange: widget.handleBrightnessChange,
        gptService: _gptService,
        chatHistoryManager: _chatHistoryManager,
        showExtraIcons: false,
        onRefreshChatHistory: refresh,
      ),
    );
  }
}
