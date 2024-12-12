import 'package:chat/domain/entities/chat_message.dart';
import 'package:chat/domain/entities/user.dart';

abstract class ChatRepository {
  Future<void> connect(User user);

  Stream<ChatMessage> messagesStream();

  void sendMessage(ChatMessage chatMessage);

  Future<void> disconnect();
}
