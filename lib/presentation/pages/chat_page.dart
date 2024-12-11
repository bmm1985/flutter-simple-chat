import 'package:auto_route/auto_route.dart';
import 'package:chat/domain/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat/domain/bloc/chat_bloc/chat_event.dart';
import 'package:chat/domain/bloc/chat_bloc/chat_state.dart';
import 'package:chat/domain/repositories/chat_repository.dart';
import 'package:chat/locator.dart';
import 'package:chat/models/user.dart';
import 'package:chat/presentation/widgets/error_message_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class ChatPage extends StatefulWidget {
  final User user;

  const ChatPage({super.key, required this.user});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatBloc _chatBloc;

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _chatBloc = ChatBloc(locator.get<ChatRepository>())..add(ChatConnectEvent(widget.user));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _chatBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${context.tr('ChatPage.AppBar')} ${widget.user.username}')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: BlocConsumer<ChatBloc, ChatState>(
                bloc: _chatBloc,
                listener: (context, state) {
                  if (state is ChatDisconnected) {
                    context.router.back();
                  }
                },
                builder: (context, state) {
                  if (state is ChatConnecting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ChatReceived) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[state.messages.length - 1 - index];
                        return ListTile(
                          title: Text(message.username),
                          subtitle: Text(message.text),
                          trailing: Text(
                            message.timestamp.toLocal().toString().split('.')[0],
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    );
                  }

                  if (state is ChatFailure) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ErrorMessageWidget(error: state.exception),
                        ElevatedButton(
                          onPressed: () => _chatBloc.add(ChatConnectEvent(widget.user)),
                          child: Text(context.tr('ChatPage.ReconnectButton')),
                        ),
                      ],
                    );
                  }

                  return Container();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration:  InputDecoration(
                        hintText: context.tr('ChatPage.MessagePlaceholder'),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      _chatBloc.add(ChatSendEvent(widget.user, text));
    }

    _messageController.clear();
  }
}
