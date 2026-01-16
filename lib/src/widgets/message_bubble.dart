import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

import '../theme/chat_theme.dart';
import '../adapters/adapters.dart';
import '../config/chat_message_ui_config.dart';
import '../utils/messages_grouping.dart';
import 'message_bubble_layout.dart';
import 'message_content_builder.dart';
import 'message_metadata_builder.dart';
import 'reaction_chip.dart';
import 'reply_bubble_widget.dart';
import 'user_avatar.dart';

/// Widget that displays a message bubble with support for different content types.
///
/// Uses [IChatMessageData] interface to support multiple data sources.
class MessageBubble extends StatelessWidget {
  /// The message to display.
  final IChatMessageData message;

  /// Whether to show the sender's avatar.
  final bool showAvatar;

  /// Callback when the message is long-pressed.
  final VoidCallback? onLongPress;

  /// Callback when a reaction is tapped.
  final Function(String)? onReactionTap;

  /// Available reaction emojis.
  final List<String> availableReactions;

  /// Callback when reply message is tapped.
  final VoidCallback? onReplyTap;

  /// Avatar size.
  final double avatarSize;

  /// Whether to show the message status.
  final bool showStatus;

  /// Whether to show the timestamp.
  final bool showTimestamp;

  /// Custom format for the timestamp.
  final String Function(DateTime)? timeFormatter;

  /// Message group status.
  final MessageGroupStatus? messageGroupStatus;

  /// Current user id for styling and reactions.
  final String currentUserId;

  /// Callback for route taps in text.
  final Function(RouteTextData)? onRouteTap;

  /// Callback for link taps in text.
  final Function(LinkTextData)? onLinkTap;

  /// Callback for attachment taps.
  final VoidCallback? onAttachmentTap;

  /// Callback for poll option selection.
  final Function(String optionId)? onPollVote;

  /// Custom builder for deleted message content.
  final Widget Function(BuildContext context)? deletedMessageBuilder;

  /// Auto-download settings for media attachments.
  final ChatAutoDownloadConfig? autoDownloadConfig;

  /// Current search query to highlight in text content.
  final String? searchQuery;

  /// Whether this message is the current search match.
  final bool isCurrentSearchMatch;

  const MessageBubble({
    super.key,
    required this.message,
    required this.currentUserId,
    this.showAvatar = false,
    this.onLongPress,
    this.onReactionTap,
    this.availableReactions = const ['👍', '❤️', '😂', '😮', '😢', '🙏'],
    this.avatarSize = 15.0,
    this.showStatus = true,
    this.showTimestamp = true,
    this.timeFormatter,
    this.onReplyTap,
    this.messageGroupStatus,
    this.onRouteTap,
    this.onLinkTap,
    this.onAttachmentTap,
    this.onPollVote,
    this.deletedMessageBuilder,
    this.autoDownloadConfig,
    this.searchQuery,
    this.isCurrentSearchMatch = false,
  });

  /// Whether this message was sent by the current user.
  bool get isMyMessage => message.senderId == currentUserId;

  /// Whether this is the first message in a group.
  bool get isFirstInGroup => messageGroupStatus?.isFirst ?? false;

  /// Whether this is the last message in a group.
  bool get isLastInGroup => messageGroupStatus?.isLast ?? false;

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.get(context);

