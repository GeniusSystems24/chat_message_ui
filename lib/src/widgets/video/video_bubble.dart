import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transfer_kit/transfer_kit.dart';
import 'package:video_player/video_player.dart';

import '../../adapters/adapters.dart';
import '../../config/chat_message_ui_config.dart';
import '../../theme/chat_theme.dart';
import '../../transfer/media_transfer_controller.dart';
import '../audio/audio_player_factory.dart';
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
/// - Automatic pause of other audio/video when playing
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

  /// Auto-download policy for network media.
  final AutoDownloadPolicy autoDownloadPolicy;

  /// Allow streaming from network URLs when local file is unavailable.
  final bool allowNetworkStreaming;

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
    this.autoDownloadPolicy = AutoDownloadPolicy.never,
    this.allowNetworkStreaming = true,
  });

  @override
  State<VideoBubble> createState() => _VideoBubbleState();
}

class _VideoBubbleState extends State<VideoBubble>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _loadingController;
  String? _downloadedPath;
  bool _autoStartTriggered = false;
  StreamSubscription<VideoPlayerState>? _stateSubscription;

  String get _videoId => 'video-${widget.message.id}';

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

  String? get videoSource => _downloadedPath ?? localPath;
  bool get isLocalSource => videoSource != null;
  bool get canStream => widget.allowNetworkStreaming && url != null;

  String? get thumbnailPath => widget.thumbnailFilePath;
  String? get thumbnailUrl => widget.message.mediaData?.thumbnailUrl;

  int get duration => widget.message.mediaData?.resolvedDurationSeconds ?? 0;
  int get fileSize => widget.message.mediaData?.resolvedFileSize ?? 0;
  String get heroTag => 'video-${widget.message.id}';

  double get aspectRatio {
    const double defaultRatio = 16 / 9;
    const double minRatio = 0.5;
    const double maxRatio = 2.0;
    double ratio =
        widget.message.mediaData?.resolvedAspectRatio ?? defaultRatio;
    return ratio.clamp(minRatio, maxRatio);
  }

  VideoPlayerState? get _currentState => VideoPlayerFactory.getState(_videoId);
  bool get _isInitialized => _currentState?.isReady ?? false;
  bool get _isInitializing =>
      _currentState?.state == VideoPlaybackState.initializing;
  bool get _isPlaying => _currentState?.isPlaying ?? false;
  bool get _hasError => _currentState?.hasError ?? false;
  String? get _error => _currentState?.errorMessage;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Only subscribe to video state changes if showMiniPlayer is true
    if (widget.showMiniPlayer) {
      _stateSubscription = VideoPlayerFactory.stateStream.listen((state) {
        if (state.id == _videoId && mounted) {
          setState(() {});

          if (state.isPlaying) {
            widget.onPlay?.call();
          } else if (state.isPaused) {
            widget.onPause?.call();
          }
        }
      });

      if (widget.autoPlay && videoSource != null) {
        _initializeAndPlay();
      }
    }
  }

  @override
  void didUpdateWidget(VideoBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.message.mediaData?.url != widget.message.mediaData?.url) {
      _autoStartTriggered = false;
    }
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _stateSubscription?.cancel();
    // Only dispose video controller if showMiniPlayer was enabled
    if (widget.showMiniPlayer) {
      VideoPlayerFactory.dispose(_videoId);
    }
    super.dispose();
  }

  Future<void> _initializeAndPlay() async {
    final filePath = videoSource;
    final networkUrl = url;
    if (filePath == null && networkUrl == null) return;

    // First pause any playing audio
    await AudioPlayerFactory.pauseAll();

    // Then play the video using the factory
    await VideoPlayerFactory.play(
      _videoId,
      filePath: filePath,
      url: networkUrl,
    );
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await VideoPlayerFactory.pause(_videoId);
    } else {
      await _initializeAndPlay();
    }
  }

  void _showFullScreenVideo() {
    final filePath = videoSource;
    final networkUrl = url;

    // Open full-screen player directly - it will handle initialization
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _VideoFullScreenPlayer(
          videoId: _videoId,
          filePath: filePath,
          url: networkUrl,
          videoTitle: widget.message.mediaData?.resolvedFileName ?? 'Video',
          heroTag: heroTag,
          chatTheme: widget.chatTheme,
          thumbnailWidget: _buildThumbnailContent(),
          duration: duration,
          fileSize: fileSize,
        ),
      ),
    );
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
    final isDownloadOnly = videoSource == null && url != null && !canStream;
    final canPlay = videoSource != null || canStream;

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap ??
          (canPlay
              ? _showFullScreenVideo
              : null),
      onLongPress: widget.onLongPress,
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: VideoBubbleConstants.animationDuration,
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(VideoBubbleConstants.borderRadius),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: isDownloadOnly
                ? _buildDownloadContent(context, url!)
                : _buildVideoContent(context),
          ),
        ),
      ),
    );
  }

  Widget _buildVideoContent(BuildContext context) {
    if (videoSource == null && !canStream) {
      return _VideoErrorWidget(
        error: 'Video not available',
        chatTheme: widget.chatTheme,
      );
    }

    // Show inline player when initialized and mini player mode is on
    if (widget.showMiniPlayer && _isInitialized) {
      return Hero(
        tag: heroTag,
        child: _InlineVideoPlayer(
          videoId: _videoId,
          chatTheme: widget.chatTheme,
          onFullScreen: _showFullScreenVideo,
        ),
      );
    }

    // Show thumbnail with play button (default behavior)
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
        // Play button (static, no loading state)
        Center(
          child: _PlayButton(
            onTap: _showFullScreenVideo,
            size: VideoBubbleConstants.playButtonSize,
            iconSize: VideoBubbleConstants.playIconSize,
            isPlaying: false,
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
          placeholder: (_, __) =>
              _ShimmerPlaceholder(chatTheme: widget.chatTheme),
          errorWidget: (_, __, ___) => _buildPlaceholder(),
        ),
      );
    }

    final metadataWidget = _buildMetadataThumbnail();
    if (metadataWidget != null) return metadataWidget;

    return _buildPlaceholder();
  }

  Widget? _buildMetadataThumbnail() {
    final thumbnail = widget.message.mediaData?.thumbnail;
    if (thumbnail == null) return null;
    if (thumbnail.bytes != null) {
      return _BlurredThumbnail(
        child: Image.memory(
          thumbnail.bytes!,
          fit: BoxFit.cover,
        ),
      );
    }
    if (thumbnail.base64 != null) {
      final bytes = base64Decode(thumbnail.base64!);
      return _BlurredThumbnail(
        child: Image.memory(
          bytes,
          fit: BoxFit.cover,
        ),
      );
    }
    return null;
  }

  Widget _buildDownloadContent(BuildContext context, String downloadUrl) {
    final controller = MediaTransferController.instance;
    final downloadTask = controller.buildDownloadTask(
      url: downloadUrl,
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
          _setDownloadedPath(filePath);
          return _buildVideoContent(context);
        }

        if (_shouldAutoStart() && !_autoStartTriggered) {
          _autoStartTriggered = true;
          controller.startDownload(downloadTask);
        }

        return StreamBuilder(
          initialData: FileTaskController.instance.fileUpdates[downloadTask.url],
          stream: (streamController ??
                  FileTaskController.instance.createFileController(
                    downloadTask.url,
                  ))
              .stream,
          builder: (context, snapshot) {
            final taskItem = snapshot.data;
            return MediaDownloadCard(
              item: taskItem,
              isVideo: true,
              onStart: () => controller.startDownload(downloadTask),
              onPause: controller.pauseDownload,
              onResume: controller.resumeDownload,
              onCancel: controller.cancelDownload,
              onRetry: controller.retryDownload,
              completedBuilder: (context, item) {
                _setDownloadedPath(item.filePath);
                return _buildVideoContent(context);
              },
              thumbnailWidget: _buildThumbnailContent(),
            );
          },
        );
      },
    );
  }

  void _setDownloadedPath(String filePath) {
    if (_downloadedPath == filePath) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _downloadedPath = filePath;
      });
    });
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

