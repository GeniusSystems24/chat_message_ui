part of 'audio_bubble.dart';

/// Main audio player widget for local/downloaded audio.
class AudioPlayerWidget extends StatelessWidget {
  final String? filePath;
  final String? url;
  final String messageId;
  final List<double> waveform;
  final int durationInSeconds;
  final Function(double)? onSeek;
  final Function()? onPlay;
  final Function()? onPause;

  const AudioPlayerWidget({
    super.key,
    this.filePath,
    this.url,
    required this.messageId,
    required this.waveform,
    required this.durationInSeconds,
    this.onSeek,
    this.onPlay,
    this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
          _AudioControlButton(
            messageId: messageId,
            filePath: filePath,
            url: url,
            onPlay: onPlay,
            onPause: onPause,
          ),
          const SizedBox(width: AudioBubbleConstants.spacing),
          Expanded(
            child: _AudioWaveformSection(
              messageId: messageId,
              filePath: filePath,
              url: url,
              waveform: waveform,
              durationInSeconds: durationInSeconds,
              onSeek: onSeek,
            ),
          ),
        ],
      ),
    );
  }
}
