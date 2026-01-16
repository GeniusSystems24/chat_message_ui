import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/chat_theme.dart';
import '../reactions/message_reaction_bar.dart';

/// Action types available in the context menu.
enum MessageAction {
  reply,
  copy,
  forward,
  pin,
  unpin,
  edit,
  delete,
  info,
  star,
  unstar,
}

/// Configuration for a single menu action.
class MessageActionConfig {
  /// The action type.
  final MessageAction action;

  /// The display label.
  final String label;

  /// The icon to display.
  final IconData icon;

  /// Whether this action is destructive (shown in red).
  final bool isDestructive;

  /// Whether this action is enabled.
  final bool isEnabled;

  const MessageActionConfig({
    required this.action,
    required this.label,
    required this.icon,
    this.isDestructive = false,
    this.isEnabled = true,
  });

  /// Default configurations for common actions.
  static const reply = MessageActionConfig(
    action: MessageAction.reply,
    label: 'Reply',
    icon: Icons.reply,
  );

  static const copy = MessageActionConfig(
    action: MessageAction.copy,
    label: 'Copy',
    icon: Icons.content_copy,
  );

  static const forward = MessageActionConfig(
    action: MessageAction.forward,
    label: 'Forward',
    icon: Icons.forward,
  );

  static const pin = MessageActionConfig(
    action: MessageAction.pin,
    label: 'Pin',
    icon: Icons.push_pin_outlined,
  );

  static const unpin = MessageActionConfig(
    action: MessageAction.unpin,
    label: 'Unpin',
    icon: Icons.push_pin,
  );

  static const edit = MessageActionConfig(
    action: MessageAction.edit,
    label: 'Edit',
    icon: Icons.edit_outlined,
  );

  static const delete = MessageActionConfig(
    action: MessageAction.delete,
    label: 'Delete',
    icon: Icons.delete_outline,
    isDestructive: true,
  );

  static const info = MessageActionConfig(
    action: MessageAction.info,
    label: 'Info',
    icon: Icons.info_outline,
  );

  static const star = MessageActionConfig(
    action: MessageAction.star,
    label: 'Star',
    icon: Icons.star_outline,
  );

  static const unstar = MessageActionConfig(
    action: MessageAction.unstar,
    label: 'Unstar',
    icon: Icons.star,
  );
}

/// Result of showing the context menu.
class MessageContextMenuResult {
  /// The selected action (if any).
  final MessageAction? action;

  /// The selected reaction emoji (if any).
  final String? reaction;

  const MessageContextMenuResult({
    this.action,
    this.reaction,
  });

  bool get hasAction => action != null;
  bool get hasReaction => reaction != null;
}

/// WhatsApp-style context menu for messages.
///
/// This widget shows a reaction bar at the top and action buttons below.
/// It supports customization of available actions and reactions.
///
/// Example:
/// ```dart
/// final result = await MessageContextMenu.show(
///   context,
///   position: tapPosition,
///   actions: [
///     MessageActionConfig.reply,
///     MessageActionConfig.copy,
///     MessageActionConfig.forward,
///     MessageActionConfig.pin,
///     MessageActionConfig.delete,
///   ],
///   reactions: ['❤️', '😂', '😮', '😢', '🙏', '👍'],
/// );
///
/// if (result.hasReaction) {
///   handleReaction(result.reaction!);
/// } else if (result.hasAction) {
///   handleAction(result.action!);
/// }
/// ```
class MessageContextMenu extends StatefulWidget {
  /// Position to show the menu at.
  final Offset position;

  /// Available actions to show.
  final List<MessageActionConfig> actions;

  /// Available reactions to show.
  final List<String> reactions;

  /// Whether to show the reaction bar.
  final bool showReactions;

  /// Whether to show action labels.
  final bool showActionLabels;

  /// Callback when an action is selected.
  final void Function(MessageContextMenuResult result)? onResult;

  const MessageContextMenu({
    super.key,
    required this.position,
    this.actions = const [],
    this.reactions = const ['❤️', '😂', '😮', '😢', '🙏', '👍'],
    this.showReactions = true,
    this.showActionLabels = true,
    this.onResult,
  });

