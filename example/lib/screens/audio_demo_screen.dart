import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../data/mock_message.dart';
import '../data/sample_data.dart';

/// Demo screen for audio features.
class AudioDemoScreen extends StatefulWidget {
  const AudioDemoScreen({super.key});

  @override
  State<AudioDemoScreen> createState() => _AudioDemoScreenState();
}

class _AudioDemoScreenState extends State<AudioDemoScreen> {
  String? _currentPlayingId;
  double _globalVolume = 1.0;
  double _globalSpeed = 1.0;

  // Waveform extraction state
  final WaveformExtractor _waveformExtractor = WaveformExtractor();
  List<double>? _extractedWaveform;
  bool _isExtracting = false;
  double _extractionProgress = 0.0;
  String? _extractionError;

  @override
  void dispose() {
    // Clean up audio players
    AudioPlayerFactory.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Features'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Audio Player Factory Controls
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AudioPlayerFactory Controls',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Volume control
                  Row(
                    children: [
                      const Icon(Icons.volume_up),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Slider(
                          value: _globalVolume,
                          onChanged: (value) async {
                            setState(() => _globalVolume = value);
                            await AudioPlayerFactory.setGlobalVolume(value);
                          },
                        ),
                      ),
                      Text('${(_globalVolume * 100).toInt()}%'),
                    ],
                  ),

