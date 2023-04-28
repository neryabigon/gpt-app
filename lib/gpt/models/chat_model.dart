import 'package:uuid/uuid.dart';
import 'message.dart';

class Chat {
  List<Message> messages = [];
  final String id;

  // new chat constructor
  Chat({required this.messages}) : id = const Uuid().v4();

  // chat from json constructor
  Chat.fromJSON({required this.messages, required this.id});


  @override
  bool operator ==(covariant Chat other) => id == other.id;

  // to json
  Map<String, dynamic> toJson() {
    return {
      'messages': messages.map((e) => e.toJson()).toList(),
      'id': id,
    };
  }

  // from json
  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat.fromJSON(
      messages: json['messages'].map<Message>((e) => Message.fromJson(e)).toList(),
      id: json['id'],
    );
  }

  // add message
  void addMessage(Message message) {
    messages.add(message);
  }

  // remove message
  void removeMessage(Message message) {
    messages.remove(message);
  }

  // clear messages
  void clearMessages() {
    messages.clear();
  }

  @override
  int get hashCode => id.hashCode;

}