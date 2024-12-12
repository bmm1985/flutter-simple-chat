import 'package:chat/domain/entities/chat_message.dart';

sealed class ChatState {}

class ChatInitial extends ChatState {}

class ChatConnecting extends ChatState {}

class ChatConnected extends ChatState {}

class ChatReceived extends ChatState {
  final List<ChatMessage> messages;

  ChatReceived(this.messages);
}

class ChatDisconnected extends ChatState {}

class ChatFailure extends ChatState {
  final Object? exception;

  ChatFailure(this.exception);
}
