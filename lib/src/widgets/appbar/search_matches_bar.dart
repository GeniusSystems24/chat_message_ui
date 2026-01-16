import 'package:flutter/material.dart';

import '../../theme/chat_theme.dart';
import '../../theme/search_highlight_theme.dart';

/// Callback signature for search queries.
typedef OnSearchCallback = Future<List<String>> Function(String query);

/// WhatsApp-style search matches bar widget.
///
/// Displays current match information with navigation controls.
class SearchMatchesBar extends StatefulWidget {
  /// List of matched message IDs.
  final List<String> matchedMessageIds;

  /// Current match index (0-based).
  final int currentMatchIndex;

  /// Whether a backend search is in progress.
  final bool isSearching;

  /// Callback when user navigates to previous match.
  final VoidCallback? onPrevious;

  /// Callback when user navigates to next match.
  final VoidCallback? onNext;

  /// Callback when search is closed.
  final VoidCallback? onClose;

  /// Callback when search query changes.
  final ValueChanged<String>? onQueryChanged;

  /// Placeholder text for the search input.
  final String? searchHint;

  /// Initial search query value.
  final String? initialQuery;

  /// Focus node for the search input.
  final FocusNode? focusNode;

  /// Text editing controller for external control.
  final TextEditingController? controller;

  const SearchMatchesBar({
    super.key,
    required this.matchedMessageIds,
    required this.currentMatchIndex,
    this.isSearching = false,
    this.onPrevious,
    this.onNext,
    this.onClose,
    this.onQueryChanged,
    this.searchHint,
    this.initialQuery,
    this.focusNode,
    this.controller,
  });

  @override
  State<SearchMatchesBar> createState() => _SearchMatchesBarState();
}

class _SearchMatchesBarState extends State<SearchMatchesBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        TextEditingController(text: widget.initialQuery ?? '');
    _focusNode = widget.focusNode ?? FocusNode();

    _controller.addListener(_onQueryChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onQueryChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onQueryChanged() {
    widget.onQueryChanged?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.get(context);
    final searchTheme = chatTheme.searchHighlight;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: searchTheme.barBackgroundColor,
          ),
          child: Row(
            children: [
              // Close button
              _buildIconButton(
                icon: Icons.arrow_back,
                onPressed: widget.onClose,
                color: searchTheme.closeButtonColor,
              ),
              const SizedBox(width: 8),

              // Search input
              Expanded(
                child: _buildSearchInput(searchTheme),
              ),

              // Navigation arrows (always shown, disabled when no matches)
              const SizedBox(width: 4),
              _buildNavigationArrows(searchTheme),
            ],
          ),
        ),
        // Progress indicator when searching
        if (widget.isSearching)
          LinearProgressIndicator(
            minHeight: 2,
            backgroundColor: searchTheme.barBorderColor,
            color: chatTheme.colors.primary,
          )
        else
          Container(
            height: 0.5,
            color: searchTheme.barBorderColor,
          ),
      ],
    );
  }

  Widget _buildSearchInput(SearchHighlightTheme searchTheme) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      style: searchTheme.inputTextStyle,
      decoration: InputDecoration(
        hintText: widget.searchHint ?? 'Search...',
        hintStyle: searchTheme.hintTextStyle,
        border: InputBorder.none,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 8),
      ),
      textInputAction: TextInputAction.search,
    );
  }

  Widget _buildNavigationArrows(SearchHighlightTheme searchTheme) {
    final total = widget.matchedMessageIds.length;
    final hasMatches = total > 0;
    final canGoPrevious =
        hasMatches && widget.currentMatchIndex > 0 && !widget.isSearching;
    final canGoNext = hasMatches &&
        widget.currentMatchIndex < total - 1 &&
        !widget.isSearching;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Up arrow (next - older message, moving towards end of list)
        _buildIconButton(
          icon: Icons.keyboard_arrow_up,
          onPressed: canGoNext ? widget.onNext : null,
          color: canGoNext
              ? searchTheme.arrowColor
              : searchTheme.arrowDisabledColor,
        ),
        // Down arrow (previous - newer message, moving towards start of list)
        _buildIconButton(
          icon: Icons.keyboard_arrow_down,
          onPressed: canGoPrevious ? widget.onPrevious : null,
          color: canGoPrevious
              ? searchTheme.arrowColor
              : searchTheme.arrowDisabledColor,
        ),
      ],
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    VoidCallback? onPressed,
    required Color color,
  }) {
    return IconButton(
      icon: Icon(icon, size: 24, color: color),
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 36,
        minHeight: 36,
      ),
      splashRadius: 20,
    );
  }
}
