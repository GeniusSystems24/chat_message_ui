import 'package:flutter/material.dart';

import 'floating_suggestion_config.dart';
import 'floating_suggestion_controller.dart';
import 'floating_suggestion_header.dart';
import 'floating_suggestion_item_widget.dart';
import 'floating_suggestion_models.dart';
import 'floating_suggestion_theme.dart';

/// Enhanced floating suggestion card widget.
///
/// Features:
/// - Customizable appearance via [FloatingSuggestionTheme]
/// - Keyboard navigation support
/// - Text highlighting for matches
/// - Loading and empty states
/// - Smooth animations
///
/// Example:
/// ```dart
/// EnhancedFloatingSuggestionCard<User>(
///   query: '@john',
///   typeConfig: FloatingSuggestionTypes.username,
///   suggestions: userSuggestions,
///   theme: FloatingSuggestionTheme.light(),
///   onSelected: (item) => insertMention(item.value),
/// )
/// ```
class EnhancedFloatingSuggestionCard<T> extends StatefulWidget {
  /// Current search query
  final String query;

  /// Type configuration
  final SuggestionTypeConfig typeConfig;

  /// List of suggestions
  final List<FloatingSuggestionItemData<T>> suggestions;

  /// Theme configuration (defaults to light theme)
  final FloatingSuggestionTheme? theme;

  /// Selection callback
  final OnSuggestionSelected<T>? onSelected;

  /// Close callback
  final VoidCallback? onClose;

  /// Custom filter function
  final SuggestionFilter<T>? filter;

  /// Custom item builder
  final Widget Function(
    BuildContext context,
    FloatingSuggestionItemData<T> item,
    bool isSelected,
    String query,
  )? itemBuilder;

  /// Custom empty state builder
  final Widget Function(BuildContext context)? emptyBuilder;

  /// Custom loading state builder
  final Widget Function(BuildContext context)? loadingBuilder;

  /// Whether currently loading
  final bool isLoading;

  /// Whether to enable keyboard navigation
  final bool enableKeyboardNavigation;

  /// Card width (defaults to parent width)
  final double? width;

  /// Optional controller for external control
  final FloatingSuggestionController<T>? controller;

  /// Scroll controller for the list
  final ScrollController? scrollController;

  const EnhancedFloatingSuggestionCard({
    super.key,
    required this.query,
    required this.typeConfig,
    required this.suggestions,
    this.theme,
    this.onSelected,
    this.onClose,
    this.filter,
    this.itemBuilder,
    this.emptyBuilder,
    this.loadingBuilder,
    this.isLoading = false,
    this.enableKeyboardNavigation = true,
    this.width,
    this.controller,
    this.scrollController,
  });

  @override
  State<EnhancedFloatingSuggestionCard<T>> createState() =>
      _EnhancedFloatingSuggestionCardState<T>();
}

