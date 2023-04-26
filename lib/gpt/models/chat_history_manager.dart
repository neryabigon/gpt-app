import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'message.dart';

class ChatHistoryManager {
  static final ChatHistoryManager _singleton = ChatHistoryManager._internal();

  factory ChatHistoryManager() {
    return _singleton;
  }


  ChatHistoryManager._internal() {
    _initializeJsonFile();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path\\chat_history.json'); // TODO: make this cross-platform (windows, mac, linux, android, ios)
  }

  Future<void> _initializeJsonFile() async {
    final file = await _localFile;
    if (!await file.exists()) {
      await file.writeAsString('[]');
    }
  }

  Future<List<String>> listChats() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((chat) => chat['title']).toList().cast<String>();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveChat(String title, List<Message> messages) async {
    List<String> chats = await listChats();
    if (!chats.contains(title)) {
      final file = await _localFile;
      List<dynamic> jsonList = json.decode(await file.readAsString());
      jsonList.add({
        'title': title,
        'messages': messages.map((msg) => msg.toJson()).toList(),
      });
      await file.writeAsString(json.encode(jsonList));
    }
  }

  Future<List<Message>> loadChat(String title) async {
    final file = await _localFile;
    String contents = await file.readAsString();
    List<dynamic> jsonList = json.decode(contents);
    var chat = jsonList.firstWhere((chat) => chat['title'] == title, orElse: () => null);
    if (chat != null) {
      List<dynamic> messagesJson = chat['messages'];
      return messagesJson.map((msgJson) => Message.fromJson(msgJson)).toList();
    } else {
      return [];
    }
  }
}
