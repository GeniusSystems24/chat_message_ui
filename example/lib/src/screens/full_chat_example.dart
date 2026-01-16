import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../data/example_chat_controller.dart';
import '../data/example_sample_data.dart';
import 'shared/example_scaffold.dart';

class FullChatExample extends StatefulWidget {
  const FullChatExample({super.key});

  @override
  State<FullChatExample> createState() => _FullChatExampleState();
}

class _FullChatExampleState extends State<FullChatExample> {
  late final ExampleChatController _controller;
  final ValueNotifier<ChatReplyData?> _replyNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _searchModeNotifier = ValueNotifier(false);

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
    _searchModeNotifier.dispose();
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
      onAttachmentTap: (message) => _showSnackBar(
        context,
        'Attachment tapped: ${message.type.name}',
      ),
      onReactionTap: _controller.toggleReaction,
      onPollVote: (message, optionId) => _showSnackBar(
        context,
        'Voted on ${message.id}: $optionId',
      ),
      onRefresh: _controller.refresh,
      onDelete: _controller.deleteMessages,
      onForward: (messages) =>
          _showSnackBar(context, 'Forwarded ${messages.length} message(s)'),
      onCopy: (messages, resolvedText) =>
          _showSnackBar(context, 'Copied ${messages.length} message(s)'),
      onReply: (message) {
        _replyNotifier.value = _buildReplyData(message);
      },
      onMessageInfo: (message) =>
          _showSnackBar(context, 'Message info: ${message.id}'),
      onSelectionChanged: (selected) {
        if (!mounted) return;
        setState(() {});
      },
      replyMessage: _replyNotifier,
      appBarBuilder: _buildAppBar,
      selectionAppBarBuilder: _buildSelectionAppBar,
      emptyMessage: 'All caught up! Send a message to get started.',
      pinnedMessages: _buildPinnedList(),
      onScrollToMessage: _scrollToPinnedMessage,
      onRecordingComplete: (path, duration, {waveform}) async {
        _showSnackBar(
          context,
          'Recorded ${duration}s (waveform: ${waveform?.length ?? 0})',
        );
      },
      onRecordingStart: () => _showSnackBar(context, 'Recording started'),
      onRecordingCancel: () => _showSnackBar(context, 'Recording cancelled'),
      onRecordingLockedChanged: (locked) => _showSnackBar(
          context, locked ? 'Recording locked' : 'Recording unlocked'),
      onPollRequested: () => _showSnackBar(context, 'Create poll requested'),
      // In-chat search configuration
      searchModeNotifier: _searchModeNotifier,
      searchHint: 'Search messages...',
      onBackendSearch: _simulateBackendSearch,
      config: ChatMessageUiConfig(
        enableSuggestions: true,
        enableTextPreview: true,
        pagination: ChatPaginationConfig(
          listPadding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          messagesGroupingMode: MessagesGroupingMode.sameMinute,
          messagesGroupingTimeoutInSeconds: 300,
        ),
      ),
    );
  }

  List<IChatMessageData> _buildPinnedList() {
    final items = _controller.messagesCubit.currentItems;
    if (items.isEmpty) return const [];
    return items.take(3).toList();
  }

  Future<bool> _scrollToPinnedMessage(String messageId) async {
    _showSnackBar(context, 'Jump to pinned message: $messageId');
    return true;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        color: theme.colorScheme.surface,
        child: ChatAppBar(
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
          additionalActions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Screen Overview',
              onPressed: () => ExampleDescription.showAsBottomSheet(
                context,
                title: 'Screen Overview',
                icon: Icons.forum_outlined,
                lines: const [
                  'Full chat experience with selection, reply, and search flows.',
                  'Demonstrates reactions, deletion, and multi-action app bars.',
                  'Highlights pinned messages, polls, and recording callbacks.',
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
    // Toggle in-chat search mode
    _searchModeNotifier.value = true;
  }

  /// Simulates a backend search - in real apps, this would call your API
  Future<List<String>> _simulateBackendSearch(String query) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    final lowerQuery = query.toLowerCase();
    final matches = <String>[];

    for (final message in _controller.messagesCubit.currentItems) {
      final text = message.textContent?.toLowerCase() ?? '';
      if (text.contains(lowerQuery)) {
        matches.add(message.id);
      }
    }

    return matches;
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
