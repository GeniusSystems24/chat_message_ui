import 'package:flutter/widgets.dart';
// Wait, map_extension is project specific. I need to remove this dependency.
// I will implement helper methods or use standard map access.

/// Suggestion type in floating card
enum FloatingSuggestionType {
  username(symbol: '@'),
  hashtag(symbol: '#'),
  quickReply(symbol: '/'),
  clubChatTask(symbol: '\$');

  final String symbol;
  const FloatingSuggestionType({required this.symbol});
}

/// Suggestion item in floating card
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

  @override
  String toString() => 'Hashtag(id: $id, hashtag: $hashtag)';

  @override
  bool operator ==(Object other) =>
      other is Hashtag && other.hashCode == hashCode;

  @override
  int get hashCode => id.hashCode;
}

// Placeholder for ClubChatTaskModel if needed, or use dynamic/T
// I'll leave it out or define a basic one if used by Type enum.
// It is used in FloatingSuggestionType.clubChatTask.
