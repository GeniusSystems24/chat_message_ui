import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:flutter/material.dart';

import '../data/example_sample_data.dart';
import '../data/firebase_chat_controller.dart';
import 'shared/example_scaffold.dart';

/// Firebase-connected chat example with all features.
///
/// Features demonstrated:
/// - Full Firebase integration (Firestore + Storage)
/// - Deep link support via chatId parameter
/// - In-chat search with searchModeNotifier
/// - ChatMessageSearchView as separate page
/// - Suggestion providers
/// - Custom ChatThemeData
/// - All message types (text, media, poll, contact, location)
class FirebaseFullChatExample extends StatefulWidget {
  /// Optional chat ID for deep linking.
  /// If null, uses default ExampleSampleData.chatId.
  final String? chatId;

  const FirebaseFullChatExample({super.key, this.chatId});

  @override
  State<FirebaseFullChatExample> createState() =>
      _FirebaseFullChatExampleState();
}

class _FirebaseFullChatExampleState extends State<FirebaseFullChatExample> {
  late final FirebaseChatController _controller;
  final ValueNotifier<ChatReplyData?> _replyNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _searchModeNotifier = ValueNotifier(false);

  // Suggestion data
  final List<ChatUserSuggestion> _users = const [
    ChatUserSuggestion(id: 'user_2', name: 'Omar', username: 'omar'),
    ChatUserSuggestion(id: 'user_3', name: 'Sara', username: 'sara'),
  ];

  final List<Hashtag> _hashtags = [
    Hashtag(id: 'tag_1', hashtag: 'firebase'),
    Hashtag(id: 'tag_2', hashtag: 'sync'),
  ];

  String get _effectiveChatId => widget.chatId ?? ExampleSampleData.chatId;

