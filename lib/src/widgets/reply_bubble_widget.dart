import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../theme/chat_theme.dart';
import '../adapters/adapters.dart';

/// Widget for displaying reply preview within a message bubble.
class ReplyBubbleWidget extends StatelessWidget {
  final ChatReplyData replyMessage;
  final bool isMyMessage;
  final String currentUserId;
  final VoidCallback? onTap;

  const ReplyBubbleWidget({
    super.key,
    required this.replyMessage,
    required this.isMyMessage,
    required this.currentUserId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.get(context);
    final theme = Theme.of(context);

    final isMyReply = replyMessage.senderId == currentUserId;
    final indicatorColor =
        isMyReply ? chatTheme.colors.primary : theme.colorScheme.secondary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: chatTheme.messageBubble.contentVerticalPadding,
        ),
        padding: EdgeInsets.all(chatTheme.messageBubble.contentPadding),
        decoration: BoxDecoration(
          color:
              theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: indicatorColor,
              width: 3,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    replyMessage.senderName,
                    style: chatTheme.typography.labelMedium.copyWith(
                      color: indicatorColor,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getReplyPreviewText(),
                    style: chatTheme.typography.bodySmall.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (replyMessage.thumbnailUrl != null) ...[
              const SizedBox(width: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: replyMessage.thumbnailUrl!,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    width: 40,
                    height: 40,
                    color: theme.colorScheme.surfaceContainerHigh,
                  ),
                  errorWidget: (context, url, error) => Container(
                    width: 40,
                    height: 40,
                    color: theme.colorScheme.surfaceContainerHigh,
                    child: Icon(
                      _getMediaIcon(),
                      size: 20,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getReplyPreviewText() {
    if (replyMessage.message.isNotEmpty) {
      return replyMessage.message;
    }

    return switch (replyMessage.type) {
      ChatMessageType.image => '📷 Photo',
      ChatMessageType.video => '🎬 Video',
      ChatMessageType.audio => '🎵 Voice message',
      ChatMessageType.document => '📎 File',
      ChatMessageType.location => '📍 Location',
      ChatMessageType.contact => '👤 Contact',
      ChatMessageType.poll => '📊 Poll',
      _ => 'Message',
    };
  }

  IconData _getMediaIcon() {
    return switch (replyMessage.type) {
      ChatMessageType.image => Icons.image,
      ChatMessageType.video => Icons.videocam,
      ChatMessageType.audio => Icons.mic,
      ChatMessageType.document => Icons.insert_drive_file,
      ChatMessageType.location => Icons.location_on,
      ChatMessageType.contact => Icons.person,
      ChatMessageType.poll => Icons.poll,
      _ => Icons.chat_bubble,
    };
  }
}
