import 'package:flutter/material.dart';

/// Theme configuration for search highlight styling in chat messages.
class SearchHighlightTheme {
  /// Background color for highlighted matching text.
  final Color highlightColor;

  /// Text color for highlighted matching text.
  final Color highlightTextColor;

  /// Background color for the current active match (darker than others).
  final Color currentMatchColor;

  /// Text color for the current active match.
  final Color currentMatchTextColor;

  /// Background color for the search bar.
  final Color barBackgroundColor;

  /// Border color for the search bar.
  final Color barBorderColor;

  /// Color for navigation arrows.
  final Color arrowColor;

  /// Color for disabled navigation arrows.
  final Color arrowDisabledColor;

  /// Color for the close button.
  final Color closeButtonColor;

  /// Text style for the match count (e.g., "3 of 15").
  final TextStyle countTextStyle;

  /// Text style for search input.
  final TextStyle inputTextStyle;

  /// Hint text style for search input.
  final TextStyle hintTextStyle;

  /// Creates a new [SearchHighlightTheme] instance.
  const SearchHighlightTheme({
    required this.highlightColor,
    required this.highlightTextColor,
    required this.currentMatchColor,
    required this.currentMatchTextColor,
    required this.barBackgroundColor,
    required this.barBorderColor,
    required this.arrowColor,
    required this.arrowDisabledColor,
    required this.closeButtonColor,
    required this.countTextStyle,
    required this.inputTextStyle,
    required this.hintTextStyle,
  });

  /// Light theme for search highlighting.
  const SearchHighlightTheme.light()
      : highlightColor = const Color(0xFFFFEB3B), // Yellow
        highlightTextColor = const Color(0xFF000000),
        currentMatchColor = const Color(0xFFFF9800), // Orange for current
        currentMatchTextColor = const Color(0xFF000000),
        barBackgroundColor = const Color(0xFFF5F5F5),
        barBorderColor = const Color(0xFFE0E0E0),
        arrowColor = const Color(0xFF616161),
        arrowDisabledColor = const Color(0xFFBDBDBD),
        closeButtonColor = const Color(0xFF616161),
        countTextStyle = const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF757575),
        ),
        inputTextStyle = const TextStyle(
          fontSize: 16,
          color: Color(0xFF212121),
        ),
        hintTextStyle = const TextStyle(
          fontSize: 16,
          color: Color(0xFF9E9E9E),
        );

  /// Dark theme for search highlighting.
  const SearchHighlightTheme.dark()
      : highlightColor = const Color(0xFFFFD54F), // Lighter yellow for dark
        highlightTextColor = const Color(0xFF000000),
        currentMatchColor = const Color(0xFFFFB74D), // Lighter orange for dark
        currentMatchTextColor = const Color(0xFF000000),
        barBackgroundColor = const Color(0xFF2C2C2C),
        barBorderColor = const Color(0xFF424242),
        arrowColor = const Color(0xFFB0B0B0),
        arrowDisabledColor = const Color(0xFF616161),
        closeButtonColor = const Color(0xFFB0B0B0),
        countTextStyle = const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF9E9E9E),
        ),
        inputTextStyle = const TextStyle(
          fontSize: 16,
          color: Color(0xFFE0E0E0),
        ),
        hintTextStyle = const TextStyle(
          fontSize: 16,
          color: Color(0xFF757575),
        );

  /// Creates a copy of [SearchHighlightTheme] with updated values.
  SearchHighlightTheme copyWith({
    Color? highlightColor,
    Color? highlightTextColor,
    Color? currentMatchColor,
    Color? currentMatchTextColor,
    Color? barBackgroundColor,
    Color? barBorderColor,
    Color? arrowColor,
    Color? arrowDisabledColor,
    Color? closeButtonColor,
    TextStyle? countTextStyle,
    TextStyle? inputTextStyle,
    TextStyle? hintTextStyle,
  }) {
    return SearchHighlightTheme(
      highlightColor: highlightColor ?? this.highlightColor,
      highlightTextColor: highlightTextColor ?? this.highlightTextColor,
      currentMatchColor: currentMatchColor ?? this.currentMatchColor,
      currentMatchTextColor:
          currentMatchTextColor ?? this.currentMatchTextColor,
      barBackgroundColor: barBackgroundColor ?? this.barBackgroundColor,
      barBorderColor: barBorderColor ?? this.barBorderColor,
      arrowColor: arrowColor ?? this.arrowColor,
      arrowDisabledColor: arrowDisabledColor ?? this.arrowDisabledColor,
      closeButtonColor: closeButtonColor ?? this.closeButtonColor,
      countTextStyle: countTextStyle ?? this.countTextStyle,
      inputTextStyle: inputTextStyle ?? this.inputTextStyle,
      hintTextStyle: hintTextStyle ?? this.hintTextStyle,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SearchHighlightTheme &&
        other.highlightColor == highlightColor &&
        other.highlightTextColor == highlightTextColor &&
        other.currentMatchColor == currentMatchColor &&
        other.currentMatchTextColor == currentMatchTextColor &&
        other.barBackgroundColor == barBackgroundColor &&
        other.barBorderColor == barBorderColor &&
        other.arrowColor == arrowColor &&
        other.arrowDisabledColor == arrowDisabledColor &&
        other.closeButtonColor == closeButtonColor &&
        other.countTextStyle == countTextStyle &&
        other.inputTextStyle == inputTextStyle &&
        other.hintTextStyle == hintTextStyle;
  }

  @override
  int get hashCode => Object.hash(
        highlightColor,
        highlightTextColor,
        currentMatchColor,
        currentMatchTextColor,
        barBackgroundColor,
        barBorderColor,
        arrowColor,
        arrowDisabledColor,
        closeButtonColor,
        countTextStyle,
        inputTextStyle,
        hintTextStyle,
      );
}
