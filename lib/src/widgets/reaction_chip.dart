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

/// Compact reaction chip widget displaying all emojis in a single label with total count.
///
/// This widget provides a WhatsApp-style compact reaction display where all
/// reaction emojis are shown together with the total count of reactions.
///
/// Example: "👍❤️😂 5" instead of separate chips for each emoji.
class CompactReactionChip extends StatelessWidget {
  /// Grouped reactions: emoji -> list of user IDs
  final Map<String, List<String>> groupedReactions;

  /// Current user ID to determine if user has reacted
  final String currentUserId;

  /// Callback when tapped (receives null for general tap)
  final VoidCallback? onTap;

  /// Chat theme for styling
  final ChatThemeData chatTheme;

  /// Optional theme override
  final ThemeData? theme;

  const CompactReactionChip({
    super.key,
    required this.groupedReactions,
    required this.currentUserId,
    this.onTap,
    required this.chatTheme,
    this.theme,
  });

  /// Total count of all reactions
  int get totalCount {
    int count = 0;
    for (final users in groupedReactions.values) {
      count += users.length;
    }
    return count;
  }

  /// Check if current user has any reaction
  bool get hasUserReaction {
    for (final users in groupedReactions.values) {
      if (users.contains(currentUserId)) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (groupedReactions.isEmpty) return const SizedBox.shrink();

    final themeData = theme ?? Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;

    // Professional neutral colors (WhatsApp-style)
    final backgroundColor = isDark
        ? Colors.grey.shade800.withValues(alpha: 0.95)
        : Colors.grey.shade100;

    final textColor = isDark ? Colors.grey.shade300 : Colors.grey.shade700;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // All emojis in sequence
            ...groupedReactions.keys.map(
              (emoji) => Text(
                emoji,
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const SizedBox(width: 4),
            // Total count
            Text(
              '$totalCount',
              style: TextStyle(
                fontSize: 12,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
