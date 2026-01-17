import 'package:flutter/material.dart';
import 'package:super_interactive_text/super_interactive_text.dart';

import '../theme/chat_theme.dart';
import '../adapters/adapters.dart';
import '../config/chat_message_ui_config.dart';
import 'attachment_builder.dart';
import 'bubble_builders.dart';
import 'contact/contact_bubble.dart';

/// Widget for building message content (text + attachments).
///
/// This widget uses [IChatMessageData] interface to support multiple
/// data sources transparently.
class MessageContentBuilder extends StatelessWidget {
  final IChatMessageData message;
  final ChatThemeData chatTheme;
  final bool isMyMessage;
  final String currentUserId;
  final Function(RouteTextData)? onRouteTap;
  final Function(LinkTextData)? onLinkTap;
  final Function(EmailTextData)? onEmailTap;
  final Function(PhoneNumberTextData)? onPhoneTap;
  final VoidCallback? onAttachmentTap;
  final Function(String optionId)? onPollVote;
  final Widget Function(ChatMediaData media)? customAttachmentBuilder;
  final ChatAutoDownloadConfig? autoDownloadConfig;
  final BubbleBuilders? bubbleBuilders;

  /// Current search query to highlight.
  final String? searchQuery;

  /// Whether this message is the current search match.
  final bool isCurrentSearchMatch;

  const MessageContentBuilder({
    super.key,
    required this.message,
    required this.chatTheme,
    required this.isMyMessage,
    required this.currentUserId,
    this.onRouteTap,
    this.onLinkTap,
    this.onEmailTap,
    this.onPhoneTap,
    this.onAttachmentTap,
    this.onPollVote,
    this.customAttachmentBuilder,
    this.autoDownloadConfig,
    this.bubbleBuilders,
    this.searchQuery,
    this.isCurrentSearchMatch = false,
  });

  /// Creates a builder context for custom builders.
  BubbleBuilderContext _createBuilderContext() {
    return BubbleBuilderContext(
      message: message,
      chatTheme: chatTheme,
      isMyMessage: isMyMessage,
      currentUserId: currentUserId,
      onTap: onAttachmentTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final text = message.textContent ?? '';
    final hasText = text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message.type == ChatMessageType.contact &&
            message.contactData != null)
          _buildContactBubble(context)
        else if (message.type != ChatMessageType.text)
          AttachmentBuilder(
            message: message,
            chatTheme: chatTheme,
            isMyMessage: isMyMessage,
            currentUserId: currentUserId,
            onTap: onAttachmentTap,
            customBuilder: customAttachmentBuilder,
            autoDownloadConfig: autoDownloadConfig,
            onPollVote: onPollVote,
            bubbleBuilders: bubbleBuilders,
          ),
        if (hasText) _buildTextContent(context, text),
      ],
    );
  }

  /// Builds the contact bubble, using custom builder if provided.
  Widget _buildContactBubble(BuildContext context) {
    final contactBuilder = bubbleBuilders?.contactBubbleBuilder;
    if (contactBuilder != null && message.contactData != null) {
      return contactBuilder(
        context,
        _createBuilderContext(),
        message.contactData!,
      );
    }

    return ContactBubble(
      contact: message.contactData!,
      isMyMessage: isMyMessage,
      backgroundColor: isMyMessage
          ? chatTheme.colors.primary.withValues(alpha: 0.1)
          : chatTheme.colors.surfaceContainerHigh,
      textColor: chatTheme.colors.onSurface,
    );
  }

  /// Builds the text content of the message.
  Widget _buildTextContent(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: chatTheme.messageBubble.contentPadding,
        vertical: chatTheme.messageBubble.contentVerticalPadding,
      ),
      child: searchQuery != null && searchQuery!.isNotEmpty
          ? _buildHighlightedText(context, text)
          : SuperInteractiveTextPreview(
              text: text,
              textPreviewTheme: chatTheme.textPreview,
              onRouteTap: onRouteTap,
              onLinkTap: onLinkTap,
              onEmailTap: onEmailTap,
              onPhoneTap: onPhoneTap,
            ),
    );
  }

  /// Builds text with search highlighting.
  Widget _buildHighlightedText(BuildContext context, String text) {
    final searchTheme = chatTheme.searchHighlight;
    final query = searchQuery!.toLowerCase();
    final lowerText = text.toLowerCase();

    // Find all matches
    final matches = <Match>[];
    int start = 0;
    while (true) {
      final index = lowerText.indexOf(query, start);
      if (index == -1) break;
      matches.add(_Match(index, index + query.length));
      start = index + 1;
    }

    // If no matches, use regular text preview
    if (matches.isEmpty) {
      return SuperInteractiveTextPreview(
        text: text,
        textPreviewTheme: chatTheme.textPreview,
        onRouteTap: onRouteTap,
        onLinkTap: onLinkTap,
        onEmailTap: onEmailTap,
        onPhoneTap: onPhoneTap,
      );
    }

    // Build text spans with highlighting
    final spans = <TextSpan>[];
    int currentPos = 0;

    for (int i = 0; i < matches.length; i++) {
      final match = matches[i];

      // Add non-highlighted text before match
      if (currentPos < match.start) {
        spans.add(TextSpan(
          text: text.substring(currentPos, match.start),
        ));
      }

      // Add highlighted match
      // For current match, use the current match color (more visible)
      final isFirstMatch = i == 0 && isCurrentSearchMatch;
      final backgroundColor = isFirstMatch
          ? searchTheme.currentMatchColor
          : searchTheme.highlightColor;
      final textColor = isFirstMatch
          ? searchTheme.currentMatchTextColor
          : searchTheme.highlightTextColor;

      spans.add(TextSpan(
        text: text.substring(match.start, match.end),
        style: TextStyle(
          backgroundColor: backgroundColor,
          color: textColor,
        ),
      ));

      currentPos = match.end;
    }

    // Add remaining text after last match
    if (currentPos < text.length) {
      spans.add(TextSpan(
        text: text.substring(currentPos),
      ));
    }

    return RichText(
      text: TextSpan(
        style: chatTheme.typography.bodyMedium.copyWith(
          color: chatTheme.colors.onSurface,
        ),
        children: spans,
      ),
    );
  }
}

/// Simple match helper class.
class _Match implements Match {
  @override
  final int start;
  @override
  final int end;

  _Match(this.start, this.end);

  @override
  String operator [](int group) => throw UnimplementedError();
  @override
  String? group(int group) => throw UnimplementedError();
  @override
  int get groupCount => 0;
  @override
  List<String?> groups(List<int> groupIndices) => throw UnimplementedError();
  @override
  String get input => throw UnimplementedError();
  @override
  Pattern get pattern => throw UnimplementedError();
}
