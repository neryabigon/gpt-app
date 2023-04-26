import 'package:flutter/material.dart';
import 'package:gpt/constants.dart';
import 'package:gpt/gpt/chat_widget.dart';
import 'package:gpt/gpt/gpt_service.dart';
import '../../components/myAppBar.dart';
import '../../gpt/models/chat_history_manager.dart';


class TabletScaffold extends StatefulWidget {
  const TabletScaffold(
      {super.key,
      required this.useLightMode,
      required this.handleBrightnessChange,});

  final bool useLightMode;
  final Function(bool useLightMode) handleBrightnessChange;


  @override
  State<TabletScaffold> createState() => _TabletScaffoldState();
}

class _TabletScaffoldState extends State<TabletScaffold> {
  // Use singleton instances
  final GptService _gptService = GptService();
  final ChatHistoryManager _chatHistoryManager = ChatHistoryManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: MyAppBar(
          useLightMode: widget.useLightMode,
          handleBrightnessChange: widget.handleBrightnessChange,
          showExtraIcons: false),
      drawer: myDrawer,
      body: ChatWidget(
        useLightMode: widget.useLightMode,
        handleBrightnessChange: widget.handleBrightnessChange,
        gptService: _gptService,
        chatHistoryManager: _chatHistoryManager,
        showExtraIcons: true,
      ),
    );
  }
}
