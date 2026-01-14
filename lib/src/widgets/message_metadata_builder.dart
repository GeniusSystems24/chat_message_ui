import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/chat_theme.dart';
import '../adapters/adapters.dart';
import 'status_icon.dart';

/// Widget for building message metadata (timestamp, status).
class MessageMetadataBuilder extends StatelessWidget {
  final IChatMessageData message;
  final ChatThemeData chatTheme;
  final bool isMyMessage;
  final String currentUserId;
  final bool showStatus;
  final bool showTimestamp;
  final String Function(DateTime)? timeFormatter;

  const MessageMetadataBuilder({
    super.key,
    required this.message,
    required this.chatTheme,
    required this.isMyMessage,
    required this.currentUserId,
    this.showStatus = true,
    this.showTimestamp = true,
    this.timeFormatter,
  });

  String _formatTime(DateTime dateTime) {
    if (timeFormatter != null) {
      return timeFormatter!(dateTime);
    }
    return DateFormat.Hm().format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final createdAt = message.createdAt;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: chatTheme.messageBubble.contentPadding,
        vertical: 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (message.isEdited)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Text(
                'edited',
                style: chatTheme.typography.labelSmall.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          if (showTimestamp && createdAt != null)
            Text(
              _formatTime(createdAt),
              style: chatTheme.typography.labelSmall.copyWith(
                color: theme.colorScheme.onSurface.withValues(
                  alpha: chatTheme.status.opacityDimmed,
                ),
              ),
            ),
          if (showStatus && isMyMessage) ...[
            SizedBox(width: chatTheme.status.spacing),
            StatusIcon(
              status: message.status,
              chatTheme: chatTheme,
              primaryColor: chatTheme.colors.primary,
            ),
          ],
        ],
      ),
    );
  }
}
