import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import '../data/example_message.dart';
import '../data/example_pagination.dart';
import '../data/example_sample_data.dart';
import 'shared/example_scaffold.dart';

/// Demonstrates all input-related features.
///
/// Features demonstrated:
/// - ChatAppBar with actions
/// - ChatInputWidget with all suggestion providers (@, #, /, $)
/// - EditMessagePreview for edit-in-place flow
/// - Reply preview (ChatReplyData)
/// - Voice recording callbacks
/// - Poll request callback
/// - PinnedMessagesBar
class InputFeaturesExample extends StatefulWidget {
  const InputFeaturesExample({super.key});

  @override
  State<InputFeaturesExample> createState() => _InputFeaturesExampleState();
}

class _InputFeaturesExampleState extends State<InputFeaturesExample> {
  final ValueNotifier<ChatReplyData?> _replyNotifier = ValueNotifier(null);
  final ValueNotifier<IChatMessageData?> _editNotifier = ValueNotifier(null);
  late final List<ExampleMessage> _messages;
  late final ExamplePaginationHelper<ExampleMessage> _pagination;
  int _pinnedIndex = 0;

  final List<ChatUserSuggestion> _users = const [
    ChatUserSuggestion(id: 'user_2', name: 'Omar', username: 'omar'),
    ChatUserSuggestion(id: 'user_3', name: 'Sara', username: 'sara'),
    ChatUserSuggestion(id: 'user_4', name: 'Tariq', username: 'tariq'),
  ];

  final List<Hashtag> _hashtags = [
    Hashtag(id: 'tag_1', hashtag: 'release'),
    Hashtag(id: 'tag_2', hashtag: 'design'),
    Hashtag(id: 'tag_3', hashtag: 'performance'),
  ];

  final List<QuickReply> _quickReplies = [
    QuickReply(id: 'qr_1', command: '/welcome', response: 'Welcome aboard!'),
    QuickReply(id: 'qr_2', command: '/eta', response: 'ETA is 4 PM today.'),
    QuickReply(id: 'qr_3', command: '/summary', response: 'Here is a summary.'),
  ];

  final List<Map<String, dynamic>> _tasks = const [
    {'id': 'task_1', 'title': 'Prepare demo deck'},
    {'id': 'task_2', 'title': 'Review analytics'},
    {'id': 'task_3', 'title': 'Update roadmap'},
  ];

  @override
  void initState() {
    super.initState();
    _messages = ExampleSampleData.buildMessages()
        .where((message) => message.type == ChatMessageType.text)
        .take(4)
        .toList()
        .reversed
        .toList();
    _pagination = ExamplePaginationHelper<ExampleMessage>(
      items: _messages,
      pageSize: 20,
    );
    _pagination.cubit.fetchPaginatedList();
  }

