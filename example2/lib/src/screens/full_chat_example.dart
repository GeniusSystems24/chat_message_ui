import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../data/example_chat_controller.dart';
import '../data/example_sample_data.dart';

class FullChatExample extends StatefulWidget {
  const FullChatExample({super.key});

  @override
  State<FullChatExample> createState() => _FullChatExampleState();
}

class _FullChatExampleState extends State<FullChatExample> {
  late final ExampleChatController _controller;
  final ValueNotifier<ChatReplyData?> _replyNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _controller = ExampleChatController(
      currentUserId: ExampleSampleData.currentUserId,
      seedMessages: ExampleSampleData.buildMessages(),
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
      onAttachmentSelected: (type) => _showSnackBar(
        context,
        'Attachment selected: ${type.name}',
      ),
      onReactionTap: _controller.toggleReaction,
      onRefresh: _controller.refresh,
      onDelete: _controller.deleteMessages,
      replyMessage: _replyNotifier,
      appBarBuilder: _buildAppBar,
      selectionAppBarBuilder: _buildSelectionAppBar,
      emptyMessage: 'All caught up! Send a message to get started.',
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return ChatAppBar(
      chat: const ChatAppBarData(
        id: ExampleSampleData.chatId,
        title: 'Product Studio',
        subtitle: '8 members • Online',
        imageUrl: 'https://i.pravatar.cc/150?img=64',
      ),
      onSearch: () => _openSearch(context),
      onMenuSelection: (value) => _showSnackBar(
        context,
        'Menu action: $value',
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
      onReply: (message) {
        _replyNotifier.value = _buildReplyData(message);
        onClearSelection();
      },
      onDelete: (messages) {
        _controller.deleteMessages(messages.toSet());
        onClearSelection();
      },
      onForward: (messages) => _showSnackBar(
        context,
        'Forwarded ${messages.length} message(s)',
      ),
      onInfo: (message) => _showSnackBar(
        context,
        'Message info: ${message.id}',
      ),
    );
  }

  Future<void> _openSearch(BuildContext context) async {
    final selected = await Navigator.of(context).push<IChatMessageData>(
      MaterialPageRoute(
        builder: (context) => ChatMessageSearchView(
          messages: _controller.messagesCubit.currentItems,
          currentUserId: ExampleSampleData.currentUserId,
        ),
      ),
    );

    if (!mounted || selected == null) return;
    _replyNotifier.value = _buildReplyData(selected);
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

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
