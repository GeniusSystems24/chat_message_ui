import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../adapters/adapters.dart';
import '../../theme/chat_theme.dart';
import 'video_player_factory.dart';

/// Constants for video bubble styling and configuration.
abstract class VideoBubbleConstants {
  static const double borderRadius = 12.0;
  static const double minHeight = 180.0;
  static const double maxHeight = 300.0;
  static const double thumbnailOverlayOpacity = 0.3;
  static const double playButtonSize = 64.0;
  static const double playIconSize = 32.0;
  static const double smallPlayButtonSize = 48.0;
  static const double smallPlayIconSize = 24.0;
  static const double durationFontSize = 12.0;
  static const double controlsHeight = 40.0;
  static const double progressBarHeight = 3.0;
  static const Duration animationDuration = Duration(milliseconds: 200);
}

/// Widget to display a video attachment in a message bubble.
///
/// Features:
/// - Thumbnail preview with shimmer loading
/// - Tap animation feedback
/// - Progress indicator during loading
/// - Inline mini player option
/// - Full-screen playback
/// - Video controls (play, pause, seek)
class VideoBubble extends StatefulWidget {
  final IChatMessageData message;
  final ChatThemeData chatTheme;
  final bool isMyMessage;
  final VoidCallback? onTap;

  /// Optional direct file path (overrides message.mediaData.url)
  final String? filePath;

  /// Optional thumbnail file path for placeholder
  final String? thumbnailFilePath;

  /// Whether to show mini player inline instead of full-screen
  final bool showMiniPlayer;

  /// Whether to auto-play when visible
  final bool autoPlay;

  /// Whether to mute by default
  final bool muted;

  /// Callback when video starts playing
  final VoidCallback? onPlay;

  /// Callback when video is paused
  final VoidCallback? onPause;

  /// Callback for long press
  final VoidCallback? onLongPress;

  const VideoBubble({
    super.key,
    required this.message,
    required this.chatTheme,
    required this.isMyMessage,
    this.onTap,
    this.filePath,
    this.thumbnailFilePath,
    this.showMiniPlayer = false,
    this.autoPlay = false,
    this.muted = false,
    this.onPlay,
    this.onPause,
    this.onLongPress,
  });

