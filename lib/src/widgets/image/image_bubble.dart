import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../adapters/adapters.dart';
import '../../theme/chat_theme.dart';
import 'full_screen_image_viewer.dart';

/// Constants for image bubble styling and configuration.
abstract class ImageBubbleConstants {
  static const double borderRadius = 8.0;
  static const double errorIconSize = 40.0;
  static const double errorSpacing = 8.0;
  static const String heroTagPrefix = 'internal-image-';
}

/// Widget to display an image attachment in a message bubble.
class ImageBubble extends StatelessWidget {
  final IChatMessageData message;
  final ChatThemeData chatTheme;
  final bool isMyMessage;
  final VoidCallback? onTap;

  /// Optional direct file path (overrides message.mediaData.url)
  final String? filePath;

  /// Optional thumbnail file path for placeholder
  final String? thumbnailFilePath;

  const ImageBubble({
    super.key,
    required this.message,
    required this.chatTheme,
    required this.isMyMessage,
    this.onTap,
    this.filePath,
    this.thumbnailFilePath,
  });

  /// Returns the URL from mediaData if it's a network URL
  String? get url {
    // If filePath is provided, don't use URL
    if (filePath != null) return null;

    final mediaUrl = message.mediaData?.url;
    if (mediaUrl != null && mediaUrl.startsWith('http')) {
      return mediaUrl;
    }
    return null;
  }

  /// Returns the local file path (priority: filePath > mediaData.url if local)
  String? get localPath {
    // Priority 1: Explicit filePath parameter
    if (filePath != null) return filePath;

    // Priority 2: mediaData.url if it's a local path
    final mediaUrl = message.mediaData?.url;
    if (mediaUrl != null && !mediaUrl.startsWith('http')) {
      return mediaUrl;
    }
    return null;
  }

  /// Returns the thumbnail path (priority: thumbnailFilePath > thumbnailUrl)
  String? get thumbnailPath => thumbnailFilePath;
  String? get thumbnailUrl => message.mediaData?.thumbnailUrl;

  String get heroTag => '${ImageBubbleConstants.heroTagPrefix}${message.id}';

  double get aspectRatio {
    const double maxAspectRatio = 0.8;
    double ratio = message.mediaData?.aspectRatio ?? maxAspectRatio;
    if (ratio < maxAspectRatio) ratio = maxAspectRatio;
    return ratio;
  }

  @override
  Widget build(BuildContext context) {
    final child = _ImageContainer(
      heroTag: heroTag,
      borderRadius: chatTheme.imageBubble.borderRadius,
      child: _buildImageContent(context),
    );

    return AspectRatio(aspectRatio: aspectRatio, child: child);
  }

  Widget _buildImageContent(BuildContext context) {
    // Priority 1: Local file path
    if (localPath != null) {
      return GestureDetector(
        onTap: onTap ?? () => _showFullScreenImage(context, localPath!, false),
        child: Image.file(
          File(localPath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) =>
              _ImageErrorWidget(chatTheme: chatTheme),
        ),
      );
    }

    // Priority 2: Network URL with optional thumbnail
    if (url != null) {
      return GestureDetector(
        onTap: onTap ?? () => _showFullScreenImage(context, url!, true),
        child: CachedNetworkImage(
          imageUrl: url!,
          fit: BoxFit.cover,
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) =>
              _ImageErrorWidget(chatTheme: chatTheme),
        ),
      );
    }

    return _ImageErrorWidget(chatTheme: chatTheme);
  }

  Widget _buildPlaceholder() {
    // Use thumbnail file if available
    if (thumbnailPath != null) {
      return Image.file(
        File(thumbnailPath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _defaultPlaceholder(),
      );
    }

    // Use thumbnail URL if available
    if (thumbnailUrl != null) {
      return CachedNetworkImage(
        imageUrl: thumbnailUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => _defaultPlaceholder(),
        errorWidget: (context, url, error) => _defaultPlaceholder(),
      );
    }

    return _defaultPlaceholder();
  }

  Widget _defaultPlaceholder() {
    return Container(
      color: chatTheme.colors.surfaceContainerHigh,
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  void _showFullScreenImage(BuildContext context, String path, bool isUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewerFullScreen(
          imagePath: path,
          isUrl: isUrl,
          heroTag: heroTag,
        ),
      ),
    );
  }
}

class _ImageContainer extends StatelessWidget {
  final String heroTag;
  final Widget child;
  final double borderRadius;

  const _ImageContainer({
    required this.heroTag,
    required this.child,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Hero(tag: heroTag, child: child),
    );
  }
}

class _ImageErrorWidget extends StatelessWidget {
  final ChatThemeData chatTheme;

  const _ImageErrorWidget({required this.chatTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: chatTheme.imageBubble.placeholderColor ??
          chatTheme.colors.surfaceContainerHigh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image,
            color: chatTheme.imageBubble.errorColor ??
                chatTheme.colors.onSurface.withValues(alpha: 0.5),
            size: ImageBubbleConstants.errorIconSize,
          ),
          const SizedBox(height: ImageBubbleConstants.errorSpacing),
          Text(
            'Image not available',
            style: TextStyle(
              color: chatTheme.imageBubble.errorColor ??
                  chatTheme.colors.onSurface.withValues(alpha: 0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
