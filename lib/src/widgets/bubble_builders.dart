import 'package:flutter/material.dart';

import '../adapters/adapters.dart';
import '../theme/chat_theme.dart';
import 'context_menu/message_context_menu.dart';

/// Context data passed to bubble builders.
class BubbleBuilderContext {
  /// The message data.
  final IChatMessageData message;

  /// Chat theme data.
  final ChatThemeData chatTheme;

  /// Whether this is the current user's message.
  final bool isMyMessage;

  /// Current user ID.
  final String currentUserId;

  /// Optional tap callback.
  final VoidCallback? onTap;

  const BubbleBuilderContext({
    required this.message,
    required this.chatTheme,
    required this.isMyMessage,
    required this.currentUserId,
    this.onTap,
  });
}

/// Context data for context menu builder.
class ContextMenuBuilderContext {
  /// The message data.
  final IChatMessageData message;

  /// The position where the long press occurred.
  final Offset position;

  /// Whether this is the current user's message.
  final bool isMyMessage;

  /// Current user ID.
  final String currentUserId;

  /// Callback to handle reaction selection.
  final void Function(String emoji)? onReaction;

  /// Callback to handle action selection.
  final void Function(MessageAction action)? onAction;

  /// Callback to dismiss the menu.
  final VoidCallback onDismiss;

  const ContextMenuBuilderContext({
    required this.message,
    required this.position,
    required this.isMyMessage,
    required this.currentUserId,
    required this.onDismiss,
    this.onReaction,
    this.onAction,
  });
}

/// Type definitions for bubble builders.
typedef TextBubbleBuilder = Widget Function(
  BuildContext context,
  BubbleBuilderContext builderContext,
  String text,
);

typedef AudioBubbleBuilder = Widget Function(
  BuildContext context,
  BubbleBuilderContext builderContext,
  ChatMediaData media,
);

typedef ImageBubbleBuilder = Widget Function(
  BuildContext context,
  BubbleBuilderContext builderContext,
  ChatMediaData media,
);

typedef VideoBubbleBuilder = Widget Function(
  BuildContext context,
  BubbleBuilderContext builderContext,
  ChatMediaData media,
);

typedef PollBubbleBuilder = Widget Function(
  BuildContext context,
  BubbleBuilderContext builderContext,
  ChatPollData poll,
  void Function(String optionId)? onVote,
);

typedef LocationBubbleBuilder = Widget Function(
  BuildContext context,
  BubbleBuilderContext builderContext,
  ChatLocationData location,
);

typedef ContactBubbleBuilder = Widget Function(
  BuildContext context,
  BubbleBuilderContext builderContext,
  ChatContactData contact,
);

typedef DocumentBubbleBuilder = Widget Function(
  BuildContext context,
  BubbleBuilderContext builderContext,
  ChatMediaData media,
);

typedef ContextMenuBuilder = Future<MessageContextMenuResult?> Function(
  BuildContext context,
  ContextMenuBuilderContext builderContext,
);

/// Collection of custom bubble builders.
///
/// Use this class to customize how different message types are rendered.
/// Any builder that is null will use the default implementation.
///
/// Example:
/// ```dart
/// BubbleBuilders(
///   textBubbleBuilder: (context, builderContext, text) {
///     return CustomTextBubble(
///       text: text,
///       isMyMessage: builderContext.isMyMessage,
///     );
///   },
///   imageBubbleBuilder: (context, builderContext, media) {
///     return CustomImageBubble(
///       imageUrl: media.url,
///       aspectRatio: media.aspectRatio,
///     );
///   },
///   contextMenuBuilder: (context, builderContext) async {
///     return showMyCustomContextMenu(
///       context,
///       position: builderContext.position,
///       message: builderContext.message,
///     );
///   },
/// )
/// ```
class BubbleBuilders {
  /// Custom builder for text messages.
  final TextBubbleBuilder? textBubbleBuilder;

  /// Custom builder for audio messages.
  final AudioBubbleBuilder? audioBubbleBuilder;

  /// Custom builder for image messages.
  final ImageBubbleBuilder? imageBubbleBuilder;

