import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:transfer_kit/transfer_kit.dart' hide ImageViewerFullScreen;

import '../../adapters/adapters.dart';
import '../../config/chat_message_ui_config.dart';
import '../../theme/chat_theme.dart';
import '../../transfer/media_transfer_controller.dart';
import 'full_screen_image_viewer.dart';

/// Constants for image bubble styling and configuration.
abstract class ImageBubbleConstants {
  static const double borderRadius = 12.0;
  static const double errorIconSize = 40.0;
  static const double errorSpacing = 8.0;
  static const String heroTagPrefix = 'internal-image-';
  static const double maxAspectRatio = 0.8;
  static const double minAspectRatio = 0.5;
  static const double tapScale = 0.97;
  static const Duration tapAnimationDuration = Duration(milliseconds: 100);
}

/// Widget to display an image attachment in a message bubble.
///
/// Features:
/// - Smooth loading with blur placeholder
/// - Tap animation feedback
/// - Progress indicator for network images
/// - File size overlay
/// - Full-screen viewer with zoom
/// - Support for multiple images (gallery indicator)
class ImageBubble extends StatefulWidget {
  final IChatMessageData message;
  final ChatThemeData chatTheme;
  final bool isMyMessage;
  final VoidCallback? onTap;

  /// Optional direct file path (overrides message.mediaData.url)
  final String? filePath;

  /// Optional thumbnail file path for placeholder
  final String? thumbnailFilePath;

  /// Whether to show file size overlay
  final bool showFileSize;

  /// Whether to show download progress
  final bool showProgress;

  /// Number of images in gallery (shows indicator if > 1)
  final int galleryCount;

  /// Index of this image in gallery
  final int galleryIndex;

  /// Callback for long press
  final VoidCallback? onLongPress;

  /// Auto-download policy for network media.
  final AutoDownloadPolicy autoDownloadPolicy;

  const ImageBubble({
    super.key,
    required this.message,
    required this.chatTheme,
    required this.isMyMessage,
    this.onTap,
    this.filePath,
    this.thumbnailFilePath,
    this.showFileSize = false,
    this.showProgress = true,
    this.galleryCount = 1,
    this.galleryIndex = 0,
    this.onLongPress,
    this.autoDownloadPolicy = AutoDownloadPolicy.never,
  });

  /// Returns the URL from mediaData if it's a network URL
  String? get url {
    if (filePath != null) return null;
    final mediaUrl = message.mediaData?.url;
    if (mediaUrl != null && mediaUrl.startsWith('http')) {
      return mediaUrl;
    }
    return null;
  }

  /// Returns the local file path
  String? get localPath {
    if (filePath != null) return filePath;
    final mediaUrl = message.mediaData?.url;
    if (mediaUrl != null && !mediaUrl.startsWith('http')) {
      return mediaUrl;
    }
    return null;
  }

  String? get thumbnailPath => thumbnailFilePath;
  String? get thumbnailUrl => message.mediaData?.thumbnailUrl;
  int get fileSize => message.mediaData?.resolvedFileSize ?? 0;

  String get heroTag => '${ImageBubbleConstants.heroTagPrefix}${message.id}';

  double get aspectRatio {
    double ratio = message.mediaData?.resolvedAspectRatio ??
        ImageBubbleConstants.maxAspectRatio;
    return ratio.clamp(
      ImageBubbleConstants.minAspectRatio,
      ImageBubbleConstants.maxAspectRatio,
    );
  }

  @override
  State<ImageBubble> createState() => _ImageBubbleState();
}

