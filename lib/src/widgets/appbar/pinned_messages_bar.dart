import 'package:flutter/material.dart';

import '../../adapters/chat_message_data.dart';
import '../../theme/chat_theme.dart';

/// WhatsApp-style pinned messages bar.
class PinnedMessagesBar extends StatelessWidget {
  final IChatMessageData message;
  final int index;
  final int total;
  final VoidCallback onTap;

  const PinnedMessagesBar({
    super.key,
    required this.message,
    required this.index,
    required this.total,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.get(context);
    final theme = Theme.of(context);
    final senderName = message.senderData?.displayName ?? message.senderId;
    final preview = _resolvePreview(message);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: chatTheme.colors.surfaceContainerHigh,
          border: Border(
            bottom: BorderSide(
              color: chatTheme.colors.onSurface.withValues(alpha: 0.15),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.push_pin,
              size: 16,
              color: chatTheme.colors.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '$senderName: ',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: chatTheme.colors.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    TextSpan(
                      text: preview,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color:
                            chatTheme.colors.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            if (total > 1)
              Text(
                '${index + 1}/$total',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: chatTheme.colors.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            Icon(
              Icons.keyboard_arrow_up,
              size: 20,
              color: chatTheme.colors.onSurface.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  String _resolvePreview(IChatMessageData message) {
    final text = message.textContent?.trim();
    if (text != null && text.isNotEmpty) return text;
    final fileName = message.mediaData?.resolvedFileName;
    if (fileName != null && fileName.isNotEmpty) return fileName;
    return message.type.name;
  }
}
