import 'dart:io';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/cupertino.dart';
import 'models/message.dart';


class GptService {
  late final openAI;
  static final GptService _singleton = GptService._internal();

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


  final List<Message> _messages = <Message>[]; // current chat messages list

  List<Message> get messages => _messages; // getter for messages list
  // setter for messages list
  set messages(List<Message> messages) {
    _messages.clear();
    _messages.addAll(messages);
  }


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
        temperature: 0.7,
        maxToken: 200,
        stream: true,
        model: ChatModel.gpt_4
    );

    try {
      await for (final response in openAI.onChatCompletionSSE(request: request)) {
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
}