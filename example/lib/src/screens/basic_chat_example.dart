import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../data/example_chat_controller.dart';
import '../data/example_sample_data.dart';

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
      appBar: AppBar(title: const Text('Basic Chat')),
      showAvatar: true,
      emptyMessage: 'Start the conversation with a simple text message.',
    );
  }
}