class _ImageBubbleState extends State<ImageBubble>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  bool _autoStartTriggered = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  void didUpdateWidget(ImageBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _autoStartTriggered = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: widget.aspectRatio,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap ?? () => _showFullScreenImage(context),
        onLongPress: widget.onLongPress,
        child: AnimatedScale(
          scale: _isPressed ? ImageBubbleConstants.tapScale : 1.0,
          duration: ImageBubbleConstants.tapAnimationDuration,
          child: _ImageContainer(
            heroTag: widget.heroTag,
            borderRadius: widget.chatTheme.imageBubble.borderRadius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _buildImageContent(context),
                if (widget.showFileSize && widget.fileSize > 0)
                  _FileSizeOverlay(fileSize: widget.fileSize),
                if (widget.galleryCount > 1)
                  _GalleryIndicator(
                    count: widget.galleryCount,
                    index: widget.galleryIndex,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent(BuildContext context) {
    // Priority 1: Local file path
    if (widget.localPath != null) {
      return _LocalImage(
        path: widget.localPath!,
        chatTheme: widget.chatTheme,
      );
    }

    // Priority 2: Network URL (cache-first with TransferKit)
    final url = widget.url;
    if (url != null) {
      final controller = MediaTransferController.instance;
      final downloadTask = controller.buildDownloadTask(
        url: url,
        fileName: widget.message.mediaData?.resolvedFileName,
      );

      return FutureBuilder(
        future: controller.enqueueOrResume(downloadTask, autoStart: false),
        builder: (context, asyncSnapshot) {
          final (
            String? filePath,
            StreamController<TaskItem>? streamController
          ) = asyncSnapshot.data ?? (null, null);

          if (filePath != null) {
            return _LocalImage(path: filePath, chatTheme: widget.chatTheme);
          }

          if (_shouldAutoStart() && !_autoStartTriggered) {
            _autoStartTriggered = true;
            controller.startDownload(downloadTask);
          }

          return StreamBuilder(
            initialData:
                FileTaskController.instance.fileUpdates[downloadTask.url],
            stream: (streamController ??
                    FileTaskController.instance.createFileController(
                      downloadTask.url,
                    ))
                .stream,
            builder: (context, snapshot) {
              final taskItem = snapshot.data;
              return MediaDownloadCard(
                item: taskItem,
                onStart: () => controller.startDownload(downloadTask),
                onPause: controller.pauseDownload,
                onResume: controller.resumeDownload,
                onCancel: controller.cancelDownload,
                onRetry: controller.retryDownload,
                completedBuilder: (context, item) => _LocalImage(
                  path: item.filePath,
                  chatTheme: widget.chatTheme,
                ),
                thumbnailWidget: _ThumbnailPreview(
                  thumbnailPath: widget.thumbnailPath,
                  thumbnailUrl: widget.thumbnailUrl,
                  metadataThumbnail: widget.message.mediaData?.thumbnail,
                  chatTheme: widget.chatTheme,
                ),
              );
            },
          );
        },
      );
    }

    return _ImageErrorWidget(chatTheme: widget.chatTheme);
  }

  bool _shouldAutoStart() {
    switch (widget.autoDownloadPolicy) {
      case AutoDownloadPolicy.always:
        return true;
      case AutoDownloadPolicy.wifiOnly:
      case AutoDownloadPolicy.never:
        return false;
    }
  }

  void _showFullScreenImage(BuildContext context) {
    final path = widget.localPath ?? widget.url;
    if (path == null) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ImageViewerFullScreen(
            imagePath: path,
            isUrl: widget.localPath == null,
            heroTag: widget.heroTag,
            fileName: widget.message.mediaData?.resolvedFileName,
            fileSize: widget.fileSize,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
        reverseTransitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }
}

/// Container with hero animation and border radius.
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
      child: Hero(
        tag: heroTag,
        child: Material(
          color: Colors.transparent,
          child: child,
        ),
      ),
    );
  }
}

/// Local image widget.
class _LocalImage extends StatelessWidget {
  final String path;
  final ChatThemeData chatTheme;

  const _LocalImage({
    required this.path,
    required this.chatTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(path),
      fit: BoxFit.cover,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return _ShimmerPlaceholder(chatTheme: chatTheme);
      },
      errorBuilder: (context, error, stackTrace) {
        return _ImageErrorWidget(chatTheme: chatTheme);
      },
    );
  }
}