  /// Custom builder for video messages.
  final VideoBubbleBuilder? videoBubbleBuilder;

  /// Custom builder for poll messages.
  final PollBubbleBuilder? pollBubbleBuilder;

  /// Custom builder for location messages.
  final LocationBubbleBuilder? locationBubbleBuilder;

  /// Custom builder for contact messages.
  final ContactBubbleBuilder? contactBubbleBuilder;

  /// Custom builder for document messages.
  final DocumentBubbleBuilder? documentBubbleBuilder;

  /// Custom builder for context menu (shown on long press).
  final ContextMenuBuilder? contextMenuBuilder;

  const BubbleBuilders({
    this.textBubbleBuilder,
    this.audioBubbleBuilder,
    this.imageBubbleBuilder,
    this.videoBubbleBuilder,
    this.pollBubbleBuilder,
    this.locationBubbleBuilder,
    this.contactBubbleBuilder,
    this.documentBubbleBuilder,
    this.contextMenuBuilder,
  });

  /// Creates a copy with updated builders.
  BubbleBuilders copyWith({
    TextBubbleBuilder? textBubbleBuilder,
    AudioBubbleBuilder? audioBubbleBuilder,
    ImageBubbleBuilder? imageBubbleBuilder,
    VideoBubbleBuilder? videoBubbleBuilder,
    PollBubbleBuilder? pollBubbleBuilder,
    LocationBubbleBuilder? locationBubbleBuilder,
    ContactBubbleBuilder? contactBubbleBuilder,
    DocumentBubbleBuilder? documentBubbleBuilder,
    ContextMenuBuilder? contextMenuBuilder,
  }) {
    return BubbleBuilders(
      textBubbleBuilder: textBubbleBuilder ?? this.textBubbleBuilder,
      audioBubbleBuilder: audioBubbleBuilder ?? this.audioBubbleBuilder,
      imageBubbleBuilder: imageBubbleBuilder ?? this.imageBubbleBuilder,
      videoBubbleBuilder: videoBubbleBuilder ?? this.videoBubbleBuilder,
      pollBubbleBuilder: pollBubbleBuilder ?? this.pollBubbleBuilder,
      locationBubbleBuilder: locationBubbleBuilder ?? this.locationBubbleBuilder,
      contactBubbleBuilder: contactBubbleBuilder ?? this.contactBubbleBuilder,
      documentBubbleBuilder: documentBubbleBuilder ?? this.documentBubbleBuilder,
      contextMenuBuilder: contextMenuBuilder ?? this.contextMenuBuilder,
    );
  }

  /// Merges two BubbleBuilders, with other taking precedence.
  BubbleBuilders merge(BubbleBuilders? other) {
    if (other == null) return this;
    return BubbleBuilders(
      textBubbleBuilder: other.textBubbleBuilder ?? textBubbleBuilder,
      audioBubbleBuilder: other.audioBubbleBuilder ?? audioBubbleBuilder,
      imageBubbleBuilder: other.imageBubbleBuilder ?? imageBubbleBuilder,
      videoBubbleBuilder: other.videoBubbleBuilder ?? videoBubbleBuilder,
      pollBubbleBuilder: other.pollBubbleBuilder ?? pollBubbleBuilder,
      locationBubbleBuilder: other.locationBubbleBuilder ?? locationBubbleBuilder,
      contactBubbleBuilder: other.contactBubbleBuilder ?? contactBubbleBuilder,
      documentBubbleBuilder: other.documentBubbleBuilder ?? documentBubbleBuilder,
      contextMenuBuilder: other.contextMenuBuilder ?? contextMenuBuilder,
    );
  }

  /// Whether any builder is defined.
  bool get hasAnyBuilder =>
      textBubbleBuilder != null ||
      audioBubbleBuilder != null ||
      imageBubbleBuilder != null ||
      videoBubbleBuilder != null ||
      pollBubbleBuilder != null ||
      locationBubbleBuilder != null ||
      contactBubbleBuilder != null ||
      documentBubbleBuilder != null ||
      contextMenuBuilder != null;

  /// Empty builders (all null).
  static const BubbleBuilders empty = BubbleBuilders();
}
