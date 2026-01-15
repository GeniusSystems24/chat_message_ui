import 'package:flutter/material.dart';

/// Theme configuration for floating suggestion cards.
///
/// This class provides comprehensive styling options for the floating
/// suggestion card, including colors, dimensions, typography, and animations.
///
/// Example:
/// ```dart
/// FloatingSuggestionTheme(
///   backgroundColor: Colors.white,
///   borderRadius: 16.0,
///   elevation: 8.0,
///   itemHoverColor: Colors.blue.withOpacity(0.1),
/// )
/// ```
class FloatingSuggestionTheme {
  // === Card Colors ===

  /// Background color of the suggestion card
  final Color backgroundColor;

  /// Border color of the card
  final Color borderColor;

  /// Shadow color for elevation
  final Color shadowColor;

  // === Header Colors ===

  /// Background color of the header section
  final Color headerBackgroundColor;

  /// Color of the header icon
  final Color headerIconColor;

  /// Color of the header title text
  final Color headerTitleColor;

  /// Color of the header subtitle text
  final Color headerSubtitleColor;

  // === Item Colors ===

  /// Background color of suggestion items
  final Color itemBackgroundColor;

  /// Background color when item is hovered
  final Color itemHoverColor;

  /// Background color when item is selected (keyboard navigation)
  final Color itemSelectedColor;

  /// Background color of item icons
  final Color itemIconBackgroundColor;

  /// Color of item title text
  final Color itemTitleColor;

  /// Color of item subtitle text
  final Color itemSubtitleColor;

  /// Color for highlighting matched text
  final Color highlightColor;

  /// Background color for highlighted text
  final Color highlightBackgroundColor;

  // === Dimensions ===

  /// Border radius of the card
  final double borderRadius;

  /// Border width of the card
  final double borderWidth;

  /// Elevation/shadow depth of the card
  final double elevation;

  /// Default height of each suggestion item
  final double itemHeight;

  /// Maximum height of the suggestion card
  final double maxHeight;

  /// Size of the header icon
  final double headerIconSize;

  /// Size of item icons
  final double itemIconSize;

  /// Border radius of item icons
  final double itemIconRadius;

  /// Divider thickness between items
  final double dividerThickness;

  // === Typography ===

  /// Text style for the header title
  final TextStyle? headerTitleStyle;

  /// Text style for the header subtitle
  final TextStyle? headerSubtitleStyle;

  /// Text style for item titles
  final TextStyle? itemTitleStyle;

  /// Text style for item subtitles
  final TextStyle? itemSubtitleStyle;

  /// Text style for empty state message
  final TextStyle? emptyStateStyle;

  /// Text style for loading state message
  final TextStyle? loadingStateStyle;

  // === Padding ===

  /// Padding around the entire card
  final EdgeInsets cardPadding;

  /// Padding inside the header
  final EdgeInsets headerPadding;

  /// Padding inside each item
  final EdgeInsets itemPadding;

  /// Padding for empty/loading states
  final EdgeInsets emptyStatePadding;

  // === Animation ===

  /// Duration of show/hide animations
  final Duration animationDuration;

  /// Curve for show/hide animations
  final Curve animationCurve;

  /// Duration of item hover animation
  final Duration hoverAnimationDuration;

  // === Behavior ===

  /// Whether to show dividers between items
  final bool showDividers;

  /// Whether to show the close button in header
  final bool showCloseButton;

  /// Whether to show item count in header
  final bool showItemCount;

  const FloatingSuggestionTheme({
    // Card colors
    this.backgroundColor = Colors.white,
    this.borderColor = const Color(0xFFE0E0E0),
    this.shadowColor = const Color(0x1A000000),
    // Header colors
    this.headerBackgroundColor = const Color(0xFFF8F9FA),
    this.headerIconColor = const Color(0xFF1976D2),
    this.headerTitleColor = const Color(0xFF212121),
    this.headerSubtitleColor = const Color(0xFF757575),
    // Item colors
    this.itemBackgroundColor = Colors.transparent,
    this.itemHoverColor = const Color(0xFFF5F5F5),
    this.itemSelectedColor = const Color(0xFFE3F2FD),
    this.itemIconBackgroundColor = const Color(0xFFE3F2FD),
    this.itemTitleColor = const Color(0xFF212121),
    this.itemSubtitleColor = const Color(0xFF757575),
    this.highlightColor = const Color(0xFF1976D2),
    this.highlightBackgroundColor = const Color(0xFFE3F2FD),
    // Dimensions
    this.borderRadius = 16.0,
    this.borderWidth = 1.0,
    this.elevation = 8.0,
    this.itemHeight = 56.0,
    this.maxHeight = 280.0,
    this.headerIconSize = 20.0,
    this.itemIconSize = 18.0,
    this.itemIconRadius = 20.0,
    this.dividerThickness = 0.5,
    // Typography
    this.headerTitleStyle,
    this.headerSubtitleStyle,
    this.itemTitleStyle,
    this.itemSubtitleStyle,
    this.emptyStateStyle,
    this.loadingStateStyle,
    // Padding
    this.cardPadding = EdgeInsets.zero,
    this.headerPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.emptyStatePadding = const EdgeInsets.all(24),
    // Animation
    this.animationDuration = const Duration(milliseconds: 200),
    this.animationCurve = Curves.easeOutCubic,
    this.hoverAnimationDuration = const Duration(milliseconds: 150),
    // Behavior
    this.showDividers = false,
    this.showCloseButton = true,
    this.showItemCount = false,
  });

