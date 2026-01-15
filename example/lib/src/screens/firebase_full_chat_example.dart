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
      onReactionTap: _controller.toggleReaction,
      onRefresh: _controller.refresh,
      onDelete: _controller.deleteMessages,
      replyMessage: _replyNotifier,
      appBarBuilder: _buildAppBar,
      selectionAppBarBuilder: _buildSelectionAppBar,
      emptyMessage: 'No messages yet. Send one to Firebase.',
    );
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
      preferredSize: const Size.fromHeight(210),
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
              ],
              onSearch: () => _openSearch(context),
              onMenuSelection: (value) => _handleMenuAction(context, value),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: ExampleDescription(
                title: 'Screen Overview',
                icon: Icons.cloud_outlined,
                lines: const [
                  'Fully connected chat that reads/writes messages in Firebase.',
                  'Supports text, media, location, contact, and poll messages.',
                  'Use attachments to upload to Storage and sync to Firestore.',
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
    }
  }

  void _showSnackBar(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
