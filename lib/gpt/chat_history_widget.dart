import 'package:flutter/material.dart';
import 'models/chat_history_manager.dart';
import 'models/message.dart';

class ChatHistoryWidget extends StatefulWidget {
  const ChatHistoryWidget(
      {super.key,
      required this.useLightMode,
      required this.handleBrightnessChange,
      required this.chatHistoryManager,
      required this.onLoadChat,
      required this.refreshNotifier,});

  final bool useLightMode;
  final Function(bool useLightMode) handleBrightnessChange;
  final ChatHistoryManager chatHistoryManager;
  final Function(List<Message> messages) onLoadChat;
  final ValueNotifier<bool> refreshNotifier;

  @override
  State<ChatHistoryWidget> createState() => _ChatHistoryWidgetState();
}

class _ChatHistoryWidgetState extends State<ChatHistoryWidget> {
  @override
  void initState() {
    super.initState();
    widget.refreshNotifier.addListener(() {
      if (widget.refreshNotifier.value) {
        if (mounted) {
          setState(() {});
        }
        widget.refreshNotifier.value = false;
      }
    });
  }

  @override
  void dispose() {
    widget.refreshNotifier.removeListener(() {});
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: widget.chatHistoryManager.listChats(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Chat History',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('New Chat'),
                        onTap: () async {
                          bool? shouldLoad = await showDialog<bool>(
                            context: context,
                            builder: (BuildContext alertDialogContext) {
                              return AlertDialog(
                                title: const Text('Start a new chat?'),
                                content: const Text(
                                    'Are you sure you want to continue?\nThe current chat will be lost if not saved.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(alertDialogContext).pop(true),
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(alertDialogContext).pop(false),
                                    child: const Text('No'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldLoad ?? false) {
                            MediaQuery.of(context).size.width < 1100 ? Navigator.pop(context) : null;
                            widget.onLoadChat([]);
                          }
                        },
                      ),
                      Container(
                        height: 4*72.0,
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                                  leading: const Icon(Icons.chat),
                                  title: Text(snapshot.data![index]),
                                  onTap: () async {
                                    bool? shouldLoad = await showDialog<bool>(
                                      context: context,
                                      builder: (BuildContext alertDialogContext) {
                                        return AlertDialog(
                                          title: const Text('Load this chat?'),
                                          content: const Text(
                                              'Loading a chat will replace the current chat.\nAre you sure you want to continue?\nThe current chat will be lost if not saved.'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(alertDialogContext).pop(true),
                                              child: const Text('Yes'),
                                            ),
                                            TextButton(
                                              onPressed: () => Navigator.of(alertDialogContext).pop(false),
                                              child: const Text('No'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    if (shouldLoad ?? false) {
                                      List<Message> messages = await widget.chatHistoryManager
                                          .loadChat(snapshot.data![index]);
                                      MediaQuery.of(context).size.width < 1100 ? Navigator.pop(context) : null;
                                      widget.onLoadChat(messages);
                                      // widget.onRefreshChatHistory();
                                    }
                                  },
                                );
                          },
                        ),
                      ),
                    ],
                  ),

              ),
            ],
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
