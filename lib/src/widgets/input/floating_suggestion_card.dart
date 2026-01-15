import 'package:flutter/material.dart';
import 'package:tooltip_card/tooltip_card.dart';
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
  final TooltipCardController _tooltipController = TooltipCardController();

  @override
  void initState() {
    super.initState();
    _filterSuggestions();
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncTooltipState());
  }

  @override
  void didUpdateWidget(FloatingSuggestionCard<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query ||
        oldWidget.suggestions != widget.suggestions) {
      _filterSuggestions();
      WidgetsBinding.instance.addPostFrameCallback((_) => _syncTooltipState());
    }
  }

  @override
  void dispose() {
    if (_tooltipController.isOpen) {
      _tooltipController.close();
    }
    _tooltipController.dispose();
    super.dispose();
  }

  void _syncTooltipState() {
    if (!mounted) return;
    if (_filteredSuggestions.isEmpty) {
      if (_tooltipController.isOpen) {
        _tooltipController.close();
      }
    } else if (_tooltipController.isOpen) {
      _tooltipController.updateData(_filteredSuggestions);
    } else {
      _tooltipController.open(data: _filteredSuggestions);
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

    final closeCallback = () {
      _tooltipController.close();
      widget.onClose?.call();
    };

    return TooltipCard.builder(
      controller: _tooltipController,
      useRootOverlay: false,
      fitToViewport: false,
      autoFlipIfZeroSpace: false,
      wrapContentInScrollView: false,
      whenContentVisible: WhenContentVisible.pressButton,
      whenContentHide: WhenContentHide.pressOutSide,
      dismissOnPointerMoveAway: false,
      placementSide: TooltipCardPlacementSide.bottom,
      beakEnabled: false,
      awaySpace: 0,
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      flyoutBackgroundColor: theme.colorScheme.surface,
      borderColor: theme.colorScheme.outline.withValues(alpha: 0.3),
      borderWidth: 1,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints.tightFor(
        width: widget.width,
        height: cardHeight + 50,
      ),
      onClose: widget.onClose == null ? null : closeCallback,
      child: SizedBox(width: widget.width ?? 0, height: 0),
      builder: (context, close) {
        final suggestions = _tooltipController
                .dataAs<List<FloatingSuggestionItem<T>>>() ??
            _filteredSuggestions;

        final contentHeight =
            (suggestions.length * widget.itemHeight).clamp(0.0, widget.maxHeight);

        return TooltipCardContent(
        icon: _getTypeIcon(),
        iconSize: 16,
        title: _getTypeTitle(),
        titleStyle: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        padding: EdgeInsets.zero,
        spacing: 0,
        onClose: widget.onClose == null ? null : closeCallback,
        content: SizedBox(
          width: widget.width,
          height: contentHeight,
          child: _buildSuggestionsList(suggestions),
        ),
        );
      },
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
