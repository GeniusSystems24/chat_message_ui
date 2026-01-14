import 'input_models.dart';

/// Enhanced ChatInputWidget settings
class ChatInputConfig {
  /// Default usernames list
  static List<String> get defaultUsernames => [
        'alex',
        'maya',
        'sam',
        'lina',
        'omar',
        'noor',
        'yousef',
        'sara',
        'ali',
        'nora',
      ];

  /// Default hashtags list
  static List<Hashtag> get defaultHashtags => [
        Hashtag(id: '1', hashtag: 'news'),
        Hashtag(id: '2', hashtag: 'events'),
        Hashtag(id: '3', hashtag: 'announcements'),
        Hashtag(id: '4', hashtag: 'meetup'),
        Hashtag(id: '5', hashtag: 'support'),
        Hashtag(id: '6', hashtag: 'urgent'),
        Hashtag(id: '7', hashtag: 'updates'),
        Hashtag(id: '8', hashtag: 'schedule'),
        Hashtag(id: '9', hashtag: 'general'),
        Hashtag(id: '10', hashtag: 'welcome'),
        Hashtag(id: '11', hashtag: 'questions'),
        Hashtag(id: '12', hashtag: 'feedback'),
        Hashtag(id: '13', hashtag: 'ideas'),
        Hashtag(id: '14', hashtag: 'help'),
        Hashtag(id: '15', hashtag: 'random'),
      ];

  /// Default quick replies list
  static List<QuickReply> get defaultQuickReplies => [
        QuickReply(
            id: '1', command: 'hello', response: 'Hello! How can I help?'),
        QuickReply(
            id: '2', command: 'thanks', response: 'Thanks for the update.'),
        QuickReply(id: '3', command: 'ok', response: 'Got it.'),
        QuickReply(id: '4', command: 'on_it', response: 'On it.'),
        QuickReply(id: '5', command: 'brb', response: 'Be right back.'),
        QuickReply(id: '6', command: 'meeting', response: 'In a meeting now.'),
        QuickReply(
            id: '7', command: 'later', response: 'Let me get back to you.'),
        QuickReply(id: '8', command: 'welcome', response: 'Welcome aboard!'),
        QuickReply(
            id: '9', command: 'review', response: 'I will review and reply.'),
        QuickReply(id: '10', command: 'done', response: 'Done.'),
        QuickReply(
            id: '11',
            command: 'need_info',
            response: 'Need more info to proceed.'),
        QuickReply(
            id: '12', command: 'call', response: 'Can we jump on a call?'),
        QuickReply(
            id: '13', command: 'sorry', response: 'Sorry for the delay.'),
      ];

  /// Generate username suggestions
  static Future<List<FloatingSuggestionItem<ChatUserSuggestion>>>
      generateUsernameSuggestions(
          String query, List<ChatUserSuggestion> usernames) async {
    final cleanQuery = query.startsWith('@') ? query.substring(1) : query;

    final filteredUsernames = usernames
        .where(
          (username) =>
              cleanQuery.isEmpty ||
              (username.name.toLowerCase().contains(
                    cleanQuery.toLowerCase(),
                  )),
        )
        .take(10)
        .toList();

    return filteredUsernames
        .map(
          (username) => FloatingSuggestionItem<ChatUserSuggestion>(
            value: username,
            label: username.name,
            subtitle: username.mentionText,
            type: FloatingSuggestionType.username,
          ),
        )
        .toList();
  }

  /// Generate hashtag suggestions
  static Future<List<FloatingSuggestionItem<Hashtag>>>
      generateHashtagSuggestions(
    String query,
    List<Hashtag>? customHashtags,
  ) async {
    final cleanQuery = query.startsWith('#') ? query.substring(1) : query;
    final hashtags = customHashtags ?? defaultHashtags;

    final filteredHashtags = hashtags
        .where(
          (hashtag) =>
              cleanQuery.isEmpty ||
              hashtag.hashtag.toLowerCase().contains(cleanQuery.toLowerCase()),
        )
        .take(10)
        .toList();

    return filteredHashtags
        .map(
          (hashtag) => FloatingSuggestionItem<Hashtag>(
            value: hashtag,
            label: '#${hashtag.hashtag}',
            type: FloatingSuggestionType.hashtag,
          ),
        )
        .toList();
  }

  /// Generate quick reply suggestions
  static Future<List<FloatingSuggestionItem<QuickReply>>>
      generateQuickReplySuggestions(
    String query,
    List<QuickReply>? customReplies,
  ) async {
    final cleanQuery = query.startsWith('/') ? query.substring(1) : query;
    final replies = customReplies ?? defaultQuickReplies;

    final filteredReplies = replies
        .where(
          (reply) =>
              cleanQuery.isEmpty ||
              reply.command.toLowerCase().contains(cleanQuery.toLowerCase()),
        )
        .take(10)
        .toList();

    return filteredReplies
        .map(
          (reply) => FloatingSuggestionItem<QuickReply>(
            value: reply,
            label: '/${reply.command}',
            subtitle: reply.response,
            type: FloatingSuggestionType.quickReply,
          ),
        )
        .toList();
  }
}

/// Helper for creating suggestion providers easily
class SuggestionProviderHelper {
  /// Create username suggestions provider using fixed list
  static Future<List<FloatingSuggestionItem<ChatUserSuggestion>>> Function(
      String) createUsernameProvider(List<ChatUserSuggestion> usernames) {
    return (String query) =>
        ChatInputConfig.generateUsernameSuggestions(query, usernames);
  }

  /// Create hashtag suggestions provider using custom list
  static Future<List<FloatingSuggestionItem<Hashtag>>> Function(String)
      createHashtagProvider([List<Hashtag>? customHashtags]) {
    return (String query) =>
        ChatInputConfig.generateHashtagSuggestions(query, customHashtags);
  }

  /// Create quick reply suggestions provider using custom list
  static Future<List<FloatingSuggestionItem<QuickReply>>> Function(String)
      createQuickReplyProvider([List<QuickReply>? customReplies]) {
    return (String query) =>
        ChatInputConfig.generateQuickReplySuggestions(query, customReplies);
  }
}
