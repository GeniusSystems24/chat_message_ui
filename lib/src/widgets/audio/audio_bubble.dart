import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:transfer_kit/transfer_kit.dart';

import '../../theme/chat_theme.dart';
import '../../adapters/chat_message_data.dart';
import '../../config/chat_message_ui_config.dart';
import '../../transfer/media_transfer_controller.dart';
import 'audio_player_factory.dart';

part 'audio_loading_widget.dart';
part 'audio_player_widget.dart';
part 'audio_waveform_painter.dart';
part 'play_pause_button.dart';
part 'audio_waveform_section.dart';
part 'constants.dart';

/// Widget to display an audio attachment in a message bubble.
///
/// Features:
/// - Real-time waveform visualization with progress indicator
/// - Play/pause with loading state
/// - Optional playback speed control
/// - Seek by tapping on waveform
/// - Supports both local files and URLs
class AudioBubble extends StatefulWidget {
  /// Message model containing audio data.
  final IChatMessageData message;

  /// Optional direct file path (overrides message.mediaData.url)
  final String? filePath;

  /// Optional custom waveform data (if not provided, generates random)
  final List<double>? waveformData;

  /// Whether to show speed control button
  final bool showSpeedControl;

  /// Whether this is a voice message (shows mic icon instead of music note)
  final bool isVoiceMessage;

  /// Custom primary color for the player
  final Color? primaryColor;

  /// Auto-download policy for network media.
  final AutoDownloadPolicy autoDownloadPolicy;

  const AudioBubble({
    super.key,
    required this.message,
    this.filePath,
    this.waveformData,
    this.showSpeedControl = false,
    this.isVoiceMessage = true,
    this.primaryColor,
    this.autoDownloadPolicy = AutoDownloadPolicy.never,
  });

  String get messageId => message.id;

  /// Returns the audio source (priority: filePath > mediaData.url)
  String? get audioSource {
    if (filePath != null) return filePath;
    return message.mediaData?.url;
  }

  /// Duration of the audio in seconds.
  int get duration => message.mediaData?.resolvedDurationSeconds ?? 0;

  /// File size in bytes.
  int get fileSize => message.mediaData?.resolvedFileSize ?? 0;

