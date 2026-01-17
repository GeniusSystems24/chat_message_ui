import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import '../data/example_message.dart';
import '../data/example_pagination.dart';
import '../data/example_sample_data.dart';
import 'shared/example_scaffold.dart';

/// Demonstrates all supported message types and special states.
///
/// Features demonstrated:
/// - ChatAppBar with standard layout
/// - All message types (text, image, video, audio, document, location, contact, poll)
/// - Deleted message display (isDeleted = true)
/// - Edited message display (isEdited = true, editedAt)
/// - Replied message display (with replyTo)
/// - Reaction display
/// - PinnedMessagesBar integration
class MessageTypesExample extends StatefulWidget {
  const MessageTypesExample({super.key});

  @override
  State<MessageTypesExample> createState() => _MessageTypesExampleState();
}

class _MessageTypesExampleState extends State<MessageTypesExample> {
  late final ExamplePaginationHelper<Widget> _pagination;
  late final List<IChatMessageData> _pinnedMessages;
  final ScrollController _scrollController = ScrollController();
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

    // Build deleted message
    final deletedMessage = ExampleMessage(
      id: 'deleted_msg_001',
      chatId: 'message_types_chat',
      senderId: ExampleSampleData.currentUserId,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      type: ChatMessageType.text,
      textContent: 'This message was deleted',
      isDeleted: true,
      status: ChatMessageStatus.sent,
      senderData: textMessage.senderData,
    );

    // Build edited message
    final editedMessage = ExampleMessage(
      id: 'edited_msg_001',
      chatId: 'message_types_chat',
      senderId: ExampleSampleData.currentUserId,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      type: ChatMessageType.text,
      textContent: 'This message was edited after sending.',
      isEdited: true,
      updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      status: ChatMessageStatus.sent,
      senderData: textMessage.senderData,
    );

    // Build message with reactions
    final messageWithReactions = ExampleMessage(
      id: 'reaction_msg_001',
      chatId: 'message_types_chat',
      senderId: 'user_other',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      type: ChatMessageType.text,
      textContent: 'Check out these reactions! 👆',
      status: ChatMessageStatus.read,
      reactions: [
        ChatReactionData(emoji: '❤️', userId: 'user_1', createdAt: DateTime.now()),
        ChatReactionData(emoji: '❤️', userId: 'user_2', createdAt: DateTime.now()),
        ChatReactionData(emoji: '😂', userId: 'user_3', createdAt: DateTime.now()),
        ChatReactionData(emoji: '👍', userId: 'user_current', createdAt: DateTime.now()),
      ],
      senderData: const ChatSenderData(
        id: 'user_other',
        name: 'Other User',
        imageUrl: 'https://i.pravatar.cc/150?img=5',
      ),
    );

    // Build message with reply
    final messageWithReply = ExampleMessage(
      id: 'reply_msg_001',
      chatId: 'message_types_chat',
      senderId: ExampleSampleData.currentUserId,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      type: ChatMessageType.text,
      textContent: 'Yes, I saw that image! Great shot.',
      status: ChatMessageStatus.sent,
      senderData: textMessage.senderData,
      replyToId: imageMessage.id,
      replyData: ChatReplyData(
        id: imageMessage.id,
        senderId: imageMessage.senderId,
        senderName: imageMessage.senderData?.displayName ?? 'Unknown',
        message: 'Photo attachment',
        type: ChatMessageType.image,
        thumbnailUrl: imageMessage.mediaData?.thumbnailUrl,
      ),
    );

    // Pinned messages
    _pinnedMessages = [textMessage, imageMessage, videoMessage];

    final items = <Widget>[
      const _SectionTitle(title: 'Deleted Message'),
      MessageBubble(
        message: deletedMessage,
        currentUserId: ExampleSampleData.currentUserId,
        showAvatar: true,
      ),
      const SizedBox(height: 16),
      const _SectionTitle(title: 'Edited Message'),
      MessageBubble(
        message: editedMessage,
        currentUserId: ExampleSampleData.currentUserId,
        showAvatar: true,
      ),
      const SizedBox(height: 16),
      const _SectionTitle(title: 'Message with Reactions'),
      MessageBubble(
        message: messageWithReactions,
        currentUserId: ExampleSampleData.currentUserId,
        showAvatar: true,
      ),
      const SizedBox(height: 16),
      const _SectionTitle(title: 'Message with Reply'),
      MessageBubble(
        message: messageWithReply,
        currentUserId: ExampleSampleData.currentUserId,
        showAvatar: true,
      ),
      const SizedBox(height: 24),
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          color: theme.colorScheme.surface,
          child: ChatAppBar(
            chat: const ChatAppBarData(
              id: 'message_types_demo',
              title: 'Message Types',
              subtitle: 'All bubble types & states',
              imageUrl: 'https://i.pravatar.cc/150?img=20',
            ),
            showSearch: false,
            showMenu: true,
            showVideoCall: false,
            menuItems: const [
              PopupMenuItem(
                value: 'scroll_top',
                child: Row(
                  children: [
                    Icon(Icons.vertical_align_top),
                    SizedBox(width: 8),
                    Text('Scroll to top'),
                  ],
                ),
              ),
            ],
            onMenuSelection: (_) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
            additionalActions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: 'Screen Overview',
                onPressed: () => ExampleDescription.showAsBottomSheet(
                  context,
                  title: 'Screen Overview',
                  icon: Icons.category_outlined,
                  lines: const [
                    'Displays every supported message bubble in one scroll.',
                    'Shows deleted, edited, and replied message states.',
                    'Demonstrates reaction display on bubbles.',
                    'Includes PinnedMessagesBar for quick navigation.',
                  ],
                ),
              ),
            ],
          ),
        ),
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
              scrollController: _scrollController,
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