  @override
  State<VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble>
    with SingleTickerProviderStateMixin {
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;
  bool _isInitialized = false;
  bool _isInitializing = false;
  String? _error;
  bool _isPressed = false;
  late AnimationController _loadingController;
  double _loadingProgress = 0.0;

  String? get url {
    if (widget.filePath != null) return null;
    final mediaUrl = widget.message.mediaData?.url;
    if (mediaUrl != null && mediaUrl.startsWith('http')) {
      return mediaUrl;
    }
    return null;
  }

  String? get localPath {
    if (widget.filePath != null) return widget.filePath;
    final mediaUrl = widget.message.mediaData?.url;
    if (mediaUrl != null && !mediaUrl.startsWith('http')) {
      return mediaUrl;
    }
    return null;
  }

  String? get videoSource => localPath ?? url;
  bool get isLocalSource => localPath != null;

  String? get thumbnailPath => widget.thumbnailFilePath;
  String? get thumbnailUrl => widget.message.mediaData?.thumbnailUrl;

  int get duration => widget.message.mediaData?.duration ?? 0;
  int get fileSize => widget.message.mediaData?.fileSize ?? 0;
  String get heroTag => 'video-${widget.message.id}';

  double get aspectRatio {
    const double defaultRatio = 16 / 9;
    const double minRatio = 0.5;
    const double maxRatio = 2.0;
    double ratio = widget.message.mediaData?.aspectRatio ?? defaultRatio;
    return ratio.clamp(minRatio, maxRatio);
  }

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    if (widget.autoPlay) {
      _initializeVideo();
    }
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    if (_isInitializing) return;

    final source = videoSource;
    if (source == null) {
      setState(() => _error = 'Video not available');
      return;
    }

    setState(() {
      _isInitializing = true;
      _error = null;
    });

    try {
      _videoPlayerController = isLocalSource
          ? VideoPlayerController.file(File(source))
          : VideoPlayerController.networkUrl(Uri.parse(source));

      // Listen for buffering progress
      _videoPlayerController!.addListener(_onVideoProgress);

      await _videoPlayerController!.initialize();

      if (widget.muted) {
        await _videoPlayerController!.setVolume(0);
      }

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: widget.showMiniPlayer,
        looping: false,
        showControls: true,
        aspectRatio: _videoPlayerController!.value.aspectRatio,
        placeholder: _buildThumbnailContent(),
        autoInitialize: true,
        errorBuilder: (context, errorMessage) => _VideoErrorWidget(
          error: errorMessage,
          chatTheme: widget.chatTheme,
          onRetry: _retryInitialization,
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: widget.chatTheme.colors.primary,
          handleColor: widget.chatTheme.colors.primary,
          backgroundColor: Colors.white.withValues(alpha: 0.3),
          bufferedColor: Colors.white.withValues(alpha: 0.5),
        ),
      );

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _isInitializing = false;
        });
        widget.onPlay?.call();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isInitializing = false;
        });
      }
    }
  }

  void _onVideoProgress() {
    if (_videoPlayerController == null) return;

    final value = _videoPlayerController!.value;
    if (value.buffered.isNotEmpty) {
      final buffered = value.buffered.last.end.inMilliseconds;
      final total = value.duration.inMilliseconds;
      if (total > 0) {
        setState(() {
          _loadingProgress = buffered / total;
        });
      }
    }
  }

  void _retryInitialization() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    _chewieController = null;
    _videoPlayerController = null;
    setState(() {
      _isInitialized = false;
      _error = null;
    });
    _initializeVideo();
  }

  void _showFullScreenVideo() {
    if (_chewieController != null && _isInitialized) {
      _chewieController!.enterFullScreen();
    } else if (!_isInitialized && !_isInitializing) {
      _initializeVideo().then((_) {
        if (_chewieController != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => _VideoFullScreenPlayer(
                chewieController: _chewieController!,
                videoTitle: widget.message.mediaData?.fileName ?? 'Video',
                heroTag: heroTag,
                onShare: null,
                onDownload: null,
              ),
            ),
          );
        }
      });
    }
  }

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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap ?? (_isInitialized ? _showFullScreenVideo : _initializeVideo),
      onLongPress: widget.onLongPress,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: VideoBubbleConstants.animationDuration,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(VideoBubbleConstants.borderRadius),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: _buildVideoContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoContent(BuildContext context) {
    if (_error != null) {
      return _VideoErrorWidget(
        error: _error!,
        chatTheme: widget.chatTheme,
        onRetry: _retryInitialization,
      );
    }

    if (videoSource == null) {
      return _VideoErrorWidget(
        error: 'Video not available',
        chatTheme: widget.chatTheme,
      );
    }

    if (_isInitialized && _chewieController != null && widget.showMiniPlayer) {
      return Hero(
        tag: heroTag,
        child: Chewie(controller: _chewieController!),
      );
    }

    // Show thumbnail with play button
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildThumbnailContent(),
        // Gradient overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withValues(alpha: 0.6),
              ],
              stops: const [0.5, 1.0],
            ),
          ),
        ),
        // Play button or loading indicator
        Center(
          child: _isInitializing
              ? _LoadingIndicator(
                  controller: _loadingController,
                  progress: _loadingProgress,
                )
              : _PlayButton(
                  onTap: _initializeVideo,
                  size: VideoBubbleConstants.playButtonSize,
                  iconSize: VideoBubbleConstants.playIconSize,
                ),
        ),
        // Info overlay
        Positioned(
          bottom: 8,
          left: 8,
          right: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (duration > 0)
                _InfoChip(
                  text: _formatDuration(duration),
                  icon: Icons.play_arrow_rounded,
                ),
              if (fileSize > 0)
                _InfoChip(
                  text: _formatFileSize(fileSize),
                  icon: Icons.video_file_rounded,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildThumbnailContent() {
    if (thumbnailPath != null) {
      return _BlurredThumbnail(
        child: Image.file(
          File(thumbnailPath!),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }

    if (thumbnailUrl != null) {
      return _BlurredThumbnail(
        child: CachedNetworkImage(
          imageUrl: thumbnailUrl!,
          fit: BoxFit.cover,
          placeholder: (_, __) => _ShimmerPlaceholder(chatTheme: widget.chatTheme),
          errorWidget: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }

    return _ShimmerPlaceholder(chatTheme: widget.chatTheme);
  }

  Widget _buildPlaceholder() {
    return Container(
      color: widget.chatTheme.colors.surfaceContainerHigh,
      child: Center(
        child: Icon(
          Icons.videocam_rounded,
          color: widget.chatTheme.colors.onSurface.withValues(alpha: 0.3),
          size: 48,
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
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

/// Blurred thumbnail background.
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
            filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
            child: Container(color: Colors.transparent),
          ),
        ),
        child,
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
    final highlightColor = widget.chatTheme.colors.surfaceContainerHigh;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(_animation.value, 0),
              end: Alignment(_animation.value + 1, 0),
              colors: [baseColor, highlightColor, baseColor],
            ),
          ),
          child: Center(
            child: Icon(
              Icons.videocam_rounded,
              size: 48,
              color: widget.chatTheme.colors.onSurface.withValues(alpha: 0.2),
            ),
          ),
        );
      },
    );
  }
}

/// Loading indicator with progress.
class _LoadingIndicator extends StatelessWidget {
  final AnimationController controller;
  final double progress;

  const _LoadingIndicator({
    required this.controller,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              value: progress > 0 ? progress : null,
              strokeWidth: 3,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          if (progress > 0)
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            )
          else
            const Icon(
              Icons.videocam_rounded,
              color: Colors.white,
              size: 20,
            ),
        ],
      ),
    );
  }
}