  /// Light theme preset
  const FloatingSuggestionTheme.light() : this();

  /// Dark theme preset
  const FloatingSuggestionTheme.dark()
      : this(
          // Card colors
          backgroundColor: const Color(0xFF1E1E1E),
          borderColor: const Color(0xFF333333),
          shadowColor: const Color(0x40000000),
          // Header colors
          headerBackgroundColor: const Color(0xFF252525),
          headerIconColor: const Color(0xFF64B5F6),
          headerTitleColor: const Color(0xFFE0E0E0),
          headerSubtitleColor: const Color(0xFF9E9E9E),
          // Item colors
          itemBackgroundColor: Colors.transparent,
          itemHoverColor: const Color(0xFF2D2D2D),
          itemSelectedColor: const Color(0xFF1E3A5F),
          itemIconBackgroundColor: const Color(0xFF1E3A5F),
          itemTitleColor: const Color(0xFFFFFFFF),
          itemSubtitleColor: const Color(0xFFBDBDBD),
          highlightColor: const Color(0xFF64B5F6),
          highlightBackgroundColor: const Color(0xFF1E3A5F),
        );

  /// Create theme from Material [ThemeData]
  factory FloatingSuggestionTheme.fromThemeData(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return FloatingSuggestionTheme(
      backgroundColor: colorScheme.surface,
      borderColor: colorScheme.outlineVariant,
      shadowColor: isDark ? const Color(0x40000000) : const Color(0x1A000000),
      headerBackgroundColor: colorScheme.surfaceContainerHighest,
      headerIconColor: colorScheme.primary,
      headerTitleColor: colorScheme.onSurface,
      headerSubtitleColor: colorScheme.onSurfaceVariant,
      itemHoverColor: colorScheme.surfaceContainerHighest,
      itemSelectedColor: colorScheme.primaryContainer,
      itemIconBackgroundColor: colorScheme.primaryContainer,
      itemTitleColor: colorScheme.onSurface,
      itemSubtitleColor: colorScheme.onSurfaceVariant,
      highlightColor: colorScheme.primary,
      highlightBackgroundColor: colorScheme.primaryContainer,
    );
  }

