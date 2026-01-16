import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'floating_suggestion_config.dart';
import 'floating_suggestion_models.dart';
import 'floating_suggestion_theme.dart';

/// Widget for displaying a single suggestion item.
///
/// Features:
/// - Text highlighting for matched queries
/// - Avatar/image support
/// - Hover and selection states
/// - Custom trailing widgets
class FloatingSuggestionItemWidget<T> extends StatefulWidget {
  /// The suggestion item data
  final FloatingSuggestionItemData<T> item;

  /// Theme configuration
  final FloatingSuggestionTheme theme;

  /// Whether this item is currently selected (keyboard navigation)
  final bool isSelected;

  /// Query string for text highlighting
  final String highlightQuery;

  /// Tap callback
  final VoidCallback? onTap;

  /// Custom content builder
  final Widget Function(BuildContext context, FloatingSuggestionItemData<T> item)?
      contentBuilder;

  const FloatingSuggestionItemWidget({
    super.key,
    required this.item,
    required this.theme,
    this.isSelected = false,
    this.highlightQuery = '',
    this.onTap,
    this.contentBuilder,
  });

  @override
  State<FloatingSuggestionItemWidget<T>> createState() =>
      _FloatingSuggestionItemWidgetState<T>();
}

class _FloatingSuggestionItemWidgetState<T>
    extends State<FloatingSuggestionItemWidget<T>> {
  bool _isHovered = false;

  Color get _backgroundColor {
    if (widget.isSelected) {
      return widget.theme.itemSelectedColor;
    }
    if (_isHovered) {
      return widget.theme.itemHoverColor;
    }
    return widget.theme.itemBackgroundColor;
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final item = widget.item;
    final typeConfig = item.typeConfig;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: theme.hoverAnimationDuration,
        height: theme.itemHeight,
        decoration: BoxDecoration(
          color: _backgroundColor,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: item.enabled ? widget.onTap : null,
            child: Opacity(
              opacity: item.enabled ? 1.0 : 0.5,
              child: Padding(
                padding: theme.itemPadding,
                child: widget.contentBuilder?.call(context, item) ??
                    _buildDefaultContent(context, theme, item, typeConfig),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultContent(
    BuildContext context,
    FloatingSuggestionTheme theme,
    FloatingSuggestionItemData<T> item,
    SuggestionTypeConfig typeConfig,
  ) {
    return Row(
      children: [
        // Icon/Avatar
        _buildItemIcon(context, theme, item, typeConfig),
        const SizedBox(width: 12),

        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Title with highlighting
              _buildTitle(context, theme, item),
              if (item.subtitle != null) ...[
                const SizedBox(height: 2),
                // Subtitle
                _buildSubtitle(context, theme, item),
              ],
            ],
          ),
        ),

        // Trailing widget
        if (item.trailing != null) ...[
          const SizedBox(width: 8),
          item.trailing!,
        ],

        // Selection indicator
        if (widget.isSelected) ...[
          const SizedBox(width: 8),
          Icon(
            Icons.keyboard_return_rounded,
            size: 16,
            color: theme.headerIconColor,
          ),
        ],
      ],
    );
  }

  Widget _buildItemIcon(
    BuildContext context,
    FloatingSuggestionTheme theme,
    FloatingSuggestionItemData<T> item,
    SuggestionTypeConfig typeConfig,
  ) {
    // Custom icon provided
    if (item.icon != null) {
      return item.icon!;
    }

    // Image URL provided (avatar)
    if (item.imageUrl != null && typeConfig.showAvatars) {
      return CircleAvatar(
        radius: theme.itemIconRadius,
        backgroundColor: theme.itemIconBackgroundColor,
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: item.imageUrl!,
            width: theme.itemIconRadius * 2,
            height: theme.itemIconRadius * 2,
            fit: BoxFit.cover,
            placeholder: (_, __) => Icon(
              typeConfig.icon,
              size: theme.itemIconSize,
              color: typeConfig.color ?? theme.headerIconColor,
            ),
            errorWidget: (_, __, ___) => Icon(
              typeConfig.icon,
              size: theme.itemIconSize,
              color: typeConfig.color ?? theme.headerIconColor,
            ),
          ),
        ),
      );
    }

    // Default icon
    return Container(
      width: theme.itemIconRadius * 2,
      height: theme.itemIconRadius * 2,
      decoration: BoxDecoration(
        color: (typeConfig.color ?? theme.headerIconColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(theme.itemIconRadius),
      ),
      child: Icon(
        typeConfig.icon,
        size: theme.itemIconSize,
        color: typeConfig.color ?? theme.headerIconColor,
      ),
    );
  }

  Widget _buildTitle(
    BuildContext context,
    FloatingSuggestionTheme theme,
    FloatingSuggestionItemData<T> item,
  ) {
    final style = theme.itemTitleStyle ??
        TextStyle(
          color: theme.itemTitleColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        );

    if (widget.highlightQuery.isEmpty || !item.typeConfig.highlightMatches) {
      return Text(
        item.label,
        style: style,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return _HighlightedText(
      text: item.label,
      query: widget.highlightQuery,
      style: style,
      highlightColor: theme.highlightColor,
      highlightBackgroundColor: theme.highlightBackgroundColor,
    );
  }

  Widget _buildSubtitle(
    BuildContext context,
    FloatingSuggestionTheme theme,
    FloatingSuggestionItemData<T> item,
  ) {
    final style = theme.itemSubtitleStyle ??
        TextStyle(
          color: theme.itemSubtitleColor,
          fontSize: 12,
        );

    return Text(
      item.subtitle!,
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/// Widget for highlighting matched text
class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle style;
  final Color highlightColor;
  final Color highlightBackgroundColor;

  const _HighlightedText({
    required this.text,
    required this.query,
    required this.style,
    required this.highlightColor,
    required this.highlightBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (query.isEmpty) {
      return Text(text, style: style, maxLines: 1, overflow: TextOverflow.ellipsis);
    }

    final spans = _buildHighlightedSpans();

    return RichText(
      text: TextSpan(children: spans),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  List<TextSpan> _buildHighlightedSpans() {
    final spans = <TextSpan>[];
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int start = 0;
    int index = lowerText.indexOf(lowerQuery, start);

    while (index >= 0) {
      // Add non-highlighted text before match
      if (index > start) {
        spans.add(TextSpan(
          text: text.substring(start, index),
          style: style,
        ));
      }

      // Add highlighted match
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: style.copyWith(
          color: highlightColor,
          backgroundColor: highlightBackgroundColor,
          fontWeight: FontWeight.w600,
        ),
      ));

      start = index + query.length;
      index = lowerText.indexOf(lowerQuery, start);
    }

    // Add remaining text
    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: style,
      ));
    }

    return spans;
  }
}
