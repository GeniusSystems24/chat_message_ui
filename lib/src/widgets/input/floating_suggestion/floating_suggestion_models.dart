import 'package:flutter/widgets.dart';

import 'floating_suggestion_config.dart';

/// Data model for a suggestion item.
///
/// This is the enhanced version of the suggestion item with more options
/// for customization and display.
///
/// Example:
/// ```dart
/// final item = FloatingSuggestionItemData<User>(
///   value: user,
///   label: user.name,
///   subtitle: '@${user.username}',
///   imageUrl: user.avatarUrl,
///   typeConfig: FloatingSuggestionTypes.username,
/// );
/// ```
class FloatingSuggestionItemData<T> {
  /// The actual value/data this item represents
  final T value;

  /// Display label (primary text)
  final String label;

  /// Optional subtitle (secondary text)
  final String? subtitle;

  /// Optional custom icon widget
  final Widget? icon;

  /// Optional image URL for avatar/thumbnail
  final String? imageUrl;

  /// Optional trailing widget (e.g., badge, status)
  final Widget? trailing;

  /// The type configuration for this suggestion
  final SuggestionTypeConfig typeConfig;

  /// Optional metadata for custom use
  final Map<String, dynamic>? metadata;

  /// Whether this item is enabled/selectable
  final bool enabled;

  /// Optional search keywords for better filtering
  final List<String>? searchKeywords;

  const FloatingSuggestionItemData({
    required this.value,
    required this.label,
    required this.typeConfig,
    this.subtitle,
    this.icon,
    this.imageUrl,
    this.trailing,
    this.metadata,
    this.enabled = true,
    this.searchKeywords,
  });

  /// Create a copy with modifications
  FloatingSuggestionItemData<T> copyWith({
    T? value,
    String? label,
    String? subtitle,
    Widget? icon,
    String? imageUrl,
    Widget? trailing,
    SuggestionTypeConfig? typeConfig,
    Map<String, dynamic>? metadata,
    bool? enabled,
    List<String>? searchKeywords,
  }) {
    return FloatingSuggestionItemData<T>(
      value: value ?? this.value,
      label: label ?? this.label,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      imageUrl: imageUrl ?? this.imageUrl,
      trailing: trailing ?? this.trailing,
      typeConfig: typeConfig ?? this.typeConfig,
      metadata: metadata ?? this.metadata,
      enabled: enabled ?? this.enabled,
      searchKeywords: searchKeywords ?? this.searchKeywords,
    );
  }

  /// Get all searchable text for filtering
  List<String> get searchableText {
    return [
      label,
      if (subtitle != null) subtitle!,
      ...?searchKeywords,
    ];
  }

  /// Check if this item matches a query
  bool matches(String query) {
    if (query.isEmpty) return true;

    final lowerQuery = query.toLowerCase();
    return searchableText.any(
      (text) => text.toLowerCase().contains(lowerQuery),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FloatingSuggestionItemData &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          label == other.label;

  @override
  int get hashCode => Object.hash(value, label);

  @override
  String toString() => 'FloatingSuggestionItemData(label: $label, value: $value)';
}

/// Factory methods for creating suggestion items from common data types
extension FloatingSuggestionItemFactory on FloatingSuggestionItemData {
  /// Create from a user/mention
  static FloatingSuggestionItemData<T> fromUser<T>({
    required T value,
    required String name,
    String? username,
    String? imageUrl,
    String? role,
    SuggestionTypeConfig? typeConfig,
  }) {
    return FloatingSuggestionItemData<T>(
      value: value,
      label: name,
      subtitle: username != null ? '@$username' : role,
      imageUrl: imageUrl,
      typeConfig: typeConfig ?? FloatingSuggestionTypes.username,
      searchKeywords: [if (username != null) username, if (role != null) role],
    );
  }

  /// Create from a hashtag
  static FloatingSuggestionItemData<T> fromHashtag<T>({
    required T value,
    required String hashtag,
    int? usageCount,
    SuggestionTypeConfig? typeConfig,
  }) {
    return FloatingSuggestionItemData<T>(
      value: value,
      label: '#$hashtag',
      subtitle: usageCount != null ? '$usageCount uses' : null,
      typeConfig: typeConfig ?? FloatingSuggestionTypes.hashtag,
    );
  }

  /// Create from a command/quick reply
  static FloatingSuggestionItemData<T> fromCommand<T>({
    required T value,
    required String command,
    String? description,
    SuggestionTypeConfig? typeConfig,
  }) {
    return FloatingSuggestionItemData<T>(
      value: value,
      label: '/$command',
      subtitle: description,
      typeConfig: typeConfig ?? FloatingSuggestionTypes.quickReply,
    );
  }
}

/// Result of a suggestion selection
class SuggestionSelectionResult<T> {
  /// The selected item
  final FloatingSuggestionItemData<T> item;

  /// The text to insert
  final String insertText;

  /// Whether to close the suggestions after selection
  final bool closeAfterSelection;

  const SuggestionSelectionResult({
    required this.item,
    required this.insertText,
    this.closeAfterSelection = true,
  });
}

/// Callback type for suggestion selection
typedef OnSuggestionSelected<T> = void Function(FloatingSuggestionItemData<T> item);

/// Callback type for providing suggestions
typedef SuggestionProvider<T> = Future<List<FloatingSuggestionItemData<T>>> Function(
  String query,
  SuggestionTypeConfig typeConfig,
);

/// Filter function type
typedef SuggestionFilter<T> = bool Function(
  FloatingSuggestionItemData<T> item,
  String query,
);

/// Default filter that matches against label and subtitle
bool defaultSuggestionFilter<T>(
  FloatingSuggestionItemData<T> item,
  String query,
) {
  return item.matches(query);
}
