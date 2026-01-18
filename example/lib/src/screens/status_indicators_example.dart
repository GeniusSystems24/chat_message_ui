import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import '../data/example_message.dart';
import '../data/example_pagination.dart';
import '../data/example_sample_data.dart';
import 'shared/example_scaffold.dart';

/// Demonstrates message status indicators and compact reactions.
///
/// Features demonstrated:
/// - Pin, Star, and Save indicators in message metadata
/// - CompactReactionChip for WhatsApp-style reaction display
/// - Toggle status indicators on messages
/// - Professional neutral color scheme for reactions
class StatusIndicatorsExample extends StatefulWidget {
  const StatusIndicatorsExample({super.key});

  @override
  State<StatusIndicatorsExample> createState() =>
      _StatusIndicatorsExampleState();
}

class _StatusIndicatorsExampleState extends State<StatusIndicatorsExample> {
  late List<ExampleMessage> _messages;
  late final ExamplePaginationHelper<ExampleMessage> _pagination;

  @override
  void initState() {
    super.initState();
    _messages = _buildDemoMessages();

    _pagination = ExamplePaginationHelper<ExampleMessage>(
      items: _messages,
      pageSize: 10,
    );
    _pagination.cubit.fetchPaginatedList();
  }

  List<ExampleMessage> _buildDemoMessages() {
    final now = DateTime.now();
    return [
      // Message with all status indicators
      ExampleMessage(
        id: 'status_1',
        chatId: ExampleSampleData.chatId,
        senderId: 'user_2',
        senderData: ExampleSampleData.users['user_2'],
        type: ChatMessageType.text,
        textContent: 'This message is pinned, starred, and saved!',
        createdAt: now.subtract(const Duration(minutes: 30)),
        status: ChatMessageStatus.read,
        isPinned: true,
        isStarred: true,
        isSaved: true,
        reactions: const [
          ChatReactionData(emoji: '👍', userId: 'user_1', createdAt: null),
          ChatReactionData(emoji: '👍', userId: 'user_2', createdAt: null),
          ChatReactionData(emoji: '❤️', userId: 'user_3', createdAt: null),
          ChatReactionData(emoji: '😂', userId: 'user_1', createdAt: null),
        ],
      ),
      // Only pinned
      ExampleMessage(
        id: 'status_2',
        chatId: ExampleSampleData.chatId,
        senderId: ExampleSampleData.currentUserId,
        senderData: ExampleSampleData.users[ExampleSampleData.currentUserId],
        type: ChatMessageType.text,
        textContent: 'This message is only pinned 📌',
        createdAt: now.subtract(const Duration(minutes: 25)),
        status: ChatMessageStatus.delivered,
        isPinned: true,
        isStarred: false,
        isSaved: false,
      ),
      // Only starred
      ExampleMessage(
        id: 'status_3',
        chatId: ExampleSampleData.chatId,
        senderId: 'user_3',
        senderData: ExampleSampleData.users['user_3'],
        type: ChatMessageType.text,
        textContent: 'This message is only starred ⭐',
        createdAt: now.subtract(const Duration(minutes: 20)),
        status: ChatMessageStatus.read,
        isPinned: false,
        isStarred: true,
        isSaved: false,
        reactions: const [
          ChatReactionData(emoji: '❤️', userId: 'user_1', createdAt: null),
          ChatReactionData(emoji: '❤️', userId: 'user_2', createdAt: null),
        ],
      ),
      // Only saved
      ExampleMessage(
        id: 'status_4',
        chatId: ExampleSampleData.chatId,
        senderId: ExampleSampleData.currentUserId,
        senderData: ExampleSampleData.users[ExampleSampleData.currentUserId],
        type: ChatMessageType.text,
        textContent: 'This message is only saved 🔖',
        createdAt: now.subtract(const Duration(minutes: 15)),
        status: ChatMessageStatus.sent,
        isPinned: false,
        isStarred: false,
        isSaved: true,
      ),
      // No indicators
      ExampleMessage(
        id: 'status_5',
        chatId: ExampleSampleData.chatId,
        senderId: 'user_2',
        senderData: ExampleSampleData.users['user_2'],
        type: ChatMessageType.text,
        textContent: 'This is a regular message with no status indicators.',
        createdAt: now.subtract(const Duration(minutes: 10)),
        status: ChatMessageStatus.read,
        isPinned: false,
        isStarred: false,
        isSaved: false,
      ),
      // Edited message with star
      ExampleMessage(
        id: 'status_6',
        chatId: ExampleSampleData.chatId,
        senderId: ExampleSampleData.currentUserId,
        senderData: ExampleSampleData.users[ExampleSampleData.currentUserId],
        type: ChatMessageType.text,
        textContent: 'This message was edited and is starred.',
        createdAt: now.subtract(const Duration(minutes: 5)),
        status: ChatMessageStatus.read,
        isPinned: false,
        isStarred: true,
        isSaved: false,
        isEdited: true,
        reactions: const [
          ChatReactionData(emoji: '👍', userId: 'user_2', createdAt: null),
        ],
      ),
      // Message with many reactions for CompactReactionChip demo
      ExampleMessage(
        id: 'status_7',
        chatId: ExampleSampleData.chatId,
        senderId: 'user_3',
        senderData: ExampleSampleData.users['user_3'],
        type: ChatMessageType.text,
        textContent: 'Check out the compact reaction chip! All emojis in one badge.',
        createdAt: now.subtract(const Duration(minutes: 2)),
        status: ChatMessageStatus.read,
        isPinned: false,
        isStarred: false,
        isSaved: false,
        reactions: const [
          ChatReactionData(emoji: '👍', userId: 'user_1', createdAt: null),
          ChatReactionData(emoji: '👍', userId: 'user_2', createdAt: null),
          ChatReactionData(emoji: '❤️', userId: 'user_3', createdAt: null),
          ChatReactionData(emoji: '❤️', userId: 'user_1', createdAt: null),
          ChatReactionData(emoji: '😂', userId: 'user_2', createdAt: null),
          ChatReactionData(emoji: '🔥', userId: 'user_1', createdAt: null),
          ChatReactionData(emoji: '🎉', userId: 'user_3', createdAt: null),
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _pagination.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatTheme = ChatThemeData.get(context);

    return Scaffold(
      appBar: ChatAppBar(
        chat: const ChatAppBarData(
          id: 'status_demo',
          title: 'Status Indicators',
          subtitle: 'Pin, Star, Save & Reactions',
          imageUrl: 'https://i.pravatar.cc/150?img=30',
        ),
        showSearch: false,
        showMenu: false,
        additionalActions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Screen Overview',
            onPressed: () => ExampleDescription.showAsBottomSheet(
              context,
              title: 'Screen Overview',
              icon: Icons.push_pin_outlined,
              lines: const [
                'Demonstrates message status indicators.',
                'Icons shown: 📌 pinned, ⭐ starred, 🔖 saved.',
                'Tap a message to toggle its status.',
                'CompactReactionChip shows all emojis in one badge.',
                'Icons appear next to timestamp in bubble.',
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // CompactReactionChip Demo Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: theme.colorScheme.surfaceContainerHighest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CompactReactionChip Demo',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'WhatsApp-style compact reaction display',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Example 1: Single reaction
                    _buildReactionDemo(
                      context,
                      chatTheme,
                      'Single:',
                      {'👍': ['user_1']},
                    ),
                    const SizedBox(width: 24),
                    // Example 2: Multiple reactions
                    _buildReactionDemo(
                      context,
                      chatTheme,
                      'Multiple:',
                      {
                        '👍': ['user_1', 'user_2'],
                        '❤️': ['user_3'],
                        '😂': ['user_1'],
                      },
                    ),
                    const SizedBox(width: 24),
                    // Example 3: Many reactions
                    _buildReactionDemo(
                      context,
                      chatTheme,
                      'Many:',
                      {
                        '👍': ['user_1', 'user_2', 'user_3'],
                        '❤️': ['user_1', 'user_2'],
                        '😂': ['user_3'],
                        '🔥': ['user_1'],
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Status Icons Legend
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outlineVariant,
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(
                  context,
                  Icons.push_pin,
                  'Pinned',
                  theme.colorScheme.onSurfaceVariant,
                ),
                _buildLegendItem(
                  context,
                  Icons.star,
                  'Starred',
                  Colors.amber.shade600,
                ),
                _buildLegendItem(
                  context,
                  Icons.bookmark,
                  'Saved',
                  theme.colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),

          // Instructions
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.touch_app,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tap messages to toggle status indicators',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Message list
          Expanded(
            child: SmartPaginationListView.withCubit(
              cubit: _pagination.cubit,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, items, index) {
                final message = items[index] as ExampleMessage;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => _showStatusMenu(context, message),
                    child: MessageBubble(
                      message: message,
                      currentUserId: ExampleSampleData.currentUserId,
                      showAvatar: true,
                      onReactionTap: (emoji) =>
                          _toggleReaction(message, emoji),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionDemo(
    BuildContext context,
    ChatThemeData chatTheme,
    String label,
    Map<String, List<String>> reactions,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
        const SizedBox(height: 4),
        CompactReactionChip(
          groupedReactions: reactions,
          currentUserId: ExampleSampleData.currentUserId,
          chatTheme: chatTheme,
          onTap: () => _showSnackBar('Tapped reactions'),
        ),
      ],
    );
  }

  Widget _buildLegendItem(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }

  void _showStatusMenu(BuildContext context, ExampleMessage message) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Toggle Status',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: Icon(
                Icons.push_pin,
                color: message.isPinned
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              title: const Text('Pin Message'),
              trailing: message.isPinned
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                Navigator.pop(context);
                _toggleStatus(message, 'pin');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.star,
                color:
                    message.isStarred ? Colors.amber.shade600 : null,
              ),
              title: const Text('Star Message'),
              trailing: message.isStarred
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                Navigator.pop(context);
                _toggleStatus(message, 'star');
              },
            ),
            ListTile(
              leading: Icon(
                Icons.bookmark,
                color: message.isSaved
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              title: const Text('Save Message'),
              trailing: message.isSaved
                  ? const Icon(Icons.check, color: Colors.green)
                  : null,
              onTap: () {
                Navigator.pop(context);
                _toggleStatus(message, 'save');
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _toggleStatus(ExampleMessage message, String status) {
    final index = _messages.indexWhere((m) => m.id == message.id);
    if (index == -1) return;

    ExampleMessage updated;
    String statusName;

    switch (status) {
      case 'pin':
        updated = message.copyWith(isPinned: !message.isPinned);
        statusName = message.isPinned ? 'Unpinned' : 'Pinned';
        break;
      case 'star':
        updated = message.copyWith(isStarred: !message.isStarred);
        statusName = message.isStarred ? 'Unstarred' : 'Starred';
        break;
      case 'save':
        updated = message.copyWith(isSaved: !message.isSaved);
        statusName = message.isSaved ? 'Unsaved' : 'Saved';
        break;
      default:
        return;
    }

    setState(() {
      _messages[index] = updated;
    });
    _pagination.setItems(_messages);
    _showSnackBar('$statusName message');
  }

  void _toggleReaction(ExampleMessage message, String emoji) {
    final index = _messages.indexWhere((m) => m.id == message.id);
    if (index == -1) return;

    final reactions = List<ChatReactionData>.from(message.reactions);
    final currentUserId = ExampleSampleData.currentUserId;
    final existingIndex = reactions.indexWhere(
      (reaction) =>
          reaction.emoji == emoji && reaction.userId == currentUserId,
    );

    if (existingIndex >= 0) {
      reactions.removeAt(existingIndex);
    } else {
      reactions.add(
        ChatReactionData(
          emoji: emoji,
          userId: currentUserId,
          createdAt: DateTime.now(),
        ),
      );
    }

    setState(() {
      _messages[index] = message.copyWith(reactions: reactions);
    });
    _pagination.setItems(_messages);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}
