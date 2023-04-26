class Message {
  final String text;
  final bool isUser;
  final bool isImage;

  Message(this.text, this.isUser, this.isImage);

  // to json
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isUser': isUser,
      'isImage': isImage,
    };
  }

  // from json
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      json['text'],
      json['isUser'],
      json['isImage'],
    );
  }
}