  /// Copy with modifications
  FloatingSuggestionTheme copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? shadowColor,
    Color? headerBackgroundColor,
    Color? headerIconColor,
    Color? headerTitleColor,
    Color? headerSubtitleColor,
    Color? itemBackgroundColor,
    Color? itemHoverColor,
    Color? itemSelectedColor,
    Color? itemIconBackgroundColor,
    Color? itemTitleColor,
    Color? itemSubtitleColor,
    Color? highlightColor,
    Color? highlightBackgroundColor,
    double? borderRadius,
    double? borderWidth,
    double? elevation,
    double? itemHeight,
    double? maxHeight,
    double? headerIconSize,
    double? itemIconSize,
    double? itemIconRadius,
    double? dividerThickness,
    TextStyle? headerTitleStyle,
    TextStyle? headerSubtitleStyle,
    TextStyle? itemTitleStyle,
    TextStyle? itemSubtitleStyle,
    TextStyle? emptyStateStyle,
    TextStyle? loadingStateStyle,
    EdgeInsets? cardPadding,
    EdgeInsets? headerPadding,
    EdgeInsets? itemPadding,
    EdgeInsets? emptyStatePadding,
    Duration? animationDuration,
    Curve? animationCurve,
    Duration? hoverAnimationDuration,
    bool? showDividers,
    bool? showCloseButton,
    bool? showItemCount,
  }) {
    return FloatingSuggestionTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      shadowColor: shadowColor ?? this.shadowColor,
      headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor,
      headerIconColor: headerIconColor ?? this.headerIconColor,
      headerTitleColor: headerTitleColor ?? this.headerTitleColor,
      headerSubtitleColor: headerSubtitleColor ?? this.headerSubtitleColor,
      itemBackgroundColor: itemBackgroundColor ?? this.itemBackgroundColor,
      itemHoverColor: itemHoverColor ?? this.itemHoverColor,
      itemSelectedColor: itemSelectedColor ?? this.itemSelectedColor,
      itemIconBackgroundColor: itemIconBackgroundColor ?? this.itemIconBackgroundColor,
      itemTitleColor: itemTitleColor ?? this.itemTitleColor,
      itemSubtitleColor: itemSubtitleColor ?? this.itemSubtitleColor,
      highlightColor: highlightColor ?? this.highlightColor,
      highlightBackgroundColor: highlightBackgroundColor ?? this.highlightBackgroundColor,
      borderRadius: borderRadius ?? this.borderRadius,
      borderWidth: borderWidth ?? this.borderWidth,
      elevation: elevation ?? this.elevation,
      itemHeight: itemHeight ?? this.itemHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      headerIconSize: headerIconSize ?? this.headerIconSize,
      itemIconSize: itemIconSize ?? this.itemIconSize,
      itemIconRadius: itemIconRadius ?? this.itemIconRadius,
      dividerThickness: dividerThickness ?? this.dividerThickness,
      headerTitleStyle: headerTitleStyle ?? this.headerTitleStyle,
      headerSubtitleStyle: headerSubtitleStyle ?? this.headerSubtitleStyle,
      itemTitleStyle: itemTitleStyle ?? this.itemTitleStyle,
      itemSubtitleStyle: itemSubtitleStyle ?? this.itemSubtitleStyle,
      emptyStateStyle: emptyStateStyle ?? this.emptyStateStyle,
      loadingStateStyle: loadingStateStyle ?? this.loadingStateStyle,
      cardPadding: cardPadding ?? this.cardPadding,
      headerPadding: headerPadding ?? this.headerPadding,
      itemPadding: itemPadding ?? this.itemPadding,
      emptyStatePadding: emptyStatePadding ?? this.emptyStatePadding,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      hoverAnimationDuration: hoverAnimationDuration ?? this.hoverAnimationDuration,
      showDividers: showDividers ?? this.showDividers,
      showCloseButton: showCloseButton ?? this.showCloseButton,
      showItemCount: showItemCount ?? this.showItemCount,
    );
  }

  /// Linearly interpolate between two themes
  static FloatingSuggestionTheme lerp(
    FloatingSuggestionTheme? a,
    FloatingSuggestionTheme? b,
    double t,
  ) {
    if (a == null && b == null) return const FloatingSuggestionTheme();
    if (a == null) return b!;
    if (b == null) return a;

    return FloatingSuggestionTheme(
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t)!,
      borderColor: Color.lerp(a.borderColor, b.borderColor, t)!,
      shadowColor: Color.lerp(a.shadowColor, b.shadowColor, t)!,
      headerBackgroundColor: Color.lerp(a.headerBackgroundColor, b.headerBackgroundColor, t)!,
      headerIconColor: Color.lerp(a.headerIconColor, b.headerIconColor, t)!,
      headerTitleColor: Color.lerp(a.headerTitleColor, b.headerTitleColor, t)!,
      headerSubtitleColor: Color.lerp(a.headerSubtitleColor, b.headerSubtitleColor, t)!,
      itemBackgroundColor: Color.lerp(a.itemBackgroundColor, b.itemBackgroundColor, t)!,
      itemHoverColor: Color.lerp(a.itemHoverColor, b.itemHoverColor, t)!,
      itemSelectedColor: Color.lerp(a.itemSelectedColor, b.itemSelectedColor, t)!,
      itemIconBackgroundColor: Color.lerp(a.itemIconBackgroundColor, b.itemIconBackgroundColor, t)!,
      itemTitleColor: Color.lerp(a.itemTitleColor, b.itemTitleColor, t)!,
      itemSubtitleColor: Color.lerp(a.itemSubtitleColor, b.itemSubtitleColor, t)!,
      highlightColor: Color.lerp(a.highlightColor, b.highlightColor, t)!,
      highlightBackgroundColor: Color.lerp(a.highlightBackgroundColor, b.highlightBackgroundColor, t)!,
      borderRadius: lerpDouble(a.borderRadius, b.borderRadius, t)!,
      borderWidth: lerpDouble(a.borderWidth, b.borderWidth, t)!,
      elevation: lerpDouble(a.elevation, b.elevation, t)!,
      itemHeight: lerpDouble(a.itemHeight, b.itemHeight, t)!,
      maxHeight: lerpDouble(a.maxHeight, b.maxHeight, t)!,
      headerIconSize: lerpDouble(a.headerIconSize, b.headerIconSize, t)!,
      itemIconSize: lerpDouble(a.itemIconSize, b.itemIconSize, t)!,
      itemIconRadius: lerpDouble(a.itemIconRadius, b.itemIconRadius, t)!,
      dividerThickness: lerpDouble(a.dividerThickness, b.dividerThickness, t)!,
      headerPadding: EdgeInsets.lerp(a.headerPadding, b.headerPadding, t)!,
      itemPadding: EdgeInsets.lerp(a.itemPadding, b.itemPadding, t)!,
      emptyStatePadding: EdgeInsets.lerp(a.emptyStatePadding, b.emptyStatePadding, t)!,
      animationDuration: t < 0.5 ? a.animationDuration : b.animationDuration,
      animationCurve: t < 0.5 ? a.animationCurve : b.animationCurve,
      hoverAnimationDuration: t < 0.5 ? a.hoverAnimationDuration : b.hoverAnimationDuration,
      showDividers: t < 0.5 ? a.showDividers : b.showDividers,
      showCloseButton: t < 0.5 ? a.showCloseButton : b.showCloseButton,
      showItemCount: t < 0.5 ? a.showItemCount : b.showItemCount,
    );
  }
}

/// Helper function for lerp
double? lerpDouble(double? a, double? b, double t) {
  if (a == null && b == null) return null;
  a ??= 0.0;
  b ??= 0.0;
  return a + (b - a) * t;
}
