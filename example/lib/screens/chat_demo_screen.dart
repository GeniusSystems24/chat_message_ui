import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';
import 'package:smart_pagination/pagination.dart';

import '../data/mock_message.dart';
import '../data/sample_data.dart';

/// Demo screen showing the full chat interface.
class ChatDemoScreen extends StatefulWidget {
  const ChatDemoScreen({super.key});

  @override
  State<ChatDemoScreen> createState() => _ChatDemoScreenState();
}

class _ChatDemoScreenState extends State<ChatDemoScreen> {
  late final SmartPaginationCubit<IChatMessageData> _messagesCubit;
  final ValueNotifier<ChatReplyData?> _replyMessage = ValueNotifier(null);
  final List<MockChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messages.addAll(allSampleMessages);
    _messagesCubit = SmartPaginationCubit<IChatMessageData>(
      fetcher: _fetchMessages,
      initialItems: _messages,
    );
  }

  Future<PaginatedResponse<IChatMessageData>> _fetchMessages(int page) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return PaginatedResponse(
      items: _messages,
      hasMore: false,
      currentPage: page,
    );
  }

  @override
  void dispose() {
    _messagesCubit.close();
    _replyMessage.dispose();
    super.dispose();
  }

  Future<void> _handleSendMessage(String text) async {
    // Create new message
    final newMessage = MockChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      chatId: 'chat_1',
      senderId: currentUserId,
      type: ChatMessageType.text,
      textContent: text,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.sent,
      senderData: sender1,
      replyData: _replyMessage.value,
    );

    // Add to list
    setState(() {
      _messages.insert(0, newMessage);
    });

    // Clear reply
    _replyMessage.value = null;

    // Refresh cubit
    _messagesCubit.refresh();

    // Simulate status update
    await Future.delayed(const Duration(seconds: 1));
    final index = _messages.indexWhere((m) => m.id == newMessage.id);
    if (index != -1) {
      setState(() {
        _messages[index] = newMessage.copyWith(status: ChatMessageStatus.delivered);
      });
      _messagesCubit.refresh();
    }
  }

  void _handleReaction(IChatMessageData message, String emoji) {
    final index = _messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      final msg = _messages[index];
      final reactions = List<ChatReactionData>.from(msg.reactions);

      // Toggle reaction
      final existingIndex = reactions.indexWhere(
        (r) => r.emoji == emoji && r.userId == currentUserId,
      );

      if (existingIndex != -1) {
        reactions.removeAt(existingIndex);
      } else {
        reactions.add(ChatReactionData(
          emoji: emoji,
          userId: currentUserId,
          createdAt: DateTime.now(),
        ));
      }

      setState(() {
        _messages[index] = msg.copyWith(reactions: reactions);
      });
      _messagesCubit.refresh();
    }
  }

  void _handleDelete(Set<IChatMessageData> messages) {
    setState(() {
      for (final msg in messages) {
        final index = _messages.indexWhere((m) => m.id == msg.id);
        if (index != -1) {
          _messages[index] = (_messages[index]).copyWith(isDeleted: true);
        }
      }
    });
    _messagesCubit.refresh();
  }

  void _handleAttachment(AttachmentSource type) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Selected attachment type: ${type.name}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChatTheme(
      data: ChatThemeData.fromTheme(Theme.of(context)),
      child: ChatScreen(
        messagesCubit: _messagesCubit,
        currentUserId: currentUserId,
        onSendMessage: _handleSendMessage,
        onAttachmentSelected: _handleAttachment,
        onReactionTap: _handleReaction,
        onDelete: _handleDelete,
        replyMessage: _replyMessage,
        showAvatar: true,
        appBarBuilder: (context) => AppBar(
          title: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(sender2.imageUrl ?? ''),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sender2.displayName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.videocam),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () {},
            ),
            PopupMenuButton<String>(
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'search', child: Text('Search')),
                const PopupMenuItem(value: 'mute', child: Text('Mute')),
                const PopupMenuItem(value: 'clear', child: Text('Clear chat')),
              ],
            ),
          ],
        ),
        emptyMessage: 'Start a conversation!',
      ),
    );
  }
}
