import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../data/example_chat_controller.dart';
import '../data/example_sample_data.dart';
import 'shared/example_scaffold.dart';

/// Basic chat example with minimal features.
///
/// Features demonstrated:
/// - ChatScreen with text-only messages
/// - ChatAppBar (replaces standard AppBar)
/// - ChatSelectionAppBar (basic selection with reply/copy)
/// - Reply functionality with replyMessage notifier
/// - PinnedMessagesBar
///
/// This example intentionally keeps things simple to show the minimum
/// viable chat implementation.
class BasicChatExample extends StatefulWidget {
  const BasicChatExample({super.key});

  @override
  State<BasicChatExample> createState() => _BasicChatExampleState();
}

class _BasicChatExampleState extends State<BasicChatExample> {
  late final ExampleChatController _controller;
  final ValueNotifier<ChatReplyData?> _replyNotifier = ValueNotifier(null);

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
    _replyNotifier.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChatScreen(
      messagesCubit: _controller.messagesCubit,
      currentUserId: ExampleSampleData.currentUserId,
      onSendMessage: (text) async {
        await _controller.sendText(text, reply: _replyNotifier.value);
        _replyNotifier.value = null;
      },
      onRefresh: _controller.refresh,
      onReply: (message) {
        _replyNotifier.value = _buildReplyData(message);
      },
      onCopy: (messages, resolvedText) => _showSnackBar(
        'Copied ${messages.length} message(s)',
      ),
      replyMessage: _replyNotifier,
      config: const ChatMessageUiConfig(
        pagination: ChatPaginationConfig(
          messagesGroupingMode: MessagesGroupingMode.sameMinute,
          messagesGroupingTimeoutInSeconds: 300,
        ),
      ),
      appBarBuilder: _buildAppBar,
      selectionAppBarBuilder: _buildSelectionAppBar,
      pinnedMessages: _buildPinnedList(),
      onScrollToMessage: _scrollToPinnedMessage,
      showAvatar: true,
      emptyMessage: 'Start the conversation with a simple text message.',
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        color: theme.colorScheme.surface,
        child: ChatAppBar(
          chat: const ChatAppBarData(
            id: 'basic_chat',
            title: 'Basic Chat',
            subtitle: 'Text messages only',
            imageUrl: 'https://i.pravatar.cc/150?img=12',
          ),
          showSearch: false,
          showMenu: false,
          showVideoCall: false,
          showTasks: false,
          onTitleTap: () => _showSnackBar('Chat info'),
          additionalActions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Screen Overview',
              onPressed: () => ExampleDescription.showAsBottomSheet(
                context,
                title: 'Screen Overview',
                icon: Icons.info_outline,
                lines: const [
                  'Shows the minimum setup required to render a chat timeline.',
                  'Uses ChatAppBar instead of standard AppBar.',
                  'Includes basic reply and copy functionality.',
                  'Focuses on text-only messaging and simple refresh behavior.',
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildSelectionAppBar(
    BuildContext context,
    Set<IChatMessageData> selectedMessages,
    VoidCallback onClearSelection,
  ) {
    return ChatSelectionAppBar(
      selectedCount: selectedMessages.length,
      selectedMessages: selectedMessages,
      currentUserId: ExampleSampleData.currentUserId,
      onClose: onClearSelection,
      // Basic selection: only reply and copy
      onReply: (message) {
        _replyNotifier.value = _buildReplyData(message);
        onClearSelection();
      },
      onCopy: () {
        _showSnackBar('Copied ${selectedMessages.length} message(s)');
        onClearSelection();
      },
      // Hide advanced actions to keep it simple
      onDelete: null,
      onForward: null,
      onPin: null,
      onStar: null,
    );
  }

  ChatReplyData _buildReplyData(IChatMessageData message) {
    final senderName = message.senderData?.displayName ?? message.senderId;
    final preview = message.textContent?.trim().isNotEmpty == true
        ? message.textContent!
        : message.type.name;

    return ChatReplyData(
      id: message.id,
      senderId: message.senderId,
      senderName: senderName,
      message: preview,
      type: message.type,
      thumbnailUrl: message.mediaData?.thumbnailUrl,
    );
  }

  List<IChatMessageData> _buildPinnedList() {
    final items = _controller.messagesCubit.currentItems;
    if (items.isEmpty) return const [];
    return items.take(2).toList();
  }

  Future<bool> _scrollToPinnedMessage(String messageId) async {
    _showSnackBar('Jump to pinned message: $messageId');
    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

