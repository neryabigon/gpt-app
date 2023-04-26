import 'package:flutter/material.dart';
import 'package:gpt/components/myAppBar.dart';
import 'package:gpt/gpt/chat_history_widget.dart';
import 'package:gpt/gpt/chat_widget.dart';
import 'package:gpt/gpt/gpt_service.dart';
import '../../components/myNavRail.dart';
import '../../gpt/models/chat_history_manager.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold(
      {super.key,
      required this.useLightMode,
      required this.handleBrightnessChange,});

  final bool useLightMode;
  final Function(bool useLightMode) handleBrightnessChange;


  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // open drawer
            // myDrawer,
            const MyNavRail(),

            // first half of page
            Expanded(
              flex: 3,
              child: ChatWidget(
                useLightMode: widget.useLightMode,
                handleBrightnessChange: widget.handleBrightnessChange,
                gptService: _gptService,
                chatHistoryManager: _chatHistoryManager,
                showExtraIcons: true,
              ),
            ),
            // second half of page
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).colorScheme.secondaryContainer,
                      ),
                        child: ChatHistoryWidget(
                          useLightMode: widget.useLightMode,
                          handleBrightnessChange: widget.handleBrightnessChange,
                          chatHistoryManager: ChatHistoryManager(),
                          onLoadChat: (messages) {
                            setState(() {
                              _gptService.messages = messages;
                            });
                          },
                        )
                    ),
                  ),
                  // list of stuff
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Theme.of(context).colorScheme.secondary,
                        ),

                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
