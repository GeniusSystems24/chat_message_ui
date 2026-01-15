/// Floating Suggestion System
///
/// A comprehensive, customizable suggestion system for chat input fields.
///
/// ## Features
/// - Multiple suggestion types (mentions, hashtags, commands, custom)
/// - Full theme customization
/// - Keyboard navigation support
/// - Text highlighting for matches
/// - Loading and empty states
/// - Smooth animations
///
/// ## Usage
///
/// ```dart
/// // Basic usage with built-in type
/// EnhancedFloatingSuggestionCard<User>(
///   query: '@john',
///   typeConfig: FloatingSuggestionTypes.username,
///   suggestions: userSuggestions,
///   onSelected: (item) => insertMention(item.value),
/// )
///
/// // Custom type
/// final customType = FloatingSuggestionTypes.custom(
///   symbol: '!',
///   displayName: 'Commands',
///   icon: Icons.terminal,
/// );
///
/// // Custom theme
/// final customTheme = FloatingSuggestionTheme(
///   backgroundColor: Colors.grey[900]!,
///   highlightColor: Colors.amber,
///   borderRadius: 12.0,
/// );
/// ```
library;

export 'floating_suggestion_card_new.dart';
export 'floating_suggestion_config.dart';
export 'floating_suggestion_controller.dart';
export 'floating_suggestion_header.dart';
export 'floating_suggestion_item_widget.dart';
export 'floating_suggestion_models.dart';
export 'floating_suggestion_theme.dart';
