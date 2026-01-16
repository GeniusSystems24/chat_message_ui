import 'package:flutter/material.dart';
import 'package:tooltip_card/tooltip_card.dart';
import 'input_models.dart';

/// Callback for handling suggestion selection
typedef OnSuggestionSelected<T> = void Function(FloatingSuggestionItem<T> item);

class TooltipSuggestionPayload {
  final FloatingSuggestionType type;
  final String query;
  final List<FloatingSuggestionItem<dynamic>> suggestions;
  final double itemHeight;
  final double? width;
  final double maxHeight;

  const TooltipSuggestionPayload({
    required this.type,
    required this.query,
    required this.suggestions,
    required this.itemHeight,
    this.width,
    this.maxHeight = 200.0,
  });
}

/// Floating suggestion card widget
class FloatingSuggestionCard<T> extends StatelessWidget {
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

  /// Filter suggestions based on input text
  List<FloatingSuggestionItem<T>> _filterSuggestions() {
    final query = _getCleanQuery();
    if (query.isEmpty) {
      return suggestions;
    }
    return suggestions
        .where((item) => onFilter(item, query))
        .toList();
  }

  /// Get clean query (without special symbols)
  String _getCleanQuery() {
    return query.startsWith(type.symbol) ? query.substring(1) : query;
  }

  /// Get suggestion type icon
  Widget _getTypeIcon() {
    switch (type) {
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
    switch (type) {
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
    final filteredSuggestions = _filterSuggestions();

    if (filteredSuggestions.isEmpty) {
      return const SizedBox.shrink();
    }

    final cardHeight = (filteredSuggestions.length * itemHeight).clamp(
      0.0,
      maxHeight,
    );
    final closeCallback = onClose;

    return Container(
      width: width,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: TooltipCardContent(
        icon: _getTypeIcon(),
        iconSize: 16,
        title: _getTypeTitle(),
        titleStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        padding: EdgeInsets.zero,
        spacing: 0,
        onClose: closeCallback,
        content: SizedBox(
          width: width,
          height: cardHeight,
          child: _buildSuggestionsList(filteredSuggestions),
        ),
      ),
    );
  }

  /// Build suggestions list
  Widget _buildSuggestionsList(List<FloatingSuggestionItem<T>> suggestions) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final item = suggestions[index];
        return Container(
          height: itemHeight,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: onSelected == null
                ? null
                : () => onSelected?.call(item),
            child: itemBuilder?.call(context, item) ??
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
        item.icon ?? _getDefaultItemIcon(context, item.type),
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
  Widget _getDefaultItemIcon(
    BuildContext context,
    FloatingSuggestionType type,
  ) {
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

Widget buildSuggestionContent({
  required TooltipSuggestionPayload payload,
  required void Function(String value) onValueSelected,
  VoidCallback? onClose,
}) {
  switch (payload.type) {
    case FloatingSuggestionType.username:
      return FloatingSuggestionCard<ChatUserSuggestion>(
        width: payload.width,
        itemHeight: payload.itemHeight,
        query: payload.query,
        type: FloatingSuggestionType.username,
        suggestions:
            payload.suggestions.cast<FloatingSuggestionItem<ChatUserSuggestion>>(),
        onSelected: (item) => onValueSelected(item.value.mentionText),
        onFilter: (item, query) {
          final lowered = query.toLowerCase();
          return item.label.toLowerCase().contains(lowered) ||
              (item.subtitle?.toLowerCase().contains(lowered) ?? false);
        },
        onClose: onClose,
        maxHeight: payload.maxHeight,
      );
    case FloatingSuggestionType.hashtag:
      return FloatingSuggestionCard<Hashtag>(
        width: payload.width,
        itemHeight: payload.itemHeight,
        query: payload.query,
        type: FloatingSuggestionType.hashtag,
        suggestions: payload.suggestions.cast<FloatingSuggestionItem<Hashtag>>(),
        onSelected: (item) => onValueSelected(
          '${FloatingSuggestionType.hashtag.symbol}${item.value.hashtag}',
        ),
        onClose: onClose,
        onFilter: (item, query) =>
            item.value.hashtag.toLowerCase().startsWith(query.toLowerCase()),
        maxHeight: payload.maxHeight,
      );
    case FloatingSuggestionType.quickReply:
      return FloatingSuggestionCard<QuickReply>(
        width: payload.width,
        itemHeight: payload.itemHeight,
        query: payload.query,
        type: FloatingSuggestionType.quickReply,
        suggestions:
            payload.suggestions.cast<FloatingSuggestionItem<QuickReply>>(),
        onSelected: (item) => onValueSelected(item.value.response),
        onClose: onClose,
        onFilter: (item, query) =>
            item.value.response.toLowerCase().startsWith(query.toLowerCase()),
        maxHeight: payload.maxHeight,
      );
    case FloatingSuggestionType.clubChatTask:
      return FloatingSuggestionCard<dynamic>(
        width: payload.width,
        itemHeight: payload.itemHeight,
        query: payload.query,
        type: FloatingSuggestionType.clubChatTask,
        suggestions: payload.suggestions,
        onSelected: (item) => onValueSelected(
          '${FloatingSuggestionType.clubChatTask.symbol}${item.value}',
        ),
        onClose: onClose,
        onFilter: (item, query) =>
            item.label.toLowerCase().contains(query.toLowerCase()),
        maxHeight: payload.maxHeight,
      );
  }
}
