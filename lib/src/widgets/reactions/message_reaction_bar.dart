import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/chat_theme.dart';

/// WhatsApp-style horizontal reaction bar that appears above a message.
///
/// This widget displays a row of emoji reactions that users can tap to add
/// a reaction to a message. It includes haptic feedback and smooth animations.
///
/// Example:
/// ```dart
/// MessageReactionBar(
///   reactions: ['❤️', '😂', '😮', '😢', '🙏', '👍'],
///   onReactionSelected: (emoji) => handleReaction(emoji),
///   onMorePressed: () => showAllReactions(),
/// )
/// ```
class MessageReactionBar extends StatefulWidget {
  /// List of emoji reactions to display.
  final List<String> reactions;

  /// Callback when a reaction is selected.
  final void Function(String emoji)? onReactionSelected;

  /// Callback when the "more" button is pressed.
  final VoidCallback? onMorePressed;

  /// Whether to show the "more" button.
  final bool showMoreButton;

  /// The currently selected reaction (if any).
  final String? selectedReaction;

  /// Animation duration for appearing.
  final Duration animationDuration;

  /// Whether to enable haptic feedback.
  final bool enableHapticFeedback;

  const MessageReactionBar({
    super.key,
    this.reactions = const ['❤️', '😂', '😮', '😢', '🙏', '👍'],
    this.onReactionSelected,
    this.onMorePressed,
    this.showMoreButton = true,
    this.selectedReaction,
    this.animationDuration = const Duration(milliseconds: 200),
    this.enableHapticFeedback = true,
  });

  @override
  State<MessageReactionBar> createState() => _MessageReactionBarState();
}

class _MessageReactionBarState extends State<MessageReactionBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
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

  void _handleReactionTap(String emoji) {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onReactionSelected?.call(emoji);
  }

  void _handleMoreTap() {
    if (widget.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
    widget.onMorePressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chatTheme = ChatThemeData.get(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...widget.reactions.map((emoji) => _ReactionButton(
                  emoji: emoji,
                  isSelected: widget.selectedReaction == emoji,
                  onTap: () => _handleReactionTap(emoji),
                  chatTheme: chatTheme,
                )),
            if (widget.showMoreButton) ...[
              const SizedBox(width: 4),
              _MoreButton(
                onTap: _handleMoreTap,
                isDark: isDark,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Individual reaction button in the bar.
class _ReactionButton extends StatefulWidget {
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;
  final ChatThemeData chatTheme;

  const _ReactionButton({
    required this.emoji,
    required this.isSelected,
    required this.onTap,
    required this.chatTheme,
  });

  @override
  State<_ReactionButton> createState() => _ReactionButtonState();
}

class _ReactionButtonState extends State<_ReactionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: widget.isSelected
                ? widget.chatTheme.colors.primary.withValues(alpha: 0.2)
                : Colors.transparent,
            shape: BoxShape.circle,
            border: widget.isSelected
                ? Border.all(
                    color: widget.chatTheme.colors.primary.withValues(alpha: 0.5),
                    width: 2,
                  )
                : null,
          ),
          child: Center(
            child: Text(
              widget.emoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}

/// "More" button to show additional reactions.
class _MoreButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isDark;

  const _MoreButton({
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.black.withValues(alpha: 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add,
          size: 20,
          color: isDark
              ? Colors.white.withValues(alpha: 0.7)
              : Colors.black.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}

/// Full screen emoji picker for selecting from all emojis.
class ReactionEmojiPicker extends StatelessWidget {
  /// Callback when an emoji is selected.
  final void Function(String emoji)? onEmojiSelected;

  /// Common reaction emojis.
  static const List<String> commonEmojis = [
    '❤️', '😂', '😮', '😢', '🙏', '👍', '👎', '🔥',
    '🎉', '😍', '😡', '😱', '🤔', '👏', '💪', '✨',
    '😊', '😭', '🥺', '😘', '🤣', '😎', '🙄', '💕',
    '💯', '🤝', '😴', '🤦', '🤷', '😇', '🥰', '😋',
  ];

  const ReactionEmojiPicker({
    super.key,
    this.onEmojiSelected,
  });

  /// Shows the emoji picker as a bottom sheet.
  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ReactionEmojiPicker(
        onEmojiSelected: (emoji) => Navigator.of(context).pop(emoji),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2C34) : theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12, bottom: 16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Reactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Emoji grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 8,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: commonEmojis.length,
              itemBuilder: (context, index) {
                final emoji = commonEmojis[index];
                return GestureDetector(
                  onTap: () => onEmojiSelected?.call(emoji),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.black.withValues(alpha: 0.03),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
