import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../adapters/adapters.dart';
import '../../theme/chat_theme.dart';

/// Constants for video bubble styling and configuration.
abstract class VideoBubbleConstants {
  static const double borderRadius = 12.0;
  static const double minHeight = 200.0;
  static const double maxHeight = 300.0;
  static const double thumbnailOverlayOpacity = 0.3;
  static const double playButtonSize = 64.0;
  static const double playIconSize = 32.0;
  static const double durationFontSize = 12.0;
}

/// Widget to display a video attachment in a message bubble.
class VideoBubble extends StatefulWidget {
  final IChatMessageData message;
  final ChatThemeData chatTheme;
  final bool isMyMessage;
  final VoidCallback? onTap;

  /// Optional direct file path (overrides message.mediaData.url)
  final String? filePath;

  /// Optional thumbnail file path for placeholder
  final String? thumbnailFilePath;

  const VideoBubble({
    super.key,
    required this.message,
    required this.chatTheme,
    required this.isMyMessage,
    this.onTap,
    this.filePath,
    this.thumbnailFilePath,
  });

  @override
  State<VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;
  bool _isInitialized = false;
  String? _error;

  /// Returns the URL from mediaData if it's a network URL
  String? get url {
    // If filePath is provided, don't use URL
    if (widget.filePath != null) return null;

    final mediaUrl = widget.message.mediaData?.url;
    if (mediaUrl != null && mediaUrl.startsWith('http')) {
      return mediaUrl;
    }
    return null;
  }

  /// Returns the local file path (priority: filePath > mediaData.url if local)
  String? get localPath {
    // Priority 1: Explicit filePath parameter
    if (widget.filePath != null) return widget.filePath;

    // Priority 2: mediaData.url if it's a local path
    final mediaUrl = widget.message.mediaData?.url;
    if (mediaUrl != null && !mediaUrl.startsWith('http')) {
      return mediaUrl;
    }
    return null;
  }

  /// Returns the video source (local path or URL)
  String? get videoSource => localPath ?? url;

  /// Whether the source is a local file
  bool get isLocalSource => localPath != null;

  /// Returns the thumbnail path (priority: thumbnailFilePath > thumbnailUrl)
  String? get thumbnailPath => widget.thumbnailFilePath;
  String? get thumbnailUrl => widget.message.mediaData?.thumbnailUrl;

  int get duration => widget.message.mediaData?.duration ?? 0;
  int get fileSize => widget.message.mediaData?.fileSize ?? 0;
  String get heroTag => 'video-${widget.message.id}';

