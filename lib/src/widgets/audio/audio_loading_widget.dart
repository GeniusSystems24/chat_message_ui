part of 'audio_bubble.dart';

/// Loading widget for audio download with progress indication.
/// Loading widget for audio download with progress indication.
class AudioLoadingWidget extends StatelessWidget {
  final double progress;
  final bool isDownloading;
  final bool isPaused;
  final VoidCallback? onPauseTap;
  final VoidCallback? onResumeTap;
  final VoidCallback? onStartTap;

  const AudioLoadingWidget({
    super.key,
    this.progress = 0.0,
    this.isDownloading = false,
    this.isPaused = false,
    this.onPauseTap,
    this.onResumeTap,
    this.onStartTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final progressPercentage = progress * 100;

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
          GestureDetector(
            onTap: isDownloading ? onPauseTap : (onResumeTap ?? onStartTap),
            child: Container(
              width: AudioBubbleConstants.playButtonSize,
              height: AudioBubbleConstants.playButtonSize,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(
                  alpha: AudioBubbleConstants.opacityButton,
                ),
                shape: BoxShape.circle,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: AudioBubbleConstants.playButtonSize - 4,
                    height: AudioBubbleConstants.playButtonSize - 4,
                    child: CircularProgressIndicator(
                      strokeWidth: AudioBubbleConstants.progressStrokeWidth,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                      value: progress,
                    ),
                  ),
                  Icon(
                    isDownloading ? Icons.pause : Icons.download,
                    color: theme.colorScheme.primary,
                    size: AudioBubbleConstants.playIconSize,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AudioBubbleConstants.spacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: AudioBubbleConstants.waveformHeight,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: AudioBubbleConstants.opacitySecondary,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: AudioBubbleConstants.smallSpacing),
                Text(
                  _statusText(progressPercentage),
                  style: TextStyle(
                    fontSize: AudioBubbleConstants.durationFontSize,
                    fontWeight: FontWeight.w500,
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: AudioBubbleConstants.opacityDimmed,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _statusText(double progressPercentage) {
    if (isDownloading) {
      return 'Downloading ${progressPercentage.toStringAsFixed(0)}%';
    }
    if (isPaused) {
      return 'Download paused ${progressPercentage.toStringAsFixed(0)}%';
    }
    return 'Tap to download';
  }
}
