import 'package:flutter/material.dart';

import 'floating_suggestion_config.dart';
import 'floating_suggestion_theme.dart';

/// Header widget for the floating suggestion card.
///
/// Displays:
/// - Type icon
/// - Title and optional subtitle
/// - Item count (optional)
/// - Close button (optional)
class FloatingSuggestionHeader extends StatelessWidget {
  /// Type configuration
  final SuggestionTypeConfig typeConfig;

  /// Theme configuration
  final FloatingSuggestionTheme theme;

  /// Number of items (for display)
  final int? itemCount;

  /// Close button callback
  final VoidCallback? onClose;

  /// Custom title override
  final String? title;

  /// Custom subtitle override
  final String? subtitle;

  const FloatingSuggestionHeader({
    super.key,
    required this.typeConfig,
    required this.theme,
    this.itemCount,
    this.onClose,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? typeConfig.title;
    final displaySubtitle = subtitle ?? typeConfig.headerSubtitle;
    final iconColor = typeConfig.color ?? theme.headerIconColor;

    return Container(
      padding: theme.headerPadding,
      decoration: BoxDecoration(
        color: theme.headerBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(theme.borderRadius),
          topRight: Radius.circular(theme.borderRadius),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              typeConfig.icon,
              size: theme.headerIconSize,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 12),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        displayTitle,
                        style: theme.headerTitleStyle ??
                            TextStyle(
                              color: theme.headerTitleColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (theme.showItemCount && itemCount != null) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: iconColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$itemCount',
                          style: TextStyle(
                            color: iconColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (displaySubtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    displaySubtitle,
                    style: theme.headerSubtitleStyle ??
                        TextStyle(
                          color: theme.headerSubtitleColor,
                          fontSize: 12,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Keyboard hint
          _buildKeyboardHint(context),

          // Close button
          if (theme.showCloseButton && onClose != null) ...[
            const SizedBox(width: 8),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onClose,
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.close_rounded,
                    size: 20,
                    color: theme.headerSubtitleColor,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildKeyboardHint(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _KeyHint(icon: Icons.keyboard_arrow_up, theme: theme),
        _KeyHint(icon: Icons.keyboard_arrow_down, theme: theme),
        const SizedBox(width: 4),
        _KeyHint(
          icon: Icons.keyboard_return_rounded,
          theme: theme,
          label: 'Select',
        ),
      ],
    );
  }
}

class _KeyHint extends StatelessWidget {
  final IconData icon;
  final String? label;
  final FloatingSuggestionTheme theme;

  const _KeyHint({
    required this.icon,
    required this.theme,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: theme.headerSubtitleColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: theme.headerSubtitleColor.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: theme.headerSubtitleColor,
          ),
          if (label != null) ...[
            const SizedBox(width: 2),
            Text(
              label!,
              style: TextStyle(
                fontSize: 10,
                color: theme.headerSubtitleColor,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state widget for when no suggestions match
class FloatingSuggestionEmptyState extends StatelessWidget {
  /// Theme configuration
  final FloatingSuggestionTheme theme;

  /// Type configuration (for icon)
  final SuggestionTypeConfig typeConfig;

  /// Custom message
  final String? message;

  /// Custom icon
  final IconData? icon;

  const FloatingSuggestionEmptyState({
    super.key,
    required this.theme,
    required this.typeConfig,
    this.message,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: theme.emptyStatePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon ?? Icons.search_off_rounded,
            size: 32,
            color: theme.headerSubtitleColor,
          ),
          const SizedBox(height: 8),
          Text(
            message ?? 'No ${typeConfig.displayName.toLowerCase()} found',
            style: theme.emptyStateStyle ??
                TextStyle(
                  color: theme.headerSubtitleColor,
                  fontSize: 13,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Loading state widget
class FloatingSuggestionLoadingState extends StatelessWidget {
  /// Theme configuration
  final FloatingSuggestionTheme theme;

  /// Custom message
  final String? message;

  const FloatingSuggestionLoadingState({
    super.key,
    required this.theme,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: theme.emptyStatePadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(theme.headerIconColor),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 8),
            Text(
              message!,
              style: theme.loadingStateStyle ??
                  TextStyle(
                    color: theme.headerSubtitleColor,
                    fontSize: 13,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
