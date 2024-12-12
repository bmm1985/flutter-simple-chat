import 'dart:async';

import 'package:chat/domain/bloc/chat_bloc/chat_event.dart';
import 'package:chat/domain/bloc/chat_bloc/chat_state.dart';
import 'package:chat/domain/repositories/chat_repository.dart';
import 'package:chat/domain/entities/chat_message.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  StreamSubscription<ChatMessage>? _messageStreamSubscription;

  final List<ChatMessage> _messages = [];

  ChatBloc(this.chatRepository) : super(ChatInitial()) {
    on<ChatConnectEvent>(_onConnect);
    on<ChatReceivedEvent>(_onReceived);
    on<ChatSendEvent>(_onSend);
    on<ChatDisconnectEvent>(_onDisconnect);
    on<ChatStreamClosedEvent>(_onStreamClosed);
  }

  Future<void> _onConnect(ChatConnectEvent event, Emitter<ChatState> emit) async {
    try {
      _resetMessages();
      emit(ChatConnecting());

      await chatRepository.connect(event.user);

      _messageStreamSubscription = chatRepository.messagesStream().listen(
        (msg) {
          add(ChatReceivedEvent(msg));
        },
        onError: (error) {
          emit(ChatFailure(error));
        },
        onDone: () {
          add(ChatStreamClosedEvent());
        },
        cancelOnError: true,
      );

      emit(ChatConnected());
    } catch (e) {
      emit(ChatFailure(e));
    }
  }

  Future<void> _onReceived(ChatReceivedEvent event, Emitter<ChatState> emit) async {
    _messages.add(event.message);
    emit(ChatReceived(List.from(_messages)));
  }

  void _onSend(ChatSendEvent event, Emitter<ChatState> emit) {
    try {
      var chatMessage = ChatMessage(username: event.user.username, text: event.text, timestamp: DateTime.now());
      chatRepository.sendMessage(chatMessage);
    } catch (e) {
      emit(ChatFailure(e));
    }
  }

  Future<void> _onDisconnect(ChatDisconnectEvent event, Emitter<ChatState> emit) async {
    try {
      await chatRepository.disconnect();
      _resetMessages();
      emit(ChatDisconnected());
    } catch (e) {
      emit(ChatFailure(e));
    }
  }

  Future<void> _onStreamClosed(ChatStreamClosedEvent event, Emitter<ChatState> emit) async {
    await _resetMessages();
    emit(ChatDisconnected());
  }

  Future<void> _resetMessages() async {
    await _messageStreamSubscription?.cancel();
    _messageStreamSubscription = null;
    _messages.clear();
  }

  @override
  Future<void> close() async {
    await chatRepository.disconnect();
    await _resetMessages();
    return super.close();
  }
}