class _EnhancedFloatingSuggestionCardState<T>
    extends State<EnhancedFloatingSuggestionCard<T>>
    with SingleTickerProviderStateMixin {
  late FloatingSuggestionController<T> _controller;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late ScrollController _scrollController;

  List<FloatingSuggestionItemData<T>> _filteredSuggestions = [];
  bool _isInternalController = false;

  FloatingSuggestionTheme get _theme =>
      widget.theme ?? const FloatingSuggestionTheme.light();

  @override
  void initState() {
    super.initState();

    // Initialize controller
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = FloatingSuggestionController<T>();
      _isInternalController = true;
    }

    // Initialize scroll controller
    _scrollController = widget.scrollController ?? ScrollController();

    // Initialize animations
    _animationController = AnimationController(
      vsync: this,
      duration: _theme.animationDuration,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: _theme.animationCurve,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: _theme.animationCurve,
    ));

    // Filter and start animation
    _filterSuggestions();
    _animationController.forward();

    // Listen to controller changes
    _controller.addListener(_onControllerChange);
  }

  @override
  void didUpdateWidget(EnhancedFloatingSuggestionCard<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.query != widget.query ||
        oldWidget.suggestions != widget.suggestions) {
      _filterSuggestions();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChange);
    if (_isInternalController) {
      _controller.dispose();
    }
    _animationController.dispose();
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _onControllerChange() {
    if (mounted) {
      setState(() {});
      _scrollToSelectedItem();
    }
  }

  void _filterSuggestions() {
    final query = _getCleanQuery();
    final filter = widget.filter ?? defaultSuggestionFilter;

    if (query.isEmpty) {
      _filteredSuggestions = widget.suggestions;
    } else {
      _filteredSuggestions = widget.suggestions
          .where((item) => filter(item, query))
          .toList();
    }

    _controller.setItems(_filteredSuggestions);
  }

  String _getCleanQuery() {
    final symbol = widget.typeConfig.symbol;
    return widget.query.startsWith(symbol)
        ? widget.query.substring(symbol.length)
        : widget.query;
  }

  void _scrollToSelectedItem() {
    if (!_scrollController.hasClients) return;

    final selectedIndex = _controller.selectedIndex;
    final itemHeight = _theme.itemHeight;
    final viewportHeight = _scrollController.position.viewportDimension;
    final currentOffset = _scrollController.offset;

    final itemTop = selectedIndex * itemHeight;
    final itemBottom = itemTop + itemHeight;

    // Scroll if selected item is not fully visible
    if (itemTop < currentOffset) {
      _scrollController.animateTo(
        itemTop,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    } else if (itemBottom > currentOffset + viewportHeight) {
      _scrollController.animateTo(
        itemBottom - viewportHeight,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleItemTap(FloatingSuggestionItemData<T> item) {
    widget.onSelected?.call(item);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: _buildCard(context),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final theme = _theme;

    return Container(
      width: widget.width,
      margin: theme.cardPadding,
      decoration: BoxDecoration(
        color: theme.backgroundColor,
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(
          color: theme.borderColor,
          width: theme.borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor,
            blurRadius: theme.elevation,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(theme.borderRadius),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            FloatingSuggestionHeader(
              typeConfig: widget.typeConfig,
              theme: theme,
              itemCount: _filteredSuggestions.length,
              onClose: widget.onClose,
            ),

            // Divider
            if (theme.showDividers)
              Divider(
                height: theme.dividerThickness,
                thickness: theme.dividerThickness,
                color: theme.borderColor,
              ),

            // Content
            _buildContent(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, FloatingSuggestionTheme theme) {
    // Loading state
    if (widget.isLoading) {
      return widget.loadingBuilder?.call(context) ??
          FloatingSuggestionLoadingState(
            theme: theme,
            message: 'Loading...',
          );
    }

    // Empty state
    if (_filteredSuggestions.isEmpty) {
      return widget.emptyBuilder?.call(context) ??
          FloatingSuggestionEmptyState(
            theme: theme,
            typeConfig: widget.typeConfig,
          );
    }

    // Suggestions list
    final contentHeight = (_filteredSuggestions.length * theme.itemHeight)
        .clamp(0.0, theme.maxHeight);

    return SizedBox(
      height: contentHeight,
      child: ListView.builder(
        controller: _scrollController,
        padding: EdgeInsets.zero,
        itemCount: _filteredSuggestions.length,
        itemExtent: theme.itemHeight,
        itemBuilder: (context, index) {
          final item = _filteredSuggestions[index];
          final isSelected = _controller.selectedIndex == index;

          if (widget.itemBuilder != null) {
            return widget.itemBuilder!(
              context,
              item,
              isSelected,
              _getCleanQuery(),
            );
          }

          return FloatingSuggestionItemWidget<T>(
            item: item,
            theme: theme,
            isSelected: isSelected,
            highlightQuery: _getCleanQuery(),
            onTap: () => _handleItemTap(item),
          );
        },
      ),
    );
  }
}
