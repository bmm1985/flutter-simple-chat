class ChatMessage {
  final String username;
  final String text;
  final DateTime timestamp;

  ChatMessage({required this.username, required this.text, required this.timestamp});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      username: json['username'] as String,
      text: json['text'] as String,
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'ChatMessage{username: $username, text: $text, timestamp: $timestamp}';
  }
}
