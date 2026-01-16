import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import '../data/example_message.dart';
import '../data/example_pagination.dart';
import '../data/example_sample_data.dart';
import 'shared/example_scaffold.dart';

class ReactionsExample extends StatefulWidget {
  const ReactionsExample({super.key});

  @override
  State<ReactionsExample> createState() => _ReactionsExampleState();
}

class _ReactionsExampleState extends State<ReactionsExample> {
  late final List<ExampleMessage> _messages;
  late final ExamplePaginationHelper<ExampleMessage> _pagination;
  int _pinnedIndex = 0;
  Set<IChatMessageData> _selectedMessages = {};
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _messages = ExampleSampleData.buildMessages()
        .where((message) => message.type == ChatMessageType.text)
        .take(5)
        .toList()
        .reversed
        .toList();

    _pagination = ExamplePaginationHelper<ExampleMessage>(
      items: _messages,
      pageSize: 10,
    );
    _pagination.cubit.fetchPaginatedList();
  }

  @override
  void dispose() {
    _pagination.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSelectionMode
          ? ChatSelectionAppBar(
              selectedCount: _selectedMessages.length,
              selectedMessages: _selectedMessages,
              currentUserId: ExampleSampleData.currentUserId,
              onClose: _clearSelection,
              onReply: (msg) {
                _showSnackBar('Reply to: ${msg.textContent}');
                _clearSelection();
              },
              onCopy: () {
                _showSnackBar('Copied ${_selectedMessages.length} messages');
                _clearSelection();
              },
              onPin: (msgs) {
                _showSnackBar('Pinned ${msgs.length} messages');
                _clearSelection();
              },
              onStar: (msgs) {
                _showSnackBar('Starred ${msgs.length} messages');
                _clearSelection();
              },
              onForward: (msgs) {
                _showSnackBar('Forward ${msgs.length} messages');
                _clearSelection();
              },
              onDelete: (msgs) {
                _showSnackBar('Deleted ${msgs.length} messages');
                _clearSelection();
              },
            )
          : AppBar(
              title: const Text('Reactions & Context Menu'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.info_outline),
                  tooltip: 'Screen Overview',
                  onPressed: () => ExampleDescription.showAsBottomSheet(
                    context,
                    title: 'Screen Overview',
                    icon: Icons.emoji_emotions_outlined,
                    lines: const [
                      'WhatsApp-style reactions and context menu.',
                      'Long press a message to show context menu.',
                      'Select multiple messages for bulk actions.',
                      'Includes pin, star, reply, copy, forward, delete.',
                    ],
                  ),
                ),
              ],
            ),
      body: Column(
        children: [
          // Demo section for MessageReactionBar
          _buildReactionBarDemo(),

          if (_messages.isNotEmpty)
            PinnedMessagesBar(
              message: _messages[_pinnedIndex],
              index: _pinnedIndex,
              total: _messages.length,
              onTap: () {
                setState(() {
                  _pinnedIndex = (_pinnedIndex + 1) % _messages.length;
                });
                _showSnackBar('Pinned message: ${_messages[_pinnedIndex].id}');
              },
            ),
          Expanded(
            child: SmartPaginationListView.withCubit(
              cubit: _pagination.cubit,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, items, index) {
                final message = items[index];
                final isSelected = _selectedMessages.contains(message);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onLongPressStart: (details) =>
                        _showContextMenu(context, details.globalPosition, message),
                    onTap: _isSelectionMode
                        ? () => _toggleSelection(message)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context)
                                .colorScheme
                                .primary
                                .withValues(alpha: 0.1)
                            : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: MessageBubble(
                        message: message,
                        currentUserId: ExampleSampleData.currentUserId,
                        showAvatar: true,
                        onReactionTap: (emoji) =>
                            _toggleReaction(message, emoji),
                      ),
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

  Widget _buildReactionBarDemo() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MessageReactionBar Demo',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Center(
            child: MessageReactionBar(
              reactions: const ['❤️', '😂', '😮', '😢', '🙏', '👍'],
              onReactionSelected: (emoji) {
                _showSnackBar('Selected reaction: $emoji');
              },
              onMorePressed: () async {
                final emoji = await ReactionEmojiPicker.show(context);
                if (emoji != null) {
                  _showSnackBar('Selected from picker: $emoji');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showContextMenu(
    BuildContext context,
    Offset position,
    ExampleMessage message,
  ) async {
    final result = await MessageContextMenu.show(
      context,
      position: position,
      reactions: const ['❤️', '😂', '😮', '😢', '🙏', '👍'],
      actions: [
        MessageActionConfig.reply,
        MessageActionConfig.copy,
        MessageActionConfig.forward,
        MessageActionConfig.pin,
        MessageActionConfig.star,
        MessageActionConfig.delete,
      ],
    );

    if (result == null) return;

    if (result.hasReaction) {
      _toggleReaction(message, result.reaction!);
    } else if (result.hasAction) {
      _handleAction(result.action!, message);
    }
  }

  void _handleAction(MessageAction action, ExampleMessage message) {
    switch (action) {
      case MessageAction.reply:
        _showSnackBar('Reply to: ${message.textContent}');
        break;
      case MessageAction.copy:
        _showSnackBar('Copied: ${message.textContent}');
        break;
      case MessageAction.forward:
        _showSnackBar('Forward message');
        break;
      case MessageAction.pin:
        _showSnackBar('Pinned message');
        break;
      case MessageAction.star:
        _showSnackBar('Starred message');
        break;
      case MessageAction.delete:
        _showSnackBar('Deleted message');
        break;
      default:
        _showSnackBar('Action: $action');
    }
  }

  void _toggleSelection(IChatMessageData message) {
    setState(() {
      if (_selectedMessages.contains(message)) {
        _selectedMessages.remove(message);
        if (_selectedMessages.isEmpty) {
          _isSelectionMode = false;
        }
      } else {
        _selectedMessages.add(message);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedMessages = {};
      _isSelectionMode = false;
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  void _toggleReaction(ExampleMessage message, String emoji) {
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
      final updated = message.copyWith(reactions: reactions);
      _messages[_messages.indexOf(message)] = updated;
    });
    _pagination.setItems(_messages);
  }
}
