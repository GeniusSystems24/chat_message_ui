import 'package:flutter/material.dart';
import 'package:smart_pagination/pagination.dart';

import '../adapters/chat_message_data.dart';
import '../utils/messages_grouping.dart';
import '../utils/message_utils.dart';
import 'message_bubble.dart';
import 'chat_date_separator.dart';
import 'chat_initial_loader.dart';
import 'chat_empty_display.dart';

/// A paginated list widget for displaying chat messages.
///
/// Uses [SmartPaginationCubit] from the smart_pagination library
/// for efficient pagination and state management.
class ChatMessageList extends StatelessWidget {
  /// The pagination cubit containing the messages.
  final SmartPaginationCubit<IChatMessageData> cubit;

  /// Scroll controller for the list.
  final ScrollController scrollController;

  /// Current user ID to determine message ownership.
  final String currentUserId;

  /// Callback for pull-to-refresh.
  final Future<void> Function() onRefresh;

  /// Whether to show avatar for messages.
  final bool showAvatar;

  /// Set of selected messages (for multi-select mode).
  final Set<IChatMessageData> selectedMessages;

  /// Callback when a message is long-pressed.
  final ValueChanged<IChatMessageData>? onMessageLongPress;

  /// Callback when the reply bubble is tapped.
  final ValueChanged<IChatMessageData>? onReplyTap;

  /// Callback when a reaction is tapped.
  final Function(IChatMessageData, String)? onReactionTap;

  /// ID of the message to focus/highlight.
  final String? focusedMessageId;

  /// Callback when selection changes.
  final VoidCallback? onSelectionChanged;

  /// Custom message bubble builder.
  final Widget Function(BuildContext context, IChatMessageData message,
      MessageGroupStatus? groupStatus)? messageBubbleBuilder;

  /// Custom date separator builder.
  final Widget Function(BuildContext context, DateTime date)?
      dateSeparatorBuilder;

  /// Custom initial loading builder.
  final Widget Function(BuildContext context)? initialLoadingBuilder;

  /// Custom empty state builder.
  final Widget Function(BuildContext context)? emptyBuilder;

  /// Custom load more loading builder.
  final Widget Function(BuildContext context)? loadMoreBuilder;

  /// Padding for the list.
  final EdgeInsets padding;

  /// Available reaction emojis.
  final List<String> availableReactions;

  const ChatMessageList({
    super.key,
    required this.cubit,
    required this.scrollController,
    required this.currentUserId,
    required this.onRefresh,
    this.selectedMessages = const {},
    this.showAvatar = true,
    this.onMessageLongPress,
    this.onReplyTap,
    this.onReactionTap,
    this.focusedMessageId,
    this.onSelectionChanged,
    this.messageBubbleBuilder,
    this.dateSeparatorBuilder,
    this.initialLoadingBuilder,
    this.emptyBuilder,
    this.loadMoreBuilder,
    this.padding = const EdgeInsets.all(12),
    this.availableReactions = const ['👍', '❤️', '😂', '😮', '😢', '😡'],
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: SmartPagination<IChatMessageData>.listViewWithCubit(
        cubit: cubit,
        scrollController: scrollController,
        reverse: true,
        padding: padding,
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, messages, index) =>
            _buildMessageItem(context, messages, index),
        firstPageLoadingBuilder: (context) =>
            initialLoadingBuilder?.call(context) ?? const ChatInitialLoader(),
        firstPageEmptyBuilder: (context) =>
            emptyBuilder?.call(context) ?? const ChatEmptyDisplay(),
        loadMoreLoadingBuilder: (context) =>
            loadMoreBuilder?.call(context) ?? _buildLoadingIndicator(context),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildMessageItem(
    BuildContext context,
    List<IChatMessageData> messages,
    int index,
  ) {
    final message = messages[index];
    final groupStatus = MessageGroupStatus.resolveGroupStatus(
      items: messages,
      index: index,
    );

    final messageDate = message.createdAt;
    final nextMessage =
        index < messages.length - 1 ? messages[index + 1] : null;
    final nextDate = nextMessage?.createdAt;

    final showDateSeparator = messageDate != null &&
        (nextDate == null || !_isSameDay(messageDate, nextDate));

    final bubble = Padding(
      padding: EdgeInsets.only(top: groupStatus?.isFirst == true ? 10 : 4),
      child: messageBubbleBuilder?.call(context, message, groupStatus) ??
          MessageBubble(
            message: message,
            showAvatar: showAvatar,
            currentUserId: currentUserId,
            messageGroupStatus: groupStatus,
            onLongPress: onMessageLongPress != null
                ? () => onMessageLongPress!(message)
                : null,
            onReactionTap: onReactionTap != null
                ? (emoji) => onReactionTap!(message, emoji)
                : null,
            onReplyTap: onReplyTap != null ? () => onReplyTap!(message) : null,
          ),
    );

    final content = showDateSeparator
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              dateSeparatorBuilder?.call(context, messageDate) ??
                  ChatDateSeparator(date: messageDate),
              bubble,
            ],
          )
        : bubble;

    if (selectedMessages.isEmpty) {
      return _buildFocusableMessage(context, message, content);
    }

    return _buildSelectionModeMessage(context, message, content);
  }

  Widget _buildFocusableMessage(
    BuildContext context,
    IChatMessageData message,
    Widget child,
  ) {
    final theme = Theme.of(context);
    final isFocused =
        focusedMessageId != null && focusedMessageId == message.id;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutQuint,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(
          alpha: isFocused ? 0.25 : 0,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildSelectionModeMessage(
    BuildContext context,
    IChatMessageData message,
    Widget bubble,
  ) {
    final theme = Theme.of(context);
    final isSelected = selectedMessages.contains(message);
    final isOne = selectedMessages.length == 1;

    final child = InkWell(
      onTap: () {
        if (isSelected) {
          selectedMessages.remove(message);
        } else {
          selectedMessages.add(message);
        }
        onSelectionChanged?.call();
      },
      child: Container(
        width: double.infinity,
        color: isSelected
            ? theme.colorScheme.primary.withValues(alpha: 0.2)
            : null,
        child: IgnorePointer(ignoring: true, child: bubble),
      ),
    );

    if (isSelected && isOne) {
      return _buildMessageWithReactions(context, message, child);
    }

    return child;
  }

  Widget _buildMessageWithReactions(
    BuildContext context,
    IChatMessageData message,
    Widget child,
  ) {
    final isMe = message.senderId == currentUserId;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        PositionedDirectional(
          end: isMe ? 20 : null,
          child: _buildReactionOverlay(context, message),
        ),
      ],
    );
  }

  Widget _buildReactionOverlay(BuildContext context, IChatMessageData message) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: availableReactions
            .map((emoji) => _buildReactionButton(theme, message, emoji))
            .toList(),
      ),
    );
  }

  Widget _buildReactionButton(
    ThemeData theme,
    IChatMessageData message,
    String emoji,
  ) {
    final reactions = message.reactions;
    final grouped = groupReactions(reactions);
    final hasReacted = grouped[emoji]?.contains(currentUserId) ?? false;

    return InkWell(
      onTap: () => onReactionTap?.call(message, emoji),
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: hasReacted
              ? theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.2)
              : null,
          shape: BoxShape.circle,
        ),
        child: Text(emoji, style: const TextStyle(fontSize: 20)),
      ),
    );
  }

  bool _isSameDay(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}
