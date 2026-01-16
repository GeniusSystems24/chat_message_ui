import 'package:flutter/material.dart';
import '../theme/chat_theme.dart';
import '../adapters/adapters.dart';
import '../config/chat_message_ui_config.dart';
import 'audio/audio_bubble.dart';
import 'bubble_builders.dart';
import 'image/image_bubble.dart';
import 'video/video_bubble.dart';
import 'location/location_bubble.dart';
import 'document/document_bubble.dart';
import 'poll/poll_bubble.dart';

/// Widget for building media attachments (images, videos, documents, etc.).
class AttachmentBuilder extends StatelessWidget {
  final IChatMessageData message;
  final ChatThemeData chatTheme;
  final bool isMyMessage;
  final String currentUserId;
  final VoidCallback? onTap;
  final Widget Function(ChatMediaData media)? customBuilder;
  final ChatAutoDownloadConfig? autoDownloadConfig;
  final Function(String optionId)? onPollVote;
  final BubbleBuilders? bubbleBuilders;

  const AttachmentBuilder({
    super.key,
    required this.message,
    required this.chatTheme,
    required this.isMyMessage,
    required this.currentUserId,
    this.onTap,
    this.customBuilder,
    this.autoDownloadConfig,
    this.onPollVote,
    this.bubbleBuilders,
  });

  /// Creates a builder context for custom builders.
  BubbleBuilderContext _createBuilderContext() {
    return BubbleBuilderContext(
      message: message,
      chatTheme: chatTheme,
      isMyMessage: isMyMessage,
      currentUserId: currentUserId,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (customBuilder != null && message.mediaData != null) {
      return customBuilder!(message.mediaData!);
    }

    final resolvedAutoDownload =
        autoDownloadConfig ?? ChatMessageUiConfig.instance.autoDownload;

    return switch (message.type) {
      ChatMessageType.image when message.mediaData != null =>
        _buildImageAttachment(context, message.mediaData!, resolvedAutoDownload),
      ChatMessageType.video when message.mediaData != null =>
        _buildVideoAttachment(context, message.mediaData!, resolvedAutoDownload),
      ChatMessageType.audio when message.mediaData != null =>
        _buildAudioAttachment(context, message.mediaData!, resolvedAutoDownload),
      ChatMessageType.document when message.mediaData != null =>
        _buildDocumentAttachment(context, message.mediaData!, resolvedAutoDownload),
      ChatMessageType.poll when message.pollData != null =>
        _buildPollAttachment(context, message.pollData!),
      ChatMessageType.location when message.locationData != null =>
        _buildLocationAttachment(context, message.locationData!),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildImageAttachment(
    BuildContext context,
    ChatMediaData media,
    ChatAutoDownloadConfig config,
  ) {
    // Use custom builder if provided
    final imageBuilder = bubbleBuilders?.imageBubbleBuilder;
    if (imageBuilder != null) {
      return imageBuilder(context, _createBuilderContext(), media);
    }

    return ImageBubble(
      message: message,
      chatTheme: chatTheme,
      isMyMessage: isMyMessage,
      onTap: onTap,
      autoDownloadPolicy: config.image,
    );
  }

  Widget _buildVideoAttachment(
    BuildContext context,
    ChatMediaData media,
    ChatAutoDownloadConfig config,
  ) {
    // Use custom builder if provided
    final videoBuilder = bubbleBuilders?.videoBubbleBuilder;
    if (videoBuilder != null) {
      return videoBuilder(context, _createBuilderContext(), media);
    }

    final thumbnailUrl = media.thumbnailUrl;
    final thumbnailFilePath =
        thumbnailUrl != null &&
                !thumbnailUrl.startsWith('http') &&
                !thumbnailUrl.startsWith('https')
            ? thumbnailUrl
            : null;

    return VideoBubble(
      message: message,
      chatTheme: chatTheme,
      isMyMessage: isMyMessage,
      onTap: onTap,
      thumbnailFilePath: thumbnailFilePath,
      autoDownloadPolicy: config.video,
    );
  }

  Widget _buildAudioAttachment(
    BuildContext context,
    ChatMediaData media,
    ChatAutoDownloadConfig config,
  ) {
    // Use custom builder if provided
    final audioBuilder = bubbleBuilders?.audioBubbleBuilder;
    if (audioBuilder != null) {
      return audioBuilder(context, _createBuilderContext(), media);
    }

    return AudioBubble(
      message: message,
      autoDownloadPolicy: config.audio,
    );
  }

  Widget _buildDocumentAttachment(
    BuildContext context,
    ChatMediaData media,
    ChatAutoDownloadConfig config,
  ) {
    // Use custom builder if provided
    final documentBuilder = bubbleBuilders?.documentBubbleBuilder;
    if (documentBuilder != null) {
      return documentBuilder(context, _createBuilderContext(), media);
    }

    return DocumentBubble(
      message: message,
      chatTheme: chatTheme,
      isMyMessage: isMyMessage,
      onTap: onTap,
      autoDownloadPolicy: config.document,
    );
  }

  Widget _buildPollAttachment(
    BuildContext context,
    ChatPollData poll,
  ) {
    // Use custom builder if provided
    final pollBuilder = bubbleBuilders?.pollBubbleBuilder;
    if (pollBuilder != null) {
      return pollBuilder(context, _createBuilderContext(), poll, onPollVote);
    }

    return PollBubble(
      message: message,
      onVote: onPollVote,
    );
  }

  Widget _buildLocationAttachment(
    BuildContext context,
    ChatLocationData location,
  ) {
    // Use custom builder if provided
    final locationBuilder = bubbleBuilders?.locationBubbleBuilder;
    if (locationBuilder != null) {
      return locationBuilder(context, _createBuilderContext(), location);
    }

    return LocationBubble(
      location: location,
      chatTheme: chatTheme,
      isMyMessage: isMyMessage,
    );
  }
}
