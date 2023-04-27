import 'package:flutter/material.dart';
import 'package:gpt/components/myAppBar.dart';
import 'package:gpt/gpt/chat_history_widget.dart';
import 'package:gpt/gpt/chat_widget.dart';
import 'package:gpt/gpt/gpt_service.dart';
import 'package:gpt/gpt/model_setting_widget.dart';
import '../../components/myNavRail.dart';
import '../../gpt/models/chat_history_manager.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({
    super.key,
    required this.useLightMode,
    required this.handleBrightnessChange,
  });

  final bool useLightMode;
  final Function(bool useLightMode) handleBrightnessChange;

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: MediaQuery.of(context).size.height*0.9,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                      onRefreshChatHistory: refresh,
                    ),
                  ),
                  // second half of page
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height*0.85,
                        width: MediaQuery.of(context).size.width*0.3,
                        child: Column(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Container(
                                      height: MediaQuery.of(context).size.height*0.4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                      ),
                                      child: ChatHistoryWidget(
                                        useLightMode: widget.useLightMode,
                                        handleBrightnessChange:
                                            widget.handleBrightnessChange,
                                        chatHistoryManager: _chatHistoryManager,
                                        onLoadChat: (messages) {
                                          setState(() {
                                            _gptService.messages = messages;
                                          });
                                        },
                                        refreshNotifier: refreshNotifier,
                                      )),
                                ),
                              ),
                            ),
                            // list of stuff
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height*0.4,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                    child: ModelSettingsWidget(
                                      useLightMode: widget.useLightMode,
                                      handleBrightnessChange:
                                          widget.handleBrightnessChange,
                                      gptService: _gptService,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}
