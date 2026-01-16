import 'package:flutter/widgets.dart';

import 'floating_suggestion/floating_suggestion.dart';

// Re-export new suggestion system for convenience
export 'floating_suggestion/floating_suggestion.dart';

/// Suggestion type in floating card
///
/// @Deprecated: Consider using [SuggestionTypeConfig] and [FloatingSuggestionTypes]
/// for more customization options.
enum FloatingSuggestionType {
  username(symbol: '@'),
  hashtag(symbol: '#'),
  quickReply(symbol: '/'),
  clubChatTask(symbol: '\$');

  final String symbol;
  const FloatingSuggestionType({required this.symbol});

  /// Convert to new [SuggestionTypeConfig]
  SuggestionTypeConfig toConfig() {
    switch (this) {
      case FloatingSuggestionType.username:
        return FloatingSuggestionTypes.username;
      case FloatingSuggestionType.hashtag:
        return FloatingSuggestionTypes.hashtag;
      case FloatingSuggestionType.quickReply:
        return FloatingSuggestionTypes.quickReply;
      case FloatingSuggestionType.clubChatTask:
        return FloatingSuggestionTypes.task;
    }
  }
}

/// Suggestion item in floating card
///
/// This is the legacy item class. For new implementations, consider using
/// [FloatingSuggestionItemData] which provides more options.
class FloatingSuggestionItem<T> {
  final T value;
  final String label;
  final String? subtitle;
  final Widget? icon;
  final FloatingSuggestionType type;

  FloatingSuggestionItem({
    required this.value,
    required this.label,
    this.subtitle,
    this.icon,
    required this.type,
  });

  /// Convert to new [FloatingSuggestionItemData]
  FloatingSuggestionItemData<T> toItemData() {
    return FloatingSuggestionItemData<T>(
      value: value,
      label: label,
      subtitle: subtitle,
      icon: icon,
      typeConfig: type.toConfig(),
    );
  }
}

/// Data model for mention suggestions
class ChatUserSuggestion {
  final String id;
  final String name;
  final String? username;
  final String? imageUrl;
  final String? role;

  const ChatUserSuggestion({
    required this.id,
    required this.name,
    this.username,
    this.imageUrl,
    this.role,
  });

  String get mentionText => '@${username ?? id}';

  /// Convert to [FloatingSuggestionItemData]
  FloatingSuggestionItemData<ChatUserSuggestion> toSuggestionItem() {
    return FloatingSuggestionItemData<ChatUserSuggestion>(
      value: this,
      label: name,
      subtitle: username != null ? '@$username' : role,
      imageUrl: imageUrl,
      typeConfig: FloatingSuggestionTypes.username,
      searchKeywords: [if (username != null) username!, if (role != null) role!],
    );
  }
}

/// Quick reply model
class QuickReply {
  final Map<String, dynamic> data;

  String get id => data['id'] as String;
  set id(String value) => data['id'] = value;

  String get command => data['command'] as String;
  set command(String value) => data['command'] = value;

  String get response => data['response'] as String;
  set response(String value) => data['response'] = value;

  QuickReply({
    required String id,
    required String command,
    required String response,
  }) : data = {'id': id, 'command': command, 'response': response};

  QuickReply.fromMap(this.data);

  Map<String, dynamic> toMap() => data;

  /// Convert to [FloatingSuggestionItemData]
  FloatingSuggestionItemData<QuickReply> toSuggestionItem() {
    return FloatingSuggestionItemData<QuickReply>(
      value: this,
      label: '/$command',
      subtitle: response,
      typeConfig: FloatingSuggestionTypes.quickReply,
    );
  }

  @override
  String toString() =>
      'QuickReply(id: $id, command: $command, response: $response)';

  @override
  bool operator ==(Object other) =>
      other is QuickReply && other.hashCode == hashCode;

  @override
  int get hashCode => id.hashCode;
}

/// Hashtag model
class Hashtag {
  final Map<String, dynamic> data;

  String get id => data['id'] as String;
  set id(String value) => data['id'] = value;

  String get hashtag => data['hashtag'] as String;
  set hashtag(String value) => data['hashtag'] = value;

  Hashtag({required String id, required String hashtag})
      : data = {'id': id, 'hashtag': hashtag};

  Hashtag.fromMap(this.data);

  Map<String, dynamic> toMap() => data;

  /// Convert to [FloatingSuggestionItemData]
  FloatingSuggestionItemData<Hashtag> toSuggestionItem() {
    return FloatingSuggestionItemData<Hashtag>(
      value: this,
      label: '#$hashtag',
      typeConfig: FloatingSuggestionTypes.hashtag,
    );
  }

  @override
  String toString() => 'Hashtag(id: $id, hashtag: $hashtag)';

  @override
  bool operator ==(Object other) =>
      other is Hashtag && other.hashCode == hashCode;

  @override
  int get hashCode => id.hashCode;
}