  @override
  void initState() {
    super.initState();
    _controller = FirebaseChatController(
      currentUserId: ExampleSampleData.currentUserId,
      chatId: _effectiveChatId,
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
    // Apply custom theme for Firebase example
    final baseTheme = ChatThemeData.get(context);
    final customTheme = baseTheme.copyWith(
      colors: baseTheme.colors.copyWith(
            primary: Colors.teal,
          ),
    );

    return Theme(
      data: Theme.of(context).copyWith(
        extensions: [customTheme],
      ),
      child: ChatScreen(
        messagesCubit: _controller.messagesCubit,
        currentUserId: ExampleSampleData.currentUserId,
        onSendMessage: _handleSendText,
        onAttachmentSelected: _handleAttachment,
        onAttachmentTap: (message) => _showSnackBar(
          'Attachment tapped: ${message.type.name}',
        ),
        onReactionTap: _controller.toggleReaction,
        onPollVote: (message, optionId) => _showSnackBar(
          'Voted on ${message.id}: $optionId',
        ),
        onRefresh: _controller.refresh,
        onDelete: _controller.deleteMessages,
        onForward: (messages) =>
            _showSnackBar('Forwarded ${messages.length} message(s)'),
        onCopy: (messages, resolvedText) =>
            _showSnackBar('Copied ${messages.length} message(s)'),
        onReply: (message) {
          _replyNotifier.value = _buildReplyData(message);
        },
        onMessageInfo: (message) => _showSnackBar('Message info: ${message.id}'),
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
            'Uploaded audio (${duration}s, waveform: ${waveform?.length ?? 0})',
          );
        },
        onRecordingStart: () => _showSnackBar('Recording started'),
        onRecordingCancel: () => _showSnackBar('Recording cancelled'),
        onRecordingLockedChanged: (locked) =>
            _showSnackBar(locked ? 'Recording locked' : 'Recording unlocked'),
        onPollRequested: () async {
          final poll = await CreatePollScreen.showAsBottomSheet(context);
          if (poll != null) {
            await _controller.sendPoll(reply: _replyNotifier.value);
            _replyNotifier.value = null;
          }
        },
        // In-chat search
        searchModeNotifier: _searchModeNotifier,
        searchHint: 'Search Firebase messages...',
        onBackendSearch: _searchMessages,
        // Suggestion providers
        usernameProvider: _usernameProvider,
        hashtagProvider: _hashtagProvider,
        config: const ChatMessageUiConfig(
          enableSuggestions: true,
          enableTextPreview: true,
          pagination: ChatPaginationConfig(
            listPadding: EdgeInsets.fromLTRB(16, 12, 16, 12),
            messagesGroupingMode: MessagesGroupingMode.sameMinute,
            messagesGroupingTimeoutInSeconds: 300,
          ),
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
    _showSnackBar('Jump to pinned message: $messageId');
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
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Container(
        color: theme.colorScheme.surface,
        child: ChatAppBar(
          chat: ChatAppBarData(
            id: _effectiveChatId,
            title: 'Firebase Live Chat',
            subtitle: 'Chat ID: $_effectiveChatId',
            imageUrl: 'https://i.pravatar.cc/150?img=31',
          ),
          showSearch: true,
          showMenu: true,
          showVideoCall: true,
          showTasks: true,
          menuItems: [
            PopupMenuItem(
              value: 'search_page',
              child: Row(
                children: [
                  Icon(Icons.search, color: theme.colorScheme.onSurface),
                  const SizedBox(width: 8),
                  const Text('Search (Full Page)'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'seed_samples',
              child: Row(
                children: [
                  Icon(Icons.auto_awesome_outlined),
                  SizedBox(width: 8),
                  Text('Seed sample messages'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'send_audio',
              child: Row(
                children: [
                  Icon(Icons.mic_outlined),
                  SizedBox(width: 8),
                  Text('Send audio message'),
                ],
              ),
            ),
            const PopupMenuItem(
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
          onSearch: () => _searchModeNotifier.value = true,
          onMenuSelection: (value) => _handleMenuAction(value),
          onTitleTap: () => _showSnackBar('Chat ID: $_effectiveChatId'),
          onVideoCall: () => _showSnackBar('Start video call'),
          onTasks: () => _showSnackBar('Open tasks'),
          additionalActions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Screen Overview',
              onPressed: () => ExampleDescription.showAsBottomSheet(
                context,
                title: 'Screen Overview',
                icon: Icons.cloud_outlined,
                lines: [
                  'Fully connected chat with Firebase (Firestore + Storage).',
                  'Supports deep linking via chatId parameter.',
                  'Current chat ID: $_effectiveChatId',
                  'Custom teal theme applied.',
                  'In-chat search and full page search available.',
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
        'Forwarded ${messages.length} message(s)',
      ),
      onInfo: (message) => _showSnackBar('Message info: ${message.id}'),
      onPin: (messages) => _showSnackBar('Pinned ${messages.length} message(s)'),
      onStar: (messages) =>
          _showSnackBar('Starred ${messages.length} message(s)'),
    );
  }

  Future<List<String>> _searchMessages(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowerQuery = query.toLowerCase();
    return _controller.messagesCubit.currentItems
        .where((m) => (m.textContent?.toLowerCase() ?? '').contains(lowerQuery))
        .map((m) => m.id)
        .toList();
  }

  Future<void> _openSearchPage(BuildContext context) async {
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

  // Suggestion providers
  Future<List<FloatingSuggestionItem<ChatUserSuggestion>>> _usernameProvider(
    String query,
  ) async {
    final clean = query.startsWith('@') ? query.substring(1) : query;
    final lower = clean.toLowerCase();
    final matches = clean.isEmpty
        ? _users
        : _users.where((u) =>
            u.name.toLowerCase().contains(lower) ||
            (u.username ?? '').toLowerCase().contains(lower));

    return matches
        .map((u) => FloatingSuggestionItem(
              value: u,
              label: u.name,
              subtitle: '@${u.username}',
              icon: const Icon(Icons.person_outline, size: 16),
              type: FloatingSuggestionType.username,
            ))
        .toList();
  }

  Future<List<FloatingSuggestionItem<Hashtag>>> _hashtagProvider(
    String query,
  ) async {
    final clean = query.startsWith('#') ? query.substring(1) : query;
    final lower = clean.toLowerCase();
    final matches = clean.isEmpty
        ? _hashtags
        : _hashtags.where((h) => h.hashtag.toLowerCase().contains(lower));

    return matches
        .map((h) => FloatingSuggestionItem(
              value: h,
              label: '#${h.hashtag}',
              type: FloatingSuggestionType.hashtag,
            ))
        .toList();
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

  Future<void> _handleMenuAction(String value) async {
    switch (value) {
      case 'search_page':
        await _openSearchPage(context);
        break;
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

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
