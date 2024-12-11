import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:chat/domain/repositories/chat_repository.dart';
import 'package:chat/models/chat_message.dart';
import 'package:chat/models/exceptions.dart';
import 'package:chat/models/user.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatRepositoryImpl extends ChatRepository {
  WebSocketChannel? _webSocketChannel;
  StreamController<ChatMessage>? _messagesController;

  bool _isConnected = false;

  @override
  Future<void> connect(User user) async {
    if (_isConnected) {
      await disconnect();
    }

    _isConnected = true;

    try {
      _messagesController = StreamController.broadcast();

      _webSocketChannel = WebSocketChannel.connect(
        Uri.parse('wss://echo.websocket.events'),
      );

      await _webSocketChannel?.ready;

      _webSocketChannel?.stream.listen(
        _receivedMessage,
        onError: _onError,
        onDone: _onDone,
      );
    } catch (e) {
      _closeResources();
      throw ChatException('Failed to connect: $e');
    }
  }

  void _receivedMessage(dynamic data) {
    log('Received from server: $data');

    try {
      ChatMessage receivedMessage = ChatMessage.fromJson(json.decode(data));

      if (!_messagesController!.isClosed) {
        _messagesController!.add(receivedMessage);
      }
    } catch (e) {
      log('Note: Ignored non-JSON data on echo servers');
    }
  }

  void _onError(dynamic error) {
    log('WebSocket error: $error');
    if (!_messagesController!.isClosed) {
      _messagesController!.addError(error);
    }
  }

  void _onDone() {
    log('WebSocket closed on server-side');
    _closeResources();
  }

  @override
  Stream<ChatMessage> messagesStream() {
    if (!_isConnected || _messagesController == null || _messagesController!.isClosed) {
      _messagesController?.addError(ChatException('No active connection'));
      return const Stream.empty();
    }

    return _messagesController!.stream;
  }

  @override
  void sendMessage(ChatMessage chatMessage) {
    if (!_isConnected || _webSocketChannel == null || _webSocketChannel!.closeCode != null) {
      throw ChatException('Cannot send message: No active connection');
    }

    try {
      var messageJson = json.encode(chatMessage.toJson());

      log('Sending to server: $messageJson');
      _webSocketChannel!.sink.add(messageJson);
    } catch (e) {
      throw ChatException('Error sending message: $e');
    }
  }

  @override
  Future<void> disconnect() async {
    if (!_isConnected) return;

    try {
      await _webSocketChannel?.sink.close();
    } catch (e) {
      throw ChatException('Error while disconnecting: $e');
    } finally {
      _closeResources();
    }
  }

  void _closeResources() {
    _isConnected = false;

    // close webSocketChannel
    if (_webSocketChannel != null && _webSocketChannel!.closeCode == null) _webSocketChannel!.sink.close();
    _webSocketChannel = null;

    // close messagesController
    if (_messagesController != null && !_messagesController!.isClosed) _messagesController!.close();
    _messagesController = null;
  }
}