/// Play button widget.
class _PlayButton extends StatelessWidget {
  final VoidCallback onTap;
  final double size;
  final double iconSize;

  const _PlayButton({
    required this.onTap,
    this.size = 64,
    this.iconSize = 32,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.play_arrow_rounded,
            color: Colors.black87,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

/// Info chip widget.
class _InfoChip extends StatelessWidget {
  final String text;
  final IconData icon;

  const _InfoChip({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Video error widget.
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
      return 'Network error';
    }
    if (lowerError.contains('format') || lowerError.contains('codec')) {
      return 'Unsupported format';
    }
    if (lowerError.contains('not found') || lowerError.contains('404')) {
      return 'Video not found';
    }
    return 'Unable to play';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: chatTheme.colors.errorContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: chatTheme.colors.onErrorContainer,
            size: 40,
          ),
          const SizedBox(height: 8),
          Text(
            userFriendlyError,
            style: TextStyle(
              color: chatTheme.colors.onErrorContainer,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              style: TextButton.styleFrom(
                foregroundColor: chatTheme.colors.onErrorContainer,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Full-screen video player.
class _VideoFullScreenPlayer extends StatefulWidget {
  final ChewieController chewieController;
  final String videoTitle;
  final String? heroTag;
  final VoidCallback? onShare;
  final VoidCallback? onDownload;

  const _VideoFullScreenPlayer({
    required this.chewieController,
    required this.videoTitle,
    this.heroTag,
    this.onShare,
    this.onDownload,
  });

  @override
  State<_VideoFullScreenPlayer> createState() => _VideoFullScreenPlayerState();
}

class _VideoFullScreenPlayerState extends State<_VideoFullScreenPlayer> {
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    final videoWidget = AspectRatio(
      aspectRatio: widget.chewieController.videoPlayerController.value.aspectRatio,
      child: Chewie(controller: widget.chewieController),
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: widget.heroTag != null
                  ? Hero(tag: widget.heroTag!, child: videoWidget)
                  : videoWidget,
            ),
            // Top bar
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: _showControls ? 0 : -100,
              left: 0,
              right: 0,
              child: _TopBar(
                title: widget.videoTitle,
                onClose: () => Navigator.of(context).pop(),
              ),
            ),
            // Bottom actions
            if (widget.onShare != null || widget.onDownload != null)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                bottom: _showControls ? 0 : -80,
                left: 0,
                right: 0,
                child: _BottomActions(
                  onShare: widget.onShare,
                  onDownload: widget.onDownload,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Top bar for full-screen player.
class _TopBar extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _TopBar({
    required this.title,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Container(
      padding: EdgeInsets.only(
        top: padding.top + 8,
        left: 8,
        right: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
            color: Colors.white,
            iconSize: 28,
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Bottom actions for full-screen player.
class _BottomActions extends StatelessWidget {
  final VoidCallback? onShare;
  final VoidCallback? onDownload;

  const _BottomActions({
    this.onShare,
    this.onDownload,
  });

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;

    return Container(
      padding: EdgeInsets.only(
        bottom: padding.bottom + 16,
        left: 24,
        right: 24,
        top: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.7),
            Colors.transparent,
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          if (onShare != null)
            _ActionButton(
              icon: Icons.share_rounded,
              label: 'Share',
              onTap: onShare!,
            ),
          if (onDownload != null)
            _ActionButton(
              icon: Icons.download_rounded,
              label: 'Save',
              onTap: onDownload!,
            ),
        ],
      ),
    );
  }
}

/// Action button widget.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

/// Legacy full-screen video player (for backward compatibility).
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
    return _VideoFullScreenPlayer(
      chewieController: chewieController,
      videoTitle: videoTitle,
      heroTag: heroTag,
    );
  }
}