/// Thumbnail preview used during download.
class _ThumbnailPreview extends StatelessWidget {
  final String? thumbnailPath;
  final String? thumbnailUrl;
  final ThumbnailData? metadataThumbnail;
  final ChatThemeData chatTheme;

  const _ThumbnailPreview({
    required this.thumbnailPath,
    required this.thumbnailUrl,
    required this.metadataThumbnail,
    required this.chatTheme,
  });

  @override
  Widget build(BuildContext context) {
    if (thumbnailPath != null) {
      return _BlurredThumbnail(
        child: Image.file(
          File(thumbnailPath!),
          fit: BoxFit.cover,
        ),
      );
    }

    if (thumbnailUrl != null) {
      return _BlurredThumbnail(
        child: CachedNetworkImage(
          imageUrl: thumbnailUrl!,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => _ShimmerPlaceholder(chatTheme: chatTheme),
        ),
      );
    }

    final metadataWidget = _buildMetadataThumbnail();
    if (metadataWidget != null) return metadataWidget;

    return _ShimmerPlaceholder(chatTheme: chatTheme);
  }

  Widget? _buildMetadataThumbnail() {
    if (metadataThumbnail == null) return null;
    if (metadataThumbnail!.bytes != null) {
      return _BlurredThumbnail(
        child: Image.memory(
          metadataThumbnail!.bytes!,
          fit: BoxFit.cover,
        ),
      );
    }
    if (metadataThumbnail!.base64 != null) {
      final bytes = base64Decode(metadataThumbnail!.base64!);
      return _BlurredThumbnail(
        child: Image.memory(
          bytes,
          fit: BoxFit.cover,
        ),
      );
    }
    return null;
  }
}

/// Blurred thumbnail placeholder.
class _BlurredThumbnail extends StatelessWidget {
  final Widget child;

  const _BlurredThumbnail({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withValues(alpha: 0.1),
            ),
          ),
        ),
      ],
    );
  }
}

/// Shimmer loading placeholder.
class _ShimmerPlaceholder extends StatefulWidget {
  final ChatThemeData chatTheme;

  const _ShimmerPlaceholder({required this.chatTheme});

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.chatTheme.colors.surfaceContainerHigh;
    final highlightColor = widget.chatTheme.colors.surfaceContainerHighest;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [
                baseColor,
                highlightColor,
                baseColor,
              ],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.image_outlined,
              size: 40,
              color: widget.chatTheme.colors.onSurface.withValues(alpha: 0.2),
            ),
          ),
        );
      },
    );
  }
}

// Intentionally left empty: progress UI handled by MediaDownloadCard.

/// File size overlay widget.
class _FileSizeOverlay extends StatelessWidget {
  final int fileSize;

  const _FileSizeOverlay({required this.fileSize});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          _formatFileSize(fileSize),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes <= 0) return '';
    const suffixes = ['B', 'KB', 'MB', 'GB'];
    var i = 0;
    double size = bytes.toDouble();
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
  }
}

/// Gallery indicator for multiple images.
class _GalleryIndicator extends StatelessWidget {
  final int count;
  final int index;

  const _GalleryIndicator({
    required this.count,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.photo_library_rounded,
              color: Colors.white,
              size: 14,
            ),
            const SizedBox(width: 4),
            Text(
              '${index + 1}/$count',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error widget when image fails to load.
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
            Icons.broken_image_rounded,
            color: chatTheme.imageBubble.errorColor ??
                chatTheme.colors.onSurface.withValues(alpha: 0.4),
            size: ImageBubbleConstants.errorIconSize,
          ),
          const SizedBox(height: ImageBubbleConstants.errorSpacing),
          Text(
            'Image not available',
            style: TextStyle(
              color: chatTheme.imageBubble.errorColor ??
                  chatTheme.colors.onSurface.withValues(alpha: 0.4),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
