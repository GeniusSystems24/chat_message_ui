import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tooltip_card/tooltip_card.dart';

import '../context_menu/message_context_menu.dart';
import '../reactions/message_reaction_bar.dart';

/// A focused message overlay that displays a message with modal barrier,
/// reaction bar, and action buttons.
///
/// This widget uses [TooltipCard] with a modal barrier pattern to highlight
/// a specific message and allow the user to interact with it through
/// reactions and context actions.
///
/// Example:
/// ```dart
/// FocusedMessageOverlay.show(
///   context,
///   messageBuilder: (context) => MessageBubble(message: message),
///   reactions: ['❤️', '😂', '😮', '😢', '🙏', '👍'],
///   actions: [
///     MessageActionConfig.reply,
///     MessageActionConfig.copy,
///     MessageActionConfig.forward,
///   ],
///   onReactionSelected: (emoji) => handleReaction(emoji),
///   onActionSelected: (action) => handleAction(action),
/// );
/// ```
class FocusedMessageOverlay extends StatefulWidget {
  /// The widget builder for the message to display.
  final Widget Function(BuildContext context) messageBuilder;

  /// Available reactions to show.
  final List<String> reactions;

  /// Available actions to show.
  final List<MessageActionConfig> actions;

  /// Whether to show the reaction bar.
  final bool showReactions;

  /// Whether to show action labels in vertical layout.
  final bool showActionLabels;

  /// Callback when a reaction is selected.
  final void Function(String emoji)? onReactionSelected;

  /// Callback when an action is selected.
  final void Function(MessageAction action)? onActionSelected;

  /// Callback when the overlay is dismissed.
  final VoidCallback? onDismiss;

  /// Whether the message is from the current user.
  final bool isMyMessage;

  /// Background barrier color.
  final Color? barrierColor;

  /// Animation duration for showing/hiding.
  final Duration animationDuration;

