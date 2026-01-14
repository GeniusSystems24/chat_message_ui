import 'package:flutter/material.dart';
import 'input_models.dart';

/// Callback for handling suggestion selection
typedef OnSuggestionSelected<T> = void Function(FloatingSuggestionItem<T> item);

/// Floating suggestion card widget
class FloatingSuggestionCard<T> extends StatefulWidget {
  /// Current input text
  final String query;

  /// Suggestion type
  final FloatingSuggestionType type;

  /// List of suggestions
  final List<FloatingSuggestionItem<T>> suggestions;

  /// Callback when suggestion is selected
  final OnSuggestionSelected<T>? onSelected;

  /// Callback when card is closed
  final VoidCallback? onClose;

  /// Item height
  final double itemHeight;

  /// Maximum card height
  final double maxHeight;

  /// Card width
  final double? width;

  /// Filter function
  final bool Function(FloatingSuggestionItem<T> item, String query) onFilter;

  /// Custom item builder
  final Widget Function(BuildContext context, FloatingSuggestionItem<T> item)?
      itemBuilder;

  const FloatingSuggestionCard({
    super.key,
    required this.query,
    required this.type,
    required this.suggestions,
    required this.onFilter,
    this.onSelected,
    this.onClose,
    this.itemHeight = 52.0,
    this.maxHeight = 200.0,
    this.width,
    this.itemBuilder,
  });

  @override
  State<FloatingSuggestionCard<T>> createState() =>
      _FloatingSuggestionCardState<T>();
}

class _FloatingSuggestionCardState<T> extends State<FloatingSuggestionCard<T>> {
  late List<FloatingSuggestionItem<T>> _filteredSuggestions;

  @override
  void initState() {
    super.initState();
    _filterSuggestions();
  }

  @override
  void didUpdateWidget(FloatingSuggestionCard<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query ||
        oldWidget.suggestions != widget.suggestions) {
      _filterSuggestions();
    }
  }

  /// Filter suggestions based on input text
  void _filterSuggestions() {
    final query = _getCleanQuery();
    if (query.isEmpty) {
      _filteredSuggestions = widget.suggestions;
    } else {
      _filteredSuggestions = widget.suggestions
          .where((item) => widget.onFilter(item, query))
          .toList();
    }
  }

  /// Get clean query (without special symbols)
  String _getCleanQuery() {
    return widget.query.startsWith(widget.type.symbol)
        ? widget.query.substring(1)
        : widget.query;
  }

  /// Get suggestion type icon
  Widget _getTypeIcon() {
    switch (widget.type) {
      case FloatingSuggestionType.username:
        return const Icon(Icons.person, size: 16);
      case FloatingSuggestionType.hashtag:
        return const Icon(Icons.tag, size: 16);
      case FloatingSuggestionType.quickReply:
        return const Icon(Icons.flash_on, size: 16);
      case FloatingSuggestionType.clubChatTask:
        return const Icon(Icons.task, size: 16);
    }
  }

  /// Get suggestion type title
  String _getTypeTitle() {
    switch (widget.type) {
      case FloatingSuggestionType.username:
        return 'Mentions';
      case FloatingSuggestionType.hashtag:
        return 'Hashtags';
      case FloatingSuggestionType.quickReply:
        return 'Quick replies';
      case FloatingSuggestionType.clubChatTask:
        return 'Tasks';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_filteredSuggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    final cardHeight = (_filteredSuggestions.length * widget.itemHeight).clamp(
      0.0,
      widget.maxHeight,
    );

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: widget.width,
        height: cardHeight + 50, // 50 for header
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Card header
            _buildCardHeader(theme),
            // Suggestions list
            Expanded(child: _buildSuggestionsList()),
          ],
        ),
      ),
    );
  }

  /// Build card header
  Widget _buildCardHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          _getTypeIcon(),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _getTypeTitle(),
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (widget.onClose != null)
            GestureDetector(
              onTap: widget.onClose,
              child: Icon(
                Icons.close,
                size: 18,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }

  /// Build suggestions list
  Widget _buildSuggestionsList() {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: _filteredSuggestions.length,
      itemBuilder: (context, index) {
        final item = _filteredSuggestions[index];
        return Container(
          height: widget.itemHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: widget.onSelected == null
                ? null
                : () => widget.onSelected?.call(item),
            child: widget.itemBuilder?.call(context, item) ??
                _buildSuggestionItem(context, item),
          ),
        );
      },
    );
  }

  /// Build single suggestion item
  Widget _buildSuggestionItem(
    BuildContext context,
    FloatingSuggestionItem<T> item,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        // Item icon or default
        item.icon ?? _getDefaultItemIcon(item.type),
        const SizedBox(width: 12),
        // Item content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (item.subtitle != null) ...[
                const SizedBox(height: 2),
                Text(
                  item.subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  /// Get default item icon
  Widget _getDefaultItemIcon(FloatingSuggestionType type) {
    final theme = Theme.of(context);

    switch (type) {
      case FloatingSuggestionType.username:
        return CircleAvatar(
          radius: 16,
          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
          child: Icon(Icons.person, size: 16, color: theme.colorScheme.primary),
        );
      case FloatingSuggestionType.hashtag:
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.secondary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.tag, size: 16, color: theme.colorScheme.secondary),
        );
      case FloatingSuggestionType.quickReply:
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.flash_on,
            size: 16,
            color: theme.colorScheme.tertiary,
          ),
        );
      case FloatingSuggestionType.clubChatTask:
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.task, size: 16, color: theme.colorScheme.tertiary),
        );
    }
  }
}