  /// Shows the context menu as an overlay.
  static Future<MessageContextMenuResult?> show(
    BuildContext context, {
    required Offset position,
    List<MessageActionConfig> actions = const [],
    List<String> reactions = const ['❤️', '😂', '😮', '😢', '🙏', '👍'],
    bool showReactions = true,
    bool showActionLabels = true,
  }) async {
    // Add haptic feedback
    HapticFeedback.mediumImpact();

    return showGeneralDialog<MessageContextMenuResult>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withValues(alpha: 0.3),
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) {
        return MessageContextMenu(
          position: position,
          actions: actions,
          reactions: reactions,
          showReactions: showReactions,
          showActionLabels: showActionLabels,
          onResult: (result) => Navigator.of(context).pop(result),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  State<MessageContextMenu> createState() => _MessageContextMenuState();
}

class _MessageContextMenuState extends State<MessageContextMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleReaction(String emoji) {
    HapticFeedback.lightImpact();
    widget.onResult?.call(MessageContextMenuResult(reaction: emoji));
  }

  void _handleAction(MessageAction action) {
    HapticFeedback.lightImpact();
    widget.onResult?.call(MessageContextMenuResult(action: action));
  }

  void _handleMoreReactions() async {
    final emoji = await ReactionEmojiPicker.show(context);
    if (emoji != null) {
      _handleReaction(emoji);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatTheme = ChatThemeData.get(context);
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    // Calculate menu position
    final menuWidth = widget.showActionLabels ? 200.0 : 280.0;
    final menuHeight = _calculateMenuHeight();

    // Adjust position to keep menu on screen
    double left = widget.position.dx - (menuWidth / 2);
    double top = widget.position.dy - menuHeight - 20;

    // Keep within screen bounds
    if (left < 16) left = 16;
    if (left + menuWidth > size.width - 16) left = size.width - menuWidth - 16;
    if (top < 60) top = widget.position.dy + 20;

    return Stack(
      children: [
        // Dismiss area
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.transparent),
          ),
        ),

        // Menu
        Positioned(
          left: left,
          top: top,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: child,
                ),
              );
            },
            child: Material(
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Reaction bar
                  if (widget.showReactions && widget.reactions.isNotEmpty)
                    MessageReactionBar(
                      reactions: widget.reactions,
                      onReactionSelected: _handleReaction,
                      onMorePressed: _handleMoreReactions,
                      showMoreButton: true,
                    ),

                  if (widget.showReactions && widget.actions.isNotEmpty)
                    const SizedBox(height: 8),

                  // Actions
                  if (widget.actions.isNotEmpty)
                    _buildActionsMenu(context, isDark, chatTheme),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _calculateMenuHeight() {
    double height = 0;
    if (widget.showReactions && widget.reactions.isNotEmpty) {
      height += 52; // Reaction bar height
    }
    if (widget.showReactions && widget.actions.isNotEmpty) {
      height += 8; // Spacing
    }
    if (widget.actions.isNotEmpty) {
      if (widget.showActionLabels) {
        height += widget.actions.length * 48 + 16; // Vertical list
      } else {
        height += 60; // Horizontal row
      }
    }
    return height;
  }

  Widget _buildActionsMenu(
    BuildContext context,
    bool isDark,
    ChatThemeData chatTheme,
  ) {
    if (widget.showActionLabels) {
      return _buildVerticalActions(isDark, chatTheme);
    } else {
      return _buildHorizontalActions(isDark, chatTheme);
    }
  }

  Widget _buildVerticalActions(bool isDark, ChatThemeData chatTheme) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2C34) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          ...widget.actions.map((config) {
            final isLast = config == widget.actions.last;
            return _VerticalActionItem(
              config: config,
              onTap: () => _handleAction(config.action),
              isDark: isDark,
              chatTheme: chatTheme,
              showDivider: !isLast,
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildHorizontalActions(bool isDark, ChatThemeData chatTheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2C34) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.actions.map((config) {
          return _HorizontalActionItem(
            config: config,
            onTap: () => _handleAction(config.action),
            isDark: isDark,
            chatTheme: chatTheme,
          );
        }).toList(),
      ),
    );
  }
}

/// Vertical action item for the context menu.
class _VerticalActionItem extends StatelessWidget {
  final MessageActionConfig config;
  final VoidCallback onTap;
  final bool isDark;
  final ChatThemeData chatTheme;
  final bool showDivider;

  const _VerticalActionItem({
    required this.config,
    required this.onTap,
    required this.isDark,
    required this.chatTheme,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = config.isDestructive
        ? Colors.red
        : (isDark ? Colors.white : Colors.black87);

    final iconColor = config.isDestructive
        ? Colors.red
        : (isDark ? Colors.white70 : Colors.black54);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: config.isEnabled ? onTap : null,
          borderRadius: BorderRadius.circular(8),
          child: Opacity(
            opacity: config.isEnabled ? 1.0 : 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Icon(
                    config.icon,
                    size: 22,
                    color: iconColor,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      config.label,
                      style: TextStyle(
                        fontSize: 15,
                        color: textColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
            color: isDark
                ? Colors.white.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: 0.08),
          ),
      ],
    );
  }
}

/// Horizontal action item for the context menu.
class _HorizontalActionItem extends StatelessWidget {
  final MessageActionConfig config;
  final VoidCallback onTap;
  final bool isDark;
  final ChatThemeData chatTheme;

  const _HorizontalActionItem({
    required this.config,
    required this.onTap,
    required this.isDark,
    required this.chatTheme,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = config.isDestructive
        ? Colors.red
        : (isDark ? Colors.white70 : Colors.black54);

    return InkWell(
      onTap: config.isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Opacity(
        opacity: config.isEnabled ? 1.0 : 0.5,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            config.icon,
            size: 24,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
