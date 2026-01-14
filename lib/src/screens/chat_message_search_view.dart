import 'package:flutter/material.dart';

import '../adapters/chat_message_data.dart';
import '../utils/messages_grouping.dart';
import '../widgets/widgets.dart';

/// A search view for filtering and displaying chat messages.
///
/// This widget provides a search interface to filter messages by text content.
/// When a message is tapped, it pops with the selected message.
class ChatMessageSearchView extends StatefulWidget {
  /// List of messages to search through.
  final List<IChatMessageData> messages;

  /// Current user ID to determine message ownership.
  final String currentUserId;

  /// Optional custom message bubble builder.
  final Widget Function(
    BuildContext context,
    IChatMessageData message,
    bool isMyMessage,
  )? messageBubbleBuilder;

  /// Placeholder text for search input.
  final String searchHintText;

  /// Text shown when no results found.
  final String noResultsText;

  const ChatMessageSearchView({
    super.key,
    required this.messages,
    required this.currentUserId,
    this.messageBubbleBuilder,
    this.searchHintText = 'Search',
    this.noResultsText = 'No messages found',
  });

  @override
  State<ChatMessageSearchView> createState() => _ChatMessageSearchViewState();
}

class _ChatMessageSearchViewState extends State<ChatMessageSearchView> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = _filterMessages(widget.messages, _query);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          maxLength: 30,
          decoration: InputDecoration(
            hintText: widget.searchHintText,
            counterText: '',
            border: InputBorder.none,
            prefixIcon: BackButton(
              style: IconButton.styleFrom(
                iconSize: 24,
                foregroundColor: theme.appBarTheme.iconTheme?.color,
              ),
            ),
            suffixIcon: _query.isNotEmpty
                ? IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                    icon: const Icon(Icons.clear),
                  )
                : null,
          ),
          onChanged: (text) => setState(() => _query = text),
        ),
      ),
      body: results.isEmpty
          ? Center(
              child: Text(
                widget.noResultsText,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(12),
              itemCount: results.length,
              itemBuilder: (context, index) {
                return _messageItemBuilder(context, results, index);
              },
            ),
    );
  }

  List<IChatMessageData> _filterMessages(
    List<IChatMessageData> messages,
    String query,
  ) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return messages;
    final lower = trimmed.toLowerCase();

    return messages.where((message) {
      final text = message.textContent ?? '';
      return text.toLowerCase().contains(lower);
    }).toList();
  }

  Widget _messageItemBuilder(
    BuildContext context,
    List<IChatMessageData> documents,
    int index,
  ) {
    final theme = Theme.of(context);
    final message = documents[index];
    final messageGroupStatus = MessageGroupStatus.resolveGroupStatus(
      items: documents,
      index: index,
    );

    final isLastMessage = index == documents.length - 1;
    final nextMessage =
        index < documents.length - 1 ? documents[index + 1] : null;
    final isSameDay = _messageTimestamp(nextMessage)?.day ==
            _messageTimestamp(message)?.day &&
        _messageTimestamp(nextMessage)?.month ==
            _messageTimestamp(message)?.month &&
        _messageTimestamp(nextMessage)?.year ==
            _messageTimestamp(message)?.year;

    final isMyMessage = message.senderId == widget.currentUserId;

    final messageBubble = InkWell(
      onTap: () => Navigator.of(context).pop(message),
      child: Padding(
        padding: EdgeInsets.only(
          top: messageGroupStatus?.isFirst == true ? 10 : 4,
        ),
        child:
            widget.messageBubbleBuilder?.call(context, message, isMyMessage) ??
                MessageBubble(
                  message: message,
                  showAvatar: true,
                  currentUserId: widget.currentUserId,
                  messageGroupStatus: messageGroupStatus,
                ),
      ),
    );

    if (!isLastMessage && isSameDay) return messageBubble;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLastMessage || !isSameDay)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _formatDate(context, message),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        messageBubble,
      ],
    );
  }

  String _formatDate(BuildContext context, IChatMessageData message) {
    final date = message.createdAt;
    if (date == null) return '';
    return MaterialLocalizations.of(context).formatFullDate(date.toLocal());
  }

  DateTime? _messageTimestamp(IChatMessageData? message) {
    if (message == null) return null;
    return message.createdAt;
  }
}
