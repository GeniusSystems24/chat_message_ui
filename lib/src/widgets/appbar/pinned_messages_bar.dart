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
    final countLabel = total > 1 ? '${index + 1}/$total' : 'Pinned';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: chatTheme.colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(
              color: chatTheme.colors.primary,
              width: 3,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.push_pin, size: 18, color: chatTheme.colors.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    senderName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: chatTheme.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    preview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color:
                          chatTheme.colors.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: chatTheme.colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    countLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: chatTheme.colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: chatTheme.colors.primary,
                  ),
                ],
              ),
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
