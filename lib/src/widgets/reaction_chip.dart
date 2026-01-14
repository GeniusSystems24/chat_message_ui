import 'package:flutter/material.dart';

import '../theme/chat_theme.dart';

/// Reaction chip widget displaying emoji with count.
class ReactionChip extends StatelessWidget {
  final String emoji;
  final List<String> users;
  final String currentUserId;
  final Function(String)? onTap;
  final ChatThemeData chatTheme;
  final ThemeData? theme;

  const ReactionChip({
    super.key,
    required this.emoji,
    required this.users,
    required this.currentUserId,
    this.onTap,
    required this.chatTheme,
    this.theme,
  });

  bool get isActiveUser => users.contains(currentUserId);

  @override
  Widget build(BuildContext context) {
    final themeData = theme ?? Theme.of(context);
    final reactionsTheme = chatTheme.reactions;

    return GestureDetector(
      onTap: onTap != null ? () => onTap!(emoji) : null,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: reactionsTheme.padding,
          vertical: reactionsTheme.verticalPadding,
        ),
        decoration: BoxDecoration(
          color: isActiveUser
              ? (reactionsTheme.activeBackgroundColor ??
                  themeData.colorScheme.primary.withValues(alpha: 0.2))
              : (reactionsTheme.inactiveBackgroundColor ??
                  themeData.colorScheme.surfaceContainerHighest),
          borderRadius: BorderRadius.circular(reactionsTheme.borderRadius),
          border: isActiveUser
              ? Border.all(
                  color: themeData.colorScheme.primary.withValues(alpha: 0.5),
                )
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              emoji,
              style: TextStyle(fontSize: reactionsTheme.emojiSize),
            ),
            if (users.length > 1) ...[
              const SizedBox(width: 4),
              Text(
                '${users.length}',
                style: TextStyle(
                  fontSize: reactionsTheme.countSize,
                  color: isActiveUser
                      ? (reactionsTheme.activeTextColor ??
                          themeData.colorScheme.primary)
                      : (reactionsTheme.inactiveTextColor ??
                          themeData.colorScheme.onSurface),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
