import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import '../data/example_pagination.dart';
import '../data/example_sample_data.dart';
import 'shared/example_scaffold.dart';

class MessageTypesExample extends StatefulWidget {
  const MessageTypesExample({super.key});

  @override
  State<MessageTypesExample> createState() => _MessageTypesExampleState();
}

class _MessageTypesExampleState extends State<MessageTypesExample> {
  late final ExamplePaginationHelper<Widget> _pagination;
  late final List<IChatMessageData> _pinnedMessages;
  int _pinnedIndex = 0;

  @override
  void initState() {
    super.initState();
    final messages = ExampleSampleData.buildMessages();

    final textMessage = messages.firstWhere(
      (message) => message.type == ChatMessageType.text && !message.isDeleted,
    );
    final imageMessage =
        messages.firstWhere((message) => message.type == ChatMessageType.image);
    final videoMessage =
        messages.firstWhere((message) => message.type == ChatMessageType.video);
    final audioMessage =
        messages.firstWhere((message) => message.type == ChatMessageType.audio);
    final documentMessage = messages
        .firstWhere((message) => message.type == ChatMessageType.document);
    final locationMessage = messages
        .firstWhere((message) => message.type == ChatMessageType.location);
    final contactMessage = messages
        .firstWhere((message) => message.type == ChatMessageType.contact);
    final pollMessage =
        messages.firstWhere((message) => message.type == ChatMessageType.poll);

    // الرسائل المثبتة هي نفس الرسائل المعروضة
    _pinnedMessages = [textMessage, imageMessage, videoMessage];

    final items = <Widget>[
      const _SectionTitle(title: 'Text & Metadata'),
      MessageBubble(
        message: textMessage,
        currentUserId: ExampleSampleData.currentUserId,
        showAvatar: true,
      ),
      const SizedBox(height: 16),
      const _SectionTitle(title: 'Image'),
      MessageBubble(
        message: imageMessage,
        currentUserId: ExampleSampleData.currentUserId,
        showAvatar: true,
      ),
      const SizedBox(height: 16),
      const _SectionTitle(title: 'Video'),
      MessageBubble(
        message: videoMessage,
        currentUserId: ExampleSampleData.currentUserId,
        showAvatar: true,
      ),
      const SizedBox(height: 16),
      const _SectionTitle(title: 'Audio'),
      MessageBubble(
        message: audioMessage,
        currentUserId: ExampleSampleData.currentUserId,
        showAvatar: true,
      ),
      const SizedBox(height: 16),
      const _SectionTitle(title: 'Document'),
      MessageBubble(
        message: documentMessage,
        currentUserId: ExampleSampleData.currentUserId,
        showAvatar: true,
      ),
      const SizedBox(height: 16),
      const _SectionTitle(title: 'Location'),
      MessageBubble(
        message: locationMessage,
        currentUserId: ExampleSampleData.currentUserId,
        showAvatar: true,
      ),
      const SizedBox(height: 16),
      const _SectionTitle(title: 'Contact'),
      MessageBubble(
        message: contactMessage,
        currentUserId: ExampleSampleData.currentUserId,
        showAvatar: true,
      ),
      const SizedBox(height: 16),
      const _SectionTitle(title: 'Poll'),
      PollBubble(message: pollMessage),
    ];

    _pagination = ExamplePaginationHelper<Widget>(items: items, pageSize: 20);
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
      appBar: AppBar(
        title: const Text('Message Types'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Screen Overview',
            onPressed: () => ExampleDescription.showAsBottomSheet(
              context,
              title: 'Screen Overview',
              icon: Icons.category_outlined,
              lines: const [
                'Displays every supported message bubble in one scroll.',
                'Shows the data requirements for each message type.',
                'Great for testing rendering consistency across media.',
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_pinnedMessages.isNotEmpty)
            PinnedMessagesBar(
              message: _pinnedMessages[_pinnedIndex],
              index: _pinnedIndex,
              total: _pinnedMessages.length,
              onTap: () {
                setState(() {
                  _pinnedIndex = (_pinnedIndex + 1) % _pinnedMessages.length;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Jump to: ${_pinnedMessages[_pinnedIndex].id}',
                    ),
                  ),
                );
              },
            ),
          Expanded(
            child: SmartPaginationListView.withCubit(
              cubit: _pagination.cubit,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, items, index) => items[index],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
