import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import '../data/example_message.dart';
import '../data/example_pagination.dart';
import '../data/example_sample_data.dart';

class ReactionsExample extends StatefulWidget {
  const ReactionsExample({super.key});

  @override
  State<ReactionsExample> createState() => _ReactionsExampleState();
}

class _ReactionsExampleState extends State<ReactionsExample> {
  late final List<ExampleMessage> _messages;
  late final ExamplePaginationHelper<ExampleMessage> _pagination;

  @override
  void initState() {
    super.initState();
    _messages = ExampleSampleData.buildMessages()
        .where((message) => message.type == ChatMessageType.text)
        .take(3)
        .toList()
        .reversed
        .toList();

    _pagination = ExamplePaginationHelper<ExampleMessage>(
      items: _messages,
      pageSize: 10,
    );
    _pagination.cubit.fetchPaginatedList();
  }

  @override
  void dispose() {
    _pagination.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reactions & Status')),
      body: SmartPaginationListView.withCubit(
        cubit: _pagination.cubit,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, items, index) {
          final message = items[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MessageBubble(
              message: message,
              currentUserId: ExampleSampleData.currentUserId,
              showAvatar: true,
              onReactionTap: (emoji) => _toggleReaction(message, emoji),
            ),
          );
        },
      ),
    );
  }

  void _toggleReaction(ExampleMessage message, String emoji) {
    final reactions = List<ChatReactionData>.from(message.reactions);
    final currentUserId = ExampleSampleData.currentUserId;
    final existingIndex = reactions.indexWhere(
      (reaction) =>
          reaction.emoji == emoji && reaction.userId == currentUserId,
    );

    if (existingIndex >= 0) {
      reactions.removeAt(existingIndex);
    } else {
      reactions.add(
        ChatReactionData(
          emoji: emoji,
          userId: currentUserId,
          createdAt: DateTime.now(),
        ),
      );
    }

    setState(() {
      final updated = message.copyWith(reactions: reactions);
      _messages[_messages.indexOf(message)] = updated;
    });
    _pagination.setItems(_messages);
  }
}
