import 'dart:io';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'message.dart';
import 'chat_model.dart';

class GptService {
  late dynamic openAI;
  static final GptService _singleton = GptService._internal();
  double temperature = 0.7;
  int maxTokens = 200;
  double topP = 1.0;
  double frequencyPenalty = 0.0;
  double presencePenalty = 0.0;

  factory GptService() {
    return _singleton;
  }

  GptService._internal() {
    openAI = OpenAI.instance.build(
        token: "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",
        baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 30),
            connectTimeout: const Duration(seconds: 20)),
        isLog: true);
  }

  void updateApiKey(String newApiKey) {
    openAI = OpenAI.instance.build(
      token: newApiKey,
      baseOption: HttpSetup(
        receiveTimeout: const Duration(seconds: 30),
        connectTimeout: const Duration(seconds: 20),
      ),
      isLog: true,
    );
  }

  Chat _chat = Chat(messages: []);

  Chat get chat => _chat; // getter for chat
  // setter for chat
  set chat(Chat chat) =>
      _chat = Chat.fromJSON(messages: chat.messages, id: chat.id);

  // chat completion
  Stream<dynamic> getGptResponse(List<Message> messages) async* {
    List<Map<String, String>> formattedMessages = [];

    for (Message message in messages) {
      if (!message.isImage) {
        formattedMessages.add({
          "role": message.isUser ? "user" : "assistant",
          "content": message.text
        });
      }
    }

    final request = ChatCompleteText(
        messages: formattedMessages,
        temperature: temperature,
        maxToken: maxTokens,
        topP: topP,
        frequencyPenalty: frequencyPenalty,
        presencePenalty: presencePenalty,
        stream: true,
        model: ChatModel.gpt_4);

    try {
      await for (final response
          in openAI.onChatCompletionSSE(request: request)) {
        debugPrint(response.choices.last.message?.content);
        yield response.choices.last.message?.content;
      }
    } catch (error) {
      if (error is HttpException) {
        debugPrint('Stream canceled');
        return;
      }
    }
  }

  // cancel chat completion gracefully
  void cancelGptResponse() {
    openAI.cancelAIGenerate();
  }

  // dalle completion
  Future<String> getDalleResponse(String prompt) async {
    final request = GenerateImage(prompt, 1,
        size: ImageSize.size256, responseFormat: Format.url);
    final response = await openAI.generateImage(request);
    return "${response?.data?.last?.url}";
  }

  void handleUserMessage(String message, Function scrollToBottom) {
    if (message.isNotEmpty) {
      _chat.addMessage(Message(message, true, false));
      // scroll to bottom
      scrollToBottom();
    } else {
      return;
    }

    String concatenatedResponse = '';

    getGptResponse(_chat.messages).listen((response) {
      if (response != null) {
        concatenatedResponse += response;
        if (_chat.messages.isNotEmpty && _chat.messages.last.isUser) {
          _chat.addMessage(Message(concatenatedResponse, false, false));
        } else if (_chat.messages.isNotEmpty && !_chat.messages.last.isUser) {
          _chat.messages.removeLast();
          _chat.addMessage(Message(concatenatedResponse, false, false));
        }
      }
    });
  }

  void handleImageResponse(String prompt, Function scrollToBottom) {
    if (prompt.isEmpty) {
      return;
    }

    _chat.addMessage(Message(prompt, true, false));

    getDalleResponse(prompt).then((response) {
      _chat.addMessage(Message(response, false, true));
    });
  }
}