    return MessageBubbleLayout(
      isMyMessage: isMyMessage,
      messageBubble: _buildMessageBubbleWithReactions(context, chatTheme),
      showAvatar: showAvatar,
      userAvatar: _buildUserAvatar(context, chatTheme),
      spacing: chatTheme.spacing,
    );
  }

  /// Builds the message bubble with reactions if present.
  Widget _buildMessageBubbleWithReactions(
    BuildContext context,
    ChatThemeData chatTheme,
  ) {
    final messageBubble = _buildMessageBubble(context, chatTheme);
    final reactionsBar = _buildReactionsBar(context, chatTheme);

    if (reactionsBar == null) return messageBubble;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.only(top: chatTheme.reactions.topOffset),
          child: messageBubble,
        ),
        PositionedDirectional(
          top: 0,
          end: isMyMessage ? -chatTheme.reactions.endOffset : null,
          start: isMyMessage ? null : -chatTheme.reactions.endOffset,
          child: reactionsBar,
        ),
      ],
    );
  }

  /// Builds the main message bubble container.
  Widget _buildMessageBubble(BuildContext context, ChatThemeData chatTheme) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onLongPress: message.isDeleted ? null : onLongPress,
      child: Card(
        color: _getBubbleBackgroundColor(theme, chatTheme),
        shape: _getBubbleShape(chatTheme),
        margin: _getBubbleMargin(chatTheme),
        elevation: chatTheme.messageBubble.showShadow
            ? chatTheme.messageBubble.shadowElevation
            : 0,
        shadowColor: chatTheme.messageBubble.shadowColor,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: size.width * chatTheme.messageBubble.maxWidthFactor,
            minWidth: chatTheme.messageBubble.minBubbleWidth,
          ),
          padding: EdgeInsets.all(chatTheme.messageBubble.bubblePadding),
          child: _buildBubbleContent(context, chatTheme),
        ),
      ),
    );
  }

  /// Builds the content inside the bubble.
  Widget _buildBubbleContent(BuildContext context, ChatThemeData chatTheme) {
    if (message.isDeleted) {
      if (deletedMessageBuilder != null) {
        return deletedMessageBuilder!(context);
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Text(
          'This message was deleted',
          style: chatTheme.typography.bodyMedium.copyWith(
            fontStyle: FontStyle.italic,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
      );
    }

    final reply = message.replyData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (reply != null)
          ReplyBubbleWidget(
            replyMessage: reply,
            isMyMessage: isMyMessage,
            currentUserId: currentUserId,
            onTap: onReplyTap,
          ),
        MessageContentBuilder(
          message: message,
          chatTheme: chatTheme,
          isMyMessage: isMyMessage,
          autoDownloadConfig: autoDownloadConfig,
          searchQuery: searchQuery,
          isCurrentSearchMatch: isCurrentSearchMatch,
          onRouteTap: onRouteTap,
          onLinkTap: onLinkTap,
          onAttachmentTap: onAttachmentTap,
          onPollVote: onPollVote,
        ),
        if (_shouldShowMetadata())
          MessageMetadataBuilder(
            message: message,
            chatTheme: chatTheme,
            isMyMessage: isMyMessage,
            currentUserId: currentUserId,
            showStatus: showStatus,
            showTimestamp: showTimestamp,
            timeFormatter: timeFormatter,
          ),
      ],
    );
  }

  /// Builds the user avatar widget.
  Widget _buildUserAvatar(BuildContext context, ChatThemeData chatTheme) {
    return UserAvatar(
      senderData: message.senderData,
      avatarSize: avatarSize,
    );
  }

  /// Builds the reactions bar if reactions exist.
  Widget? _buildReactionsBar(BuildContext context, ChatThemeData chatTheme) {
    final reactionGroups = message.groupedReactions;
    if (reactionGroups.isEmpty) return null;

    final theme = Theme.of(context);

    return Wrap(
      spacing: chatTheme.reactions.spacing,
      runSpacing: chatTheme.reactions.spacing,
      children: reactionGroups.entries.map((entry) {
        return ReactionChip(
          emoji: entry.key,
          users: entry.value,
          currentUserId: currentUserId,
          onTap: onReactionTap,
          chatTheme: chatTheme,
          theme: theme,
        );
      }).toList(),
    );
  }

  // Helper methods for styling and logic.

  /// Gets the bubble background color based on sender.
  Color _getBubbleBackgroundColor(ThemeData theme, ChatThemeData chatTheme) {
    return isMyMessage
        ? (chatTheme.messageBubble.senderBubbleColor ??
            chatTheme.colors.primary)
        : (chatTheme.messageBubble.receiverBubbleColor ??
            chatTheme.colors.surfaceContainer);
  }

  /// Gets the bubble shape with rounded corners.
  RoundedRectangleBorder _getBubbleShape(ChatThemeData chatTheme) {
    return RoundedRectangleBorder(
      borderRadius: BorderRadiusDirectional.only(
        topStart: Radius.circular(chatTheme.messageBubble.bubbleRadius),
        topEnd: Radius.circular(chatTheme.messageBubble.bubbleRadius),
        bottomStart: !(isMyMessage && isFirstInGroup)
            ? Radius.zero
            : Radius.circular(chatTheme.messageBubble.bubbleRadius),
        bottomEnd: !(!isMyMessage && isFirstInGroup)
            ? Radius.zero
            : Radius.circular(chatTheme.messageBubble.bubbleRadius),
      ),
    );
  }

  /// Gets the bubble margin based on group position.
  EdgeInsets _getBubbleMargin(ChatThemeData chatTheme) {
    if (isFirstInGroup) {
      return EdgeInsets.only(bottom: chatTheme.messageBubble.bubbleMargin);
    } else if (isLastInGroup) {
      return EdgeInsets.only(top: chatTheme.messageBubble.bubbleMargin);
    }
    return EdgeInsets.zero;
  }

  /// Checks if metadata should be shown.
  bool _shouldShowMetadata() {
    return showTimestamp || (showStatus && isMyMessage);
  }
}
