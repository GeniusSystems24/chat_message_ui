import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

/// Demo screen for video features.
class VideoDemoScreen extends StatefulWidget {
  const VideoDemoScreen({super.key});

  @override
  State<VideoDemoScreen> createState() => _VideoDemoScreenState();
}

class _VideoDemoScreenState extends State<VideoDemoScreen> {
  double _globalVolume = 1.0;
  double _globalSpeed = 1.0;
  bool _globalMuted = false;

  @override
  void dispose() {
    // Clean up video players
    VideoPlayerFactory.disposeAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Features'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Video Player Factory Controls
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VideoPlayerFactory Controls',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Volume control
                  Row(
                    children: [
                      Icon(_globalMuted ? Icons.volume_off : Icons.volume_up),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Slider(
                          value: _globalVolume,
                          onChanged: (value) async {
                            setState(() => _globalVolume = value);
                            await VideoPlayerFactory.setGlobalVolume(value);
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
                          min: 0.25,
                          max: 2.0,
                          divisions: 7,
                          onChanged: (value) async {
                            setState(() => _globalSpeed = value);
                            await VideoPlayerFactory.setGlobalSpeed(value);
                          },
                        ),
                      ),
                      Text('${_globalSpeed.toStringAsFixed(2)}x'),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          await VideoPlayerFactory.toggleMute();
                          setState(() => _globalMuted = !_globalMuted);
                        },
                        icon: Icon(_globalMuted ? Icons.volume_up : Icons.volume_off),
                        label: Text(_globalMuted ? 'Unmute' : 'Mute'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await VideoPlayerFactory.pauseAll();
                        },
                        icon: const Icon(Icons.pause),
                        label: const Text('Pause All'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final count = await VideoPlayerFactory.disposeAll();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Disposed $count players')),
                            );
                          }
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

          // Video Bubbles
          Text(
            'Video Bubble Variants',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Standard video bubble
          _VideoBubbleDemo(
            title: 'Standard Video Bubble',
            child: VideoBubble(
              videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
              thumbnailUrl: 'https://picsum.photos/400/300',
              duration: 65,
              fileSize: 1024 * 1024 * 15,
              isMe: false,
              onPlay: () => _showSnackBar('Video play'),
              onPause: () => _showSnackBar('Video pause'),
            ),
          ),

          // Sender video bubble
          _VideoBubbleDemo(
            title: 'Sender Video Bubble',
            child: VideoBubble(
              videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_2mb.mp4',
              thumbnailUrl: 'https://picsum.photos/300/400',
              duration: 120,
              fileSize: 1024 * 1024 * 25,
              isMe: true,
            ),
          ),

          // Mini player inline
          _VideoBubbleDemo(
            title: 'With Mini Player',
            child: VideoBubble(
              videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
              thumbnailUrl: 'https://picsum.photos/400/225',
              duration: 45,
              isMe: false,
              showMiniPlayer: true,
              muted: true,
            ),
          ),

          // Auto-play video
          _VideoBubbleDemo(
            title: 'Auto-play (muted)',
            child: VideoBubble(
              videoUrl: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
              thumbnailUrl: 'https://picsum.photos/400/300',
              duration: 30,
              isMe: false,
              autoPlay: true,
              muted: true,
              showMiniPlayer: true,
            ),
          ),

          const SizedBox(height: 24),

          // Video Player State Info
          Text(
            'VideoPlayerState Features',
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
                  _FeatureRow(
                    icon: Icons.play_arrow,
                    title: 'Playback States',
                    description: 'uninitialized, initializing, ready, playing, paused, buffering, completed, error',
                  ),
                  const Divider(),
                  _FeatureRow(
                    icon: Icons.high_quality,
                    title: 'Video Quality',
                    description: 'auto, low (360p), medium (480p), high (720p), hd (1080p)',
                  ),
                  const Divider(),
                  _FeatureRow(
                    icon: Icons.timer,
                    title: 'Duration Formatting',
                    description: 'Automatic MM:SS or HH:MM:SS formatting',
                  ),
                  const Divider(),
                  _FeatureRow(
                    icon: Icons.aspect_ratio,
                    title: 'Aspect Ratio',
                    description: 'Auto-detected from video metadata',
                  ),
                  const Divider(),
                  _FeatureRow(
                    icon: Icons.loop,
                    title: 'Loop Control',
                    description: 'Toggle video looping on/off',
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }
}

class _VideoBubbleDemo extends StatelessWidget {
  final String title;
  final Widget child;

  const _VideoBubbleDemo({
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

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