  @override
  void dispose() {
    _replyNotifier.dispose();
    _editNotifier.dispose();
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
              id: 'input_features_demo',
              title: 'Input Features',
              subtitle: 'Suggestions, reply, edit, voice',
              imageUrl: 'https://i.pravatar.cc/150?img=15',
            ),
            showSearch: false,
            showMenu: true,
            showVideoCall: false,
            showTasks: true,
            menuItems: [
              PopupMenuItem(
                value: 'clear_reply',
                child: Row(
                  children: [
                    Icon(Icons.clear, color: theme.colorScheme.onSurface),
                    const SizedBox(width: 8),
                    const Text('Clear reply/edit'),
                  ],
                ),
              ),
            ],
            onMenuSelection: (_) {
              _replyNotifier.value = null;
              _editNotifier.value = null;
            },
            onTasks: () => _showSnackBar('Open tasks view'),
            additionalActions: [
              IconButton(
                icon: const Icon(Icons.info_outline),
                tooltip: 'Screen Overview',
                onPressed: () => ExampleDescription.showAsBottomSheet(
                  context,
                  title: 'Screen Overview',
                  icon: Icons.keyboard_outlined,
                  lines: const [
                    'Highlights advanced input options like mentions and quick replies.',
                    'Shows EditMessagePreview for editing existing messages.',
                    'Try @mention, #hashtag, /command, or \$task in the input.',
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (_messages.isNotEmpty)
            PinnedMessagesBar(
              message: _messages[_pinnedIndex % _messages.length],
              index: _pinnedIndex % _messages.length,
              total: _messages.length,
              onTap: () {
                setState(() {
                  _pinnedIndex = (_pinnedIndex + 1) % _messages.length;
                });
                _showSnackBar(
                  'Pinned: ${_messages[_pinnedIndex % _messages.length].id}',
                );
              },
            ),
          _buildHintCard(context),
          const SizedBox(height: 12),
          Expanded(
            child: SmartPaginationListView.withCubit(
              cubit: _pagination.cubit,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemBuilder: (context, items, index) {
                final message = items[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onLongPress: () => _startEditMessage(message),
                    child: MessageBubble(
                      message: message,
                      currentUserId: ExampleSampleData.currentUserId,
                      showAvatar: true,
                    ),
                  ),
                );
              },
            ),
          ),
          _buildActionButtons(context),
          // EditMessagePreview integration
          ValueListenableBuilder<IChatMessageData?>(
            valueListenable: _editNotifier,
            builder: (context, editMessage, _) {
              if (editMessage == null) return const SizedBox.shrink();
              return EditMessagePreview(
                message: editMessage,
                onCancel: () => _editNotifier.value = null,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              );
            },
          ),
          ChatInputWidget(
            onSendText: _handleSendText,
            onAttachmentSelected: (type) =>
                _showSnackBar('Attachment selected: ${type.name}'),
            onPollRequested: () => _showSnackBar('Create poll requested'),
            onRecordingStart: () => _showSnackBar('Recording started'),
            onRecordingCancel: () => _showSnackBar('Recording cancelled'),
            onRecordingComplete: (path, duration, {waveform}) async {
              _showSnackBar(
                'Recorded ${duration}s (waveform: ${waveform?.length ?? 0})',
              );
            },
            replyMessage: _replyNotifier,
            usernameProvider: _usernameProvider,
            hashtagProvider: _hashtagProvider,
            quickReplyProvider: _quickReplyProvider,
            taskProvider: _taskProvider,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                _replyNotifier.value = ChatReplyData(
                  id: 'msg_reply',
                  senderId: 'user_2',
                  senderName: 'Omar',
                  message: 'Reply preview enabled from the example screen.',
                  type: ChatMessageType.text,
                );
              },
              icon: const Icon(Icons.reply_outlined, size: 18),
              label: const Text('Reply'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                if (_messages.isEmpty) return;
                final message = _messages.first;
                _startEditMessage(message);
              },
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit'),
            ),
          ),
        ],
      ),
    );
  }

  void _startEditMessage(ExampleMessage message) {
    if (message.senderId != ExampleSampleData.currentUserId) {
      _showSnackBar('Cannot edit messages from other users');
      return;
    }

    _editNotifier.value = message;
    _showSnackBar('Editing message: ${message.id}');
  }

  Widget _buildHintCard(BuildContext context) {
    final theme = Theme.of(context);
    final hints = [
      '@mention',
      '#hashtag',
      '/quick',
      r'$task',
      'Long-press to edit',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Try these input features',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: hints
                .map(
                  (hint) => Chip(
                    label: Text(hint),
                    backgroundColor: theme.colorScheme.surface,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSendText(String text) async {
    // If editing, update existing message
    if (_editNotifier.value != null) {
      final editMessage = _editNotifier.value!;
      final index = _messages.indexWhere((m) => m.id == editMessage.id);
      if (index != -1) {
        final original = _messages[index];
        _messages[index] = original.copyWith(
          textContent: text.trim(),
          isEdited: true,
          updatedAt: DateTime.now(),
        );
        _pagination.setItems(_messages);
        _showSnackBar('Message edited');
      }
      _editNotifier.value = null;
      return;
    }

    // Clear reply if set
    if (_replyNotifier.value != null) {
      _replyNotifier.value = null;
    }

    final message = ExampleMessage(
      id: 'input_${DateTime.now().microsecondsSinceEpoch}',
      chatId: ExampleSampleData.chatId,
      senderId: ExampleSampleData.currentUserId,
      senderData: ExampleSampleData.users[ExampleSampleData.currentUserId] ??
          const ChatSenderData(id: 'user_1', name: 'You'),
      type: ChatMessageType.text,
      textContent: text.trim(),
      createdAt: DateTime.now(),
      status: ChatMessageStatus.sent,
    );
    setState(() {
      _messages.add(message);
    });
    _pagination.setItems(_messages);
  }

  Future<List<FloatingSuggestionItem<ChatUserSuggestion>>> _usernameProvider(
    String query,
  ) async {
    final cleanQuery = _cleanQuery(query);
    if (cleanQuery.isEmpty) {
      return _users
          .map(
            (user) => FloatingSuggestionItem(
              value: user,
              label: user.name,
              subtitle: '@${user.username}',
              icon: const Icon(Icons.person_outline, size: 16),
              type: FloatingSuggestionType.username,
            ),
          )
          .toList();
    }

    final lower = cleanQuery.toLowerCase();
    final matches = _users.where(
      (user) =>
          user.name.toLowerCase().contains(lower) ||
          (user.username ?? '').toLowerCase().contains(lower),
    );

    return matches
        .map(
          (user) => FloatingSuggestionItem(
            value: user,
            label: user.name,
            subtitle: '@${user.username}',
            icon: const Icon(Icons.person_outline, size: 16),
            type: FloatingSuggestionType.username,
          ),
        )
        .toList();
  }

  Future<List<FloatingSuggestionItem<Hashtag>>> _hashtagProvider(
    String query,
  ) async {
    final cleanQuery = _cleanQuery(query);
    if (cleanQuery.isEmpty) {
      return _hashtags
          .map(
            (tag) => FloatingSuggestionItem(
              value: tag,
              label: '#${tag.hashtag}',
              type: FloatingSuggestionType.hashtag,
            ),
          )
          .toList();
    }

    final lower = cleanQuery.toLowerCase();
    return _hashtags
        .where((tag) => tag.hashtag.toLowerCase().contains(lower))
        .map(
          (tag) => FloatingSuggestionItem(
            value: tag,
            label: '#${tag.hashtag}',
            type: FloatingSuggestionType.hashtag,
          ),
        )
        .toList();
  }

  Future<List<FloatingSuggestionItem<QuickReply>>> _quickReplyProvider(
    String query,
  ) async {
    final cleanQuery = _cleanQuery(query);
    if (cleanQuery.isEmpty) {
      return _quickReplies
          .map(
            (reply) => FloatingSuggestionItem(
              value: reply,
              label: reply.command,
              subtitle: reply.response,
              type: FloatingSuggestionType.quickReply,
            ),
          )
          .toList();
    }

    final lower = cleanQuery.toLowerCase();
    return _quickReplies
        .where((reply) {
          final command = reply.command.startsWith('/')
              ? reply.command.substring(1)
              : reply.command;
          return command.toLowerCase().contains(lower);
        })
        .map(
          (reply) => FloatingSuggestionItem(
            value: reply,
            label: reply.command,
            subtitle: reply.response,
            type: FloatingSuggestionType.quickReply,
          ),
        )
        .toList();
  }

  Future<List<FloatingSuggestionItem<dynamic>>> _taskProvider(
    String query,
  ) async {
    final cleanQuery = _cleanQuery(query);
    if (cleanQuery.isEmpty) {
      return _tasks
          .map(
            (task) => FloatingSuggestionItem(
              value: task,
              label: task['title'].toString(),
              type: FloatingSuggestionType.clubChatTask,
            ),
          )
          .toList();
    }

    final lower = cleanQuery.toLowerCase();
    return _tasks
        .where((task) => task['title'].toString().toLowerCase().contains(lower))
        .map(
          (task) => FloatingSuggestionItem(
            value: task,
            label: task['title'].toString(),
            type: FloatingSuggestionType.clubChatTask,
          ),
        )
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

  void _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
