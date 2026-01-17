import 'package:flutter/material.dart';
import 'package:chat_message_ui/chat_message_ui.dart';

import '../../data/example_message.dart';
import '../shared/example_scaffold.dart';

/// Example screen showcasing all VideoBubble features and properties.
class VideoBubbleExample extends StatefulWidget {
  const VideoBubbleExample({super.key});

  @override
  State<VideoBubbleExample> createState() => _VideoBubbleExampleState();
}

class _VideoBubbleExampleState extends State<VideoBubbleExample> {
  static const String _sampleVideoUrl =
      'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/What%20are%20Chatbots-.mp4?alt=media&token=68b7385c-8394-48d3-9ac3-2b26b22abb1d';

  static const String _sampleThumbnailUrl =
      'https://firebasestorage.googleapis.com/v0/b/skycachefiles.appspot.com/o/primary_sys%2F%D8%A7%D9%84%D9%85%D9%86%D8%AA%D8%AC%D8%A7%D8%AA%2F125.jpg?alt=media&token=a3694a14-7774-411d-aeee-7d9ccaa732c5';

  String _playbackStatus = 'No video playing';
  int _activeVideos = 0;

  @override
  void initState() {
    super.initState();
    // Listen to video state changes
    VideoPlayerFactory.stateStream.listen((state) {
      if (mounted) {
        setState(() {
          if (state.isPlaying) {
            _playbackStatus = 'Playing: ${state.id}';
          } else if (state.isPaused) {
            _playbackStatus = 'Paused: ${state.id}';
          }
          _activeVideos = VideoPlayerFactory.controllersCount;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatTheme = ChatThemeData.light();

    return ExampleScaffold(
      title: 'VideoBubble',
      subtitle: 'Video player widget with thumbnail',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ExampleDescription(
            title: 'Screen Overview',
            icon: Icons.videocam_outlined,
            lines: [
              'Demonstrates inline video playback with thumbnails.',
              'Shows duration, file size, and aspect ratio handling.',
              'Validates mini player and full-screen behaviors.',
            ],
          ),
          const SizedBox(height: 16),

          // Media Playback Manager Section
          const ExampleSectionHeader(
            title: 'Media Playback Manager',
            description: 'Centralized control for audio/video playback',
            icon: Icons.speaker_group_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Playback Status',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'When a video plays, all other audio/video automatically pauses.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _playbackStatus.contains('Playing')
                                ? Icons.play_circle
                                : Icons.pause_circle,
                            color: _playbackStatus.contains('Playing')
                                ? Colors.green
                                : Colors.grey,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _playbackStatus,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Active video controllers: $_activeVideos',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await VideoPlayerFactory.pauseAll();
                          setState(() {
                            _playbackStatus = 'All paused';
                          });
                        },
                        icon: const Icon(Icons.pause, size: 18),
                        label: const Text('Pause All'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final count = await VideoPlayerFactory.disposeAll();
                          setState(() {
                            _playbackStatus = 'Disposed $count controllers';
                            _activeVideos = 0;
                          });
                        },
                        icon: const Icon(Icons.clear_all, size: 18),
                        label: const Text('Dispose All'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Overview
          const ExampleSectionHeader(
            title: 'Overview',
            description: 'Play videos inline or full-screen with native controls',
            icon: Icons.videocam_outlined,
          ),
          const SizedBox(height: 16),

          // Basic Video
          DemoContainer(
            title: 'Basic Video with Thumbnail',
            child: Center(
              child: SizedBox(
                width: 300,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_1',
                    duration: 90,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // With Duration and Size
          const ExampleSectionHeader(
            title: 'Video Info Overlay',
            description: 'Duration and file size badges',
            icon: Icons.info_outline,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Duration & File Size',
            child: Center(
              child: SizedBox(
                width: 300,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_2',
                    duration: 180,
                    fileSize: 15728640, // 15 MB
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Different Aspect Ratios
          const ExampleSectionHeader(
            title: 'Aspect Ratios',
            description: 'VideoBubble adapts to video dimensions',
            icon: Icons.aspect_ratio_outlined,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Wide Video (16:9)',
            child: Center(
              child: SizedBox(
                width: 320,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_3',
                    duration: 60,
                    aspectRatio: 16 / 9,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Square Video (1:1)',
            child: Center(
              child: SizedBox(
                width: 250,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_4',
                    duration: 45,
                    aspectRatio: 1.0,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Portrait Video (9:16)',
            child: Center(
              child: SizedBox(
                width: 180,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_5',
                    duration: 30,
                    aspectRatio: 9 / 16,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Mini Player Mode
          const ExampleSectionHeader(
            title: 'Player Modes',
            description: 'Inline mini player or tap for full-screen',
            icon: Icons.play_circle_outline,
          ),
          const SizedBox(height: 12),
          DemoContainer(
            title: 'Default (Tap to Play)',
            child: Center(
              child: SizedBox(
                width: 300,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_6',
                    duration: 120,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: false,
                  showMiniPlayer: false,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          DemoContainer(
            title: 'Mini Player Mode',
            child: Center(
              child: SizedBox(
                width: 300,
                child: VideoBubble(
                  message: _createVideoMessage(
                    id: 'video_7',
                    duration: 90,
                  ),
                  chatTheme: chatTheme,
                  isMyMessage: true,
                  showMiniPlayer: true,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Properties Reference
          const ExampleSectionHeader(
            title: 'Properties Reference',
            description: 'All available VideoBubble properties',
            icon: Icons.list_alt_outlined,
          ),
          const SizedBox(height: 12),
          const PropertyShowcase(
            property: 'message',
            value: 'IChatMessageData',
            description: 'Message data with video URL and metadata',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'chatTheme',
            value: 'ChatThemeData',
            description: 'Theme configuration for styling',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'isMyMessage',
            value: 'bool',
            description: 'Whether the message is from current user',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'showMiniPlayer',
            value: 'bool (default: false)',
            description: 'Play video inline instead of full-screen',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'autoPlay',
            value: 'bool (default: false)',
            description: 'Start playing automatically',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'muted',
            value: 'bool (default: false)',
            description: 'Start muted by default',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onPlay',
            value: 'VoidCallback?',
            description: 'Called when video starts playing',
          ),
          const SizedBox(height: 8),
          const PropertyShowcase(
            property: 'onPause',
            value: 'VoidCallback?',
            description: 'Called when video is paused',
          ),
          const SizedBox(height: 24),

          // Code Example
          const CodeSnippet(
            title: 'VideoBubble Usage',
            code: '''VideoBubble(
  message: message,
  chatTheme: ChatThemeData.light(),
  isMyMessage: false,
  showMiniPlayer: true,
  autoPlay: false,
  muted: false,
  onPlay: () => print('Playing'),
  onPause: () => print('Paused'),
)''',
          ),
          const SizedBox(height: 16),

          // VideoPlayerFactory Code Example
          const CodeSnippet(
            title: 'VideoPlayerFactory Usage',
            code: '''// Play a video (auto-pauses other media)
await VideoPlayerFactory.play(
  'video-123',
  filePath: '/path/to/video.mp4',
);

// Pause video
await VideoPlayerFactory.pause('video-123');

// Seek to position
await VideoPlayerFactory.seek(
  'video-123',
  Duration(seconds: 30),
);

// Listen to state changes
VideoPlayerFactory.stateStream.listen((state) {
  print('Video \${state.id}: \${state.isPlaying}');
});

// Pause all videos
await VideoPlayerFactory.pauseAll();

// Cleanup
await VideoPlayerFactory.dispose('video-123');''',
          ),
          const SizedBox(height: 16),

          // MediaPlaybackManager Code Example
          const CodeSnippet(
            title: 'MediaPlaybackManager Usage',
            code: '''// Initialize once at app startup
MediaPlaybackManager.instance.initialize();

// Play video (pauses any audio)
await MediaPlaybackManager.instance.playVideo(
  'video-123',
  filePath: '/path/to/video.mp4',
);

// Pause all media (audio + video)
await MediaPlaybackManager.instance.pauseAll();

// Check current state
final state = MediaPlaybackManager.instance.state;
print('Type: \${state.type}'); // audio, video, none
print('Playing: \${state.isPlaying}');''',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  ExampleMessage _createVideoMessage({
    required String id,
    required int duration,
    double aspectRatio = 16 / 9,
    int fileSize = 0,
  }) {
    return ExampleMessage(
      id: id,
      chatId: 'demo',
      senderId: 'user_1',
      type: ChatMessageType.video,
      createdAt: DateTime.now(),
      status: ChatMessageStatus.read,
      mediaData: ChatMediaData(
        url: _sampleVideoUrl,
        thumbnailUrl: _sampleThumbnailUrl,
        mediaType: ChatMessageType.video,
        duration: duration,
        aspectRatio: aspectRatio,
        fileSize: fileSize,
      ),
    );
  }
}