  /// File name of the document.
  String? get fileName => message.mediaData?.resolvedFileName;

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble>
    with SingleTickerProviderStateMixin {
  List<double> _displayWaveform = [];
  double _currentSpeed = 1.0;
  late AnimationController _loadingController;
  bool _autoStartTriggered = false;

  static const List<double> _availableSpeeds = [1.0, 1.25, 1.5, 1.75, 2.0, 0.5, 0.75];

  @override
  void initState() {
    super.initState();
    _initializeWaveform();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void didUpdateWidget(AudioBubble oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.waveformData != widget.waveformData ||
        oldWidget.duration != widget.duration) {
      _initializeWaveform();
    }
    if (oldWidget.audioSource != widget.audioSource) {
      _autoStartTriggered = false;
    }
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  void _initializeWaveform() {
    if (widget.waveformData != null && widget.waveformData!.isNotEmpty) {
      _displayWaveform = widget.waveformData!;
      return;
    }

    final metadataWaveform = widget.message.mediaData?.waveform?.samples;
    if (metadataWaveform != null && metadataWaveform.isNotEmpty) {
      _displayWaveform = metadataWaveform;
      return;
    } else {
      final pointCount = widget.duration > 0 ? widget.duration : 60;
      final actualPointCount =
          pointCount < AudioBubbleConstants.minWaveformPoints
              ? AudioBubbleConstants.minWaveformPoints
              : pointCount;
      _displayWaveform = WaveformDataGenerator.generateRandomWaveform(
        actualPointCount,
      );
    }
  }

  void _handleSeek(double position) {
    final duration = widget.duration;
    final currentPosition = (position * duration).toInt();
    final seekDuration = Duration(seconds: currentPosition);
    AudioPlayerFactory.seek(widget.messageId, seekDuration);
  }

  void _cycleSpeed() {
    final currentIndex = _availableSpeeds.indexOf(_currentSpeed);
    final nextIndex = (currentIndex + 1) % _availableSpeeds.length;
    setState(() {
      _currentSpeed = _availableSpeeds[nextIndex];
    });
    AudioPlayerFactory.setSpeed(widget.messageId, _currentSpeed);
  }

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.get(context);
    final source = widget.audioSource;
    if (source == null || source.isEmpty) {
      return _AudioEmptyState(chatTheme: chatTheme);
    }

    final isUrl = source.startsWith('http') || source.startsWith('https');
    if (!isUrl) {
      return _AudioPlayerCard(
        filePath: source,
        messageId: widget.messageId,
        waveform: _displayWaveform,
        durationInSeconds: widget.duration,
        fileSize: widget.fileSize,
        onSeek: _handleSeek,
        showSpeedControl: widget.showSpeedControl,
        currentSpeed: _currentSpeed,
        onSpeedChange: _cycleSpeed,
        isVoiceMessage: widget.isVoiceMessage,
        loadingAnimation: _loadingController,
        primaryColor: widget.primaryColor,
      );
    }

    return _buildDownloadContent(context, source);
  }

  Widget _buildDownloadContent(BuildContext context, String url) {
    final controller = MediaTransferController.instance;
    final downloadTask = controller.buildDownloadTask(
      url: url,
      fileName: widget.fileName,
    );

    return FutureBuilder(
      future: controller.enqueueOrResume(downloadTask, autoStart: false),
      builder: (context, asyncSnapshot) {
        final (
          String? filePath,
          StreamController<TaskItem>? streamController
        ) = asyncSnapshot.data ?? (null, null);

        if (filePath != null) {
          return _AudioPlayerCard(
            filePath: filePath,
            messageId: widget.messageId,
            waveform: _displayWaveform,
            durationInSeconds: widget.duration,
            fileSize: widget.fileSize,
            onSeek: _handleSeek,
            showSpeedControl: widget.showSpeedControl,
            currentSpeed: _currentSpeed,
            onSpeedChange: _cycleSpeed,
            isVoiceMessage: widget.isVoiceMessage,
            loadingAnimation: _loadingController,
            primaryColor: widget.primaryColor,
          );
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
            return DocumentDownloadCard(
              item: taskItem,
              fileName: widget.fileName,
              fileSize: widget.fileSize,
              onStart: () => controller.startDownload(downloadTask),
              onPause: controller.pauseDownload,
              onResume: controller.resumeDownload,
              onCancel: controller.cancelDownload,
              onRetry: controller.retryDownload,
              completedBuilder: (context, item) => _AudioPlayerCard(
                filePath: item.filePath,
                messageId: widget.messageId,
                waveform: _displayWaveform,
                durationInSeconds: widget.duration,
                fileSize: widget.fileSize,
                onSeek: _handleSeek,
                showSpeedControl: widget.showSpeedControl,
                currentSpeed: _currentSpeed,
                onSpeedChange: _cycleSpeed,
                isVoiceMessage: widget.isVoiceMessage,
                loadingAnimation: _loadingController,
                primaryColor: widget.primaryColor,
              ),
              loadingBuilder: (context, item) =>
                  _buildWaveformLoading(context),
            );
          },
        );
      },
    );
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

  Widget _buildWaveformLoading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: AudioBubbleConstants.smallSpacing),
        InteractiveAudioWaveform(
          amplitudes: _displayWaveform,
          progress: 0,
          type: WaveformType.static,
          height: AudioBubbleConstants.waveformHeight,
          primaryColor: Theme.of(context).colorScheme.primary,
          secondaryColor: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: AudioBubbleConstants.opacitySecondary),
          onSeek: null,
          interactive: false,
        ),
        const SizedBox(height: AudioBubbleConstants.smallSpacing),
        _AudioDurationDisplay(
          currentPosition: 0,
          totalDuration: widget.duration,
        ),
      ],
    );
  }
}

/// Main audio player card widget.
class _AudioPlayerCard extends StatelessWidget {
  final String? filePath;
  final String messageId;
  final List<double> waveform;
  final int durationInSeconds;
  final int fileSize;
  final Function(double)? onSeek;
  final bool showSpeedControl;
  final double currentSpeed;
  final VoidCallback? onSpeedChange;
  final bool isVoiceMessage;
  final AnimationController loadingAnimation;
  final Color? primaryColor;

