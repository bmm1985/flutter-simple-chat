import 'package:chat/domain/entities/chat_message.dart';
import 'package:chat/domain/entities/user.dart';

sealed class ChatEvent {}

class ChatConnectEvent extends ChatEvent {
  final User user;

  ChatConnectEvent(this.user);
}

class ChatReceivedEvent extends ChatEvent {
  final ChatMessage message;

  ChatReceivedEvent(this.message);
}

class ChatSendEvent extends ChatEvent {
  final User user;
  final String text;

  ChatSendEvent(this.user, this.text);
}

class ChatDisconnectEvent extends ChatEvent {}

class ChatStreamClosedEvent extends ChatEvent {}
