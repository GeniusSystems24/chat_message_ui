import 'package:flutter/material.dart';

import '../../adapters/adapters.dart';
import '../../theme/chat_theme.dart';

/// Preview widget shown above input field when editing a message.
///
/// Similar to [ReplyPreviewWidget] but specifically for edit mode.
/// Shows the original message with an edit icon and cancel button.
///
/// Example:
/// ```dart
/// EditMessagePreview(
///   message: messageToEdit,
///   onCancel: () => setState(() => editingMessage = null),
/// )
/// ```
class EditMessagePreview extends StatelessWidget {
  /// The message being edited.
  final IChatMessageData message;

  /// Callback when cancel button is pressed.
  final VoidCallback onCancel;

  /// Custom background color.
  final Color? backgroundColor;

  /// Custom border color (left accent).
  final Color? borderColor;

  /// Custom icon color.
  final Color? iconColor;

  const EditMessagePreview({
    super.key,
    required this.message,
    required this.onCancel,
    this.backgroundColor,
    this.borderColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatTheme = ChatThemeData.get(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = backgroundColor ??
        (isDark
            ? const Color(0xFF1F2C34)
            : theme.colorScheme.surfaceContainerHighest);
    final accentColor = borderColor ?? chatTheme.colors.primary;
    final fgColor = iconColor ?? accentColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          left: BorderSide(color: accentColor, width: 4),
        ),
      ),
      child: Row(
        children: [
          // Edit icon
          Icon(Icons.edit, size: 20, color: fgColor),
          const SizedBox(width: 8),

          // Message content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // "Edit message" label
                Text(
                  'Edit message',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: fgColor,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),

                // Original message preview
                Text(
                  _getMessagePreview(),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? Colors.white70
                        : theme.colorScheme.onSurfaceVariant,
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
              color: isDark
                  ? Colors.white54
                  : theme.colorScheme.onSurfaceVariant,
            ),
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            padding: EdgeInsets.zero,
            tooltip: 'Cancel editing',
          ),
        ],
      ),
    );
  }

  String _getMessagePreview() {
    switch (message.type) {
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
        return message.message ?? '';
    }
  }
}

/// Data class for edit message state.
class EditMessageData {
  /// The message being edited.
  final IChatMessageData message;

  /// The current edited text.
  final String currentText;

  const EditMessageData({
    required this.message,
    required this.currentText,
  });

  /// Whether the text has been modified.
  bool get isModified => currentText != (message.message ?? '');

  /// Whether the edit is valid (not empty and modified).
  bool get isValid => currentText.trim().isNotEmpty && isModified;

  /// Creates a copy with updated text.
  EditMessageData copyWith({String? currentText}) {
    return EditMessageData(
      message: message,
      currentText: currentText ?? this.currentText,
    );
  }
}
