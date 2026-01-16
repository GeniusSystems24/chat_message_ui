part of 'audio_bubble.dart';

/// Waveform section widget containing waveform and duration.
class _AudioWaveformSection extends StatelessWidget {
  final String messageId;
  final String? filePath;
  final List<double> waveform;
  final int durationInSeconds;
  final Function(double position)? onSeek;

  const _AudioWaveformSection({
    required this.messageId,
    this.filePath,
    required this.waveform,
    required this.durationInSeconds,
    this.onSeek,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioPlayer = AudioPlayerFactory.create(
      messageId,
      filePath: filePath,
    );

    return StreamBuilder<Duration>(
      initialData: audioPlayer.position,
      stream: audioPlayer.positionStream,
      builder: (context, asyncSnapshot) {
        final position = asyncSnapshot.data;
        final currentPosition = position?.inSeconds ?? 0;
        final progress =
            durationInSeconds > 0 ? currentPosition / durationInSeconds : 0.0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: AudioBubbleConstants.smallSpacing),
            InteractiveAudioWaveform(
              amplitudes: waveform,
              progress: progress,
              type: currentPosition == 0
                  ? WaveformType.static
                  : WaveformType.playing,
              height: AudioBubbleConstants.waveformHeight,
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.onSurface.withValues(
                alpha: AudioBubbleConstants.opacitySecondary,
              ),
              onSeek: onSeek,
              interactive: onSeek != null,
            ),
            const SizedBox(height: AudioBubbleConstants.smallSpacing),
            _AudioDurationDisplay(
              currentPosition: currentPosition,
              totalDuration: durationInSeconds,
            ),
          ],
        );
      },
    );
  }
}

/// Duration display widget.
class _AudioDurationDisplay extends StatelessWidget {
  final int currentPosition;
  final int totalDuration;

  const _AudioDurationDisplay({
    this.currentPosition = 0,
    required this.totalDuration,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      _getDurationText(),
      style: TextStyle(
        fontSize: AudioBubbleConstants.durationFontSize,
        fontWeight: FontWeight.w500,
        color: theme.colorScheme.onSurface.withValues(
          alpha: AudioBubbleConstants.opacityDimmed,
        ),
      ),
    );
  }

  /// Get duration text based on state.
  String _getDurationText() {
    if (currentPosition == 0) return formatDuration(totalDuration);
    return '${formatDuration(currentPosition)} / ${formatDuration(totalDuration)}';
  }
}
