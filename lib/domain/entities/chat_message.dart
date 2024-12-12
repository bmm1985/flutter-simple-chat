class ChatMessage {
  final String username;
  final String text;
  final DateTime timestamp;

  ChatMessage({required this.username, required this.text, required this.timestamp});

  @override
  String toString() {
    return 'ChatMessage{username: $username, text: $text, timestamp: $timestamp}';
  }
}