                  // Speed control
                  Row(
                    children: [
                      const Icon(Icons.speed),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Slider(
                          value: _globalSpeed,
                          min: 0.5,
                          max: 2.0,
                          divisions: 6,
                          onChanged: (value) async {
                            setState(() => _globalSpeed = value);
                            await AudioPlayerFactory.setGlobalSpeed(value);
                          },
                        ),
                      ),
                      Text('${_globalSpeed.toStringAsFixed(2)}x'),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await AudioPlayerFactory.pauseAll();
                          setState(() => _currentPlayingId = null);
                        },
                        icon: const Icon(Icons.pause),
                        label: const Text('Pause All'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final count = await AudioPlayerFactory.disposeAll();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Disposed $count players')),
                            );
                          }
                          setState(() => _currentPlayingId = null);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Dispose All'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Audio Bubbles
          Text(
            'Audio Bubble Variants',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Standard audio bubble
          _AudioBubbleDemo(
            title: 'Standard Audio Bubble',
            child: AudioBubble(
              message: MockChatMessage(
                id: 'audio-demo-1',
                chatId: 'demo-chat',
                senderId: 'user_2',
                type: ChatMessageType.audio,
                mediaData: const ChatMediaData(
                  url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                  mediaType: ChatMessageType.audio,
                  duration: 185,
                  fileSize: 1024 * 1024 * 3,
                ),
              ),
              showSpeedControl: true,
            ),
          ),

          // Voice message style
          _AudioBubbleDemo(
            title: 'Voice Message Style',
            child: AudioBubble(
              message: MockChatMessage(
                id: 'audio-demo-2',
                chatId: 'demo-chat',
                senderId: currentUserId,
                type: ChatMessageType.audio,
                mediaData: const ChatMediaData(
                  url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
                  mediaType: ChatMessageType.audio,
                  duration: 45,
                ),
              ),
              isVoiceMessage: true,
              waveformData: sampleWaveformData,
            ),
          ),

          // With custom primary color
          _AudioBubbleDemo(
            title: 'Custom Primary Color',
            child: AudioBubble(
              message: MockChatMessage(
                id: 'audio-demo-3',
                chatId: 'demo-chat',
                senderId: 'user_2',
                type: ChatMessageType.audio,
                mediaData: const ChatMediaData(
                  url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
                  mediaType: ChatMessageType.audio,
                  duration: 120,
                ),
              ),
              primaryColor: Colors.purple,
              showSpeedControl: true,
            ),
          ),

          // With file size
          _AudioBubbleDemo(
            title: 'With File Size Display',
            child: AudioBubble(
              message: MockChatMessage(
                id: 'audio-demo-4',
                chatId: 'demo-chat',
                senderId: currentUserId,
                type: ChatMessageType.audio,
                mediaData: const ChatMediaData(
                  url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-4.mp3',
                  mediaType: ChatMessageType.audio,
                  duration: 200,
                  fileSize: 1024 * 1024 * 3,
                ),
              ),
              showSpeedControl: true,
            ),
          ),

          const SizedBox(height: 24),

          // Waveform Extraction Demo
          Text(
            'Waveform Extraction',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Extract waveform from audio URL',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Extraction controls
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _isExtracting ? null : _extractWaveformFromUrl,
                          icon: _isExtracting
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    value: _extractionProgress > 0
                                        ? _extractionProgress
                                        : null,
                                  ),
                                )
                              : const Icon(Icons.download),
                          label: Text(_isExtracting
                              ? 'Extracting ${(_extractionProgress * 100).toInt()}%'
                              : 'Extract from URL'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_extractedWaveform != null)
                        IconButton(
                          onPressed: _clearExtractedWaveform,
                          icon: const Icon(Icons.clear),
                          tooltip: 'Clear',
                        ),
                    ],
                  ),

                  // Error message
                  if (_extractionError != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      _extractionError!,
                      style: TextStyle(
                        color: theme.colorScheme.error,
                        fontSize: 12,
                      ),
                    ),
                  ],

                  // Extracted waveform display
                  if (_extractedWaveform != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Extracted Waveform (${_extractedWaveform!.length} points)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomPaint(
                        size: const Size(double.infinity, 60),
                        painter: _WaveformPainter(
                          data: _extractedWaveform!,
                          color: Colors.green,
                          progress: 1.0,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Auto-extraction AudioBubble demo
          _AudioBubbleDemo(
            title: 'Auto Waveform Extraction',
            child: _buildAutoExtractAudioBubble(),
          ),
          const SizedBox(height: 24),

          // Waveform visualization
          Text(
            'Waveform Visualization',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sample Waveform Data',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: CustomPaint(
                      size: const Size(double.infinity, 60),
                      painter: _WaveformPainter(
                        data: sampleWaveformData,
                        color: theme.colorScheme.primary,
                        progress: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _extractWaveformFromUrl() async {
    setState(() {
      _isExtracting = true;
      _extractionProgress = 0.0;
      _extractionError = null;
    });

    try {
      final result = await _waveformExtractor.extractFromUrl(
        'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
        config: const WaveformConfig(
          samplesPerSecond: 50,
          maxPoints: 80,
        ),
        onProgress: (progress) {
          if (mounted) {
            setState(() => _extractionProgress = progress);
          }
        },
      );

      if (mounted) {
        setState(() {
          _extractedWaveform = result.amplitudes;
          _isExtracting = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Extracted ${result.amplitudes.length} points, '
              'duration: ${result.durationSeconds}s',
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isExtracting = false;
          _extractionError = e.toString();
        });
      }
    }
  }

  void _clearExtractedWaveform() {
    setState(() {
      _extractedWaveform = null;
      _extractionError = null;
    });
  }

  Widget _buildAutoExtractAudioBubble() {
    return AudioBubble(
      message: MockChatMessage(
        id: 'auto-extract-demo',
        chatId: 'demo-chat',
        type: ChatMessageType.audio,
        senderId: 'demo',
        mediaData: const ChatMediaData(
          url: 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
          mediaType: ChatMessageType.audio,
          duration: 45,
        ),
      ),
      autoExtractWaveform: true,
      waveformConfig: WaveformConfig.voiceMessage,
      showSpeedControl: true,
      onWaveformExtracted: (waveform) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Waveform extracted: ${waveform.length} points'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
    );
  }
}

class _AudioBubbleDemo extends StatelessWidget {
  final String title;
  final Widget child;

  const _AudioBubbleDemo({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// Simple waveform painter for visualization.
class _WaveformPainter extends CustomPainter {
  final List<double> data;
  final Color color;
  final double progress;

  _WaveformPainter({
    required this.data,
    required this.color,
    this.progress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final barWidth = size.width / data.length;
    final maxHeight = size.height * 0.8;
    final progressIndex = (data.length * progress).floor();

    for (int i = 0; i < data.length; i++) {
      final barHeight = data[i] * maxHeight;
      final x = i * barWidth + barWidth / 4;
      final y = (size.height - barHeight) / 2;

      final paint = Paint()
        ..color = i < progressIndex ? color : color.withOpacity(0.3)
        ..style = PaintingStyle.fill;

      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, barWidth / 2, barHeight),
          const Radius.circular(2),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.data != data;
  }
}
