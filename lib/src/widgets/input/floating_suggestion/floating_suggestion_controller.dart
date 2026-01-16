import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'floating_suggestion_models.dart';

/// Controller for managing floating suggestion card state and keyboard navigation.
///
/// This controller handles:
/// - Keyboard navigation (up/down arrows, Enter, Escape)
/// - Selected item tracking
/// - Focus management
///
/// Example:
/// ```dart
/// final controller = FloatingSuggestionController<User>();
///
/// // Set items
/// controller.setItems(suggestions);
///
/// // Handle keyboard events
/// FocusScope(
///   onKeyEvent: controller.handleKeyEvent,
///   child: ...,
/// )
/// ```
class FloatingSuggestionController<T> extends ChangeNotifier {
  int _selectedIndex = 0;
  List<FloatingSuggestionItemData<T>> _items = [];
  bool _isVisible = false;

  /// Current selected index
  int get selectedIndex => _selectedIndex;

  /// Current items list
  List<FloatingSuggestionItemData<T>> get items => _items;

  /// Whether suggestions are visible
  bool get isVisible => _isVisible;

  /// Number of items
  int get itemCount => _items.length;

  /// Whether there are any items
  bool get hasItems => _items.isNotEmpty;

  /// Currently selected item (or null if empty)
  FloatingSuggestionItemData<T>? get selectedItem {
    if (_items.isEmpty || _selectedIndex < 0 || _selectedIndex >= _items.length) {
      return null;
    }
    return _items[_selectedIndex];
  }

  /// Set items and reset selection
  void setItems(List<FloatingSuggestionItemData<T>> items) {
    _items = items;
    _selectedIndex = 0;
    _isVisible = items.isNotEmpty;
    notifyListeners();
  }

  /// Clear all items
  void clear() {
    _items = [];
    _selectedIndex = 0;
    _isVisible = false;
    notifyListeners();
  }

  /// Show suggestions
  void show() {
    if (_items.isNotEmpty) {
      _isVisible = true;
      notifyListeners();
    }
  }

  /// Hide suggestions
  void hide() {
    _isVisible = false;
    notifyListeners();
  }

  /// Move selection up
  void moveUp() {
    if (_items.isEmpty) return;

    if (_selectedIndex > 0) {
      _selectedIndex--;
      notifyListeners();
    }
  }

  /// Move selection down
  void moveDown() {
    if (_items.isEmpty) return;

    if (_selectedIndex < _items.length - 1) {
      _selectedIndex++;
      notifyListeners();
    }
  }

  /// Move to first item
  void moveToFirst() {
    if (_items.isEmpty) return;

    _selectedIndex = 0;
    notifyListeners();
  }

  /// Move to last item
  void moveToLast() {
    if (_items.isEmpty) return;

    _selectedIndex = _items.length - 1;
    notifyListeners();
  }

  /// Select item at index
  void selectIndex(int index) {
    if (index >= 0 && index < _items.length) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  /// Handle keyboard events
  ///
  /// Returns `KeyEventResult.handled` if the event was handled,
  /// `KeyEventResult.ignored` otherwise.
  ///
  /// Handles:
  /// - ArrowUp: Move selection up
  /// - ArrowDown: Move selection down
  /// - Enter: Confirm selection (triggers onSelect callback)
  /// - Escape: Hide suggestions (triggers onClose callback)
  /// - Home: Move to first item
  /// - End: Move to last item
  KeyEventResult handleKeyEvent(
    FocusNode node,
    KeyEvent event, {
    VoidCallback? onSelect,
    VoidCallback? onClose,
  }) {
    if (!_isVisible || _items.isEmpty) {
      return KeyEventResult.ignored;
    }

    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }

    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowUp) {
      moveUp();
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.arrowDown) {
      moveDown();
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter) {
      onSelect?.call();
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.escape) {
      hide();
      onClose?.call();
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.home) {
      moveToFirst();
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.end) {
      moveToLast();
      return KeyEventResult.handled;
    }

    // Page up/down for faster navigation
    if (key == LogicalKeyboardKey.pageUp) {
      final newIndex = (_selectedIndex - 5).clamp(0, _items.length - 1);
      selectIndex(newIndex);
      return KeyEventResult.handled;
    }

    if (key == LogicalKeyboardKey.pageDown) {
      final newIndex = (_selectedIndex + 5).clamp(0, _items.length - 1);
      selectIndex(newIndex);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  void dispose() {
    _items = [];
    super.dispose();
  }
}

/// Mixin for widgets that need keyboard navigation support
mixin FloatingSuggestionKeyboardMixin<T extends StatefulWidget> on State<T> {
  late final FocusNode _suggestionFocusNode;
  FloatingSuggestionController? _suggestionController;

  @protected
  FocusNode get suggestionFocusNode => _suggestionFocusNode;

  @protected
  FloatingSuggestionController? get suggestionController => _suggestionController;

  @protected
  void initSuggestionKeyboard(FloatingSuggestionController controller) {
    _suggestionController = controller;
    _suggestionFocusNode = FocusNode(
      debugLabel: 'FloatingSuggestionFocusNode',
      onKeyEvent: (node, event) => controller.handleKeyEvent(
        node,
        event,
        onSelect: onSuggestionSelect,
        onClose: onSuggestionClose,
      ),
    );
  }

  @protected
  void disposeSuggestionKeyboard() {
    _suggestionFocusNode.dispose();
  }

  /// Called when user presses Enter on selected suggestion
  @protected
  void onSuggestionSelect();

  /// Called when user presses Escape
  @protected
  void onSuggestionClose();
}
