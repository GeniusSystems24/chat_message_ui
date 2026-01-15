import 'package:flutter/material.dart';

/// Configuration for a suggestion type.
///
/// This class defines how a suggestion type should be displayed and behave.
/// You can use built-in types from [FloatingSuggestionTypes] or create custom ones.
///
/// Example:
/// ```dart
/// final customType = SuggestionTypeConfig(
///   symbol: '!',
///   displayName: 'Commands',
///   icon: Icons.terminal,
///   color: Colors.purple,
/// );
/// ```
class SuggestionTypeConfig {
  /// The trigger symbol (e.g., '@', '#', '/')
  final String symbol;

  /// Display name for the suggestion type
  final String displayName;

  /// Icon for the suggestion type
  final IconData icon;

  /// Primary color for the type (used for icons, highlights)
  final Color? color;

  /// Title shown in the suggestion card header
  final String? headerTitle;

  /// Subtitle shown in the header (optional)
  final String? headerSubtitle;

  /// Default item height
  final double itemHeight;

  /// Maximum card height
  final double maxHeight;

  /// Custom icon builder for items without explicit icons
  final Widget Function(BuildContext context, Color color)? defaultItemIconBuilder;

  /// Whether to show avatars for this type (useful for user mentions)
  final bool showAvatars;

  /// Whether to highlight matching text
  final bool highlightMatches;

  const SuggestionTypeConfig({
    required this.symbol,
    required this.displayName,
    required this.icon,
    this.color,
    this.headerTitle,
    this.headerSubtitle,
    this.itemHeight = 56.0,
    this.maxHeight = 280.0,
    this.defaultItemIconBuilder,
    this.showAvatars = false,
    this.highlightMatches = true,
  });

  /// Get the header title (falls back to displayName)
  String get title => headerTitle ?? displayName;

  /// Copy with modifications
  SuggestionTypeConfig copyWith({
    String? symbol,
    String? displayName,
    IconData? icon,
    Color? color,
    String? headerTitle,
    String? headerSubtitle,
    double? itemHeight,
    double? maxHeight,
    Widget Function(BuildContext context, Color color)? defaultItemIconBuilder,
    bool? showAvatars,
    bool? highlightMatches,
  }) {
    return SuggestionTypeConfig(
      symbol: symbol ?? this.symbol,
      displayName: displayName ?? this.displayName,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      headerTitle: headerTitle ?? this.headerTitle,
      headerSubtitle: headerSubtitle ?? this.headerSubtitle,
      itemHeight: itemHeight ?? this.itemHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      defaultItemIconBuilder: defaultItemIconBuilder ?? this.defaultItemIconBuilder,
      showAvatars: showAvatars ?? this.showAvatars,
      highlightMatches: highlightMatches ?? this.highlightMatches,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SuggestionTypeConfig &&
          runtimeType == other.runtimeType &&
          symbol == other.symbol;

  @override
  int get hashCode => symbol.hashCode;
}

/// Built-in suggestion types.
///
/// Use these pre-configured types or create your own using [SuggestionTypeConfig].
abstract class FloatingSuggestionTypes {
  /// Username/mention suggestions (@)
  static const username = SuggestionTypeConfig(
    symbol: '@',
    displayName: 'Mentions',
    icon: Icons.alternate_email_rounded,
    headerTitle: 'Mention someone',
    headerSubtitle: 'Type to search users',
    showAvatars: true,
    itemHeight: 58.0,
  );

  /// Hashtag suggestions (#)
  static const hashtag = SuggestionTypeConfig(
    symbol: '#',
    displayName: 'Hashtags',
    icon: Icons.tag_rounded,
    headerTitle: 'Add hashtag',
    headerSubtitle: 'Type to search tags',
  );

  /// Quick reply/command suggestions (/)
  static const quickReply = SuggestionTypeConfig(
    symbol: '/',
    displayName: 'Commands',
    icon: Icons.flash_on_rounded,
    headerTitle: 'Quick commands',
    headerSubtitle: 'Type to search commands',
  );

  /// Task suggestions ($)
  static const task = SuggestionTypeConfig(
    symbol: '\$',
    displayName: 'Tasks',
    icon: Icons.task_alt_rounded,
    headerTitle: 'Link task',
    headerSubtitle: 'Type to search tasks',
  );

  /// Create a custom suggestion type
  static SuggestionTypeConfig custom({
    required String symbol,
    required String displayName,
    required IconData icon,
    Color? color,
    String? headerTitle,
    String? headerSubtitle,
    double itemHeight = 56.0,
    double maxHeight = 280.0,
    bool showAvatars = false,
    bool highlightMatches = true,
  }) {
    return SuggestionTypeConfig(
      symbol: symbol,
      displayName: displayName,
      icon: icon,
      color: color,
      headerTitle: headerTitle,
      headerSubtitle: headerSubtitle,
      itemHeight: itemHeight,
      maxHeight: maxHeight,
      showAvatars: showAvatars,
      highlightMatches: highlightMatches,
    );
  }

  /// Get config from legacy FloatingSuggestionType enum
  static SuggestionTypeConfig fromLegacyType(FloatingSuggestionType type) {
    switch (type) {
      case FloatingSuggestionType.username:
        return username;
      case FloatingSuggestionType.hashtag:
        return hashtag;
      case FloatingSuggestionType.quickReply:
        return quickReply;
      case FloatingSuggestionType.clubChatTask:
        return task;
    }
  }
}

/// Legacy suggestion type enum (kept for backward compatibility)
@Deprecated('Use SuggestionTypeConfig instead')
enum FloatingSuggestionType {
  username(symbol: '@'),
  hashtag(symbol: '#'),
  quickReply(symbol: '/'),
  clubChatTask(symbol: '\$');

  final String symbol;
  const FloatingSuggestionType({required this.symbol});

  /// Convert to new config
  SuggestionTypeConfig get config => FloatingSuggestionTypes.fromLegacyType(this);
}
