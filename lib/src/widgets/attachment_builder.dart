import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../theme/chat_theme.dart';
import '../adapters/adapters.dart';
import 'location/location_bubble.dart';
import 'document/document_bubble.dart';

/// Widget for building media attachments (images, videos, documents, etc.).
class AttachmentBuilder extends StatelessWidget {
  final IChatMessageData message;
  final ChatThemeData chatTheme;
  final bool isMyMessage;
  final VoidCallback? onTap;
  final Widget Function(ChatMediaData media)? customBuilder;

  const AttachmentBuilder({
    super.key,
    required this.message,
    required this.chatTheme,
    required this.isMyMessage,
    this.onTap,
    this.customBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (customBuilder != null && message.mediaData != null) {
      return customBuilder!(message.mediaData!);
    }

    return switch (message.type) {
      ChatMessageType.image when message.mediaData != null =>
        _buildImageAttachment(context, message.mediaData!),
      ChatMessageType.video when message.mediaData != null =>
        _buildVideoAttachment(context, message.mediaData!),
      ChatMessageType.audio when message.mediaData != null =>
        _buildAudioAttachment(context, message.mediaData!),
      ChatMessageType.document => DocumentBubble(
          message: message,
          chatTheme: chatTheme,
          isMyMessage: isMyMessage,
          onTap: onTap,
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

  Widget _buildImageAttachment(BuildContext context, ChatMediaData media) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(chatTheme.imageBubble.borderRadius),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: chatTheme.imageBubble.maxWidth,
            maxHeight: chatTheme.imageBubble.maxHeight,
          ),
          child: CachedNetworkImage(
            imageUrl: media.url,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              constraints: BoxConstraints(
                maxWidth: chatTheme.imageBubble.maxWidth,
                maxHeight: chatTheme.imageBubble.maxHeight,
              ),
              color: chatTheme.colors.surfaceContainerHigh,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              constraints: BoxConstraints(
                maxWidth: chatTheme.imageBubble.maxWidth,
                maxHeight: chatTheme.imageBubble.maxHeight,
              ),
              color: chatTheme.colors.surfaceContainerHigh,
              child: Icon(
                Icons.broken_image,
                color: chatTheme.colors.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoAttachment(BuildContext context, ChatMediaData media) {
    final thumbnailUrl = media.thumbnailUrl ?? media.url;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(chatTheme.videoBubble.borderRadius),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: chatTheme.videoBubble.maxWidth,
                maxHeight: chatTheme.videoBubble.maxHeight,
              ),
              child: CachedNetworkImage(
                imageUrl: thumbnailUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  constraints: BoxConstraints(
                    maxWidth: chatTheme.videoBubble.maxWidth,
                    maxHeight: chatTheme.videoBubble.maxHeight,
                  ),
                  color: chatTheme.colors.surfaceContainerHigh,
                ),
                errorWidget: (context, url, error) => Container(
                  constraints: BoxConstraints(
                    maxWidth: chatTheme.videoBubble.maxWidth,
                    maxHeight: chatTheme.videoBubble.maxHeight,
                  ),
                  color: chatTheme.colors.surfaceContainerHigh,
                  child: Icon(
                    Icons.videocam,
                    color: chatTheme.colors.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ),
            ),
            // Play button overlay
            Container(
              width: chatTheme.videoBubble.playButtonSize,
              height: chatTheme.videoBubble.playButtonSize,
              decoration: BoxDecoration(
                color: chatTheme.videoBubble.playButtonBackgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                size: chatTheme.videoBubble.playIconSize,
                color: chatTheme.videoBubble.playButtonIconColor,
              ),
            ),
            // Duration indicator
            if (media.duration != null)
              Positioned(
                bottom: 8,
                right: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _formatDuration(media.duration!),
                    style: chatTheme.typography.labelSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioAttachment(BuildContext context, ChatMediaData media) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(chatTheme.audioBubble.padding),
      decoration: BoxDecoration(
        color: isMyMessage
            ? chatTheme.audioBubble.senderBackgroundColor
            : chatTheme.audioBubble.receiverBackgroundColor,
        borderRadius: BorderRadius.circular(chatTheme.audioBubble.borderRadius),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/pause button
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: chatTheme.audioBubble.playButtonSize,
              height: chatTheme.audioBubble.playButtonSize,
              decoration: BoxDecoration(
                color: chatTheme.audioBubble.playButtonColor ??
                    chatTheme.colors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow,
                size: chatTheme.audioBubble.playIconSize,
                color: chatTheme.audioBubble.playIconColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Waveform placeholder
          Expanded(
            child: Container(
              height: chatTheme.audioBubble.waveformHeight,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          if (media.duration != null) ...[
            const SizedBox(width: 8),
            Text(
              _formatDuration(media.duration!),
              style: chatTheme.typography.labelSmall.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }
}