  double get aspectRatio {
    const double maxAspectRatio = 0.8;
    double ratio = widget.message.mediaData?.aspectRatio ?? maxAspectRatio;
    if (ratio < maxAspectRatio) ratio = maxAspectRatio;
    return ratio;
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    final source = videoSource;
    if (source == null) {
      setState(() => _error = 'Video not available');
      return;
    }

    try {
      _videoPlayerController = isLocalSource
          ? VideoPlayerController.file(File(source))
          : VideoPlayerController.networkUrl(Uri.parse(source));

      await _videoPlayerController!.initialize();

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: false,
        looping: false,
        showControls: true,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        errorBuilder: (context, errorMessage) => _VideoErrorWidget(
          error: errorMessage,
          chatTheme: widget.chatTheme,
        ),
      );

      if (mounted) {
        setState(() => _isInitialized = true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = e.toString());
      }
    }
  }

  void _showFullScreenVideo() {
    if (_chewieController != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoFullScreen(
            chewieController: _chewieController!,
            videoTitle: 'Video',
            heroTag: heroTag,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(VideoBubbleConstants.borderRadius),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: _buildVideoContent(context),
      ),
    );
  }

  Widget _buildVideoContent(BuildContext context) {
    if (_error != null) {
      return _VideoErrorWidget(
        error: _error!,
        chatTheme: widget.chatTheme,
        onRetry: () {
          setState(() {
            _error = null;
          });
          _initializeVideo();
        },
      );
    }

    if (videoSource == null) {
      return _VideoErrorWidget(
        error: 'Video not available',
        chatTheme: widget.chatTheme,
      );
    }

    if (_isInitialized && _chewieController != null) {
      return GestureDetector(
        onTap: widget.onTap ?? _showFullScreenVideo,
        child: Hero(
          tag: heroTag,
          child: Chewie(controller: _chewieController!),
        ),
      );
    }

    // Show thumbnail with play button
    return _VideoThumbnail(
      thumbnailFilePath: thumbnailPath,
      thumbnailUrl: thumbnailUrl,
      duration: _formatDuration(duration),
      fileSize: _formatFileSize(fileSize),
      chatTheme: widget.chatTheme,
      onTap: _initializeVideo,
    );
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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

class _VideoThumbnail extends StatelessWidget {
  final String? thumbnailFilePath;
  final String? thumbnailUrl;
  final String duration;
  final String fileSize;
  final ChatThemeData chatTheme;
  final VoidCallback onTap;

  const _VideoThumbnail({
    this.thumbnailFilePath,
    this.thumbnailUrl,
    required this.duration,
    required this.fileSize,
    required this.chatTheme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.grey[900],
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildThumbnailImage(),
            // Overlay
            Container(
              color: Colors.black.withValues(alpha: 0.3),
            ),
            // Play button
            _PlayButton(onTap: onTap, chatTheme: chatTheme),
            // Info overlay
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (duration.isNotEmpty)
                    _InfoChip(
                      text: duration,
                      icon: Icons.videocam,
                      chatTheme: chatTheme,
                    ),
                  if (fileSize.isNotEmpty)
                    _InfoChip(
                      text: fileSize,
                      icon: Icons.storage,
                      chatTheme: chatTheme,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnailImage() {
    // Priority 1: Local thumbnail file
    if (thumbnailFilePath != null) {
      return Positioned.fill(
        child: Image.file(
          File(thumbnailFilePath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
        ),
      );
    }

    // Priority 2: Network thumbnail URL
    if (thumbnailUrl != null) {
      return Positioned.fill(
        child: CachedNetworkImage(
          imageUrl: thumbnailUrl!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: chatTheme.colors.surfaceContainerHigh,
          ),
          errorWidget: (context, url, error) => _buildPlaceholder(),
        ),
      );
    }

    // Default placeholder
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: chatTheme.colors.surfaceContainerHigh,
      child: Center(
        child: Icon(
          Icons.videocam,
          color: chatTheme.colors.onSurface.withValues(alpha: 0.5),
          size: 48,
        ),
      ),
    );
  }
}

class _PlayButton extends StatelessWidget {
  final VoidCallback onTap;
  final ChatThemeData chatTheme;

  const _PlayButton({required this.onTap, required this.chatTheme});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: VideoBubbleConstants.playButtonSize,
        height: VideoBubbleConstants.playButtonSize,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.play_arrow,
            color: Colors.black87,
            size: VideoBubbleConstants.playIconSize,
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String text;
  final IconData icon;
  final ChatThemeData chatTheme;

  const _InfoChip({
    required this.text,
    required this.icon,
    required this.chatTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 12),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: VideoBubbleConstants.durationFontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback? onRetry;
  final ChatThemeData chatTheme;

  const _VideoErrorWidget({
    required this.error,
    this.onRetry,
    required this.chatTheme,
  });

  String get userFriendlyError {
    final lowerError = error.toLowerCase();
    if (lowerError.contains('network') || lowerError.contains('connection')) {
      return 'Network connection error';
    }
    if (lowerError.contains('format') || lowerError.contains('codec')) {
      return 'Unsupported video format';
    }
    if (lowerError.contains('permission') || lowerError.contains('access')) {
      return 'Access denied';
    }
    if (lowerError.contains('not found') || lowerError.contains('404')) {
      return 'Video not found';
    }
    return 'Unable to play video';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onRetry,
      child: Container(
        width: double.infinity,
        height: VideoBubbleConstants.minHeight,
        color: theme.colorScheme.errorContainer,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.onErrorContainer,
              size: 48,
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                userFriendlyError,
                style: TextStyle(
                  color: theme.colorScheme.onErrorContainer,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                onRetry != null ? 'Tap to try again' : 'Video unavailable',
                style: TextStyle(
                  color:
                      theme.colorScheme.onErrorContainer.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Full-screen video player.
class VideoFullScreen extends StatelessWidget {
  final ChewieController chewieController;
  final String videoTitle;
  final String? heroTag;

  const VideoFullScreen({
    super.key,
    required this.chewieController,
    required this.videoTitle,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final child = AspectRatio(
      aspectRatio: chewieController.videoPlayerController.value.aspectRatio,
      child: Chewie(controller: chewieController),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        title: Text(videoTitle),
        leading: const CloseButton(),
      ),
      body: Center(
        child: heroTag == null ? child : Hero(tag: heroTag!, child: child),
      ),
    );
  }
}