/// Inline video player widget with controls.
class _InlineVideoPlayer extends StatelessWidget {
  final String videoId;
  final ChatThemeData chatTheme;
  final VoidCallback? onFullScreen;

  const _InlineVideoPlayer({
    required this.videoId,
    required this.chatTheme,
    this.onFullScreen,
  });

  @override
  Widget build(BuildContext context) {
    final controller = VideoPlayerFactory.getController(videoId);
    if (controller == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        // Video player
        ValueListenableBuilder<VideoPlayerValue>(
          valueListenable: controller,
          builder: (context, value, child) {
            return AspectRatio(
              aspectRatio: value.aspectRatio > 0 ? value.aspectRatio : 16 / 9,
              child: VideoPlayer(controller),
            );
          },
        ),
        // Controls overlay
        _VideoControlsOverlay(
          videoId: videoId,
          chatTheme: chatTheme,
          onFullScreen: onFullScreen,
        ),
      ],
    );
  }
}

/// Video controls overlay.
class _VideoControlsOverlay extends StatefulWidget {
  final String videoId;
  final ChatThemeData chatTheme;
  final VoidCallback? onFullScreen;

  const _VideoControlsOverlay({
    required this.videoId,
    required this.chatTheme,
    this.onFullScreen,
  });

  @override
  State<_VideoControlsOverlay> createState() => _VideoControlsOverlayState();
}

