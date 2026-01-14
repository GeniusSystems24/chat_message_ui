import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../adapters/adapters.dart';
import '../../theme/chat_theme.dart';
import 'file_icon.dart';

/// Widget to display a document attachment in a message bubble.
class DocumentBubble extends StatelessWidget {
  final IChatMessageData message;
  final ChatThemeData chatTheme;
  final bool isMyMessage;
  final VoidCallback? onTap;

  const DocumentBubble({
    super.key,
    required this.message,
    required this.chatTheme,
    required this.isMyMessage,
    this.onTap,
  });

  String? get fileName => message.mediaData?.fileName ?? message.textContent;
  String? get url => message.mediaData?.url;
  int get fileSize => message.mediaData?.fileSize ?? 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => _handleTap(context),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMyMessage
              ? chatTheme.colors.primary.withValues(alpha: 0.1)
              : chatTheme.colors.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: chatTheme.colors.onSurface.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          children: [
            FileIcon(fileName: fileName ?? 'Document'),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    fileName ?? 'Document',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: chatTheme.colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatFileSize(fileSize),
                    style: TextStyle(
                      fontSize: 12,
                      color: chatTheme.colors.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (url != null) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.download_rounded,
                size: 20,
                color: chatTheme.colors.primary,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    if (url != null) {
      final uri = Uri.parse(url!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Could not open document: $url')),
          );
        }
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return '';
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    var i = 0;
    double size = bytes.toDouble();
    while (size > 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(1)} ${suffixes[i]}';
  }
}
