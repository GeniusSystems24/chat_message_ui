import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../adapters/chat_message_data.dart';
import '../../theme/chat_theme.dart';

/// Selection action type for callback handling.
enum SelectionAction {
  reply,
  copy,
  forward,
  pin,
  unpin,
  star,
  unstar,
  delete,
  info,
}

/// Widget for chat selection app bar with enhanced functionality
///
/// This widget provides a comprehensive selection app bar for chat screens that includes:
/// - Selected message count display
/// - Action buttons for selected messages (reply, copy, delete, forward, pin, star)
/// - WhatsApp-style design with proper theming
/// - Conditional actions based on selection count
/// - Proper theming and accessibility support
///
/// Example:
/// ```dart
/// ChatSelectionAppBar(
///   selectedCount: selectedMessages.length,
///   selectedMessages: selectedMessages,
///   currentUserId: userId,
///   onClose: () => clearSelection(),
///   onReply: (msg) => replyTo(msg),
///   onCopy: () => copyMessages(),
///   onPin: (msgs) => pinMessages(msgs),
///   onDelete: (msgs) => deleteMessages(msgs),
///   onForward: (msgs) => forwardMessages(msgs),
/// )
/// ```
class ChatSelectionAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  /// Number of selected messages
  final int selectedCount;

  /// Set of selected messages
  final Set<IChatMessageData> selectedMessages;

  /// Current user id
  final String currentUserId;

  /// Callback when close button is pressed
  final VoidCallback onClose;

  /// Callback when reply action is triggered
  final ValueChanged<IChatMessageData>? onReply;

  /// Callback when copy action is triggered
  final VoidCallback? onCopy;

  /// Callback when info action is triggered
  final ValueChanged<IChatMessageData>? onInfo;

  /// Callback when delete action is triggered
  final ValueChanged<Iterable<IChatMessageData>>? onDelete;

  /// Callback when forward action is triggered
  final ValueChanged<Iterable<IChatMessageData>>? onForward;

  /// Callback when pin action is triggered
  final ValueChanged<Iterable<IChatMessageData>>? onPin;

  /// Callback when unpin action is triggered
  final ValueChanged<Iterable<IChatMessageData>>? onUnpin;

  /// Callback when star action is triggered
  final ValueChanged<Iterable<IChatMessageData>>? onStar;

  /// Callback when unstar action is triggered
  final ValueChanged<Iterable<IChatMessageData>>? onUnstar;

  /// Delete time restriction in hours (default: 8 hours)
  final int deleteTimeRestrictionHours;

  /// Custom title builder
  final Widget Function(int count)? titleBuilder;

  /// Whether all selected messages are pinned (to show unpin instead of pin)
  final bool areAllPinned;

  /// Whether all selected messages are starred (to show unstar instead of star)
  final bool areAllStarred;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom icon color
  final Color? iconColor;

  /// Whether to show haptic feedback
  final bool enableHapticFeedback;

  const ChatSelectionAppBar({
    super.key,
    required this.selectedCount,
    required this.selectedMessages,
    required this.currentUserId,
    required this.onClose,
    this.onReply,
    this.onCopy,
    this.onInfo,
    this.onDelete,
    this.onForward,
    this.onPin,
    this.onUnpin,
    this.onStar,
    this.onUnstar,
    this.deleteTimeRestrictionHours = 8,
    this.titleBuilder,
    this.areAllPinned = false,
    this.areAllStarred = false,
    this.backgroundColor,
    this.iconColor,
    this.enableHapticFeedback = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  void _triggerHaptic() {
    if (enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatTheme = ChatThemeData.get(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = backgroundColor ??
        (isDark ? const Color(0xFF1F2C34) : chatTheme.colors.primary);
    final fgColor = iconColor ?? Colors.white;

    return AppBar(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          _triggerHaptic();
          onClose();
        },
        tooltip: 'Close selection',
      ),
      title: titleBuilder?.call(selectedCount) ??
          Text(
            '$selectedCount',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: fgColor,
            ),
          ),
      actions: _buildSelectionActions(context, fgColor),
    );
  }

  /// Build selection action buttons
  List<Widget> _buildSelectionActions(BuildContext context, Color iconColor) {
    final actions = <Widget>[];

    // Star/Unstar button
    if (onStar != null || onUnstar != null) {
      actions.add(
        _ActionButton(
          icon: areAllStarred ? Icons.star : Icons.star_outline,
          tooltip: areAllStarred ? 'Unstar' : 'Star',
          onPressed: () {
            _triggerHaptic();
            if (areAllStarred) {
              onUnstar?.call(selectedMessages);
            } else {
              onStar?.call(selectedMessages);
            }
          },
          iconColor: iconColor,
        ),
      );
    }

    // Reply button (only for single selection)
    if (selectedCount == 1 && onReply != null) {
      actions.add(
        _ActionButton(
          icon: Icons.reply,
          tooltip: 'Reply',
          onPressed: () {
            _triggerHaptic();
            onReply!(selectedMessages.first);
          },
          iconColor: iconColor,
        ),
      );
    }

    // Copy text button
    if (onCopy != null) {
      actions.add(
        _ActionButton(
          icon: Icons.content_copy,
          tooltip: 'Copy',
          onPressed: () {
            _triggerHaptic();
            onCopy!();
          },
          iconColor: iconColor,
        ),
      );
    }

    // Pin/Unpin button
    if (onPin != null || onUnpin != null) {
      actions.add(
        _ActionButton(
          icon: areAllPinned ? Icons.push_pin : Icons.push_pin_outlined,
          tooltip: areAllPinned ? 'Unpin' : 'Pin',
          onPressed: () {
            _triggerHaptic();
            if (areAllPinned) {
              onUnpin?.call(selectedMessages);
            } else {
              onPin?.call(selectedMessages);
            }
          },
          iconColor: iconColor,
        ),
      );
    }

    // Forward button
    if (onForward != null) {
      actions.add(
        _ActionButton(
          icon: Icons.forward,
          tooltip: 'Forward',
          onPressed: () {
            _triggerHaptic();
            onForward!(selectedMessages);
          },
          iconColor: iconColor,
        ),
      );
    }

    // Delete button (with time restriction check)
    if (onDelete != null && _canDeleteMessages()) {
      actions.add(
        Builder(
          builder: (context) => _ActionButton(
            icon: Icons.delete_outline,
            tooltip: 'Delete',
            onPressed: () {
              _triggerHaptic();
              _showDeleteConfirmation(context);
            },
            iconColor: iconColor,
          ),
        ),
      );
    }

    // Info button (only for single selection)
    if (selectedCount == 1 && onInfo != null) {
      actions.add(
        _ActionButton(
          icon: Icons.info_outline,
          tooltip: 'Info',
          onPressed: () {
            _triggerHaptic();
            onInfo!(selectedMessages.first);
          },
          iconColor: iconColor,
        ),
      );
    }

    return actions;
  }

  /// Check if messages can be deleted (time restriction)
  bool _canDeleteMessages() {
    final minDate = DateTime.now().subtract(
      Duration(hours: deleteTimeRestrictionHours),
    );

    return !selectedMessages.any(
      (message) =>
          message.senderId != currentUserId ||
          (message.createdAt ?? DateTime(1970)).isBefore(minDate),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: isDark ? const Color(0xFF1F2C34) : Colors.white,
        title: Text(
          selectedCount == 1 ? 'Delete message?' : 'Delete $selectedCount messages?',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        content: Text(
          'This action cannot be undone.',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: isDark ? Colors.white70 : theme.colorScheme.primary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true);
              onDelete?.call(selectedMessages);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

/// Action button for the selection app bar.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final Color iconColor;

  const _ActionButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: iconColor),
      tooltip: tooltip,
      onPressed: onPressed,
      splashRadius: 20,
    );
  }
}
