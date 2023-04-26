import 'package:flutter/material.dart';
import 'models/chat_history_manager.dart';
import 'models/message.dart';

class ChatHistoryWidget extends StatefulWidget {
  const ChatHistoryWidget(
      {super.key,
      required this.useLightMode,
      required this.handleBrightnessChange,
      required this.chatHistoryManager,
      required this.onLoadChat});

  final bool useLightMode;
  final Function(bool useLightMode) handleBrightnessChange;
  final ChatHistoryManager chatHistoryManager;
  final Function(List<Message> messages) onLoadChat;

  @override
  State<ChatHistoryWidget> createState() => _ChatHistoryWidgetState();
}

class _ChatHistoryWidgetState extends State<ChatHistoryWidget> {
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
                child: Container(
                  height: 6 * 72.0, // Visible items (6) multiplied by an approximate item height (72.0)
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.chat),
                        title: Text(snapshot.data![index]),
                        onTap: () async {
                          bool? shouldLoad = await showDialog<bool>(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text('Load this chat?\nThe current chat will be lost if not saved.'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text('No'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (shouldLoad ?? false) {
                            List<Message> messages = await widget.chatHistoryManager
                                .loadChat(snapshot.data![index]);
                            widget.onLoadChat(messages);
                          }
                        },
                      );
                    },
                  ),
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
