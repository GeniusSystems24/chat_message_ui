import 'dart:io';

import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

import '../data/example_chat_controller.dart';
import '../data/example_sample_data.dart';
import 'shared/example_scaffold.dart';

/// Full chat example with all features enabled.
///
/// Features demonstrated:
/// - All ChatScreen callbacks and features
/// - ChatAppBar with all actions
/// - ChatSelectionAppBar with full actions
/// - In-chat search with searchModeNotifier
/// - ChatMessageSearchView as separate page
/// - Suggestion providers (@mention, #hashtag, /quick, $task)
/// - EditMessagePreview for editing messages
/// - Reactions, replies, polls, attachments
class FullChatExample extends StatefulWidget {
  const FullChatExample({super.key});

  @override
  State<FullChatExample> createState() => _FullChatExampleState();
}

class _FullChatExampleState extends State<FullChatExample> {
  late final ExampleChatController _controller;
  final ValueNotifier<ChatReplyData?> _replyNotifier = ValueNotifier(null);
  final ValueNotifier<bool> _searchModeNotifier = ValueNotifier(false);
  final ImagePicker _imagePicker = ImagePicker();

  // Suggestion data
  final List<ChatUserSuggestion> _users = const [
    ChatUserSuggestion(id: 'user_2', name: 'Omar', username: 'omar'),
    ChatUserSuggestion(id: 'user_3', name: 'Sara', username: 'sara'),
    ChatUserSuggestion(id: 'user_4', name: 'Tariq', username: 'tariq'),
  ];

  final List<Hashtag> _hashtags = [
    Hashtag(id: 'tag_1', hashtag: 'release'),
    Hashtag(id: 'tag_2', hashtag: 'design'),
    Hashtag(id: 'tag_3', hashtag: 'urgent'),
  ];

  final List<QuickReply> _quickReplies = [
    QuickReply(id: 'qr_1', command: '/welcome', response: 'Welcome aboard!'),
    QuickReply(id: 'qr_2', command: '/thanks', response: 'Thank you!'),
    QuickReply(id: 'qr_3', command: '/done', response: 'Task completed ✓'),
  ];

  final List<Map<String, dynamic>> _tasks = const [
    {'id': 'task_1', 'title': 'Review PR #123'},
    {'id': 'task_2', 'title': 'Update documentation'},
    {'id': 'task_3', 'title': 'Fix login bug'},
  ];

  @override
  void initState() {
    super.initState();
    _controller = ExampleChatController(
      currentUserId: ExampleSampleData.currentUserId,
      seedMessages: ExampleSampleData.buildMessages(),
    );
    _loadInitialMessages();
  }

