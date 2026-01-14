import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../theme/chat_theme.dart';
import '../../adapters/chat_message_data.dart';
import 'audio_player_factory.dart';

part 'audio_loading_widget.dart';
part 'audio_player_widget.dart';
part 'audio_waveform_painter.dart';
part 'play_pause_button.dart';
part 'audio_waveform_section.dart';
part 'constants.dart';

/// Widget to display an audio attachment in a message bubble.
class AudioBubble extends StatefulWidget {
  /// Message model containing audio data.
  final IChatMessageData message;

  /// Optional direct file path (overrides message.mediaData.url)
  final String? filePath;

  const AudioBubble({
    super.key,
    required this.message,
    this.filePath,
  });

  String get messageId => message.id;

  /// Returns the audio source (priority: filePath > mediaData.url)
  String? get audioSource {
    // Priority 1: Explicit filePath parameter
    if (filePath != null) return filePath;

    // Priority 2: mediaData.url
    return message.mediaData?.url;
  }

  /// Duration of the audio in seconds.
  int get duration => message.mediaData?.duration ?? 0;

  /// File size in bytes.
  int get fileSize => message.mediaData?.fileSize ?? 0;

  /// File name of the document.
  String? get fileName => message.mediaData?.fileName;

  @override
  State<AudioBubble> createState() => _AudioBubbleState();
}

class _AudioBubbleState extends State<AudioBubble> {
  List<double> _displayWaveform = [];

  @override
  void initState() {
    super.initState();
    _initializeWaveform();
  }

  /// Initialize waveform data.
  void _initializeWaveform() {
    // In the future, if IChatMessageData supports waveform data, use it here.
    // For now, generate random waveform.
    final pointCount = widget.duration > 0 ? widget.duration : 60;
    final actualPointCount = pointCount < AudioBubbleConstants.minWaveformPoints
        ? AudioBubbleConstants.minWaveformPoints
        : pointCount;
    _displayWaveform = WaveformDataGenerator.generateRandomWaveform(
      actualPointCount,
    );
  }

  /// Handle seeking to a specific position.
  void _handleSeek(double position) {
    final duration = widget.duration;
    final currentPosition = (position * duration).toInt();
    final seekDuration = Duration(seconds: currentPosition);

    AudioPlayerFactory.seek(widget.messageId, seekDuration);
  }

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.get(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 100),
      child: _buildAudioContent(context, chatTheme),
    );
  }

  /// Builds the audio content.
  Widget _buildAudioContent(BuildContext context, ChatThemeData chatTheme) {
    final source = widget.audioSource;
    if (source == null || source.isEmpty) {
      return _buildEmptyState(chatTheme, 'Audio not available');
    }

    final isUrl = source.startsWith('http') || source.startsWith('https');

    return AudioPlayerWidget(
      url: isUrl ? source : null,
      filePath: !isUrl ? source : null,
      messageId: widget.messageId,
      waveform: _displayWaveform,
      durationInSeconds: widget.duration,
      onSeek: _handleSeek,
      onPlay: () =>
          AudioPlayerFactory.currentAudioMessageId.value = widget.messageId,
    );
  }

  Widget _buildEmptyState(ChatThemeData chatTheme, String label) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chatTheme.colors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.mic_none, size: 18, color: chatTheme.colors.primary),
          const SizedBox(width: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: chatTheme.typography.bodySmall.copyWith(
              color: chatTheme.colors.onSurface,
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
  return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
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
