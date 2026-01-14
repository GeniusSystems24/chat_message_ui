import 'package:flutter/material.dart';

import '../../adapters/adapters.dart';

/// Compact reply preview displayed above the input field.
///
/// Uses [ChatReplyData] from adapters layer.
class ReplyPreviewWidget extends StatelessWidget {
  final ChatReplyData replyMessage;
  final VoidCallback onCancel;
  final Color? backgroundColor;
  final Color? borderColor;

  const ReplyPreviewWidget({
    super.key,
    required this.replyMessage,
    required this.onCancel,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: borderColor ?? colorScheme.primary, width: 4),
        ),
      ),
      child: Row(
        children: [
          // Reply icon
          Icon(Icons.reply, size: 20, color: colorScheme.primary),
          const SizedBox(width: 8),

          // Reply content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Sender name
                Text(
                  replyMessage.senderName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),

                // Message preview
                Text(
                  _getMessagePreview(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Cancel button
          IconButton(
            onPressed: onCancel,
            icon: Icon(
              Icons.close,
              size: 20,
              color: colorScheme.onSurfaceVariant,
            ),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  String _getMessagePreview() {
    switch (replyMessage.type) {
      case ChatMessageType.image:
        return 'Photo';
      case ChatMessageType.video:
        return 'Video';
      case ChatMessageType.audio:
        return 'Voice message';
      case ChatMessageType.document:
        return 'File';
      case ChatMessageType.location:
        return 'Location';
      case ChatMessageType.contact:
        return 'Contact';
      case ChatMessageType.poll:
        return 'Poll';
      default:
        return replyMessage.message;
    }
  }
}
