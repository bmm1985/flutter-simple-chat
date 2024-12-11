import 'package:chat/models/chat_message.dart';
import 'package:chat/models/user.dart';

abstract class ChatRepository {
  Future<void> connect(User user);

  Stream<ChatMessage> messagesStream();

  void sendMessage(ChatMessage chatMessage);

  Future<void> disconnect();
}
