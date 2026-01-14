import 'package:flutter/material.dart';

/// A widget displayed when the chat is empty.
class ChatEmptyDisplay extends StatelessWidget {
  /// Custom empty state widget.
  final Widget? child;

  /// Empty state message.
  final String message;

  /// Empty state icon.
  final IconData icon;

  const ChatEmptyDisplay({
    super.key,
    this.child,
    this.message = 'No messages yet',
    this.icon = Icons.chat_bubble_outline,
  });

  @override
  Widget build(BuildContext context) {
    if (child != null) return child!;

    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
