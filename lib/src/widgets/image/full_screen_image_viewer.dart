import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Full screen image viewer with zoom, pan, and gesture controls.
///
/// Features:
/// - Pinch to zoom (0.5x - 5.0x)
/// - Pan when zoomed
/// - Double-tap to zoom in/out
/// - Swipe down to close
/// - Tap to toggle controls visibility
/// - Shows file info (name, size)
class ImageViewerFullScreen extends StatefulWidget {
  /// Path to the image (URL or local file path).
  final String imagePath;

  /// Whether the path is a URL.
  final bool isUrl;

  /// Hero animation tag.
  final String heroTag;

  /// Optional file name to display.
  final String? fileName;

  /// Optional file size in bytes.
  final int? fileSize;

  /// Callback when share is pressed.
  final VoidCallback? onShare;

  /// Callback when download/save is pressed.
  final VoidCallback? onDownload;

  const ImageViewerFullScreen({
    super.key,
    required this.imagePath,
    required this.isUrl,
    required this.heroTag,
    this.fileName,
    this.fileSize,
    this.onShare,
    this.onDownload,
  });

  @override
  State<ImageViewerFullScreen> createState() => _ImageViewerFullScreenState();
}

class _ImageViewerFullScreenState extends State<ImageViewerFullScreen>
    with SingleTickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;
  bool _showControls = true;
  double _dragOffset = 0;
  double _opacity = 1.0;

  static const double _minScale = 0.5;
  static const double _maxScale = 5.0;
  static const double _doubleTapScale = 2.5;
  static const double _dismissThreshold = 100.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animationController.addListener(() {
      if (_animation != null) {
        _transformationController.value = _animation!.value;
      }
    });

    // Set system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap(TapDownDetails details) {
    final position = details.localPosition;
    final currentScale = _transformationController.value.getMaxScaleOnAxis();

    Matrix4 endMatrix;
    if (currentScale > 1.0) {
      // Zoom out to original
      endMatrix = Matrix4.identity();
    } else {
      // Zoom in to double tap position
      endMatrix = Matrix4.identity()
        ..translate(-position.dx * (_doubleTapScale - 1),
            -position.dy * (_doubleTapScale - 1))
        ..scale(_doubleTapScale);
    }

    _animation = Matrix4Tween(
      begin: _transformationController.value,
      end: endMatrix,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward(from: 0);
  }

  void _handleVerticalDragUpdate(DragUpdateDetails details) {
    final scale = _transformationController.value.getMaxScaleOnAxis();
    if (scale > 1.0) return;

    setState(() {
      _dragOffset += details.delta.dy;
      _opacity = (1 - (_dragOffset.abs() / 300)).clamp(0.3, 1.0);
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_dragOffset.abs() > _dismissThreshold) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _dragOffset = 0;
        _opacity = 1.0;
      });
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: _opacity),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Main image viewer
          GestureDetector(
            onTap: _toggleControls,
            onDoubleTapDown: _handleDoubleTap,
            onVerticalDragUpdate: _handleVerticalDragUpdate,
            onVerticalDragEnd: _handleVerticalDragEnd,
            child: Transform.translate(
              offset: Offset(0, _dragOffset),
              child: Center(
                child: Hero(
                  tag: widget.heroTag,
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    minScale: _minScale,
                    maxScale: _maxScale,
                    panEnabled: true,
                    scaleEnabled: true,
                    child: _buildImage(),
                  ),
                ),
              ),
            ),
          ),

          // Top controls
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            top: _showControls ? 0 : -100,
            left: 0,
            right: 0,
            child: _TopBar(
              fileName: widget.fileName,
              fileSize: widget.fileSize,
              onClose: () => Navigator.of(context).pop(),
            ),
          ),

          // Bottom controls
          if (widget.onShare != null || widget.onDownload != null)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              bottom: _showControls ? 0 : -80,
              left: 0,
              right: 0,
              child: _BottomBar(
                onShare: widget.onShare,
                onDownload: widget.onDownload,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (widget.isUrl) {
      return CachedNetworkImage(
        imageUrl: widget.imagePath,
        fit: BoxFit.contain,
        progressIndicatorBuilder: (context, url, progress) {
          return Center(
            child: _LoadingWithProgress(progress: progress.progress ?? 0),
          );
        },
        errorWidget: (context, url, error) => const _ErrorWidget(),
      );
    }

    return Image.file(
      File(widget.imagePath),
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => const _ErrorWidget(),
    );
  }
}

/// Top bar with file info and close button.
class _TopBar extends StatelessWidget {
  final String? fileName;
  final int? fileSize;
  final VoidCallback onClose;

  const _TopBar({
    this.fileName,
    this.fileSize,
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
          // Close button
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close_rounded),
            color: Colors.white,
            iconSize: 28,
          ),

          // File info
          if (fileName != null || fileSize != null)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (fileName != null)
                      Text(
                        fileName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (fileSize != null && fileSize! > 0)
                      Text(
                        _formatFileSize(fileSize!),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            )
          else
            const Spacer(),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
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

/// Bottom bar with action buttons.
class _BottomBar extends StatelessWidget {
  final VoidCallback? onShare;
  final VoidCallback? onDownload;

  const _BottomBar({
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
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading indicator widget.
class _LoadingIndicator extends StatelessWidget {
  const _LoadingIndicator();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    );
  }
}

/// Loading indicator with progress.
class _LoadingWithProgress extends StatelessWidget {
  final double progress;

  const _LoadingWithProgress({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 50,
          height: 50,
          child: CircularProgressIndicator(
            value: progress,
            color: Colors.white,
            backgroundColor: Colors.white.withValues(alpha: 0.2),
            strokeWidth: 3,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '${(progress * 100).toInt()}%',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

/// Error widget.
class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.broken_image_rounded,
          color: Colors.white54,
          size: 64,
        ),
        SizedBox(height: 16),
        Text(
          'Failed to load image',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
