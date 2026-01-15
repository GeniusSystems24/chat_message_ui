import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:flutter/material.dart';

import '../data/example_sample_data.dart';
import '../data/firebase_chat_controller.dart';
import 'shared/example_scaffold.dart';

class FirebaseFullChatExample extends StatefulWidget {
  const FirebaseFullChatExample({super.key});

  @override
  State<FirebaseFullChatExample> createState() => _FirebaseFullChatExampleState();
}

class _FirebaseFullChatExampleState extends State<FirebaseFullChatExample> {
  late final FirebaseChatController _controller;
  final ValueNotifier<ChatReplyData?> _replyNotifier = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _controller = FirebaseChatController(
      currentUserId: ExampleSampleData.currentUserId,
      chatId: ExampleSampleData.chatId,
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
      onSendMessage: _handleSendText,
      onAttachmentSelected: _handleAttachment,
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
      emptyMessage: 'No messages yet. Send one to Firebase.',
      pinnedMessages: _buildPinnedList(),
      onScrollToMessage: _scrollToPinnedMessage,
      onRecordingComplete: (path, duration, {waveform}) async {
        await _controller.sendAudio(reply: _replyNotifier.value);
        _replyNotifier.value = null;
        _showSnackBar(
          context,
          'Uploaded audio (${duration}s, waveform: ${waveform?.length ?? 0})',
        );
      },
      onRecordingStart: () => _showSnackBar(context, 'Recording started'),
      onRecordingCancel: () => _showSnackBar(context, 'Recording cancelled'),
      onRecordingLockedChanged: (locked) =>
          _showSnackBar(context, locked ? 'Recording locked' : 'Recording unlocked'),
      onPollRequested: () async {
        await _controller.sendPoll(reply: _replyNotifier.value);
        _replyNotifier.value = null;
      },
      config: const ChatMessageUiConfig(
        enableSuggestions: true,
        enableTextPreview: true,
        pagination: ChatPaginationConfig(
          listPadding: EdgeInsets.fromLTRB(16, 12, 16, 12),
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

  Future<void> _handleSendText(String text) async {
    await _controller.sendText(text, reply: _replyNotifier.value);
    _replyNotifier.value = null;
  }

  Future<void> _handleAttachment(AttachmentSource type) async {
    final reply = _replyNotifier.value;
    switch (type) {
      case AttachmentSource.cameraImage:
      case AttachmentSource.galleryImage:
        await _controller.sendImage(reply: reply);
        break;
      case AttachmentSource.cameraVideo:
      case AttachmentSource.galleryVideo:
        await _controller.sendVideo(reply: reply);
        break;
      case AttachmentSource.location:
        await _controller.sendLocation(reply: reply);
        break;
      case AttachmentSource.document:
        await _controller.sendDocument(reply: reply);
        break;
      case AttachmentSource.contact:
        await _controller.sendContact(reply: reply);
        break;
      case AttachmentSource.voting:
        await _controller.sendPoll(reply: reply);
        break;
    }
    _replyNotifier.value = null;
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    final theme = Theme.of(context);
    return PreferredSize(
      preferredSize: const Size.fromHeight(230),
      child: Container(
        color: theme.colorScheme.surface,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ChatAppBar(
              chat: const ChatAppBarData(
                id: 'firebase_demo',
                title: 'Firebase Live Chat',
                subtitle: 'Firestore + Storage sync',
                imageUrl: 'https://i.pravatar.cc/150?img=31',
              ),
              showSearch: true,
              showMenu: true,
              showVideoCall: true,
              showTasks: true,
              menuItems: const [
                PopupMenuItem(
                  value: 'seed_samples',
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome_outlined),
                      SizedBox(width: 8),
                      Text('Seed sample messages'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'send_audio',
                  child: Row(
                    children: [
                      Icon(Icons.mic_outlined),
                      SizedBox(width: 8),
                      Text('Send audio message'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'send_poll',
                  child: Row(
                    children: [
                      Icon(Icons.poll_outlined),
                      SizedBox(width: 8),
                      Text('Send poll message'),
                    ],
                  ),
                ),
              ],
              onSearch: () => _openSearch(context),
              onMenuSelection: (value) => _handleMenuAction(context, value),
              onTitleTap: () => _showSnackBar(context, 'Open chat profile'),
              onVideoCall: () => _showSnackBar(context, 'Start video call'),
              onTasks: () => _showSnackBar(context, 'Open tasks'),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: ExampleDescription(
                title: 'Screen Overview',
                icon: Icons.cloud_outlined,
                lines: const [
                  'Fully connected chat that reads/writes messages in Firebase.',
                  'Supports text, media, location, contact, and poll messages.',
                  'Showcases pinned highlights, polls, and audio uploads.',
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

  Future<void> _handleMenuAction(BuildContext context, String value) async {
    switch (value) {
      case 'seed_samples':
        await _controller.seedSampleMessages();
        break;
      case 'send_audio':
        await _controller.sendAudio(reply: _replyNotifier.value);
        _replyNotifier.value = null;
        break;
      case 'send_poll':
        await _controller.sendPoll(reply: _replyNotifier.value);
        _replyNotifier.value = null;
        break;
    }
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