  Future<void> _loadInitialMessages() async {
    await _controller.loadInitial();
    if (mounted) setState(() {}); // Rebuild to show pinned messages
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
      onSendMessage: _handleSendMessage,
      onAttachmentSelected: _handleAttachmentSelected,
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
      emptyMessage: 'All caught up! Send a message to get started.',
      pinnedMessages: _buildPinnedList(),
      onScrollToMessage: _scrollToPinnedMessage,
      onRecordingComplete: (path, duration, {waveform}) async {
        await _controller.sendAudio(
          path,
          duration: duration,
          waveform: waveform,
          reply: _replyNotifier.value,
        );
        _replyNotifier.value = null;
      },
      onRecordingStart: () => _showSnackBar('Recording started'),
      onRecordingCancel: () => _showSnackBar('Recording cancelled'),
      onRecordingLockedChanged: (locked) =>
          _showSnackBar(locked ? 'Recording locked' : 'Recording unlocked'),
      onPollRequested: () async {
        final poll = await CreatePollScreen.showAsBottomSheet(context);
        if (poll != null) {
          _showSnackBar('Created poll: ${poll.question}');
        }
      },
      // In-chat search configuration
      searchModeNotifier: _searchModeNotifier,
      searchHint: 'Search messages...',
      onBackendSearch: _simulateBackendSearch,
      // Suggestion providers
      usernameProvider: _usernameProvider,
      hashtagProvider: _hashtagProvider,
      quickReplyProvider: _quickReplyProvider,
      taskProvider: _taskProvider,
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

  Future<void> _handleSendMessage(String text) async {
    // Send new message - input is automatically cleared by ChatInput
    await _controller.sendText(text, reply: _replyNotifier.value);
    _replyNotifier.value = null;
  }

  /// Handles attachment selection using file_picker and image_picker
  Future<void> _handleAttachmentSelected(AttachmentSource source) async {
    try {
      switch (source) {
        case AttachmentSource.cameraImage:
          final XFile? image = await _imagePicker.pickImage(
            source: ImageSource.camera,
            imageQuality: 85,
          );
          if (image != null) {
            await _controller.sendImage(
              File(image.path),
              reply: _replyNotifier.value,
            );
            _replyNotifier.value = null;
          }
          break;

        case AttachmentSource.galleryImage:
          final XFile? image = await _imagePicker.pickImage(
            source: ImageSource.gallery,
            imageQuality: 85,
          );
          if (image != null) {
            await _controller.sendImage(
              File(image.path),
              reply: _replyNotifier.value,
            );
            _replyNotifier.value = null;
          }
          break;

        case AttachmentSource.cameraVideo:
          final XFile? video = await _imagePicker.pickVideo(
            source: ImageSource.camera,
            maxDuration: const Duration(minutes: 5),
          );
          if (video != null) {
            await _controller.sendVideo(
              File(video.path),
              reply: _replyNotifier.value,
            );
            _replyNotifier.value = null;
          }
          break;

        case AttachmentSource.galleryVideo:
          final XFile? video = await _imagePicker.pickVideo(
            source: ImageSource.gallery,
          );
          if (video != null) {
            await _controller.sendVideo(
              File(video.path),
              reply: _replyNotifier.value,
            );
            _replyNotifier.value = null;
          }
          break;

        case AttachmentSource.document:
          final result = await FilePicker.platform.pickFiles(
            type: FileType.any,
            allowMultiple: false,
          );
          if (result != null && result.files.isNotEmpty) {
            final file = result.files.first;
            if (file.path != null) {
              await _controller.sendDocument(
                File(file.path!),
                reply: _replyNotifier.value,
                fileName: file.name,
              );
              _replyNotifier.value = null;
            }
          }
          break;

        case AttachmentSource.location:
          _showSnackBar('Location sharing not implemented in demo');
          break;

        case AttachmentSource.contact:
          _showSnackBar('Contact sharing not implemented in demo');
          break;

        case AttachmentSource.voting:
          final poll = await CreatePollScreen.showAsBottomSheet(context);
          if (poll != null) {
            _showSnackBar('Created poll: ${poll.question}');
          }
          break;
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    }
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
          showSearch: true,
          showVideoCall: true,
          showTasks: true,
          showMenu: true,
          menuItems: [
            PopupMenuItem(
              value: 'search_page',
              child: Row(
                children: [
                  Icon(Icons.search,
                      size: 20, color: theme.colorScheme.onSurface),
                  const SizedBox(width: 12),
                  const Text('Search (Full Page)'),
                ],
              ),
            ),
          ],
          onSearch: () => _searchModeNotifier.value = true,
          onMenuSelection: (value) {
            if (value == 'search_page') {
              _openSearchPage(context);
            } else {
              _showSnackBar('Menu action: $value');
            }
          },
          onVideoCall: () => _showSnackBar('Video call'),
          onTasks: () => _showSnackBar('Tasks'),
          additionalActions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              tooltip: 'Screen Overview',
              onPressed: () => ExampleDescription.showAsBottomSheet(
                context,
                title: 'Screen Overview',
                icon: Icons.forum_outlined,
                lines: const [
                  'Full chat with all features enabled.',
                  'Suggestion providers: @mention, #hashtag, /quick, \$task.',
                  'Two search modes: in-chat and full page.',
                  'EditMessagePreview for editing messages.',
                  'Reactions, replies, polls, and attachments.',
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
      onPin: (messages) =>
          _showSnackBar('Pinned ${messages.length} message(s)'),
      onStar: (messages) =>
          _showSnackBar('Starred ${messages.length} message(s)'),
    );
  }

  /// Open ChatMessageSearchView as a separate page
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
    _showSnackBar('Selected: ${selected.id}');
  }

  /// Simulates a backend search - in real apps, this would call your API
  Future<List<String>> _simulateBackendSearch(String query) async {
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

  // Suggestion providers
  Future<List<FloatingSuggestionItem<ChatUserSuggestion>>> _usernameProvider(
    String query,
  ) async {
    final cleanQuery = _cleanQuery(query);
    final lower = cleanQuery.toLowerCase();
    final matches = cleanQuery.isEmpty
        ? _users
        : _users.where(
            (u) =>
                u.name.toLowerCase().contains(lower) ||
                (u.username ?? '').toLowerCase().contains(lower),
          );

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
    final cleanQuery = _cleanQuery(query);
    final lower = cleanQuery.toLowerCase();
    final matches = cleanQuery.isEmpty
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

  Future<List<FloatingSuggestionItem<QuickReply>>> _quickReplyProvider(
    String query,
  ) async {
    final cleanQuery = _cleanQuery(query);
    final lower = cleanQuery.toLowerCase();
    final matches = cleanQuery.isEmpty
        ? _quickReplies
        : _quickReplies.where((r) {
            final cmd =
                r.command.startsWith('/') ? r.command.substring(1) : r.command;
            return cmd.toLowerCase().contains(lower);
          });

    return matches
        .map((r) => FloatingSuggestionItem(
              value: r,
              label: r.command,
              subtitle: r.response,
              type: FloatingSuggestionType.quickReply,
            ))
        .toList();
  }

  Future<List<FloatingSuggestionItem<dynamic>>> _taskProvider(
    String query,
  ) async {
    final cleanQuery = _cleanQuery(query);
    final lower = cleanQuery.toLowerCase();
    final matches = cleanQuery.isEmpty
        ? _tasks
        : _tasks
            .where((t) => t['title'].toString().toLowerCase().contains(lower));

    return matches
        .map((t) => FloatingSuggestionItem(
              value: t,
              label: t['title'].toString(),
              type: FloatingSuggestionType.clubChatTask,
            ))
        .toList();
  }

  String _cleanQuery(String query) {
    if (query.isEmpty) return '';
    if (query.startsWith('@') ||
        query.startsWith('#') ||
        query.startsWith('/') ||
        query.startsWith(r'$')) {
      return query.substring(1);
    }
    return query;
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

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
