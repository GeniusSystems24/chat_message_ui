part of 'audio_bubble.dart';

/// Play/pause button widget.
class _AudioControlButton extends StatelessWidget {
  final String messageId;
  final String? filePath;
  final String? url;
  final Function()? onPlay;
  final Function()? onPause;

  const _AudioControlButton({
    required this.messageId,
    this.filePath,
    this.url,
    this.onPlay,
    this.onPause,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final audioPlayer = AudioPlayerFactory.create(
      messageId,
      filePath: filePath,
      url: url,
    );

    return StreamBuilder<PlayerState>(
      stream: audioPlayer.playerStateStream,
      builder: (context, asyncSnapshot) {
        final playerState = asyncSnapshot.data;
        final isPlaying = (playerState?.playing ?? false) &&
            (playerState?.processingState != ProcessingState.completed);
        if (playerState?.processingState == ProcessingState.completed) {
          AudioPlayerFactory.pause(messageId);
          audioPlayer.seek(Duration.zero);
        }

        return GestureDetector(
          onTap: () {
            if (isPlaying) {
              AudioPlayerFactory.pause(messageId);
              onPause?.call();
            } else {
              AudioPlayerFactory.play(
                messageId,
                filePath: filePath,
                url: url,
              );
              onPlay?.call();
            }
          },
          child: Container(
            width: AudioBubbleConstants.playButtonSize,
            height: AudioBubbleConstants.playButtonSize,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: AudioBubbleConstants.playIconSize,
            ),
          ),
        );
      },
    );
  }
}