class _VideoControlsOverlayState extends State<_VideoControlsOverlay> {
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _startHideTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleControls,
      child: AnimatedOpacity(
        opacity: _showControls ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.3),
                Colors.transparent,
                Colors.black.withValues(alpha: 0.5),
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Center play/pause button
              Center(
                child: StreamBuilder<VideoPlayerState>(
                  stream: VideoPlayerFactory.stateStream
                      .where((s) => s.id == widget.videoId),
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    final isPlaying = state?.isPlaying ?? false;

                    return GestureDetector(
                      onTap: () {
                        VideoPlayerFactory.togglePlayPause(widget.videoId);
                        _startHideTimer();
                      },
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPlaying
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Bottom progress bar
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _VideoProgressBar(
                  videoId: widget.videoId,
                  chatTheme: widget.chatTheme,
                ),
              ),
              // Full screen button
              if (widget.onFullScreen != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: widget.onFullScreen,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.fullscreen_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Video progress bar.
class _VideoProgressBar extends StatelessWidget {
  final String videoId;
  final ChatThemeData chatTheme;

  const _VideoProgressBar({
    required this.videoId,
    required this.chatTheme,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<VideoPlayerState>(
      stream: VideoPlayerFactory.stateStream.where((s) => s.id == videoId),
      builder: (context, snapshot) {
        final state = snapshot.data;
        final progress = state?.progress ?? 0.0;
        final buffered = state?.bufferedProgress ?? 0.0;
        final position = state?.formattedPosition ?? '0:00';
        final duration = state?.formattedDuration ?? '0:00';

        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  final width = context.size?.width ?? 0;
                  if (width > 0) {
                    final percent =
                        (details.localPosition.dx / width).clamp(0.0, 1.0);
                    VideoPlayerFactory.seekToPercent(videoId, percent);
                  }
                },
                onTapDown: (details) {
                  final width = context.size?.width ?? 0;
                  if (width > 0) {
                    final percent =
                        (details.localPosition.dx / width).clamp(0.0, 1.0);
                    VideoPlayerFactory.seekToPercent(videoId, percent);
                  }
                },
                child: Container(
                  height: 12,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      // Background
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Buffered
                      FractionallySizedBox(
                        widthFactor: buffered,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      // Progress
                      FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: chatTheme.colors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Time display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    position,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    duration,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
  final bool isPlaying;

  const _PlayButton({
    required this.onTap,
    this.size = 64,
    this.iconSize = 32,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
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
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              key: ValueKey(isPlaying),
              color: Colors.black87,
              size: iconSize,
            ),
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
  final String videoId;
  final String? filePath;
  final String? url;
  final String videoTitle;
  final String? heroTag;
  final ChatThemeData chatTheme;
  final Widget? thumbnailWidget;
  final int duration;
  final int fileSize;
  final VoidCallback? onShare;
  final VoidCallback? onDownload;

  const _VideoFullScreenPlayer({
    required this.videoId,
    this.filePath,
    this.url,
    required this.videoTitle,
    this.heroTag,
    required this.chatTheme,
    this.thumbnailWidget,
    this.duration = 0,
    this.fileSize = 0,
    this.onShare,
    this.onDownload,
  });

  @override
  State<_VideoFullScreenPlayer> createState() => _VideoFullScreenPlayerState();
}

class _VideoFullScreenPlayerState extends State<_VideoFullScreenPlayer> {
  bool _showControls = true;
  Timer? _hideTimer;
  bool _isInitialized = false;
  bool _isInitializing = false;
  String? _error;
  StreamSubscription<VideoPlayerState>? _stateSubscription;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Subscribe to video state changes
    _stateSubscription = VideoPlayerFactory.stateStream.listen((state) {
      if (state.id == widget.videoId && mounted) {
        setState(() {
          _isInitialized = state.isReady;
          _isInitializing = state.state == VideoPlaybackState.initializing;
          _error = state.errorMessage;
        });
      }
    });

    // Initialize and play video when screen opens
    _initializeAndPlay();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _stateSubscription?.cancel();
    // Dispose the video controller when leaving full screen
    VideoPlayerFactory.dispose(widget.videoId);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<void> _initializeAndPlay() async {
    if (widget.filePath == null && widget.url == null) return;

    setState(() => _isInitializing = true);

    // First pause any playing audio
    await AudioPlayerFactory.pauseAll();

    // Then play the video using the factory
    await VideoPlayerFactory.play(
      widget.videoId,
      filePath: widget.filePath,
      url: widget.url,
    );

    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => _showControls = false);
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _startHideTimer();
      }
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail or Video player
            _buildVideoOrThumbnail(),
            // Controls overlay
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Stack(
                children: [
                  // Top bar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _TopBar(
                      title: widget.videoTitle,
                      onClose: () => Navigator.of(context).pop(),
                    ),
                  ),
                  // Center play/pause button or loading
                  Center(child: _buildCenterControl()),
                  // Bottom progress bar
                  if (_isInitialized)
                    Positioned(
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                      left: 16,
                      right: 16,
                      child: _VideoProgressBar(
                        videoId: widget.videoId,
                        chatTheme: widget.chatTheme,
                      ),
                    ),
                  // Info chips (show when not initialized)
                  if (!_isInitialized)
                    Positioned(
                      bottom: MediaQuery.of(context).padding.bottom + 16,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.duration > 0) ...[
                            _InfoChip(
                              text: _formatDuration(widget.duration),
                              icon: Icons.play_arrow_rounded,
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (widget.fileSize > 0)
                            _InfoChip(
                              text: _formatFileSize(widget.fileSize),
                              icon: Icons.video_file_rounded,
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoOrThumbnail() {
    // Show error if any
    if (_error != null) {
      return _VideoErrorWidget(
        error: _error!,
        chatTheme: widget.chatTheme,
        onRetry: _initializeAndPlay,
      );
    }

    // Show video player when initialized
    if (_isInitialized) {
      final controller = VideoPlayerFactory.getController(widget.videoId);
      if (controller != null) {
        return Center(
          child: ValueListenableBuilder<VideoPlayerValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              final videoWidget = AspectRatio(
                aspectRatio: value.aspectRatio > 0 ? value.aspectRatio : 16 / 9,
                child: VideoPlayer(controller),
              );

              return widget.heroTag != null
                  ? Hero(tag: widget.heroTag!, child: videoWidget)
                  : videoWidget;
            },
          ),
        );
      }
    }

    // Show thumbnail while loading
    if (widget.thumbnailWidget != null) {
      return widget.thumbnailWidget!;
    }

    // Fallback placeholder
    return Container(
      color: widget.chatTheme.colors.surfaceContainerHigh,
      child: Center(
        child: Icon(
          Icons.videocam_rounded,
          color: widget.chatTheme.colors.onSurface.withValues(alpha: 0.3),
          size: 64,
        ),
      ),
    );
  }

  Widget _buildCenterControl() {
    // Show loading indicator when initializing
    if (_isInitializing) {
      return Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    // Show play/pause button
    return StreamBuilder<VideoPlayerState>(
      stream: VideoPlayerFactory.stateStream.where((s) => s.id == widget.videoId),
      builder: (context, snapshot) {
        final state = snapshot.data;
        final isPlaying = state?.isPlaying ?? false;
        final isBuffering = state?.isBuffering ?? false;

        if (isBuffering) {
          return Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            if (_isInitialized) {
              VideoPlayerFactory.togglePlayPause(widget.videoId);
            } else {
              _initializeAndPlay();
            }
            _startHideTimer();
          },
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 40,
            ),
          ),
        );
      },
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

/// Legacy full-screen video player (for backward compatibility).
///
/// Use this widget when you have a pre-initialized [VideoPlayerController].
class VideoFullScreen extends StatefulWidget {
  final VideoPlayerController videoController;
  final String videoTitle;
  final String? heroTag;

  const VideoFullScreen({
    super.key,
    required this.videoController,
    required this.videoTitle,
    this.heroTag,
  });

  @override
  State<VideoFullScreen> createState() => _VideoFullScreenState();
}

class _VideoFullScreenState extends State<VideoFullScreen> {
  bool _showControls = true;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showControls = false);
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) _startHideTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.get(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video player
            Center(
              child: ValueListenableBuilder<VideoPlayerValue>(
                valueListenable: widget.videoController,
                builder: (context, value, child) {
                  final videoWidget = AspectRatio(
                    aspectRatio: value.aspectRatio > 0 ? value.aspectRatio : 16 / 9,
                    child: VideoPlayer(widget.videoController),
                  );
                  return widget.heroTag != null
                      ? Hero(tag: widget.heroTag!, child: videoWidget)
                      : videoWidget;
                },
              ),
            ),
            // Controls overlay
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Stack(
                children: [
                  // Top bar
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: _TopBar(
                      title: widget.videoTitle,
                      onClose: () => Navigator.of(context).pop(),
                    ),
                  ),
                  // Center play/pause button
                  Center(
                    child: ValueListenableBuilder<VideoPlayerValue>(
                      valueListenable: widget.videoController,
                      builder: (context, value, child) {
                        final isPlaying = value.isPlaying;
                        final isBuffering = value.isBuffering;

                        if (isBuffering) {
                          return Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                          );
                        }

                        return GestureDetector(
                          onTap: () {
                            if (isPlaying) {
                              widget.videoController.pause();
                            } else {
                              widget.videoController.play();
                            }
                            _startHideTimer();
                          },
                          child: Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  // Bottom progress bar
                  Positioned(
                    bottom: MediaQuery.of(context).padding.bottom + 16,
                    left: 16,
                    right: 16,
                    child: _LegacyVideoProgressBar(
                      controller: widget.videoController,
                      chatTheme: chatTheme,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Progress bar for legacy video player.
class _LegacyVideoProgressBar extends StatelessWidget {
  final VideoPlayerController controller;
  final ChatThemeData chatTheme;

  const _LegacyVideoProgressBar({
    required this.controller,
    required this.chatTheme,
  });

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: controller,
      builder: (context, value, child) {
        final duration = value.duration;
        final position = value.position;
        final progress = duration.inMilliseconds > 0
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0;
        final buffered = value.buffered.isNotEmpty
            ? value.buffered.last.end.inMilliseconds / duration.inMilliseconds
            : 0.0;

        return Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Progress bar
              GestureDetector(
                onHorizontalDragUpdate: (details) {
                  final width = context.size?.width ?? 0;
                  if (width > 0 && duration.inMilliseconds > 0) {
                    final percent = (details.localPosition.dx / width).clamp(0.0, 1.0);
                    controller.seekTo(Duration(
                      milliseconds: (percent * duration.inMilliseconds).toInt(),
                    ));
                  }
                },
                onTapDown: (details) {
                  final width = context.size?.width ?? 0;
                  if (width > 0 && duration.inMilliseconds > 0) {
                    final percent = (details.localPosition.dx / width).clamp(0.0, 1.0);
                    controller.seekTo(Duration(
                      milliseconds: (percent * duration.inMilliseconds).toInt(),
                    ));
                  }
                },
                child: Container(
                  height: 12,
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      // Background
                      Container(
                        height: 3,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      // Buffered
                      FractionallySizedBox(
                        widthFactor: buffered.clamp(0.0, 1.0),
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      // Progress
                      FractionallySizedBox(
                        widthFactor: progress.clamp(0.0, 1.0),
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: chatTheme.colors.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
              // Time display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(position),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                  Text(
                    _formatDuration(duration),
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
