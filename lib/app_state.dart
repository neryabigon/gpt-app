import 'package:flutter/material.dart';
import 'gpt/models/chat_model.dart';
import 'gpt/models/gpt_service.dart';

class AppState extends ChangeNotifier {
  final GptService _gptService = GptService();
  Chat _chat = Chat(messages: []);

  // Getters
  Chat get chat => _chat;
  GptService get gptService => _gptService;
  // Setters
  set chat(Chat chat) {
    _chat = Chat.fromJSON(messages: chat.messages, id: chat.id);
    notifyListeners();
  }

  void handleUserMessage(BuildContext context, String message, Function scrollToBottom) {
    // _gptService.handleUserMessage(context, message, scrollToBottom);
    notifyListeners();
  }

  void handleImageResponse(BuildContext context, String prompt, Function scrollToBottom) {
    // _gptService.handleImageResponse(context, prompt, scrollToBottom);
    notifyListeners();
  }

}