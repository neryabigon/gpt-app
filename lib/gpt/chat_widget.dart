import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gpt/gpt/models/chat_history_manager.dart';
import 'package:image_downloader/image_downloader.dart';
import '../constants.dart';
import 'gpt_service.dart';
import 'models/message.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget(
      {super.key,
      required this.useLightMode,
      required this.handleBrightnessChange,
      required this.gptService,
      required this.chatHistoryManager,
      required this.showExtraIcons,
      required this.onRefreshChatHistory,});

  final bool useLightMode;
  final Function(bool useLightMode) handleBrightnessChange;
  final GptService gptService;
  final ChatHistoryManager chatHistoryManager;
  final bool showExtraIcons;
  final Function() onRefreshChatHistory;


  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();


  void _handleUserMessage(String message) {
    // if the message is empty, pop a snackbar
    if (message.isEmpty) {
      snack(context, 'Please enter a message');
      return;
    }
    if (mounted) {
      setState(() {
        widget.gptService.messages.add(Message(message, true, false));
      });
    }

    // scroll to bottom
    _scrollToBottom();

    // temp var to hold the response
    String concatenatedResponse = '';

    widget.gptService.getGptResponse(widget.gptService.messages).listen((response) {
      concatenatedResponse += response;

      // Update the UI with the concatenated response
      if (mounted) {
        setState(() {
          if (widget.gptService.messages.isNotEmpty && widget.gptService.messages.last.isUser) {
            widget.gptService.messages.add(Message(concatenatedResponse, false, false));
          } else if (widget.gptService.messages.isNotEmpty && !widget.gptService.messages.last.isUser) {
            widget.gptService.messages.removeLast();
            widget.gptService.messages.add(Message(concatenatedResponse, false, false));
          }
        });
      }
      _scrollToBottom();
    }, onError: (error) {
      debugPrint("Error: $error");
      if (mounted) {
        setState(() {
          if (widget.gptService.messages.isNotEmpty && widget.gptService.messages.last.isUser) {
            widget.gptService.messages.add(Message(concatenatedResponse, false, false));
          } else if (widget.gptService.messages.isNotEmpty && !widget.gptService.messages.last.isUser) {
            widget.gptService.messages.removeLast();
            widget.gptService.messages.add(Message(concatenatedResponse, false, false));
          }
        });
      }
    });
  }

  void _stopResponse() {
    widget.gptService.cancelGptResponse();
  }

  // handle image response
  void _handleImageResponse(String prompt) async {
    // if the message is empty, pop a snackbar
    if (prompt.isEmpty) {
      snack(context, 'Please enter a prompt');
      return;
    }
    if (mounted) {
      setState(() {
        widget.gptService.messages.add(Message(prompt, true, false));
      });
    }

    // scroll to bottom
    _scrollToBottom();

    // send to gpt and append to the list
    widget.gptService.getDalleResponse(_textController.text).then((value) {
      if (mounted) {
        setState(() {
          widget.gptService.messages.add(
            Message(
              value,
              false,
              true,
            ),
          );
        });
      }
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  // save image
  Future<void> _saveImage(String url) async {
    await ImageDownloader.downloadImage(url);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // list of previous days
          Expanded(
            // this where this chat message will be displayed, from the list
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: widget.gptService.messages.length,
              itemBuilder: (BuildContext context, int index) {
                return widget.gptService.messages[index].isImage
                    ? _buildImageResponse(widget.gptService.messages[index])
                    : _buildMessage(widget.gptService.messages[index]);
              },
            ),
          ),
          // user input
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    maxLines: 4,
                    minLines: 1,
                    decoration: InputDecoration(
                      hintText: 'Type your message',
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      suffixIcon: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              _handleUserMessage(_textController.text);
                              _textController.clear();
                            },
                            icon: const Icon(Icons.send),
                            tooltip: 'send',
                          ),
                          IconButton(
                            onPressed: () {
                              _handleImageResponse(_textController.text);
                              _textController.clear();
                            },
                            icon: const Icon(Icons.image_outlined),
                            tooltip: 'generate image',
                          ),
                          if (widget.showExtraIcons) ...[
                            IconButton(
                              onPressed: _stopResponse,
                              icon: const Icon(Icons.pause),
                              tooltip: 'stop response',
                            ),
                            // save chat icon button
                            IconButton(
                              onPressed: () {
                                if (widget.gptService.messages.isNotEmpty) {
                                  // save chat
                                  widget.chatHistoryManager.saveChat(widget.gptService.messages[0].text, widget.gptService.messages);
                                  widget.onRefreshChatHistory();
                                  snack(context, 'Chat saved');
                                } else {
                                  snack(context, 'Nothing to save');
                                }
                              },
                              icon: const Icon(Icons.save),
                              tooltip: 'save chat',
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // chat message widget
  Widget _buildMessage(Message msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width <= 500
                    ? MediaQuery.of(context).size.width * 0.6
                    : MediaQuery.of(context).size.width * 0.4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: msg.isUser
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SelectableText(
              msg.text,
              style: TextStyle(
                color: msg.isUser
                    ? Theme.of(context).textTheme.bodyLarge?.decorationColor
                    : Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // image response widget, exaclty the same as the chat message widget just with an image
  Widget _buildImageResponse(Message msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment:
            msg.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: msg.isUser
                  ? Theme.of(context).colorScheme.primaryContainer
                  : Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
                onDoubleTap: () {
                  if (MediaQuery.of(context).size.width >= 500) {
                    snack(context, 'not available on pc yet');
                  } else {
                    _saveImage(msg.text);
                    snack(context,'Image saved to download folder');
                  }
                },
                child: Image.network(msg.text)),
          ),
        ],
      ),
    );
  }

  // snackbar
  // void snack(BuildContext context, String msg) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(msg,
  //           style:
  //               TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
  //       duration: const Duration(milliseconds: 800),
  //       backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
  //     ),
  //   );
  // }
}
