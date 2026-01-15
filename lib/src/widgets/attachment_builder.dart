import 'package:flutter/material.dart';
import '../theme/chat_theme.dart';
import '../adapters/adapters.dart';
import '../config/chat_message_ui_config.dart';
import 'audio/audio_bubble.dart';
import 'image/image_bubble.dart';
import 'video/video_bubble.dart';
import 'location/location_bubble.dart';
import 'document/document_bubble.dart';

/// Widget for building media attachments (images, videos, documents, etc.).
class AttachmentBuilder extends StatelessWidget {
  final IChatMessageData message;
  final ChatThemeData chatTheme;
  final bool isMyMessage;
  final VoidCallback? onTap;
  final Widget Function(ChatMediaData media)? customBuilder;
  final ChatAutoDownloadConfig? autoDownloadConfig;

  const AttachmentBuilder({
    super.key,
    required this.message,
    required this.chatTheme,
    required this.isMyMessage,
    this.onTap,
    this.customBuilder,
    this.autoDownloadConfig,
  });

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
      ChatMessageType.document => DocumentBubble(
          message: message,
          chatTheme: chatTheme,
          isMyMessage: isMyMessage,
          onTap: onTap,
          autoDownloadPolicy: resolvedAutoDownload.document,
        ),
      ChatMessageType.location when message.locationData != null =>
        LocationBubble(
          location: message.locationData!,
          chatTheme: chatTheme,
          isMyMessage: isMyMessage,
        ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildImageAttachment(
    BuildContext context,
    ChatMediaData media,
    ChatAutoDownloadConfig config,
  ) {
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
    final thumbnailUrl = media.thumbnailUrl ?? media.url;

    return VideoBubble(
      message: message,
      chatTheme: chatTheme,
      isMyMessage: isMyMessage,
      onTap: onTap,
      thumbnailFilePath: thumbnailUrl,
      autoDownloadPolicy: config.video,
    );
  }

  Widget _buildAudioAttachment(
    BuildContext context,
    ChatMediaData media,
    ChatAutoDownloadConfig config,
  ) {
    return AudioBubble(
      message: message,
      autoDownloadPolicy: config.audio,
    );
  }
}