  const FocusedMessageOverlay({
    super.key,
    required this.messageBuilder,
    this.reactions = const ['❤️', '😂', '😮', '😢', '🙏', '👍'],
    this.actions = const [],
    this.showReactions = true,
    this.showActionLabels = true,
    this.onReactionSelected,
    this.onActionSelected,
    this.onDismiss,
    this.isMyMessage = false,
    this.barrierColor,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  /// Shows the focused message overlay as a dialog.
  static Future<MessageContextMenuResult?> show(
    BuildContext context, {
    required Widget Function(BuildContext context) messageBuilder,
    List<String> reactions = const ['❤️', '😂', '😮', '😢', '🙏', '👍'],
    List<MessageActionConfig> actions = const [],
    bool showReactions = true,
    bool showActionLabels = true,
    bool isMyMessage = false,
    Color? barrierColor,
    Duration animationDuration = const Duration(milliseconds: 250),
  }) async {
    // Add haptic feedback
    HapticFeedback.mediumImpact();

    MessageContextMenuResult? result;

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: barrierColor ?? Colors.black.withValues(alpha: 0.6),
      transitionDuration: animationDuration,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return FocusedMessageOverlay(
          messageBuilder: messageBuilder,
          reactions: reactions,
          actions: actions,
          showReactions: showReactions,
          showActionLabels: showActionLabels,
          isMyMessage: isMyMessage,
          animationDuration: animationDuration,
          onReactionSelected: (emoji) {
            result = MessageContextMenuResult(reaction: emoji);
            Navigator.of(dialogContext).pop();
          },
          onActionSelected: (action) {
            result = MessageContextMenuResult(action: action);
            Navigator.of(dialogContext).pop();
          },
          onDismiss: () => Navigator.of(dialogContext).pop(),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );

    return result;
  }

  @override
  State<FocusedMessageOverlay> createState() => _FocusedMessageOverlayState();
}

class _FocusedMessageOverlayState extends State<FocusedMessageOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<double>(begin: 10.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
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
    widget.onReactionSelected?.call(emoji);
  }

  void _handleAction(MessageAction action) {
    HapticFeedback.lightImpact();
    widget.onActionSelected?.call(action);
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
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: widget.onDismiss,
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              );
            },
            child: GestureDetector(
              onTap: () {}, // Prevent tap from propagating
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.9,
                  maxHeight: size.height * 0.8,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: widget.isMyMessage
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    // Reaction bar at the top
                    if (widget.showReactions && widget.reactions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildReactionBar(isDark),
                      ),

                    // The message
                    _buildMessage(isDark),

                    // Actions below the message
                    if (widget.actions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _buildActionsMenu(isDark),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReactionBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2C34) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: MessageReactionBar(
        reactions: widget.reactions,
        onReactionSelected: _handleReaction,
        onMorePressed: _handleMoreReactions,
        showMoreButton: true,
      ),
    );
  }

  Widget _buildMessage(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: widget.messageBuilder(context),
      ),
    );
  }

  Widget _buildActionsMenu(bool isDark) {
    if (widget.showActionLabels) {
      return _buildVerticalActions(isDark);
    } else {
      return _buildHorizontalActions(isDark);
    }
  }

  Widget _buildVerticalActions(bool isDark) {
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
          ...widget.actions.asMap().entries.map((entry) {
            final index = entry.key;
            final config = entry.value;
            final isLast = index == widget.actions.length - 1;
            return _VerticalActionItem(
              config: config,
              onTap: () => _handleAction(config.action),
              isDark: isDark,
              showDivider: !isLast,
            );
          }),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildHorizontalActions(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2C34) : Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.actions.map((config) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _HorizontalActionItem(
              config: config,
              onTap: () => _handleAction(config.action),
              isDark: isDark,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Vertical action item widget.
class _VerticalActionItem extends StatelessWidget {
  final MessageActionConfig config;
  final VoidCallback onTap;
  final bool isDark;
  final bool showDivider;

  const _VerticalActionItem({
    required this.config,
    required this.onTap,
    required this.isDark,
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

/// Horizontal action item widget.
class _HorizontalActionItem extends StatelessWidget {
  final MessageActionConfig config;
  final VoidCallback onTap;
  final bool isDark;

  const _HorizontalActionItem({
    required this.config,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = config.isDestructive
        ? Colors.red
        : (isDark ? Colors.white70 : Colors.black54);

    return InkWell(
      onTap: config.isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(22),
      child: Tooltip(
        message: config.label,
        child: Opacity(
          opacity: config.isEnabled ? 1.0 : 0.5,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: Icon(
              config.icon,
              size: 22,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}

/// Inline focused overlay using TooltipCard pattern.
///
/// This widget wraps a message and provides focused overlay functionality
/// when triggered via the controller.
class InlineFocusedOverlay extends StatefulWidget {
  /// The child widget (message) to wrap.
  final Widget child;

  /// Controller to manage the overlay state.
  final TooltipCardController controller;

  /// Available reactions to show.
  final List<String> reactions;

  /// Available actions to show.
  final List<MessageActionConfig> actions;

  /// Whether to show the reaction bar.
  final bool showReactions;

  /// Whether to show action labels.
  final bool showActionLabels;

  /// Callback when a reaction is selected.
  final void Function(String emoji)? onReactionSelected;

  /// Callback when an action is selected.
  final void Function(MessageAction action)? onActionSelected;

  /// Whether the message is from the current user.
  final bool isMyMessage;

  const InlineFocusedOverlay({
    super.key,
    required this.child,
    required this.controller,
    this.reactions = const ['❤️', '😂', '😮', '😢', '🙏', '👍'],
    this.actions = const [],
    this.showReactions = true,
    this.showActionLabels = false,
    this.onReactionSelected,
    this.onActionSelected,
    this.isMyMessage = false,
  });

  @override
  State<InlineFocusedOverlay> createState() => _InlineFocusedOverlayState();
}

class _InlineFocusedOverlayState extends State<InlineFocusedOverlay> {
  void _handleReaction(String emoji) {
    HapticFeedback.lightImpact();
    widget.controller.dismiss();
    widget.onReactionSelected?.call(emoji);
  }

  void _handleAction(MessageAction action) {
    HapticFeedback.lightImpact();
    widget.controller.dismiss();
    widget.onActionSelected?.call(action);
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
    final isDark = theme.brightness == Brightness.dark;

    return TooltipCard.builder(
      controller: widget.controller,
      useRootOverlay: true,
      fitToViewport: true,
      autoFlipIfZeroSpace: true,
      wrapContentInScrollView: false,
      whenContentVisible: WhenContentVisible.pressButton,
      whenContentHide: WhenContentHide.pressOutSide,
      dismissOnPointerMoveAway: false,
      placementSide: TooltipCardPlacementSide.top,
      beakEnabled: false,
      awaySpace: 8,
      elevation: 8,
      borderRadius: BorderRadius.circular(28),
      flyoutBackgroundColor: isDark ? const Color(0xFF1F2C34) : Colors.white,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(maxWidth: 360),
      child: widget.child,
      builder: (context, close) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: widget.isMyMessage
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            // Reaction bar
            if (widget.showReactions && widget.reactions.isNotEmpty)
              MessageReactionBar(
                reactions: widget.reactions,
                onReactionSelected: _handleReaction,
                onMorePressed: _handleMoreReactions,
                showMoreButton: true,
              ),

            // Actions
            if (widget.actions.isNotEmpty) ...[
              if (widget.showReactions && widget.reactions.isNotEmpty)
                const SizedBox(height: 8),
              _buildActions(isDark),
            ],
          ],
        );
      },
    );
  }

  Widget _buildActions(bool isDark) {
    if (widget.showActionLabels) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.actions.map((config) {
          return _InlineActionItem(
            config: config,
            onTap: () => _handleAction(config.action),
            isDark: isDark,
          );
        }).toList(),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: widget.actions.map((config) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _HorizontalActionItem(
              config: config,
              onTap: () => _handleAction(config.action),
              isDark: isDark,
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Inline action item for the tooltip overlay.
class _InlineActionItem extends StatelessWidget {
  final MessageActionConfig config;
  final VoidCallback onTap;
  final bool isDark;

  const _InlineActionItem({
    required this.config,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = config.isDestructive
        ? Colors.red
        : (isDark ? Colors.white : Colors.black87);

    final iconColor = config.isDestructive
        ? Colors.red
        : (isDark ? Colors.white70 : Colors.black54);

    return InkWell(
      onTap: config.isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(8),
      child: Opacity(
        opacity: config.isEnabled ? 1.0 : 0.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                config.icon,
                size: 20,
                color: iconColor,
              ),
              const SizedBox(width: 12),
              Text(
                config.label,
                style: TextStyle(
                  fontSize: 14,
                  color: textColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
