import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../data/example_chat_controller.dart';
import '../data/example_sample_data.dart';
import 'shared/example_scaffold.dart';

class BasicChatExample extends StatefulWidget {
  const BasicChatExample({super.key});

  @override
  State<BasicChatExample> createState() => _BasicChatExampleState();
}

class _BasicChatExampleState extends State<BasicChatExample> {
  late final ExampleChatController _controller;

  @override
  void initState() {
    super.initState();
    final seedMessages = ExampleSampleData.buildMessages()
        .where((message) => message.type == ChatMessageType.text)
        .toList();
    _controller = ExampleChatController(
      currentUserId: ExampleSampleData.currentUserId,
      seedMessages: seedMessages,
    );
    _controller.loadInitial();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatScreen(
      messagesCubit: _controller.messagesCubit,
      currentUserId: ExampleSampleData.currentUserId,
      onSendMessage: _controller.sendText,
      onRefresh: _controller.refresh,
      appBar: AppBar(
        title: const Text('Basic Chat'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(140),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: ExampleDescription(
              title: 'Screen Overview',
              icon: Icons.info_outline,
              lines: const [
                'Shows the minimum setup required to render a chat timeline.',
                'Focuses on text-only messaging and simple refresh behavior.',
                'Useful as a starting point before adding attachments or reactions.',
              ],
            ),
          ),
        ),
      ),
      showAvatar: true,
      emptyMessage: 'Start the conversation with a simple text message.',
    );
  }
}
