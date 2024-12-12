import 'package:chat/domain/entities/chat_message.dart';

class ChatMessageModel extends ChatMessage {
  ChatMessageModel({
    required super.username,
    required super.text,
    required super.timestamp,
  });

  factory ChatMessageModel.fromEntity(ChatMessage chatMessage) {
    return ChatMessageModel(
      username: chatMessage.username,
      text: chatMessage.text,
      timestamp: chatMessage.timestamp,
    );
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      username: json['username'] as String,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