  const _AudioPlayerCard({
    this.filePath,
    required this.messageId,
    required this.waveform,
    required this.durationInSeconds,
    this.fileSize = 0,
    this.onSeek,
    this.showSpeedControl = false,
    this.currentSpeed = 1.0,
    this.onSpeedChange,
    this.isVoiceMessage = true,
    required this.loadingAnimation,
    this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final playerColor = primaryColor ?? theme.colorScheme.primary;

    return Container(
      constraints: BoxConstraints(
        maxWidth: size.width * AudioBubbleConstants.maxWidthFactor,
        minWidth: AudioBubbleConstants.minWidth,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AudioBubbleConstants.horizontalPadding,
        vertical: AudioBubbleConstants.verticalPadding,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Play/Pause button
          _PlayPauseButton(
            messageId: messageId,
            filePath: filePath,
            isVoiceMessage: isVoiceMessage,
            loadingAnimation: loadingAnimation,
            color: playerColor,
          ),
          const SizedBox(width: AudioBubbleConstants.spacing),

          // Waveform and duration
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _AudioWaveformSection(
                  messageId: messageId,
                  filePath: filePath,
                  waveform: waveform,
                  durationInSeconds: durationInSeconds,
                  onSeek: onSeek,
                ),
                if (fileSize > 0)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      formatFileSize(fileSize),
                      style: TextStyle(
                        fontSize: 10,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Speed control
          if (showSpeedControl) ...[
            const SizedBox(width: 8),
            _SpeedChip(
              speed: currentSpeed,
              onTap: onSpeedChange,
              color: playerColor,
            ),
          ],
        ],
      ),
    );
  }
}

/// Animated play/pause button with loading indicator.
class _PlayPauseButton extends StatelessWidget {
  final String messageId;
  final String? filePath;
  final bool isVoiceMessage;
  final AnimationController loadingAnimation;
  final Color color;

  const _PlayPauseButton({
    required this.messageId,
    this.filePath,
    this.isVoiceMessage = true,
    required this.loadingAnimation,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final audioPlayer = AudioPlayerFactory.create(
      messageId,
      filePath: filePath,
    );

    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, snapshot) {
        final playerState = snapshot.data;
        final processingState = playerState?.processingState;
        final isPlaying = (playerState?.playing ?? false) &&
            processingState != ProcessingState.completed;
        final isLoading = processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering;

        if (processingState == ProcessingState.completed) {
          AudioPlayerFactory.pause(messageId);
          audioPlayer.seek(Duration.zero);
        }

        return GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  if (isPlaying) {
                    AudioPlayerFactory.pause(messageId);
                  } else {
                    AudioPlayerFactory.play(
                      messageId,
                      filePath: filePath,
                    );
                  }
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: AudioBubbleConstants.playButtonSize,
            height: AudioBubbleConstants.playButtonSize,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: isPlaying
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.4),
                        blurRadius: 8,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
            child: isLoading
                ? _LoadingIndicator(
                    animation: loadingAnimation,
                    icon: isVoiceMessage ? Icons.mic : Icons.audiotrack,
                  )
                : _AnimatedPlayPauseIcon(isPlaying: isPlaying),
          ),
        );
      },
    );
  }
}

/// Animated play/pause icon with smooth transition.
class _AnimatedPlayPauseIcon extends StatelessWidget {
  final bool isPlaying;

  const _AnimatedPlayPauseIcon({required this.isPlaying});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: animation,
          child: child,
        );
      },
      child: Icon(
        isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
        key: ValueKey(isPlaying),
        color: Colors.white,
        size: AudioBubbleConstants.playIconSize,
      ),
    );
  }
}

/// Loading indicator with rotating ring.
class _LoadingIndicator extends StatelessWidget {
  final AnimationController animation;
  final IconData icon;

  const _LoadingIndicator({
    required this.animation,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _LoadingRingPainter(
            progress: animation.value,
            color: Colors.white,
          ),
          child: child,
        );
      },
      child: Center(
        child: Icon(icon, color: Colors.white, size: 16),
      ),
    );
  }
}

/// Painter for the loading ring animation.
class _LoadingRingPainter extends CustomPainter {
  final double progress;
  final Color color;

  _LoadingRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 6) / 2;

    // Background ring
    final bgPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawCircle(center, radius, bgPaint);

    // Active ring segment
    final activePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final sweepAngle = math.pi * 0.6;
    final startAngle = 2 * math.pi * progress - math.pi / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _LoadingRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Speed control chip widget.
class _SpeedChip extends StatelessWidget {
  final double speed;
  final VoidCallback? onTap;
  final Color color;

  const _SpeedChip({
    required this.speed,
    this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Text(
          '${speed}x',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}

/// Empty state widget when audio is not available.
class _AudioEmptyState extends StatelessWidget {
  final ChatThemeData chatTheme;

  const _AudioEmptyState({required this.chatTheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: chatTheme.colors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.mic_off_rounded,
            size: 20,
            color: chatTheme.colors.error,
          ),
          const SizedBox(width: 8),
          Text(
            'Audio not available',
            style: chatTheme.typography.bodySmall.copyWith(
              color: chatTheme.colors.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper function to format duration.
String formatDuration(int seconds) {
  if (seconds <= 0) return '0:00';

  final hours = seconds ~/ 3600;
  final minutes = (seconds % 3600) ~/ 60;
  final remainingSeconds = seconds % 60;

  if (hours > 0) {
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  return '${minutes}:${remainingSeconds.toString().padLeft(2, '0')}';
}

/// Helper function to format file size.
String formatFileSize(int bytes) {
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
