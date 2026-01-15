import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import '../data/example_message.dart';
import '../data/example_pagination.dart';
import '../data/example_sample_data.dart';
import 'shared/example_scaffold.dart';

class InputFeaturesExample extends StatefulWidget {
  const InputFeaturesExample({super.key});

  @override
  State<InputFeaturesExample> createState() => _InputFeaturesExampleState();
}

class _InputFeaturesExampleState extends State<InputFeaturesExample> {
  final ValueNotifier<ChatReplyData?> _replyNotifier = ValueNotifier(null);
  late final List<ExampleMessage> _messages;
  late final ExamplePaginationHelper<ExampleMessage> _pagination;

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
        .take(2)
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
    _pagination.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Features')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: ExampleDescription(
              title: 'Screen Overview',
              icon: Icons.keyboard_outlined,
              lines: [
                'Highlights advanced input options like mentions and quick replies.',
                'Shows reply preview, attachments, and command suggestions together.',
                'Useful to validate input UX before wiring real message delivery.',
              ],
            ),
          ),
          const SizedBox(height: 12),
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
                  child: MessageBubble(
                    message: message,
                    currentUserId: ExampleSampleData.currentUserId,
                    showAvatar: true,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
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
              icon: const Icon(Icons.reply_outlined),
              label: const Text('Enable reply preview'),
            ),
          ),
          ChatInputWidget(
            onSendText: _handleSendText,
            onAttachmentSelected: (type) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Attachment selected: ${type.name}')),
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

  Widget _buildHintCard(BuildContext context) {
    final theme = Theme.of(context);
    final hints = ['@mention', '#hashtag', '/quick', r'$task', 'Paste a link'];

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
}
